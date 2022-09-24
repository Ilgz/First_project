// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.id,
    required this.titleRu,
  });

  int id;
  String titleRu;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        titleRu: json["title_ru"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_ru": titleRu,
      };
}
