part of 'detail_bloc.dart';

abstract class DetailEvent {
  const DetailEvent();
}

class DetailStarted extends DetailEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeStateStatus extends DetailEvent {
  int id;
  ChangeStateStatus(this.id);
}

class LoadRelated extends DetailEvent {
  int category;
  int id;
  LoadRelated(this.category, this.id);
}
