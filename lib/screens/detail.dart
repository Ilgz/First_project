import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:second_project/favorite/favorite_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/model/upload_model.dart';
import 'package:second_project/screens/login.dart';
import 'package:second_project/screens/upload_product.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat/bloc/chat_bloc.dart';
import '../details/detail_bloc.dart';
import '../model/item_product.dart';
import '../profile/profile_bloc.dart';
import '../widgets/popup.dart';
import '../widgets/profile_widget.dart';

class Detail extends StatefulWidget {
  final UploadModel uploadModel;
  final User user;
  final bool isGuest;
  final bool isActive;

  const Detail(
      {Key? key,
      required this.user,
      required this.uploadModel,
      this.isActive = true,
      this.isGuest = true})
      : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<Datum> items = [];
  var messageController = new TextEditingController();
  late IconData favIcon = Icons.favorite_border_outlined;

  @override
  void initState() {
    bool initialValue = false;
    for (var i = 0; i < PersonalDataRepo.favoritedIds.length; i++) {
      if (PersonalDataRepo.favoritedIds[i] == widget.uploadModel.id) {
        initialValue = true;
      }
    }
    if (!initialValue) {
      favIcon = Icons.favorite_border_outlined;
    } else {
      favIcon = Icons.favorite_outlined;
    }
    if (widget.isGuest) {
      BlocProvider.of<DetailBloc>(context)
        ..add(LoadRelated(widget.uploadModel.category, widget.uploadModel.id));
    }
    super.initState();
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: widget.isGuest != true
            ? Material(
                elevation: 20,
                child: Container(
                  child: BlocBuilder<DetailBloc, DetailState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          if(!widget.isActive)...[
                            Expanded(
                              child: BlackMaterialButton(
                                buttonName:
                               "Удалить",
                                onClick: () {
                                  BlocProvider.of<DetailBloc>(context)
                                    ..add(DeleteProductEvent(widget.uploadModel.id));
                                },
                                enabled:
                                state is DeleteProductLoadingState ? false : true,
                                loading:
                                state is DeleteProductLoadingState ? true : false,
                              ),
                            ),
                          ]
                     ,
                          Expanded(
                            child: BlackMaterialButton(
                              buttonName:
                                  widget.isActive ? "Деактивировать" : "Активировать",
                              onClick: () {
                                BlocProvider.of<DetailBloc>(context)
                                  ..add(ChangeStateStatus(widget.uploadModel.id));
                              },
                              enabled:
                                  state is ChangeStateStatusLoading ? false : true,
                              loading:
                                  state is ChangeStateStatusLoading ? true : false,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : null,
        body: MultiBlocListener(listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is SendMessageSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  // duration: Duration(hours: 2),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Сообщение успешно отправлено'),
                      Spacer(),
                      Icon(Icons.check_outlined, color: Colors.white),
                    ],
                  ),
                  backgroundColor: Colors.green[500],
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
          ),
          BlocListener<DetailBloc, DetailState>(
            listener: ((context, state) {
              if (widget.isGuest) {
                if (state is LoadRelatedSuccess) {
                  setState(() {
                    items = state.items;
                  });
                }
              }
              if (state is ChangeStateStatusSuccess) {
                BlocProvider.of<ProfileBloc>(context)
                  ..add(LoadActiveProducts(PersonalDataRepo.myProfile.id, 2))
                  ..add(LoadInactiveProducts(PersonalDataRepo.myProfile.id, 2));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.isActive?"Объявление успешно деактивировано":'Объявление успешно активировано'),
                      Spacer(),
                      Icon(Icons.check_outlined, color: Colors.white),
                    ],
                  ),
                  backgroundColor: Colors.green[500],
                  behavior: SnackBarBehavior.floating,
                ));
              }
              if (state is DeleteProductSuccessState) {
                BlocProvider.of<ProfileBloc>(context)
                  ..add(LoadActiveProducts(PersonalDataRepo.myProfile.id, 2))
                  ..add(LoadInactiveProducts(PersonalDataRepo.myProfile.id, 2));
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Объявление успешно удалено'),
                      Spacer(),
                      Icon(Icons.check_outlined, color: Colors.white),
                    ],
                  ),
                  backgroundColor: Colors.green[500],
                  behavior: SnackBarBehavior.floating,
                ));
              }
            }),
          )
        ], child: _info()));
  }

  _info() {
    List<String> pictureList = widget.uploadModel.pickedFileList;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                    height: 240,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() => activeIndex = index);
                    },
                    viewportFraction: 1),
                itemCount: pictureList.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = pictureList[index];
                  return buildImage(urlImage, index);
                },
              ),
              Positioned.fill(
                bottom: 15,
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: buildIndicator(pictureList)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                height: AppBar().preferredSize.height,
                width: double.infinity,
                child: IntrinsicHeight(
                  child: Row(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            child: Icon(Icons.arrow_back_ios_new_outlined,
                                size: 20),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: widget.isGuest,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                if (PersonalDataRepo.apiKey != "") {
                                  if (favIcon != Icons.favorite_outlined) {
                                    favIcon = Icons.favorite_outlined;
                                    BlocProvider.of<FavoriteBloc>(context)
                                      ..add(AddFavorite(widget.uploadModel.id));
                                    BlocProvider.of<FavoriteBloc>(context)
                                      ..add(LoadFavorites());
                                  } else {
                                    favIcon = Icons.favorite_border_outlined;
                                    BlocProvider.of<FavoriteBloc>(context)
                                      ..add(DeleteFavorite(
                                          widget.uploadModel.id));
                                    BlocProvider.of<FavoriteBloc>(context)
                                      ..add(LoadFavorites());
                                  }
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                }
                              });
                            },
                            child: new Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(favIcon,
                                  color: Colors.black87, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !widget.isGuest,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UploadProduct(
                                            showMySnackBar: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'Объявление успешно обновлено'),
                                                    Spacer(),
                                                    Icon(Icons.check_outlined,
                                                        color: Colors.white),
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.green[500],
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ));
                                            },
                                            uploadModel: widget.uploadModel,
                                          )));
                            },
                            child: new Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.edit,
                                  color: Colors.black87, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                widget.uploadModel.productName,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  formatPrice(widget.uploadModel.productPrice.toString(),
                      widget.uploadModel.currency.toString()),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: widget.isGuest,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: interactiveButton(Icons.call_outlined,
                                "Позвонить", Colors.green.shade700)),
                        Expanded(
                            child: interactiveButton(Icons.message_outlined,
                                "Написать", Colors.black87))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
              child: DescriptionTextWidget(
                  text: widget.uploadModel.productDescription.trim()),
            ),
            Padding(
              padding: exceptBottom(8),
              child: buildProfile(
                  widget.user, context, widget.isGuest ? true : false),
            ),
            Column(
              children: [
                widget.isGuest && items.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text("Похожие объявление",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                widget.isGuest
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: LazyLoadScrollView(
                          onEndOfPage: () {},
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 0.8),
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                return ProductItem(context, items[i]);
                              }),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget interactiveButton(IconData icons, String title, Color color) {
    return Container(
      height: 60,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: color,
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (title == "Позвонить") {
              if (widget.user.phoneNumber == null) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => const PopupWidget(
                          title: "Номер телефона скрыт",
                          description: "Напишите сообщение.",
                        ));
              } else {
                launch("tel://+${widget.user.phoneNumber}");
              }
            } else {
              if (PersonalDataRepo.apiKey != "") {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  isScrollControlled: true,
                  builder: (BuildContext context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (widget.user.phoneNumber == null) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const PopupWidget(
                                          title: "Номер телефона скрыт",
                                          description: "Напишите сообщение.",
                                        ));
                              } else {
                                launch("tel://+${widget.user.phoneNumber}");
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.call_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: "Напишите сообщение...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              BlocProvider.of<ChatBloc>(context)
                                ..add(SendMessage(
                                    PersonalDataRepo.myProfile.id,
                                    widget.user.userId.toString(),
                                    messageController.text,
                                    widget.uploadModel.id.toString()));
                              messageController.clear();

                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.black87,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(List<String> pictureList) {
    return AnimatedSmoothIndicator(
        effect: JumpingDotEffect(
          dotWidth: 10,
          dotHeight: 10,
        ),
        activeIndex: activeIndex,
        count: pictureList.length);
  }

  Widget buildImage(String urlImage, int index) => Container(
        color: Color(0xFFEBEBEB),
        child: Image.network(
          urlImage,
          width: double.infinity,
          fit: BoxFit.scaleDown,
        ),
      );
}
