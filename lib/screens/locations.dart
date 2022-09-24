import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/bloc/filter_bloc.dart';
import 'package:second_project/helper.dart';

import '../model/location.dart';

class Locations extends StatefulWidget {
  final bool isPosting;
  final Function(Location) callback;
  const Locations({super.key, required this.callback, this.isPosting = false});

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  var searchController = TextEditingController();
  List<Location> _locationList = PersonalDataRepo.locationList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
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
                      "Местоположение",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ]),
            ),
          ),
          Card(
            elevation: 10,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (text) {
                      BlocProvider.of<FilterBloc>(context)
                        ..add(SearchLocations(text));
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
                  left: 5,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search_outlined),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              if (state is SearchLocationsSuccess) {
                return buildLocation(context, state.list);
              }
              return buildLocation(context, _locationList);
            },
          )
        ],
      ),
    ));
  }

  Widget buildLocation(BuildContext context, list) {
    return Expanded(
      child: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            if (widget.isPosting == true) {
              if (index == 0 && list[0].titleRu == "Все") {
                return Container();
              } else {
                return _itemList(list, index, context);
              }
            } else {
              return _itemList(list, index, context);
            }
          }),
    );
  }

  InkWell _itemList(list, int index, BuildContext context) {
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
  }
}
