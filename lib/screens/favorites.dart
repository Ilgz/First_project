import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:second_project/favorite/favorite_bloc.dart';

import '../details/detail_bloc.dart';
import '../helper.dart';
import '../model/item_product.dart';
import 'detail.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    BlocProvider.of<FavoriteBloc>(context)..add(LoadFavorites());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
        buildWhen: (context, state) {
          return true;
        },
        builder: (context, state) {
          if (state is LoadFavoritesSuccess) {
            print("succuss");
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: AppBar().preferredSize.height,
                    color: Colors.transparent,
                    width: double.infinity,
                    child: IntrinsicHeight(
                      child: Stack(children: [
                        Align(
                            child: Text(
                          'Избранное',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ]),
                    ),
                  ),
                  LazyLoadScrollView(
                    onEndOfPage: () {},
                    child: GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8),
                        itemCount: state.items.length,
                        itemBuilder: (context, i) {
                          return ProductItem(context, state.items[i]);
                        }),
                  ),
                ],
              ),
            );
          }
          if (state is LoadFavoritesFail) {
            return Stack(
              children: [
                Container(
                  height: AppBar().preferredSize.height,
                  color: Colors.transparent,
                  width: double.infinity,
                  child: IntrinsicHeight(
                    child: Stack(children: [
                      Align(
                          child: Text(
                        'Избранное',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ]),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Нет избранных обьявлений",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        textAlign: TextAlign.center,
                        "Нажмите на сердечко, чтобы добавить объявление в избранные"),
                  ],
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
