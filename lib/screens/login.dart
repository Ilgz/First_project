import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/login/login_bloc.dart';
import 'package:second_project/main.dart';
import 'package:second_project/screens/forgot_password.dart';
import 'package:second_project/screens/otp.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:second_project/widgets/popup.dart';
import '../helper.dart';
import '../widgets/default_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  int signUpErrorColor = Colors.white.value;
  int loginErrorColor = Colors.white.value;
  bool loginSubmitEnabled = true;
  bool loginLoading = false;
  bool signUpSubmitEnabled = true;
  bool signUpLoading = false;
  var signUpPhoneNumberController = TextEditingController();
  var signUpPasswordController = TextEditingController();
  var loginPhoneNumberController = TextEditingController();
  var loginPasswordController = TextEditingController();
  var signUpNameController = TextEditingController();
  var previousLength = 1;
  late TabController _tabController;
  late LoginBloc _bloc;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bloc = BlocProvider.of<LoginBloc>(context)..add(LoginStarted());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SafeArea(
        child: blocView(_tabController),
      )),
    );
  }

  Column buildLoginBody(TabController _tabController) {
    return Column(
      children: [
        Container(
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
                      Navigator.pop(context);
                    },
                    child: new Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.black87, size: 20),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Вход",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ]),
          ),
        ),
        Container(
            child: TabBar(
          indicatorColor: Colors.blue[800],
          labelColor: Colors.black,
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              text: "Логин",
            ),
            Tab(
              text: "Регистрация",
            ),
          ],
        )),
        Expanded(
          child: Container(
              child: TabBarView(
                  controller: _tabController,
                  children: [loginPage(), signUpPage()])),
        )
      ],
    );
  }

  Widget blocView(_tabController) {
    return BlocConsumer<LoginBloc, LoginState>(buildWhen: (context, state) {
      return state is LoginAccessFail;
    }, listener: (context, state) {
      if (state is LoginPhoneAvailabilityFail) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => const PopupWidget(
                  title: "Номер уже зарегистрирован",
                  description: "Используйте другой номер.",
                ));
        setState(() => signUpLoading = false);
      }
      if (state is LoginPhoneAvailabilitySuccess) {
        String phoneNumber = phoneNumberTrim(signUpPhoneNumberController.text);
        _bloc.add(RegisterSendSms(phoneNumber, 1));
      }
      if (state is LoginCheckSuccess) {
        //BlocProvider.of<HomeBloc>(context)..deleteData();
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => MyApp(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      }

      if (state is RegisterSendSmsSuccess) {
        String phoneNumber =
            phoneNumberTrim(signUpPhoneNumberController.value.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      verificationId: state.verificationId,
                      phoneNumber: phoneNumber,
                      name: signUpNameController.text,
                      password: signUpPasswordController.text,
                      unformattedPhoneNumber: signUpPhoneNumberController.text,
                      occasion: 1,
                    )));
      }
      if (state is LoginCheckFail) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => const PopupWidget(
                  title: "Неверный пароль",
                  description: "Попробуйте еще раз.",
                ));
        setState(() => loginLoading = false);
      }
      if (state is LoginAccessSuccess) {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => MyApp(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    }, builder: (context, state) {
      if (state is LoginAccessFail) {
        return buildLoginBody(_tabController);
      }
      if (state is LoginInitial) {
        return Container(
            color: Colors.white, child: FlutterLogo(size: double.infinity));
      }

      return const Center(
        child: Text(""),
      );
    });
  }

  Widget signUpPage() {
    return Column(children: [
      DefaultTextField(
        myController: signUpNameController,
        hintText: "Имя",
        onChange: (text) {
          if (text.length == 1 || text.length == 0) {
            setState(() {});
          }
          if (!signUpSubmitEnabled) {
            setState(() {
              signUpSubmitEnabled = true;
            });
          }
        },
        color: signUpNameController.text.isEmpty
            ? signUpErrorColor
            : Colors.white.value,
        isPassword: false,
      ),
      Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: signUpPhoneNumberController.text.length < 13
                  ? Color(signUpErrorColor)
                  : Color(Colors.white.value),
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: signUpPhoneNumberController,
            onChanged: (text) {
              if (!signUpSubmitEnabled) {
                setState(() {
                  signUpSubmitEnabled = true;
                });
              }
              if (text.length == 13 || text.length == 0) {
                setState(() {});
              }
              phoneNumberFormat(
                  previousLength, text, signUpPhoneNumberController);
              previousLength = signUpPhoneNumberController.text.length;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              new LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.allow(RegExp("[0-9) ]"))
            ],
            style: TextStyle(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              // errorText: errorTextPhoneNumber(signUpPhoneNumberController, isRegistered),
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Text(
                "+996 (",
                style: TextStyle(fontSize: 14),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
      ),
      DefaultTextField(
        myController: signUpPasswordController,
        hintText: "Пароль",
        onChange: (text) {
          if (text.length == 1 || text.length == 0) {
            setState(() {});
          }
          if (!signUpSubmitEnabled) {
            setState(() {
              signUpSubmitEnabled = true;
            });
          }
        },
        color: signUpPasswordController.text.isEmpty
            ? signUpErrorColor
            : Colors.white.value,
      ),
      BlackMaterialButton(
        buttonName: "Зарегистрироваться",
        onClick: () {
          if (signUpSubmitEnabled) {
            if (signUpNameController.text.isNotEmpty &&
                signUpPhoneNumberController.text.length == 13 &&
                signUpPasswordController.text.isNotEmpty) {
              String phoneNumber =
                  phoneNumberTrim(signUpPhoneNumberController.text);
              _bloc.add(CheckAvailability(phoneNumber));
              setState(() {
                signUpLoading = true;
                signUpSubmitEnabled = false;
              });
            } else {
              setState(() {
                signUpErrorColor = ErrorColor;
              });
            }
          }
        },
        enabled: signUpSubmitEnabled,
        loading: signUpLoading,
      )
    ]);
  }

  Widget loginPage() {
    return Column(children: [
      Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: loginPhoneNumberController.text.length < 13
                  ? Color(loginErrorColor)
                  : Color(Colors.white.value),
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: loginPhoneNumberController,
            onChanged: (text) {
              if (!loginSubmitEnabled) {
                setState(() {
                  loginSubmitEnabled = true;
                });
              }
              if (text.length == 13 || text.length == 0) {
                setState(() {});
              }
              phoneNumberFormat(
                  previousLength, text, loginPhoneNumberController);
              previousLength = loginPhoneNumberController.text.length;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              new LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.allow(RegExp("[0-9) ]"))
            ],
            style: TextStyle(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Text(
                "+996 (",
                style: TextStyle(fontSize: 14),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
      ),
      DefaultTextField(
        myController: loginPasswordController,
        hintText: "Пароль",
        onChange: (text) {
          if (text.length == 1 || text.length == 0) {
            setState(() {});
          }
          if (!loginSubmitEnabled) {
            setState(() {
              loginSubmitEnabled = true;
            });
          }
        },
        color: loginPasswordController.text.isEmpty
            ? loginErrorColor
            : Colors.white.value,
      ),
      BlackMaterialButton(
        buttonName: "Войти",
        onClick: () {
          if (loginSubmitEnabled) {
            if (loginPasswordController.text.isNotEmpty &&
                loginPhoneNumberController.text.length == 13) {
              String phoneNumber =
                  phoneNumberTrim(loginPhoneNumberController.text);
              _bloc.add(LoginCheck(phoneNumber, loginPasswordController.text));
              setState(() {
                loginLoading = true;
                loginSubmitEnabled = false;
              });
            } else {
              setState(() {
                loginErrorColor = ErrorColor;
              });
            }
          }
        },
        enabled: loginSubmitEnabled,
        loading: loginLoading,
      ),
      //SizedBox(height: 10),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
          child: Text(
            "Забыли пароль ?",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
      )
    ]);
  }
}
