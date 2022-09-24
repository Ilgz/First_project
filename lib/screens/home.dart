import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/main/bloc/main_bloc.dart';
import 'package:second_project/screens/chat.dart';
import 'package:second_project/screens/favorites.dart';
import 'package:second_project/screens/home_search.dart';
import 'package:second_project/screens/profile.dart';
import 'package:second_project/screens/upload_product.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  @override
  void initState() {
    BlocProvider.of<MainBloc>(context)..add(LoadStartData());
    super.initState();
  }

  late var screens = [
    HomeSearch(),
    Favorites(),
    Container(),
    Chat(),
    Profile(occasion: 2),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black87,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              if (PersonalDataRepo.apiKey != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => UploadProduct(
                              showMySnackBar: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Объявление успешно создано'),
                                      Spacer(),
                                      Icon(Icons.check_outlined,
                                          color: Colors.white),
                                    ],
                                  ),
                                  backgroundColor: Colors.green[500],
                                  behavior: SnackBarBehavior.floating,
                                ));
                              },
                            ))));
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor: Colors.blue.shade100,
                  labelTextStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) {
                  if (index != 0) {
                    if (PersonalDataRepo.apiKey != "") {
                      if (index != 2) {
                        setState(() {
                          currentIndex = index;
                        });
                      }
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }
                  } else {
                    setState(() {
                      currentIndex = index;
                    });
                  }
                },
                height: 60,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home_filled),
                    label: ("Главная"),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite_outlined),
                    label: ("Избранное"),
                  ),
                  NavigationDestination(
                    icon: Icon(null),
                    label: ("Подать"),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.chat),
                    label: ("Чаты"),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: ("Профиль"),
                  ),
                ],
              )),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                if (state is LoadStartDataSuccess) {
                  return IndexedStack(
                    index: currentIndex,
                    children: screens,
                  );
                }
                if (state is LoadStartDataFail) {
                  return HomeSearch();
                }
                return Container();
              },
            ),
          )),
    );
  }
}
