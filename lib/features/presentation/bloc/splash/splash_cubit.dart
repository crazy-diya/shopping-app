import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';

import '../../../../error/failures.dart';
import '../../../../utils/app_constants.dart';
import '../../../domain/usecases/get_all_items_usecase.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppSharedData appSharedData;

  SplashCubit({required this.appSharedData})
      : super(SplashInitial());

  Future<dynamic> getSplashData() async {
    emit(ApiLoadingState());
    if (appSharedData.hasData(uID)) {
      emit(SplashSuccessState());
    } else {
      emit(LoginRequiredState());
    }
  }
}
