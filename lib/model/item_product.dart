// To parse this JSON data, do
//
//     final itemProduct = itemProductFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ItemProduct itemProductFromJson(String str) =>
    ItemProduct.fromJson(json.decode(str));

String itemProductToJson(ItemProduct data) => json.encode(data.toJson());

class ItemProduct {
  ItemProduct({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<Datum> data;
  Links links;
  Meta meta;

  factory ItemProduct.fromJson(Map<String, dynamic> json) => ItemProduct(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Datum extends Equatable {
  Datum({
    required this.id,
    required this.product,
    required this.price,
    required this.currency,
    required this.picture,
    required this.description,
    required this.user,
    required this.category,
    required this.location,
  });

  int id;
  String product;
  String currency;
  int price;
  String picture;
  String description;
  int category;
  int location;
  User user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        product: json["product"],
        price: json["price"],
        currency: json["currency"],
        picture: json["picture"],
        description: json["description"],
        category: json["category"],
        location: json["location"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "price": price,
        "picture": picture,
        "description": description,
        "user": user.toJson(),
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id, product, price, picture, description];
}

class User {
  User({
    required this.userId,
    required this.name,
    this.email,
    this.phoneNumber,
    this.picture,
  });

  int userId;
  String name;
  String? email;
  String? phoneNumber;
  String? picture;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
      };
}

class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  String first;
  String last;
  dynamic prev;
  String? next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
