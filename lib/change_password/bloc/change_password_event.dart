part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordChange extends ChangePasswordEvent {
  String oldPassword;
  String newPassword;
  ChangePasswordChange(this.oldPassword, this.newPassword);
  @override
  List<Object> get props => [];
}
