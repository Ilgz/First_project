part of 'upload_product_bloc.dart';

abstract class UploadProductState {
  const UploadProductState();

  @override
  List<Object> get props => [];
}

class UploadProductInitial extends UploadProductState {}

class UploadDataSuccess extends UploadProductState {}

class UpdateDataSuccess extends UploadProductState {}
