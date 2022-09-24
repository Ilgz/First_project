import 'package:flutter/material.dart';

import '../helper.dart';
import '../model/category.dart';

class Categories extends StatefulWidget {
  final Function(Category) callback;
  Categories({
    super.key,
    required this.callback,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: IntrinsicHeight(
                  child: Stack(children: [
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
                          "Категория",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildCategories(context, PersonalDataRepo.categoryList)
              // Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context, list) {
    return Expanded(
      child: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                widget.callback(list[index]);
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Icon(icons[index]),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list[index].titleRu,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
