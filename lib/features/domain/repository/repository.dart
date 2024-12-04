import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopingapp/features/data/model/request/user_profile_request_model.dart';
import 'package:shopingapp/features/data/model/response/user_profile_response_model.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';

import '../../../error/failures.dart';
import '../../data/model/response/items_response_model.dart';

abstract class Repository{
  Future<Either<Failure,List<ItemsResponseModel>>> getAllItems(/*Map<String, dynamic> data*/);
  Future<Either<Failure,UserCredential>> signIn(SignInEntity signIn);
  Future<Either<Failure,String>> storeShoppingItems(List<ItemsResponseModel> itemList);
  Future<Either<Failure, String>> retrieveDataFromFirestore(String userId);
  Future<Either<Failure,UserProfileResponse>> userProfileData(UserProfileRequest userProfileRequest);
  Future<Either<Failure,UserProfileResponse>> userProfileUpdate(UserProfileResponse user);
}