// To parse this JSON data, do
//
//     final itemUserProducts = itemUserProductsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ItemUserProducts itemUserProductsFromJson(String str) =>
    ItemUserProducts.fromJson(json.decode(str));

String itemUserProductsToJson(ItemUserProducts data) =>
    json.encode(data.toJson());

class ItemUserProducts {
  ItemUserProducts({
    required this.data,
  });

  Data data;

  factory ItemUserProducts.fromJson(Map<String, dynamic> json) =>
      ItemUserProducts(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.userId,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.products,
  });

  int userId;
  String name;
  String? email;
  String? phoneNumber;
  List<Product> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.id,
    required this.product,
    required this.userId,
    required this.price,
    required this.currency,
    required this.description,
    required this.picture,
    required this.category,
    required this.location,
  });

  int id;
  String product;
  int userId;
  int price;
  String description;
  String currency;
  String picture;
  int category;
  int location;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        product: json["product"],
        userId: json["user_id"],
        price: json["price"],
        description: json["description"],
        picture: json["picture"],
        category: json["category"],
        currency: json["currency"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "user_id": userId,
        "price": price,
        "description": description,
        "picture": picture,
      };
}
