part of 'login_bloc.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class GoogleCheckSuccess extends LoginState {}

class GoogleCheckFail extends LoginState {}

class LoginLoadingState extends LoginState {}

class SignUpLoadingState extends LoginState {}

class RegisterSendSmsSuccess extends LoginState {
  final String verificationId;

  RegisterSendSmsSuccess(this.verificationId);
}

class RegisterCheckOtpSuccess extends LoginState {}

class RegisterCheckOtpFail extends LoginState {}

class ResetCheckOtpSuccess extends LoginState {}

class ResetCheckOtpFail extends LoginState {}

class ResetSendSmsSuccess extends LoginState {
  final String verificationId;

  ResetSendSmsSuccess(this.verificationId);
}

class LoginCheckSuccess extends LoginState {
  final String accessToken;

  LoginCheckSuccess(this.accessToken);
}

class LoginCheckFail extends LoginState {}

class LoginAccessSuccess extends LoginState {}

class LoginAccessFail extends LoginState {}

class LoginPhoneAvailabilitySuccess extends LoginState {}

class LoginPhoneAvailabilityFail extends LoginState {}

class ForgotPasswordPhoneExistsSuccessState extends LoginState {}

class ForgotPasswordPhoneExistsFailState extends LoginState {}

class ForgotPasswordPhoneExistsLoadingState extends LoginState {}
