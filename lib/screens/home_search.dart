import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../helper.dart';
import '../home/home_bloc.dart';
import '../model/item_product.dart';
import '../search/search_bloc.dart';
import '../widgets/filter_popup.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  late final HomeBloc _bloc = BlocProvider.of<HomeBloc>(context);
  bool isHome = true;
  List<Datum> homeItems = [];
  List<Datum> searchItems = [];
  List<Datum> productItems = [];
  final myController = TextEditingController();
  @override
  void initState() {
    _bloc.add(HomeLoadProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isHome) {
          return true;
        } else {
          isHome = true;
          myController.clear();
          productItems = homeItems;
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            //  mainAxisSize: MainAxisSize.min,
            children: [
              homesearchBar(),
              BlocListener<SearchBloc, SearchState>(
                listener: (context, state) {
                  if (state is SearchSuccess) {
                    productItems = state.items;
                    setState(() {});
                  }
                },
                child: Container(),
              ),
              BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
                if (state is HomeSuccess) {
                  homeItems = state.items;
                  productItems = homeItems;
                  setState(() {});
                }
              }, builder: (context, state) {
                if (state is HomeSuccess) {
                  return _scrollView(context);
                }
                if (state is HomeFail) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ничего не найдено",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              textAlign: TextAlign.center,
                              "Попробуйте изменить фильтры для поиска"),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.redAccent),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  _scrollView(context) {
    return Expanded(
      child: LazyLoadScrollView(
        onEndOfPage: () {
          _bloc.add(HomeLoadProducts());
        },
        child: RefreshWidget(
          onRefresh: () async {
            _bloc.deleteData();
            _bloc.add(HomeLoadProducts());
          },
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemCount: productItems.length,
              itemBuilder: (context, i) {
                return ProductItem(context, productItems[i]);
              }),
        ),
      ),
    );
  }

  Widget homesearchBar() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextField(
              controller: myController,
              onChanged: (text) {
                // widget.onChange();
              },
              onSubmitted: (text) {
                if (isHome) {
                  isHome = false;
                } else if (!isHome) {
                  isHome = true;
                }
                setState(() {});
                BlocProvider.of<SearchBloc>(context)..add(SearchFind(text));
                // if (isHome) {
                //   Navigator.of(context)
                //       .push(FadeRoute(
                //           page: Search(
                //     myController: myController,
                //   )))
                //       .whenComplete(() {
                //     myController.clear();
                //   });
                // }
              },
              style: TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: "Поиск...",
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  VerticalDivider(
                    indent: 10,
                    endIndent: 10,
                    thickness: 1,
                    width: 1,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          isScrollControlled: true,
                          builder: (BuildContext context) =>
                              const filterPopup());
                    },
                    icon: Icon(Icons.tune),
                  ),
                ],
              )),
          Positioned(
            left: 5,
            top: 0,
            bottom: 0,
            child: IconButton(
                icon: Icon(isHome ? Icons.search_outlined : Icons.arrow_back),
                onPressed: () {
                  if (!isHome) {
                    Navigator.maybePop(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
