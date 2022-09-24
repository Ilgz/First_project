part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotPasswordReset extends ForgotPasswordEvent {
  String phoneNumber;
  String password;
  ForgotPasswordReset(this.phoneNumber, this.password);
  @override
  List<Object?> get props => [];
}
