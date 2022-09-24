import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordChange>(_changePassword);
  }
  Future<void> _changePassword(
      ChangePasswordChange event, Emitter<ChangePasswordState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('apiKey');
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    String request =
        '${myServer}api/auth/change_password?current-password=${event.oldPassword}&new-password=${event.newPassword}';
    final response =
        await http.post(Uri.parse(request), headers: requestHeaders);
    if (response.body == "Wrong password") {
      emit(ChangePasswordFail());
    } else if (response.body == "Passwords are same") {
      emit(ChangePasswordSame());
    } else {
      emit(ChangePasswordSuccess());
    }
  }
}
