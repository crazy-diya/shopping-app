
import 'dart:convert';

SignInModel signInModelFromJson(String str) =>
    SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) => json.encode(data.toJson());

class SignInModel {
  SignInModel({
    this.emailAddress,
    this.password,
  });

  String? emailAddress;
  String? password;

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
    emailAddress: json["emailAddress"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "emailAddress": emailAddress,
    "password": password,
  };
}