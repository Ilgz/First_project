import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/login/login_bloc.dart';
import 'package:second_project/main.dart';
import 'package:second_project/screens/forgot_change_password.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:second_project/widgets/otpEntry.dart';

import '../helper.dart';
import '../home/home_bloc.dart';
import '../widgets/popup.dart';

class Otp extends StatefulWidget {
  final int occasion;
  final String verificationId;
  final String? phoneNumber;
  final String? name;
  final String? password;
  final String unformattedPhoneNumber;
  const Otp(
      {Key? key,
      required this.verificationId,
      this.phoneNumber,
      this.name,
      this.password,
      required this.unformattedPhoneNumber,
      required this.occasion})
      : super(key: key);
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late LoginBloc _bloc;
  bool isEnabled = true;
  bool isLoading = false;
  String otp = "";
  int defaultErrorColor = Colors.black87.value;
  List<TextEditingController> controllers = List.generate(6, (index) {
    final ctrl = TextEditingController();
    ctrl.value = zwspEditingValue;
    return ctrl;
  });
  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is RegisterCheckOtpFail || state is ResetCheckOtpFail) {
          setState(() {
            isLoading = false;
            isEnabled = true;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const PopupWidget(
                    title: "Неверный код",
                    description: "Попробуйте еще раз.",
                  ));
        }
        if (state is RegisterCheckOtpSuccess) {
          BlocProvider.of<HomeBloc>(context)..deleteData();
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MyApp(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }
        if (state is ResetCheckOtpSuccess) {
          setState(() {
            isLoading = false;
            isEnabled = true;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForgotChangePassword(
                      phoneNumber: widget.unformattedPhoneNumber)));
        }
      },
      child: buildOtp(),
    );
  }

  GestureDetector buildOtp() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myAppBar(context, "Подтверждение"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Мы отправили вам СМС код",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                  text: TextSpan(
                      text: "На номер: ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: "+996 (" + widget.unformattedPhoneNumber,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold))
                  ])),
            ),
            SizedBox(height: 70),
            OtpEntry(
              controllers: controllers,
              defaultErrorColor: defaultErrorColor,
              setErrorColor: setErrorColor,
            ),
            SizedBox(height: 20),
            BlackMaterialButton(
                buttonName: "Продолжить",
                onClick: () {
                  otp = "";
                  for (int i = 0; i < controllers.length; i++) {
                    otp += controllers[i].text;
                  }
                  ;
                  if (otp.length == 12) {
                    setState(() {
                      isLoading = true;
                      isEnabled = false;
                    });
                    if (widget.occasion == 1) {
                      _bloc.add(CheckOtp(
                          widget.verificationId,
                          otp.replaceAll("\u200b", ""),
                          1,
                          widget.name,
                          widget.password,
                          widget.phoneNumber));
                    } else if (widget.occasion == 2) {
                      _bloc.add(CheckOtp(widget.verificationId,
                          otp.replaceAll("\u200b", ""), 2, null, null, null));
                    }
                  } else {
                    if (defaultErrorColor != ErrorColor) {
                      setState(() {
                        defaultErrorColor = ErrorColor;
                      });
                    }
                  }
                },
                enabled: isEnabled,
                loading: isLoading),
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
              child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => print("I am gay"),
                          text: "Отправить повторно",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))
                    ],
                    text: "Не получили код ?  ",
                    style: TextStyle(color: Colors.black87)),
              ),
            )
          ],
        ),
      )),
    );
    // return GestureDetector(
    //     onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    //     child: Scaffold(
    //       body: SafeArea(
    //           child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 20),
    //                 child: InkWell(
    //                     onTap: () {},
    //                     child: Icon(Icons.arrow_back_ios_new_outlined))),
    //             Text("Мы отправили вам СМС код",
    //                 style:
    //                     TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    //             SizedBox(height: 10),
    //             RichText(
    //                 text: TextSpan(
    //                     text: "На номер: ",
    //                     style: TextStyle(
    //                         fontSize: 16,
    //                         color: Colors.black87,
    //                         fontWeight: FontWeight.bold),
    //                     children: [
    //                   TextSpan(
    //                       text: widget.unformattedPhoneNumber,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           color: Colors.blue,
    //                           fontWeight: FontWeight.bold))
    //                 ])),
    //             SizedBox(height: 70),
    //             OtpEntry(
    //               controllers: controllers,
    //               defaultErrorColor: defaultErrorColor,
    //               setErrorColor: setErrorColor,
    //             ),
    //             SizedBox(height: 20),
    //             BlackMaterialButton(
    //                 buttonName: "Продолжить",
    //                 onClick: () {
    //                   otp = "";
    //                   for (int i = 0; i < controllers.length; i++) {
    //                     otp += controllers[i].text;
    //                   }
    //                   ;
    //                   _bloc.add(CheckOtp(
    //                       widget.verificationId,
    //                       otp.replaceAll("\u200b", ""),
    //                       1,
    //                       widget.name,
    //                       widget.password,
    //                       widget.phoneNumber));

    //                 },
    //                 enabled: true,
    //                 loading: false)
    //           ],
    //         ),
    //       )),
    //     ));
  }

  void setErrorColor() {
    if (defaultErrorColor == ErrorColor) {
      setState(() {});
    }
  }
}
