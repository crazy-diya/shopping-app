import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';

import '../../../error/failures.dart';
import '../../data/model/response/items_response_model.dart';

abstract class Repository{
  Future<Either<Failure,List<ItemsResponseModel>>> getAllItems(/*Map<String, dynamic> data*/);
  Future<Either<Failure,UserCredential>> signIn(SignInEntity signIn);
}