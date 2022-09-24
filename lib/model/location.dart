// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Location> locationFromJson(String str) =>
    List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    required this.id,
    required this.titleRu,
  });

  int id;
  String titleRu;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        titleRu: json["title_ru"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_ru": titleRu,
      };
}
