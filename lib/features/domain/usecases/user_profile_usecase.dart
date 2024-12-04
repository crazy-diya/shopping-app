import 'package:dartz/dartz.dart';
import 'package:shopingapp/features/data/model/request/user_profile_request_model.dart';
import 'package:shopingapp/features/data/model/response/user_profile_response_model.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../repository/repository.dart';

class UserProfileUSeCase
    extends UseCase<UserProfileResponse, UserProfileRequest> {
  final Repository repository;

  UserProfileUSeCase({required this.repository});

  @override
  Future<Either<Failure, UserProfileResponse>> call(
      UserProfileRequest params) async {
    return await repository.userProfileData(params);
  }
}
