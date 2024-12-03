import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/data/model/response/items_response_model.dart';

import '../../../core/network/api_helper.dart';
import '../../domain/entities/sign_in_entity.dart';

abstract class RemoteDatasource {
  Future<List<ItemsResponseModel>> getAllItems(/*Map<String, dynamic> data*/);

  Future<UserCredential> signIn(SignInEntity signInEntity);
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final APIHelper apiHelper;
  final AppSharedData? sharedData;
  final FirebaseAuth? auth;
  final FirebaseFirestore? firestore;
  final FirebaseStorage? storage;
  late UserCredential? user;

  RemoteDatasourceImpl(
      {required this.apiHelper,
      this.auth,
      this.firestore,
      this.storage,
      this.user,
      this.sharedData});

  @override
  Future<List<ItemsResponseModel>> getAllItems(
      /*Map<String, dynamic> data*/) async {
    try {
      final response = await apiHelper.get(
        "posts/",
        // param: data,
      );
      return itemsResponseModelFromJson(jsonEncode(response));
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signIn(SignInEntity signInEntity) async {
    final user = signInEntity.toJson();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: signInEntity.email!, password: signInEntity.password!);
      return userCredential;
    } on Exception {
      rethrow;
    }
  }
}
