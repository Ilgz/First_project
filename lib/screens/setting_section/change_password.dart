import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/change_password/bloc/change_password_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/screens/login.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/login_bloc.dart';
import '../../settings/bloc/settings_bloc.dart';
import '../../widgets/default_text_field.dart';
import '../../widgets/popup.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  int defaultColor = Colors.white.value;
  bool loginLoading = false;
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool submitEnabled = true;
  late ChangePasswordBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ChangePasswordBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SafeArea(
              child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                  listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          final SettingsBloc _setBloc = BlocProvider.of<SettingsBloc>(context);
          _setBloc.add(SettingsSnackbar());
          Navigator.pop(context);
        }
        if (state is ChangePasswordFail) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const PopupWidget(
                    title: "Неверный пароль",
                    description: "Попробуйте еще раз.",
                  ));
          setState(() => loginLoading = false);
        }
      }, builder: (context, state) {
        return _buildPage();
      }))),
    );
  }

  Column _buildPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myAppBar(context, "Изменить пароль"),
        SizedBox(
          height: 10,
        ),
        DefaultTextField(
          myController: oldPasswordController,
          hintText: "Текущий пароль",
          onChange: (text) {
            if (text.length == 1 || text.length == 0) {
              setState(() {});
            }
            if (!submitEnabled) {
              setState(() {
                submitEnabled = true;
              });
            }
          },
          color: oldPasswordController.text.isEmpty
              ? defaultColor
              : Colors.white.value,
        ),
        SizedBox(
          height: 10,
        ),
        DefaultTextField(
          myController: newPasswordController,
          hintText: "Новый пароль",
          onChange: (text) {
            if (text.length == 1 || text.length == 0) {
              setState(() {});
            }
            if (!submitEnabled) {
              setState(() {
                submitEnabled = true;
              });
            }
          },
          color: newPasswordController.text.isEmpty
              ? defaultColor
              : Colors.white.value,
        ),
        SizedBox(
          height: 10,
        ),
        DefaultTextField(
          myController: confirmPasswordController,
          hintText: "Повторите новый пароль",
          onChange: (text) {
            if (text.length == 1 || text.length == 0) {
              setState(() {});
            }
            if (!submitEnabled) {
              setState(() {
                submitEnabled = true;
              });
            }
          },
          color: confirmPasswordController.text.isEmpty
              ? defaultColor
              : Colors.white.value,
        ),
        BlackMaterialButton(
          buttonName: "ОК",
          onClick: () {
            if (submitEnabled) {
              if (oldPasswordController.text.isNotEmpty &&
                  newPasswordController.text.isNotEmpty &&
                  confirmPasswordController.text.isNotEmpty) {
                if (oldPasswordController.text == newPasswordController.text) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => const PopupWidget(
                            title: "Ошибка",
                            description:
                                "Новый  пароль должен отличаться от текущего.",
                          ));
                } else {
                  _bloc.add(ChangePasswordChange(
                      oldPasswordController.text, newPasswordController.text));
                  setState(() {
                    loginLoading = true;
                    submitEnabled = false;
                  });
                }
              } else {
                setState(() {
                  defaultColor = ErrorColor;
                });
              }
            }
          },
          enabled: submitEnabled,
          loading: loginLoading,
        ),
      ],
    );
  }

  void setErrorColor() {
    if (defaultColor == ErrorColor) {
      setState(() {});
    }
  }
}
