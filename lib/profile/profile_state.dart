part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class GuestProfileShowSuccess extends ProfileState {
  final User user;
  GuestProfileShowSuccess(this.user);
}

class MyProfileShowSuccess extends ProfileState {
  final User user;
  MyProfileShowSuccess(this.user);
}

class LoadGuestActiveProductsSuccess extends ProfileState {
  final Data items;
  LoadGuestActiveProductsSuccess(this.items);
  @override
  List<Object?> get props => [];
}

class LoadGuestInactiveProductsSuccess extends ProfileState {
  final Data items;
  LoadGuestInactiveProductsSuccess(this.items);
  @override
  List<Object?> get props => [];
}

class LoadMyActiveProductsSuccess extends ProfileState {
  final Data items;
  LoadMyActiveProductsSuccess(this.items);
  @override
  List<Object?> get props => [];
}

class LoadMyInactiveProductsSuccess extends ProfileState {
  final Data items;
  LoadMyInactiveProductsSuccess(this.items);
  @override
  List<Object?> get props => [];
}

class ProfileShowFail extends ProfileState {}

class ProfileInitial extends ProfileState {}
