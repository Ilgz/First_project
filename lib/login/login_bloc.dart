import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:second_project/model/login_access.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginCheck>(_login);
    on<RegisterSendSms>(_sendSms);
    on<CheckAvailability>(_checkAvailability);
    on<LoginStarted>(_nothing);
    on<CheckOtp>(_checkOtp);
  }
  Future<void> _checkOtp(CheckOtp event, Emitter<LoginState> emit) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential result = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: event.verificationID,
          smsCode: event.otp,
        ),
      );
      if (event.occasion == 1) {
        final response = await http.post(Uri.parse(
            '${myServer}api/auth/register?name=${event.name}&password=${event.password}&phone_number=${event.phone_number}'));
        final result = loginAccessFromJson(response.body);
        if (result.accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('apiKey', result.accessToken);
        }
        emit(RegisterCheckOtpSuccess());
      } else if (event.occasion == 2) {
        emit(ResetCheckOtpSuccess());
      }
    } catch (error) {
      if (event.occasion == 1) {
        emit(RegisterCheckOtpFail());
      } else if (event.occasion == 2) {
        emit(ResetCheckOtpFail());
      }
    }
  }

  Future<void> _sendSms(RegisterSendSms event, Emitter<LoginState> emit) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    late String verificationID;
    Completer<LoginState> c = Completer<LoginState>();
    await _auth.verifyPhoneNumber(
        phoneNumber: "+" + event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException exception) async {},
        codeSent: (String verificationId, int? resendToken) async {
          verificationID = verificationId;
          if (event.occasion == 1) {
            c.complete(RegisterSendSmsSuccess(verificationID));
          } else {
            c.complete(ResetSendSmsSuccess(verificationId));
          }
        },
        // codeAutoRetrievalTimeout:  (String verificationId) {}).whenComplete(() =>  emit(RegisterSendSmsSuccess(verificationID)));
        codeAutoRetrievalTimeout: (String verificationId) async {});

    var stateToReturn = await c.future;
    emit(stateToReturn);
  }

  Future<void> _login(LoginCheck event, Emitter<LoginState> emit) async {
    final response = await http.post(Uri.parse(
        '${myServer}api/auth/login?phone_number=${event.phoneNumber}&password=${event.password}'));
    try {
      final result = loginAccessFromJson(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiKey', result.accessToken);
      emit(LoginCheckSuccess(result.accessToken));
    } catch (error) {
      emit(LoginCheckFail());
    }
  }

  Future<void> _checkAvailability(
      CheckAvailability event, Emitter<LoginState> emit) async {
    final response = await http.post(Uri.parse(
        '${myServer}api/auth/available?phone_number=${event.phoneNumber}'));
    if (response.body == "User exists") {
      emit(LoginPhoneAvailabilityFail());
    } else {
      emit(LoginPhoneAvailabilitySuccess());
    }
  }

  Future<void> _nothing(LoginStarted event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('apiKey');
    if (apiKey != null) {
      emit(LoginAccessSuccess());
    } else {
      emit(LoginAccessFail());
    }
  }
}
