import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:second_project/helper.dart';
import 'package:second_project/model/login_access.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordReset>(_showData);
  }
  Future<void> _showData(
      ForgotPasswordReset event, Emitter<ForgotPasswordState> emit) async {
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc("996" + event.phoneNumber);
    final json = {'password': event.password};
    await docUser.set(json);
    final response = await http.post(Uri.parse(
        '${myServer}api/auth/reset?newPassword=${event.password}&phone_number=${"996" + event.phoneNumber}'));
    final result = loginAccessFromJson(response.body);
    if (result.accessToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiKey', result.accessToken);
    }
    emit(ForgotPasswordResetSuccess());
  }
}
