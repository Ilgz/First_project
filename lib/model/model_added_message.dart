// To parse this JSON data, do
//
//     final missouri = missouriFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Missouri missouriFromJson(String str) => Missouri.fromJson(json.decode(str));

String missouriToJson(Missouri data) => json.encode(data.toJson());

class Missouri {
  Missouri({
    required this.message,
  });

  Message message;

  factory Missouri.fromJson(Map<String, dynamic> json) => Missouri(
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
      };
}

class Message {
  Message({
    required this.id,
    required this.from,
    required this.to,
    required this.productId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int from;
  int to;
  int productId;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        productId: json["product_id"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from": from,
        "to": to,
        "product_id": productId,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
