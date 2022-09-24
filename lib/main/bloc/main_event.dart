part of 'main_bloc.dart';

abstract class MainEvent {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class LoadStartData extends MainEvent {}
