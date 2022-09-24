import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/model/category.dart';
import 'package:second_project/model/upload_model.dart';
import 'package:second_project/upload_product/bloc/upload_product_bloc.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:second_project/widgets/default_text_field.dart';

import '../model/location.dart';
import '../profile/profile_bloc.dart';
import '../widgets/popup.dart';
import 'categories.dart';
import 'locations.dart';

class UploadProduct extends StatefulWidget {
  final Function showMySnackBar;
  final UploadModel? uploadModel;
  const UploadProduct(
      {super.key, required this.showMySnackBar, this.uploadModel});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  int _locationError = Colors.black87.value;
  int _categoryError = Colors.black87.value;
  int errorColor = Colors.white.value;
  int _imageError = Colors.black87.value;
  var productNameController = TextEditingController();
  var productPriceController = TextEditingController();
  var productDescriptionController = TextEditingController();
  String _currencyIndex = "KGS";
  Category _category = Category(id: 0, titleRu: "Не указано");

  Location _location = Location(id: 1, titleRu: "Не указано");
  bool _isLoading = false;
  bool _isEnabled = true;

  late List<String> _pickedFileList;
  final _picker = ImagePicker();
  Future<void> _pickImage(int index) async {
    _pickedFileList[index] = await _picker
        .getImage(source: ImageSource.gallery)
        .then((value) => value!.path);
    if (_pickedFileList[index] != "") {
      setState(() {});
    }
  }

  @override
  void initState() {
    _pickedFileList = List<String>.filled(15, "");
    if (widget.uploadModel != null) {
      for (int i = 0; i < widget.uploadModel!.pickedFileList.length; i++) {
        _pickedFileList[i] = (widget.uploadModel!.pickedFileList[i]);
      }
      productNameController.text = widget.uploadModel!.productName;
      productDescriptionController.text =
          widget.uploadModel!.productDescription;
      productPriceController.text = widget.uploadModel!.productPrice.toString();
      for (int i = 0; i < PersonalDataRepo.categoryList.length; i++) {
        if (PersonalDataRepo.categoryList[i].id ==
            widget.uploadModel!.category) {
          _category = Category(
              id: widget.uploadModel!.category,
              titleRu: PersonalDataRepo.categoryList[i].titleRu);
          break;
        }
      }
      for (int i = 0; i < PersonalDataRepo.locationList.length; i++) {
        if (PersonalDataRepo.locationList[i].id ==
            widget.uploadModel!.location) {
          _location = Location(
              id: widget.uploadModel!.location,
              titleRu: PersonalDataRepo.locationList[i].titleRu);
          break;
        }
      }
      _currencyIndex = widget.uploadModel!.currency;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => QuitPopup(
                  warningText:
                      "Вы действительно хотите выйти? Информация не сохраняется",
                  func: () async {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }));
          return false;
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  myAppBar(context, "Объявление", isClose: true),
                  const SizedBox(
                    height: 35,
                  ),
                  BlocListener<UploadProductBloc, UploadProductState>(
                    listener: ((context, state) {
                      if (state is UploadDataSuccess ||
                          state is UpdateDataSuccess) {
                        BlocProvider.of<ProfileBloc>(context)
                          ..add(LoadActiveProducts(
                              PersonalDataRepo.myProfile.id, 2))
                          ..add(LoadInactiveProducts(
                              PersonalDataRepo.myProfile.id, 2));
                        Navigator.pop(context);
                        if (state is UpdateDataSuccess) {
                          Navigator.pop(context);
                        }

                        widget.showMySnackBar();
                      }
                    }),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                            height: 150,
                            child: StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.count(
                                      index == 0 ? 2 : 1, index == 0 ? 2 : 1),
                              crossAxisCount: 2,
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    for (int i = 0;
                                        i < _pickedFileList.length;
                                        i++) {
                                      if (_pickedFileList[i] == "") {
                                        _pickImage(i);
                                        break;
                                      }
                                    }
                                  },
                                  child: new Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: _pickedFileList[index] != ""
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                _imageBuilder(index),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _pickedFileList[index] =
                                                            "";
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(Icons.clear,
                                                          color: Colors.white,
                                                          size: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: SvgPicture.asset(
                                                    'assets/images/imagio.svg',
                                                    color: index == 0
                                                        ? Color(_imageError)
                                                        : Colors.black87),
                                              ))),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DefaultTextField(
                          myController: productNameController,
                          hintText: "Название",
                          onChange: (text) {
                            if (text.length == 1 || text.length == 0) {
                              setState(() {});
                            }
                          },
                          isPassword: false,
                          color: productNameController.text.isEmpty
                              ? errorColor
                              : Colors.white.value),
                      SizedBox(
                        height: 10,
                      ),
                      DefaultTextField(
                          myController: productDescriptionController,
                          hintText: "Описание",
                          onChange: (text) {
                            if (text.length == 1 || text.length == 0) {
                              setState(() {});
                            }
                          },
                          isPassword: false,
                          color: productDescriptionController.text.isEmpty
                              ? errorColor
                              : Colors.white.value),
                      SizedBox(
                        height: 10,
                      ),
                      DefaultTextField(
                          isNumber: true,
                          myController: productPriceController,
                          hintText: "Стоимость",
                          onChange: (text) {},
                          isPassword: false,
                          color: Colors.white.value),
                      SizedBox(
                        height: 10,
                      ),
                      ToggleButton(
                          callbackCurrency: (value) => _currencyIndex = value,
                          initialCurrency: _currencyIndex),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              "Детали",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Categories(
                                            callback: (value) => setState(() {
                                                  _category = value;
                                                }))));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Категория",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Text(
                                      _category.titleRu,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, left: 6),
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: _category.id != 0
                                  ? Colors.black87
                                  : Color(_categoryError),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Locations(
                                            isPosting: true,
                                            callback: (value) => setState(() {
                                                  _location = value;
                                                }))));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Местоположение",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Text(
                                      _location.titleRu,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, left: 6),
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: _location.id != 1
                                  ? Colors.black87
                                  : Color(_locationError),
                            ),
                          ],
                        ),
                      ),
                      BlackMaterialButton(
                          buttonName: widget.uploadModel == null
                              ? "Добавить"
                              : "Обновить",
                          onClick: () {
                            if (_isEnabled) {
                              if (productNameController.text.isNotEmpty &&
                                  productDescriptionController
                                      .text.isNotEmpty &&
                                  _category.id != 0 &&
                                  _location != 1 &&
                                  _pickedFileList[0] != "") {
                                late int _myPrice;
                                if (productPriceController.text.isEmpty) {
                                  _myPrice = 0;
                                } else {
                                  _myPrice =
                                      int.parse(productPriceController.text);
                                }
                                if (widget.uploadModel != null) {
                                  BlocProvider.of<UploadProductBloc>(context)
                                    ..add(UpdateData(
                                        UploadModel(
                                            id: widget.uploadModel!.id,
                                            pickedFileList: _pickedFileList,
                                            productName:
                                                productNameController.text,
                                            productPrice: _myPrice,
                                            currency: _currencyIndex,
                                            productDescription:
                                                productDescriptionController
                                                    .text,
                                            location: _location.id,
                                            category: _category.id),
                                        "active"));
                                } else {
                                  BlocProvider.of<UploadProductBloc>(context)
                                    ..add(UploadData(UploadModel(
                                        id: widget.uploadModel?.id ?? 0,
                                        pickedFileList: _pickedFileList,
                                        productName: productNameController.text,
                                        productPrice: _myPrice,
                                        currency: _currencyIndex,
                                        productDescription:
                                            productDescriptionController.text,
                                        location: _location.id,
                                        category: _category.id)));
                                }
                                setState(() {
                                  _isLoading = true;
                                  _isEnabled = false;
                                });
                              } else {
                                setState(() {
                                  errorColor = ErrorColor;
                                  _locationError = ErrorColor;
                                  _categoryError = ErrorColor;
                                  _imageError = ErrorColor;
                                });
                              }
                            }
                          },
                          enabled: _isEnabled,
                          loading: _isLoading)
                    ]),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _imageBuilder(int index) {
    if (_pickedFileList[index].contains("http")) {
      return Image.network(_pickedFileList[index], fit: BoxFit.cover);
    } else {
      return Image.file(File(_pickedFileList[index]), fit: BoxFit.cover);
    }
  }
}
