import 'package:dartz/dartz.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../../data/model/response/user_profile_response_model.dart';
import '../repository/repository.dart';

class ProfileUpdateUseCase
    extends UseCase<UserProfileResponse, UserProfileResponse> {
  final Repository repository;

  ProfileUpdateUseCase({required this.repository});

  @override
  Future<Either<Failure, UserProfileResponse>> call(
      UserProfileResponse params) async {
    return await repository.userProfileUpdate(params);
  }
}
