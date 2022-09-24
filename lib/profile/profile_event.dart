part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileShow extends ProfileEvent {
  final User? user;
  ProfileShow(this.user);
  @override
  List<Object?> get props => [];
}

class LoadActiveProducts extends ProfileEvent {
  int userId;
  int occasion;
  LoadActiveProducts(this.userId, this.occasion);
  @override
  List<Object?> get props => [];
}

class LoadInactiveProducts extends ProfileEvent {
  int userId;
  int occasion;
  LoadInactiveProducts(this.userId, this.occasion);
  @override
  List<Object?> get props => [];
}
