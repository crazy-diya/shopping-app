import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/data/model/request/user_profile_request_model.dart';
import 'package:shopingapp/features/data/model/response/user_profile_response_model.dart';
import 'package:shopingapp/features/domain/usecases/profile_update_usecase.dart';
import 'package:shopingapp/features/domain/usecases/user_profile_usecase.dart';

import '../../../../error/failures.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  UserProfileUSeCase userProfileUSeCase;
  ProfileUpdateUseCase profileUpdateUseCase;

  ProfileCubit({required this.userProfileUSeCase,required this.profileUpdateUseCase}) : super(ProfileInitial());

  Future<dynamic> updateUserDetails(UserProfileResponse user) async {
    emit(ApiLoadingState());
    final result = await profileUpdateUseCase(user);
    emit(
      result.fold(
        (l) {
          if (l is DioExceptionFailure) {
            return DioExceptionFailureState();
          } else if (l is ServerFailure) {
            return ServerFailureState();
          } else if (l is ConnectionFailure) {
            return ConnectionFailureState();
          } else {
            return ApiFailureState();
          }
        },
        (r) {
          return ProfileUpdateSuccessState(userProfileResponse: r);
        },
      ),
    );
  }
}
