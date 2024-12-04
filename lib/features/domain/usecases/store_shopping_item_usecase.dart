import 'package:dartz/dartz.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../../data/model/response/items_response_model.dart';
import '../repository/repository.dart';

class StoreShoppingItemsUseCase extends UseCase<String, List<ItemsResponseModel>> {
  final Repository repository;

  StoreShoppingItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(List<ItemsResponseModel> params) async {
    return await repository.storeShoppingItems(params);
  }
}