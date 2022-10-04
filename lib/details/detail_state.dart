part of 'detail_bloc.dart';

abstract class DetailState {
  const DetailState();
}

class DetailInitial extends DetailState {
  @override
  List<Object?> get props => [];
}

class LoadRelatedSuccess extends DetailState {
  final List<Datum> items;
  LoadRelatedSuccess(this.items);
}
class DeleteProductLoadingState extends DetailState{}
class DeleteProductSuccessState extends DetailState{}
class ChangeStateStatusSuccess extends DetailState {}
class ChangeStateStatusLoading extends DetailState {}
