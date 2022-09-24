// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile(
      {required this.id,
      required this.name,
      this.email,
      required this.dateJoined,
      this.phoneNumber,
      this.picture});

  int id;
  String name;
  String? email;
  String? picture;
  DateTime dateJoined;
  String? phoneNumber;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      dateJoined: DateTime.parse(json["date_joined"]),
      phoneNumber: json["phone_number"],
      picture: json['picture']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "date_joined": dateJoined.toIso8601String(),
        "phone_number": phoneNumber,
      };
}
