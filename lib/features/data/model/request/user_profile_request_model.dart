// To parse this JSON data, do
//
//     final userProfileRequest = userProfileRequestFromJson(jsonString);

import 'dart:convert';

UserProfileRequest userProfileRequestFromJson(String str) => UserProfileRequest.fromJson(json.decode(str));

String userProfileRequestToJson(UserProfileRequest data) => json.encode(data.toJson());

class UserProfileRequest {
  final String? uid;

  UserProfileRequest({
    this.uid,
  });

  factory UserProfileRequest.fromJson(Map<String, dynamic> json) => UserProfileRequest(
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
  };
}
