import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:second_project/bloc/filter_bloc.dart';
import 'package:second_project/change_password/bloc/change_password_bloc.dart';
import 'package:second_project/chat/bloc/chat_bloc.dart';
import 'package:second_project/details/detail_bloc.dart';
import 'package:second_project/favorite/favorite_bloc.dart';
import 'package:second_project/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:second_project/home/home_bloc.dart';
import 'package:second_project/main/bloc/main_bloc.dart';
import 'package:second_project/profile/profile_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:second_project/screens/chat.dart';
import 'package:second_project/search/search_bloc.dart';
import 'package:second_project/settings/bloc/settings_bloc.dart';
import 'package:second_project/upload_product/bloc/upload_product_bloc.dart';
import 'package:second_project/user_product/user_product_bloc.dart';
import 'package:second_project/widgets/popup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';
import 'login/login_bloc.dart';
import 'screens/home.dart';
import 'screens/login.dart';

//void main()=>runApp(MaterialApp(home: Scaffold(body: Align(alignment:Alignment.bottomLeft,child:Padding(padding:EdgeInsets.all(100),child:Text("Ilgiz")))),));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // late AppLifecycleState _lastLifecycleState;
  // var client = http.Client();
  // void getKey() async {
  //   // Map<String, String> requestHeaders = {
  //   //   'Content-Type': 'application/json',
  //   //   'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
  //   // };
  //   // if (PersonalDataRepo.apiKey != "") {
  //   //   client.put(Uri.parse("${myServer}api/mes/1?status=online"),
  //   //       headers: requestHeaders);
  //   // }
  // }

  @override
  void initState() {
    super.initState();
    //getKey();
    initializeDateFormatting('ru');

    //WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     _lastLifecycleState = state;
  //   });
  //   Map<String, String> requestHeaders = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
  //   };
  //   if (PersonalDataRepo.apiKey != "") {
  //     print(_lastLifecycleState.index);
  //     if (_lastLifecycleState.index == 2) {
  //       client.put(Uri.parse("${myServer}api/mes/1?status=away"),
  //           headers: requestHeaders);
  //     }
  //     if (_lastLifecycleState.index == 0) {
  //       client.put(Uri.parse("${myServer}api/mes/1?status=online"),
  //           headers: requestHeaders);
  //     }
  //     if (_lastLifecycleState.index == 3) {
  //       print("closed");
  //       client.close();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
        providers: [
          BlocProvider<MainBloc>(
            create: (context) => MainBloc(),
          ),
          BlocProvider<UploadProductBloc>(
            create: (context) => UploadProductBloc(),
          ),
          BlocProvider<FavoriteBloc>(
            create: (context) => FavoriteBloc(),
          ),
          BlocProvider<FilterBloc>(
            create: (context) => FilterBloc(),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider<DetailBloc>(
            create: (context) => DetailBloc(),
          ),
          BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
          BlocProvider<UserProductBloc>(
            create: (context) => UserProductBloc()..add(UserProductStarted()),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc()..add(SearchStarted()),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (context) => ChangePasswordBloc(),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc(),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
          ),
        ],
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme:
                    GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme)),
            debugShowCheckedModeBanner: false,
            title: 'Bloc example',
            initialRoute: '/',
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case '':
                  return MaterialPageRoute(
                      builder: (context) => Chat(), settings: routeSettings);
                default:
                  return MaterialPageRoute(
                      builder: (context) => Home(), settings: routeSettings);
                  break;
              }
            },
          ),
        ));
  }
}
