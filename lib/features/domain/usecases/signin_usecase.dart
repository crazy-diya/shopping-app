import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../repository/repository.dart';

class Signin extends UseCase<UserCredential, SignInEntity> {
  final Repository repository;

  Signin({required this.repository});

  @override
  Future<Either<Failure, UserCredential>> call(SignInEntity params) async {
    return await repository.signIn(params);
  }
}
