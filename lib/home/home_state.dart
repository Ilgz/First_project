part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeFail extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Datum> items;
  HomeSuccess(this.items);
  @override
  List<Object?> get props => [items];
}
