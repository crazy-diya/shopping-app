// To parse this JSON data, do
//
//     final userProfileResponse = userProfileResponseFromJson(jsonString);

import 'dart:convert';

UserProfileResponse userProfileResponseFromJson(String str) => UserProfileResponse.fromJson(json.decode(str));

String userProfileResponseToJson(UserProfileResponse data) => json.encode(data.toJson());

class UserProfileResponse {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;

  UserProfileResponse({
    this.uid,
    this.name,
    this.email,
    this.image = "https://static.vecteezy.com/system/resources/thumbnails/019/900/322/small/happy-young-cute-illustration-face-profile-png.png",
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
  };
}
