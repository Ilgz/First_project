part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsStarted extends SettingsEvent {}

class SettingsSnackbar extends SettingsEvent {
  @override
  List<Object> get props => [];
}
