import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/main.dart';
import 'package:second_project/main/bloc/main_bloc.dart';
import 'package:second_project/profile/profile_bloc.dart';
import 'package:second_project/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_project/model/item_profile.dart';
import '../../helper.dart';
import '../../home/home_bloc.dart';
import '../../settings/bloc/settings_bloc.dart';
import '../home.dart';
import 'change_password.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SettingsBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SettingsBloc>(context)..add(SettingsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child:
          BlocConsumer<SettingsBloc, SettingsState>(listener: (context, state) {
        if (state is SettingsSnackbarSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ваш пароль был успешно изменен'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
        }
      }, builder: (context, state) {
        if (state is SettingsInitial) {
          // return _build_settings(context);
          return _build_settings(context);
        }
        return Text("Loading");
      }),
    ));
  }

  Column _build_settings(BuildContext context) {
    return Column(
      children: [
        myAppBar(context, "Настройки"),
        customTiles("Изменить пароль", Icons.person, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangePassword()));
        }),
        customTiles("Выйти", Icons.exit_to_app_outlined, () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => QuitPopup(
                  warningText: "Вы действительно хотите выйти?",
                  func: () async {
                    await BlocProvider.of<HomeBloc>(context)
                      ..deleteData();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('apiKey');
                    await prefs.remove('profile');
                    PersonalDataRepo.myProfile = Profile(
                        id: 0,
                        name: "",
                        dateJoined: DateTime(0),
                        phoneNumber: "");
                    PersonalDataRepo.favoritedIds = [];
                    PersonalDataRepo.locationList = [];
                    PersonalDataRepo.categoryList = [];
                    PersonalDataRepo.isHome = true;
                    PersonalDataRepo.apiKey = "";
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => MyApp(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  }));
        }),
      ],
    );
  }

  Widget customTiles(String name, IconData icon, Function func) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            func();
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(icon),
                SizedBox(
                  width: 10,
                ),
                Text(name),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
