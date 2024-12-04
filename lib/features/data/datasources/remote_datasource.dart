import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/data/model/request/user_profile_request_model.dart';
import 'package:shopingapp/features/data/model/response/items_response_model.dart';
import 'package:shopingapp/features/data/model/response/user_profile_response_model.dart';

import '../../../core/network/api_helper.dart';
import '../../domain/entities/sign_in_entity.dart';

abstract class RemoteDatasource {
  Future<List<ItemsResponseModel>> getAllItems(/*Map<String, dynamic> data*/);

  Future<UserCredential> signIn(SignInEntity signInEntity);

  Future<String> storeShoppingItems(List<ItemsResponseModel> itemList);

  Future<UserProfileResponse> userProfileData(
      UserProfileRequest userProfileRequest);

  Future<UserProfileResponse> userProfileUpdate(
      UserProfileResponse userProfileResponse);

  Future<Map<String, List<Map<String, dynamic>>>> retrieveDataFromFirestore(
      String userId);
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

  @override
  Future<UserProfileResponse> userProfileData(
      UserProfileRequest userProfileRequest) async {
    try {
      final response = await apiHelper.postOnly(
        "https://8c956790-3566-476e-bdaa-d9387f3d4059.mock.pstmn.io/user_profile",
        data: userProfileRequest.toJson(),
      );
      print(response);
      return UserProfileResponse.fromJson(jsonDecode(response));
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserProfileResponse> userProfileUpdate(
      UserProfileResponse userProfileResponse) async {
    try {
      // final response = await apiHelper.putOnly(
      //   "https://8c956790-3566-476e-bdaa-d9387f3d4059.mock.pstmn.io/update_user",
      //   data: userProfileResponse.toJson(),
      // );
      // print(response);
      // return UserProfileResponse.fromJson(jsonDecode(response));
      return UserProfileResponse(
          email: userProfileResponse.email,
          image: userProfileResponse.image,
          name: userProfileResponse.name);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<String> storeShoppingItems(List<ItemsResponseModel> itemList) async {
    final buyHistoryCollection = firestore!.collection("BuyHistory");
    try {
      List<Map<String, dynamic>> dataToStore =
          itemList.map((obj) => obj.toJson()).toList();

      buyHistoryCollection
          .doc(sharedData!.getData(uID))
          .collection(DateTime.timestamp().microsecondsSinceEpoch.toString())
          .add({
        'data': dataToStore,
      }).then(
        (value) {
          return "Ok";
        },
      );
      return "Ok";
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> retrieveDataFromFirestore(
      String userId) async {
    try {
       CollectionReference buyHistoryCollection =
          firestore!.collection("BuyHistory");

       DocumentReference userDoc =
           buyHistoryCollection.doc(userId);
       DocumentSnapshot userDocSnapshot = await userDoc.get();

       print(userDocSnapshot.data());


       List<String> collectionNames = [];

      // await userDocSnapshot.data().forEach((key, value) {
      //   if (value is DocumentReference) {
      //     collectionNames.add(value.id);
      //   }
      // });

      // return collectionNames;

      // final List<dynamic> subcollectionIds = userDoc['subcollections'] ?? [];

      Map<String, List<Map<String, dynamic>>> dayWiseData = {};

      // for (var subCollectionId in subcollectionIds) {
      //   final QuerySnapshot snapshot = await firestore!
      //       .collection("BuyHistory")
      //       .doc(userId)
      //       .collection(subCollectionId)
      //       .get();
      //
      //   // Extract documents and organize data
      //   for (var doc in snapshot.docs) {
      //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //     List<Map<String, dynamic>> items =
      //         List<Map<String, dynamic>>.from(data['data']);
      //     dayWiseData[subCollectionId] = items;
      //   }
      // }

      return dayWiseData;
    } on Exception {
      rethrow;
    } catch (e) {
      print("Error retrieving data: $e");
      throw Exception("Failed to retrieve data");
    }
  }
}
