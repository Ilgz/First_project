import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/model/user_product.dart';
import 'package:second_project/profile/profile_bloc.dart';
import 'package:second_project/screens/setting_section/settings.dart';
import 'package:second_project/widgets/profile_widget.dart';

import '../model/item_product.dart';
import '../model/upload_model.dart';
import 'detail.dart';

class GuestProfile extends StatefulWidget {
  final int occasion;
  final User? user;
  const GuestProfile({super.key, required this.occasion, this.user});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ProfileBloc _profileBloc;
  Data? guestActiveItems = null;
  Data? guestInactiveItems = null;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(ProfileShow(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
            buildWhen: (context, state) {
      return state is GuestProfileShowSuccess;
    }, listener: (context, state) {
      if (state is LoadGuestActiveProductsSuccess) {
        guestActiveItems = state.items;
        setState(() {});
      }
      if (state is LoadGuestInactiveProductsSuccess) {
        guestInactiveItems = state.items;
        setState(() {});
      }
      if (state is GuestProfileShowSuccess) {
        _profileBloc = BlocProvider.of<ProfileBloc>(context)
          ..add(LoadActiveProducts(state.user.userId, 1));
        _profileBloc = BlocProvider.of<ProfileBloc>(context)
          ..add(LoadInactiveProducts(state.user.userId, 1));
      }
    }, builder: (context, state) {
      if (state is GuestProfileShowSuccess) {
        return _profilePage(state, _tabController);
      }
      return Center(
          child: Text(
        "Загрузка...",
        style: TextStyle(fontSize: 16),
      ));
    }));
  }

  Widget _profilePage(state, TabController _tabController) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            appBar(context, 1),
            Padding(
              padding: exceptBottom(8),
              child: buildProfile(state.user, context, false),
            ),
            Container(
                child: TabBar(
              onTap: (index) {
                setState(() {});
              },
              labelColor: Colors.black87,
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Активные",
                ),
                Tab(
                  text: "Неактивные",
                ),
              ],
            )),
            customTabView(_tabController, 1, guestActiveItems, null,
                guestInactiveItems, null)
          ],
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  final int occasion;
  final User? user;
  const Profile({Key? key, required this.occasion, this.user})
      : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController _tabController;
  late ProfileBloc _profileBloc;
  Data? myActiveItems = null;
  Data? myInactiveItems = null;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(LoadActiveProducts(PersonalDataRepo.myProfile.id, 2));
    _profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(LoadInactiveProducts(PersonalDataRepo.myProfile.id, 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is LoadMyActiveProductsSuccess) {
        myActiveItems = state.items;
        setState(() {});
      }
      if (state is LoadMyInactiveProductsSuccess) {
        myInactiveItems = state.items;
        setState(() {});
      }
    }, builder: (context, state) {
      return _profilePage(state, _tabController);
    }));
  }

  Widget _profilePage(state, TabController _tabController) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            appBar(context, 2),
            Padding(
              padding: exceptBottom(8),
              child: buildProfile(
                  User(
                      userId: PersonalDataRepo.myProfile.id,
                      name: PersonalDataRepo.myProfile.name,
                      email: PersonalDataRepo.myProfile.email,
                      phoneNumber: PersonalDataRepo.myProfile.phoneNumber,
                      picture: PersonalDataRepo.myProfile.picture),
                  context,
                  false),
            ),
            Container(
                child: TabBar(
              onTap: (index) {
                setState(() {});
              },
              labelColor: Colors.black87,
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Активные",
                ),
                Tab(
                  text: "Неактивные",
                ),
              ],
            )),
            customTabView(
                _tabController, 2, null, myActiveItems, null, myInactiveItems,
                isGuest: false)
          ],
        ),
      ),
    );
  }
}

Widget appBar(context, int occasion) {
  if (occasion == 2) {
    return Container(
      height: AppBar().preferredSize.height,
      color: Colors.transparent,
      width: double.infinity,
      child: IntrinsicHeight(
        child: Stack(children: [
          Align(
              child: Text(
            'Профиль',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          Positioned(
            right: 0,
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                )),
          ),
        ]),
      ),
    );
  } else {
    return myAppBar(context, "Профиль");
  }
}

Widget customTabView(_tabController, int occasion, Data? guestActiveItems,
    Data? myActiveItems, Data? guestInactiveItems, Data? myInactiveItems,
    {bool isGuest = true}) {
  if (_tabController.index == 0) {
    late Data? activeItems;
    if (occasion == 1) {
      activeItems = guestActiveItems;
    } else {
      activeItems = myActiveItems;
    }
    if (activeItems != null) {
      if (activeItems.products.isNotEmpty) {
        return LazyLoadScrollView(
          onEndOfPage: () {},
          child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemCount: activeItems.products.length,
              itemBuilder: (context, i) {
                return _itemsElement(
                    context, activeItems!.products[i], activeItems,
                    isGuest: isGuest);
              }),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Нет активных объявлений",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
                textAlign: TextAlign.center,
                "Здесь будут отображаться активные объявления"),
          ],
        );
      }
    } else {
      return CircularProgressIndicator(color: Colors.black87);
    }
  } else {
    late Data? inactiveItems;
    if (occasion == 1) {
      inactiveItems = guestInactiveItems;
    } else {
      inactiveItems = myInactiveItems;
    }
    if (inactiveItems != null) {
      if (inactiveItems.products.isNotEmpty) {
        return LazyLoadScrollView(
          onEndOfPage: () {},
          child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemCount: inactiveItems.products.length,
              itemBuilder: (context, i) {
                return _itemsElement(
                    context, inactiveItems!.products[i], inactiveItems,
                    isGuest: isGuest, isActive: false);
              }),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Нет неактивных объявлений",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
                textAlign: TextAlign.center,
                "Здесь будут отображаться неактивные объявления"),
          ],
        );
      }
    } else {
      return CircularProgressIndicator(color: Colors.black);
    }
  }
}

_itemsElement(context, Product element, data,
    {bool isGuest = true, bool isActive = true}) {
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
                        productName: element.product,
                        pickedFileList: element.picture.split(" "),
                        currency: element.currency,
                        productDescription: element.description,
                        category: element.category,
                        productPrice: element.price,
                        location: element.location,
                        id: element.id,
                      ),
                      isGuest: isGuest,
                      isActive: isActive,
                      user: User(
                          phoneNumber: data.phoneNumber,
                          userId: data.userId,
                          name: data.name,
                          email: data.email),
                    )),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Ink.image(
              image: NetworkImage(element.picture.toString().split(" ")[0]),
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
