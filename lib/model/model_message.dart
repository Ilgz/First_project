// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.data,
  });

  List<Datum> data;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {required this.from,
      required this.to,
      required this.message,
      required this.productId,
      required this.has_read,
      this.productName,
      this.productPicture,
      this.userPicture,
      this.userId,
      this.userName,
      this.userLastSeen,
      required this.created_at});

  int from;
  int to;
  String message;
  int productId;
  String? productName;
  String? userPicture;
  String? userId;
  String? userLastSeen;
  String? userName;
  String? productPicture;
  String has_read;
  DateTime created_at;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      from: json["from"],
      to: json["to"],
      message: json["message"],
      productId: json["product_id"],
      has_read: json['has_read'],
      created_at: DateTime.parse(json["created_at"]));

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "product_id": productId,
      };
}

List<GetChatProduct> getChatProductFromJson(String str) =>
    List<GetChatProduct>.from(
        json.decode(str).map((x) => GetChatProduct.fromJson(x)));

String getChatProductToJson(List<GetChatProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChatProduct {
  GetChatProduct({
    required this.product,
    required this.picture,
  });

  String product;
  String picture;

  factory GetChatProduct.fromJson(Map<String, dynamic> json) => GetChatProduct(
        product: json["product"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "picture": picture,
      };
}

List<GetChatUser> getChatUserFromJson(String str) => List<GetChatUser>.from(
    json.decode(str).map((x) => GetChatUser.fromJson(x)));

String getChatUserToJson(List<GetChatUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChatUser {
  GetChatUser({
    required this.name,
    required this.picture,
    required this.last_seen,
  });
  String name;
  String? picture;
  String? last_seen;

  factory GetChatUser.fromJson(Map<String, dynamic> json) => GetChatUser(
        name: json["name"],
        picture: json["picture"],
        last_seen: json["last_seen"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "picture": picture,
      };
}
