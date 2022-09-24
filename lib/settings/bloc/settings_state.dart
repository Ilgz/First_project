part of 'settings_bloc.dart';

abstract class SettingsState {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsSnackbarSuccess extends SettingsState {}
