// To parse this JSON data, do
//
//     final loginAccess = loginAccessFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginAccess loginAccessFromJson(String str) => LoginAccess.fromJson(json.decode(str));

String loginAccessToJson(LoginAccess data) => json.encode(data.toJson());

class LoginAccess {
  LoginAccess({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  String accessToken;
  String tokenType;
  int expiresIn;

  factory LoginAccess.fromJson(Map<String, dynamic> json) => LoginAccess(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
  };
}
