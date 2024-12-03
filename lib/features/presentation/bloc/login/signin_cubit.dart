import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import 'package:shopingapp/features/domain/usecases/signin_usecase.dart';

import '../../../../error/failures.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final Signin signin;
  final AppSharedData appSharedData;

  SignInCubit({required this.signin, required this.appSharedData})
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
}
