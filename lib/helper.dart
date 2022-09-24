import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_project/model/item_profile.dart';
import 'package:second_project/model/upload_model.dart';
import 'package:second_project/screens/detail.dart';
import 'package:second_project/widgets/popup.dart';
import 'model/category.dart';
import 'model/location.dart';
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';
import 'model/model_added_message.dart';
import 'model/model_message.dart';

class PusherService {
  final Function(Datum) callbackMessageCame;
  static Function(Datum)? callback;
  final Function(Datum) callbackHasRead;
  PusherService(this.callbackMessageCame, this.callbackHasRead);
  Function(Datum)? newMessageScreen;

  /// Init Pusher Listener
  void initPusher(String appKey, String host, int port, String cluster) {
    LaravelFlutterPusher laravelFlutterPusher = LaravelFlutterPusher(
        appKey,
        PusherOptions(
            auth: PusherAuth(
              "https://ucontv.com.kg/app/public/broadcasting/auth",
              headers: {
                "Accept": "application/json",
                'Authorization': 'Bearer ${PersonalDataRepo.apiKey}'
              },
            ),
            host: host,
            port: port,
            encrypted: false,
            cluster: cluster),
        enableLogging: true, onConnectionStateChange: (status) {
      print(status.currentState.characters);
    });
    // Channel channelOnline = laravelFlutterPusher.subscribe(
    //   "presence-online.",
    // );
    Channel channel = laravelFlutterPusher.subscribe(
      "presence-chat.${PersonalDataRepo.myProfile.id}",
    );

    channel.bind("chat-event", (event) {
      var objectile = missouriFromJson(jsonEncode(event));
      var message = objectile.message;
      if (callback != null) {
        callback!(Datum(
            from: message.from,
            to: message.to,
            message: message.message,
            has_read: "false",
            productId: message.productId,
            created_at: message.createdAt));
      }
      callbackMessageCame(Datum(
          from: message.from,
          to: message.to,
          has_read: "false",
          message: message.message,
          productId: message.productId,
          created_at: message.createdAt));
    });
  }
}

class ChatService {
  Function(Datum) callbackMessageCame;
  ChatService(this.callbackMessageCame);

  Function(Datum) chatGetData(Function(Datum) callbackMessageCame) {
    return callbackMessageCame;
  }
}

//const myServer = "http://10.0.2.2:8000/";
const myServer = "https://ucontv.com.kg/app/public/";
String formattedNumber(String number) {
  return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
}

String formatPrice(String price, String currency) {
  if (price == "0") {
    return "Договорная";
  } else {
    return formattedNumber(price) + " " + currency;
  }
}

ProductItem(context, element) {
  return Card(
    elevation: 5.0,
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    color: Colors.white,
    child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detail(
                      uploadModel: UploadModel(
                        id: element.id,
                        productName: element.product,
                        pickedFileList: element.picture.split(" "),
                        currency: element.currency,
                        productDescription: element.description,
                        category: element.category,
                        location: element.location,
                        productPrice: element.price,
                      ),
                      user: element.user,
                    )),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Ink.image(
              image: NetworkImage(
                element.picture.toString().split(" ")[0],
              ),
              onImageError: (context, error) {},
              fit: BoxFit.cover,
              height: 200,
            )),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                element.product.toString() + "\n",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                formatPrice(element.price.toString(), element.currency),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )),
  );
}

class MyMessageHandler {
  static void showMySnackBar(var _scaffoldKey, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}

class ChatRepo {
  static List<List<Datum>>? chatList = [];
}

class PersonalDataRepo {
  static Profile myProfile =
      Profile(id: 0, name: "", dateJoined: DateTime(0), phoneNumber: "");
  static String apiKey = "";
  static List<int> favoritedIds = [];
  static List<Location> locationList = [];
  static List<Category> categoryList = [];
  static bool isHome = true;
}

class FilterPreferences {
  static int minPrice = 0;
  static int maxPrice = 0;
  static Location location = Location(id: 1, titleRu: "Все");
  static Category category = Category(id: 0, titleRu: "Все");
  static Filter sorting = Filter.asDefault;
}

EdgeInsets exceptBottom(double dp) {
  return EdgeInsets.only(right: dp, left: dp, top: dp);
}

String phoneNumberTrim(String phone_number) {
  return "996" + phone_number.trim().replaceAll(")", "").replaceAll(" ", "");
}

String phoneNumberFormatSpacer(String number, int selection) {
  if (number.length == 3) {
    return number + ") ";
  } else if (number.length == 7) {
    return number + " ";
  } else if (number.length == 10) {
    return number + " ";
  } else {
    return number;
  }
}

phoneNumberFormat(int previousLength, String text,
    TextEditingController phoneNumberController) {
  if (previousLength > text.length) {
    if (previousLength == 5) {
      phoneNumberController.text = phoneNumberController.text.substring(0, 2);
      phoneNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumberController.text.length));
    } else if (previousLength == 8) {
      phoneNumberController.text = phoneNumberController.text.substring(0, 6);

      phoneNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumberController.text.length));
    } else if (previousLength == 11) {
      phoneNumberController.text = phoneNumberController.text.substring(0, 9);
      phoneNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumberController.text.length));
    }
  } else {
    phoneNumberController.text = phoneNumberFormatSpacer(text, text.length);
    phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneNumberController.text.length));
  }
}

enum Filter {
  asDefault,
  asNewest,
  asCheapest,
  asExpensivest,
}

int ErrorColor = Color(0xffff0033).value;
String? errorTextPhoneNumber(
    TextEditingController _controller, bool isRegistered) {
  // at any time, we can get the text from _controller.value.text
  final text = _controller.value.text;
  // Note: you can do your own custom validation here
  // Move this logic this outside the widget for more testable code
  if (text.isEmpty) {
    return 'Не может быть пустым';
  }
  if (text.length < 4) {
    return 'Слишком коротко';
  }
  if (isRegistered) {
    return "Такой номер уже зарегистрирован";
  } else {
    return null;
  }
  // return null if the text is valid
}

Widget myAppBar(context, String title, {bool isClose = false}) {
  return Container(
    margin: EdgeInsets.only(top: 5, left: 20, right: 20),
    height: AppBar().preferredSize.height,
    width: double.infinity,
    child: IntrinsicHeight(
      child: Stack(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (isClose == false) {
                  Navigator.pop(context);
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => QuitPopup(
                          warningText:
                              "Вы действительно хотите выйти? Информация не сохраняется",
                          func: () async {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }));
                }
              },
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ]),
    ),
  );
}

class ToggleButton extends StatefulWidget {
  final Function(String) callbackCurrency;
  final String initialCurrency;
  const ToggleButton(
      {required this.callbackCurrency, required this.initialCurrency});
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

Size size = WidgetsBinding.instance.window.physicalSize;
double ratio = WidgetsBinding.instance.window.devicePixelRatio;
double width = size.width / ratio;
const double height = 40.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;

class _ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  double _radiusCircleAngle = 15;
  @override
  void initState() {
    super.initState();
    if (widget.initialCurrency == "KGS") {
      xAlign = loginAlign;
      loginColor = selectedColor;
      signInColor = normalColor;
    }

    if (widget.initialCurrency == "USD") {
      xAlign = signInAlign;
      signInColor = selectedColor;

      loginColor = normalColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(_radiusCircleAngle),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign, 0),
              duration: Duration(milliseconds: 300),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radiusCircleAngle),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.callbackCurrency("KGS");
                  xAlign = loginAlign;
                  loginColor = selectedColor;
                  signInColor = normalColor;
                });
              },
              child: Align(
                alignment: Alignment(-1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'KGS',
                    style: TextStyle(
                      color: loginColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.callbackCurrency("USD");
                  xAlign = signInAlign;
                  signInColor = selectedColor;

                  loginColor = normalColor;
                });
              },
              child: Align(
                alignment: Alignment(1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'USD',
                    style: TextStyle(
                      color: signInColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      // padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf, style: new TextStyle(fontSize: 16))
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: new TextStyle(fontSize: 16)),
                new InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        flag
                            ? Text(
                                "Читать далее",
                                style: new TextStyle(
                                    fontSize: 16, color: Colors.blue),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState>? keyRefresh;
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    Key? key,
    this.keyRefresh,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) =>
      Platform.isAndroid ? buildAndroidList() : buildIOSList();

  Widget buildAndroidList() => RefreshIndicator(
      key: widget.keyRefresh,
      onRefresh: widget.onRefresh,
      child: widget.child,
      color: Colors.black87);

  Widget buildIOSList() => CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
          SliverToBoxAdapter(child: widget.child),
        ],
      );
}
