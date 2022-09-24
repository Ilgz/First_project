import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/screens/home.dart';
import 'package:second_project/widgets/default_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/black_material_button.dart';

class ForgotChangePassword extends StatefulWidget {
  final String phoneNumber;
  const ForgotChangePassword({super.key, required this.phoneNumber});

  @override
  State<ForgotChangePassword> createState() => _ForgotChangePasswordState();
}

class _ForgotChangePasswordState extends State<ForgotChangePassword> {
  bool isEnabled = true;
  bool isLoading = false;
  int defaultErrorColor = Colors.white.value;
  late ForgotPasswordBloc _bloc;
  var myController = TextEditingController();
  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordResetSuccess) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => Home(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }
      },
      child: build_forgot_change_password(context),
    );
    //return build_forgot_change_password(context);
  }

  GestureDetector build_forgot_change_password(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              myAppBar(context, "Восстановить пароль"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("Введите новый пароль.",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              DefaultTextField(
                  myController: myController,
                  hintText: "Пароль",
                  onChange: (text) {
                    if (text.length == 1 || text.length == 0) {
                      setState(() {});
                    }
                    if (!isEnabled) {
                      setState(() {
                        isEnabled = true;
                      });
                    }
                  },
                  color: myController.text.isEmpty
                      ? defaultErrorColor
                      : Colors.white.value),
              BlackMaterialButton(
                buttonName: "Сохранить",
                onClick: () {
                  if (isEnabled) {
                    if (myController.text.isNotEmpty) {
                      String phoneNumber = widget.phoneNumber
                          .replaceAll("+", "")
                          .replaceAll("(", "")
                          .replaceAll(")", "")
                          .replaceAll(" ", "");
                      setState(() {
                        isLoading = true;
                        isEnabled = false;
                      });
                      _bloc.add(
                          ForgotPasswordReset(phoneNumber, myController.text));
                    } else {
                      setState(() {
                        defaultErrorColor = ErrorColor;
                      });
                    }
                  }
                },
                enabled: isEnabled,
                loading: isLoading,
              ),
            ],
          ),
        )));
  }
}
