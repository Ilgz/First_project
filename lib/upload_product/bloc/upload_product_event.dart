part of 'upload_product_bloc.dart';

abstract class UploadProductEvent {
  const UploadProductEvent();

  @override
  List<Object> get props => [];
}

class UploadDataGetImages extends UploadProductEvent {
  String path;
  UploadDataGetImages(this.path);
}

class UpdateData extends UploadProductEvent {
  UploadModel uploadModel;
  String state;
  UpdateData(this.uploadModel, this.state);
}

class UploadData extends UploadProductEvent {
  UploadModel uploadModel;
  UploadData(this.uploadModel);
}
