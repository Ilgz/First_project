import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/login/login_bloc.dart';
import 'package:second_project/screens/otp.dart';
import 'package:second_project/widgets/black_material_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int defaultErrorColor = Colors.white.value;
  bool submitEnabled = true;
  bool isLoading = false;
  var previousLength = 1;
  final myController = TextEditingController();
  late LoginBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is ResetSendSmsSuccess) {
          setState(() {
            isLoading = false;
            submitEnabled = true;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Otp(
                        unformattedPhoneNumber: myController.text,
                        verificationId: state.verificationId,
                        occasion: 2,
                      )));
        }
      },
      child: buildForgotPassword(context),
    );
  }

  Scaffold buildForgotPassword(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          myAppBar(context, "Восстановить пароль"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
                "Введите номер, указанный при регистрации. Вам будет отправлен СМС код.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: myController.text.length < 13
                      ? Color(defaultErrorColor)
                      : Color(Colors.white.value),
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: myController,
                onChanged: (text) {
                  if (!submitEnabled) {
                    setState(() {
                      submitEnabled = true;
                    });
                  }
                  setErrorColor();
                  phoneNumberFormat(previousLength, text, myController);
                  previousLength = myController.text.length;
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [new LengthLimitingTextInputFormatter(13)],
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
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                ),
              ),
            ),
          ),
          BlackMaterialButton(
              buttonName: "Отправить",
              onClick: () {
                if (submitEnabled) {
                  if (myController.text.length == 13) {
                    String phoneNumber = phoneNumberTrim(myController.text);
                    _bloc.add(RegisterSendSms(phoneNumber, 2));

                    setState(() {
                      isLoading = true;
                      submitEnabled = false;
                    });
                  } else {
                    setState(() {
                      defaultErrorColor = ErrorColor;
                    });
                  }
                }
              },
              enabled: submitEnabled,
              loading: isLoading)
        ],
      ),
    ));
  }

  void setErrorColor() {
    if (defaultErrorColor == ErrorColor) {
      setState(() {});
    }
  }
}
