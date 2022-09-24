class UploadModel {
  int id;
  List<String> pickedFileList;
  String productName;
  int productPrice;
  String currency;
  String productDescription;
  int location;
  int category;
  UploadModel(
      {required this.pickedFileList,
      required this.productName,
      required this.productPrice,
      required this.currency,
      required this.productDescription,
      required this.location,
      required this.category,
      required this.id});
}
