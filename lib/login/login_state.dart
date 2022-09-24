part of 'login_bloc.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class RegisterSendSmsSuccess extends LoginState {
  final String verificationId;
  RegisterSendSmsSuccess(this.verificationId);
  @override
  List<Object?> get props => [];
}

class RegisterCheckOtpSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class RegisterCheckOtpFail extends LoginState {
  @override
  List<Object?> get props => [];
}

class ResetCheckOtpSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class ResetCheckOtpFail extends LoginState {
  @override
  List<Object?> get props => [];
}

class ResetSendSmsSuccess extends LoginState {
  final String verificationId;
  ResetSendSmsSuccess(this.verificationId);
  @override
  List<Object?> get props => [];
}

class LoginCheckSuccess extends LoginState {
  final String accessToken;
  LoginCheckSuccess(this.accessToken);
  @override
  List<Object?> get props => [];
}

class LoginCheckFail extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginAccessSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginAccessFail extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginPhoneAvailabilitySuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginPhoneAvailabilityFail extends LoginState {
  @override
  List<Object?> get props => [];
}
