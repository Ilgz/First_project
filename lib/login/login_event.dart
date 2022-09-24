part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginStarted extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginCheck extends LoginEvent {
  final String phoneNumber;
  final String password;
  LoginCheck(this.phoneNumber, this.password);
  @override
  List<Object?> get props => [];
}

class LoginStartedTwo extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CheckAvailability extends LoginEvent {
  final String phoneNumber;
  CheckAvailability(this.phoneNumber);
  @override
  List<Object?> get props => [];
}

class CheckOtp extends LoginEvent {
  final String verificationID;
  final String otp;
  final int occasion;
  final String? name;
  final String? password;
  final String? phone_number;
  CheckOtp(this.verificationID, this.otp, this.occasion, this.name,
      this.password, this.phone_number);
  @override
  List<Object?> get props => [];
}

class RegisterSendSms extends LoginEvent {
  final String phoneNumber;
  final int occasion;
  RegisterSendSms(this.phoneNumber, this.occasion);
  @override
  List<Object?> get props => [];
}
