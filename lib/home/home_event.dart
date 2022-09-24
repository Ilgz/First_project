part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeStarted extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeLoadProducts extends HomeEvent {
  @override
  List<Object?> get props => [];
}
