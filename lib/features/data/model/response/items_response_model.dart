// To parse this JSON data, do
//
//     final itemsResponseModel = itemsResponseModelFromJson(jsonString);

import 'dart:convert';

List<ItemsResponseModel> itemsResponseModelFromJson(String str) =>
    List<ItemsResponseModel>.from(
        json.decode(str).map((x) => ItemsResponseModel.fromJson(x)));

String itemsResponseModelToJson(List<ItemsResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsResponseModel {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;
  bool? isSelected;
  int? price;

  ItemsResponseModel({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.isSelected = false,
    this.price = 260,
  });

  factory ItemsResponseModel.fromJson(Map<String, dynamic> json) =>
      ItemsResponseModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
