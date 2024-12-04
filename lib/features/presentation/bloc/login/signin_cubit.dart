import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import 'package:shopingapp/features/domain/usecases/signin_usecase.dart';

import '../../../../error/failures.dart';
import '../../../data/model/request/user_profile_request_model.dart';
import '../../../data/model/response/user_profile_response_model.dart';
import '../../../domain/usecases/user_profile_usecase.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final Signin signin;
  final AppSharedData appSharedData;
  final UserProfileUSeCase userProfileUSeCase;

  SignInCubit(
      {required this.signin,
      required this.appSharedData,
      required this.userProfileUSeCase})
      : super(SignInInitial());

  Future<dynamic> signInUser(SignInEntity signInEntity) async {
    emit(ApiLoadingState());
    final result = await signin(signInEntity);
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
          appSharedData.setData(email, r.user!.email!);
          appSharedData.setData(uID, r.user!.uid);
          return SignInSuccessState();
        },
      ),
    );
  }

  Future<dynamic> getUserDetails(UserProfileRequest user) async {
    emit(ApiLoadingState());
    final result = await userProfileUSeCase(user);
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
          appSharedData.setData(name, r.name!);
          appSharedData.setData(image, r.image!);
          return ProfileSuccessState(userProfileResponse: r);
        },
      ),
    );
  }
}
