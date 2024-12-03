import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/domain/usecases/get_all_items_usecase.dart';

import '../../../../error/failures.dart';
import '../../../data/model/response/items_response_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  GetAllItemsUseCase getAllItemsUseCase;

  HomeCubit({required this.getAllItemsUseCase}) : super(HomeInitial());

  Future<dynamic> getAllItem() async {
    emit(ApiLoadingState());
    final result = await getAllItemsUseCase({});
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
          return GetAllDataSuccessState(list: r);
        },
      ),
    );
  }
}
