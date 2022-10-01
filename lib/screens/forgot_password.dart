import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/login/login_bloc.dart';
import 'package:second_project/screens/otp.dart';
import 'package:second_project/widgets/black_material_button.dart';

import '../widgets/popup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int defaultErrorColor = Colors.white.value;
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
        if(state is ForgotPasswordPhoneExistsSuccessState){
          String phoneNumber = phoneNumberTrim(myController.text);
          _bloc.add(RegisterSendSms(phoneNumber, 2));
        }
        if(state is ForgotPasswordPhoneExistsFailState){
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const PopupWidget(
                title: "Номер не был найден",
                description: "Используйте другой номер или зарегистрируйтесь.",
              ));
        }
        if (state is ResetSendSmsSuccess) {
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
          BlocBuilder<LoginBloc, LoginState>(
  builder: (context, state) {
    return BlackMaterialButton(
              buttonName: "Отправить",
              onClick: () {
                if (state is !ForgotPasswordPhoneExistsLoadingState) {
                  if (myController.text.length == 13) {
                    String phoneNumber = phoneNumberTrim(myController.text);
                    print(phoneNumber+"aaaa");

                    _bloc.add(CheckAvailability(phoneNumber,screen: 2));
                  } else {
                    setState(() {
                      defaultErrorColor = ErrorColor;
                    });
                  }
                }
              },
      enabled: state is ForgotPasswordPhoneExistsLoadingState?false:true,
      loading: state is ForgotPasswordPhoneExistsLoadingState?true:false,
    );
  },
)
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
