import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/home/home_bloc.dart';
import 'package:second_project/model/category.dart';
import 'package:second_project/model/location.dart';
import 'package:second_project/screens/categories.dart';
import 'package:second_project/search/search_bloc.dart';
import 'package:second_project/widgets/black_material_button.dart';
import 'package:second_project/widgets/default_text_field.dart';

import '../screens/locations.dart';

class filterPopup extends StatefulWidget {
  const filterPopup({super.key});

  @override
  State<filterPopup> createState() => _filterPopupState();
}

class _filterPopupState extends State<filterPopup> {
  bool isPriceVisible = true;
  var minPriceController = TextEditingController();
  var maxPriceController = TextEditingController();
  late var _category;
  late var _location;
  late var _minPrice;
  late var _maxPrice;
  late Filter _filter;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Stack(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        FilterPreferences.minPrice = 0;
                        FilterPreferences.maxPrice = 0;
                        FilterPreferences.location =
                            Location(id: 1, titleRu: "Все");
                        FilterPreferences.category =
                            Category(id: 0, titleRu: "Все");
                        FilterPreferences.sorting = Filter.asDefault;
                        init();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Очистить",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 20),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Фильтр",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ]),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Categories(
                          callback: (value) => setState(() {
                                _category = value;
                              }))));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Категория",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    _category.titleRu,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 6),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Locations(
                          callback: (value) => setState(() {
                                _location = value;
                              }))));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Местоположение",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    _location.titleRu,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 6),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Цена",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 6),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: minPriceController,
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    _minPrice = int.parse(text);
                                  } else {
                                    _minPrice = 0;
                                  }
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: "От",
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(),
                    // ),
                    Expanded(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: maxPriceController,
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    _maxPrice = int.parse(text);
                                  } else {
                                    _maxPrice = 0;
                                  }
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: "До",
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Сортировать",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 6),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _filter = Filter.asDefault;
                        });
                      },
                      child: ListTile(
                        title: const Text('По умолчанию'),
                        leading: Radio<Filter>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black87),
                          value: Filter.asDefault,
                          groupValue: _filter,
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _filter = Filter.asNewest;
                        });
                      },
                      child: ListTile(
                        title: const Text('Сначала новые'),
                        leading: Radio<Filter>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black87),
                          value: Filter.asNewest,
                          groupValue: _filter,
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _filter = Filter.asCheapest;
                        });
                      },
                      child: ListTile(
                        title: const Text('Сначала дешевле'),
                        leading: Radio<Filter>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black87),
                          value: Filter.asCheapest,
                          groupValue: _filter,
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _filter = Filter.asExpensivest;
                        });
                      },
                      child: ListTile(
                        title: const Text('Сначала дороже'),
                        leading: Radio<Filter>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black87),
                          value: Filter.asExpensivest,
                          groupValue: _filter,
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          BlackMaterialButton(
              buttonName: "Применить",
              onClick: () {
                FilterPreferences.minPrice = _minPrice;
                FilterPreferences.maxPrice = _maxPrice;
                FilterPreferences.category = _category;
                FilterPreferences.location = _location;
                FilterPreferences.sorting = _filter;
                BlocProvider.of<HomeBloc>(context)..deleteData();
                BlocProvider.of<HomeBloc>(context)..add(HomeLoadProducts());
                if (BlocProvider.of<SearchBloc>(context)
                    .getQuery()
                    .isNotEmpty) {
                  BlocProvider.of<SearchBloc>(context)
                    ..add(SearchFind(
                        BlocProvider.of<SearchBloc>(context).getQuery()));
                }
                Navigator.pop(context);
              },
              enabled: true,
              loading: false),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void init() {
    _category = FilterPreferences.category;
    _location = FilterPreferences.location;
    _minPrice = FilterPreferences.minPrice;
    _maxPrice = FilterPreferences.maxPrice;
    _filter = FilterPreferences.sorting;
    if (FilterPreferences.minPrice.toString() != "0") {
      minPriceController.text = FilterPreferences.minPrice.toString();
    } else {
      minPriceController.clear();
    }
    if (FilterPreferences.maxPrice.toString() != "0") {
      maxPriceController.text = FilterPreferences.maxPrice.toString();
    } else {
      maxPriceController.clear();
    }
  }
}
