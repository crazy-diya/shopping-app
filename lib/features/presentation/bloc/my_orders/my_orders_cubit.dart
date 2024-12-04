import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopingapp/features/domain/usecases/retrive_data_usecase.dart';
import 'package:shopingapp/features/domain/usecases/store_shopping_item_usecase.dart';

import '../../../../error/failures.dart';
import '../../../data/model/response/items_response_model.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  final StoreShoppingItemsUseCase storeShoppingItemsUseCase;
  final RetriveDataUseCase retriveDataUseCase;

  MyOrdersCubit(
      {required this.storeShoppingItemsUseCase,
      required this.retriveDataUseCase})
      : super(MyOrdersInitial());

  Future<dynamic> storeShoppingItems(List<ItemsResponseModel> itemList) async {
    emit(ApiLoadingState());
    final result = await storeShoppingItemsUseCase(itemList);
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
          return MyOrderSuccessState();
        },
      ),
    );
  }

  Future<dynamic> retrieveData(String uID) async {
    emit(ApiLoadingState());
    final result = await retriveDataUseCase(uID);
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
          return RetrieveDataSuccessfully();
        },
      ),
    );
  }
}
