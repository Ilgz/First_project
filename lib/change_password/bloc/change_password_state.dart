part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordSame extends ChangePasswordState {}

class ChangePasswordFail extends ChangePasswordState {}
