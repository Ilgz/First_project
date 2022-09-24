import 'dart:io';
import 'package:path/path.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../helper.dart';
import '../../model/upload_model.dart';
part 'upload_product_event.dart';
part 'upload_product_state.dart';

class UploadProductBloc extends Bloc<UploadProductEvent, UploadProductState> {
  UploadProductBloc() : super(UploadProductInitial()) {
    on<UploadData>(_uploadData);
    on<UpdateData>(_updateData);
  }
  Future<void> _updateData(
      UpdateData event, Emitter<UploadProductState> emit) async {
    var postUri = Uri.parse('${myServer}api/auc');
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    for (int i = 0; i < event.uploadModel.pickedFileList.length; i++) {
      if (event.uploadModel.pickedFileList[i] != "") {
        if (!event.uploadModel.pickedFileList[i].contains("http")) {
          request.files.add(await http.MultipartFile(
              'pictures[]',
              File(event.uploadModel.pickedFileList[i])
                  .readAsBytes()
                  .asStream(),
              File(event.uploadModel.pickedFileList[i]).lengthSync(),
              filename: 'test $i'));
        } else {
          final response =
              await http.get(Uri.parse(event.uploadModel.pickedFileList[i]));
          final documentDirectory = await getApplicationDocumentsDirectory();
          final file = File(join(documentDirectory.path, 'imagetest.png'));
          file.writeAsBytesSync(response.bodyBytes);
          request.files.add(await http.MultipartFile(
              'pictures[]', file.readAsBytes().asStream(), file.lengthSync(),
              filename: 'test $i'));
        }
      }
    }
    request.fields["product"] = event.uploadModel.productName;
    request.fields["price"] = event.uploadModel.productPrice.toString();
    request.fields["currency"] = event.uploadModel.currency.toString();
    request.fields["description"] = event.uploadModel.productDescription;
    request.fields["location"] = event.uploadModel.location.toString();
    request.fields["category"] = event.uploadModel.category.toString();
    request.fields["id"] = event.uploadModel.id.toString();
    request.fields["state"] = event.state.toString();
    request.headers["Content-Type"] = 'application/json';
    request.headers["Accept"] = 'application/json';
    request.headers["Authorization"] = 'Bearer ${PersonalDataRepo.apiKey}';
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    emit(UpdateDataSuccess());
  }

  Future<void> _uploadData(
      UploadData event, Emitter<UploadProductState> emit) async {
    var postUri = Uri.parse('${myServer}api/auc');
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    for (int i = 0; i < event.uploadModel.pickedFileList.length; i++) {
      if (event.uploadModel.pickedFileList[i] != "") {
        request.files.add(await http.MultipartFile(
            'pictures[]',
            File(event.uploadModel.pickedFileList[i]).readAsBytes().asStream(),
            File(event.uploadModel.pickedFileList[i]).lengthSync(),
            filename: 'test $i'));
      }
    }
    request.fields["product"] = event.uploadModel.productName;
    request.fields["price"] = event.uploadModel.productPrice.toString();
    request.fields["currency"] = event.uploadModel.currency.toString();

    request.fields["description"] = event.uploadModel.productDescription;
    request.fields["location"] = event.uploadModel.location.toString();
    request.fields["category"] = event.uploadModel.category.toString();

    request.headers["Content-Type"] = 'application/json';
    request.headers["Accept"] = 'application/json';
    request.headers["Authorization"] = 'Bearer ${PersonalDataRepo.apiKey}';
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    emit(UploadDataSuccess());
  }
}
