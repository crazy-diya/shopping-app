import 'package:dartz/dartz.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../../data/model/response/items_response_model.dart';
import '../repository/repository.dart';

class GetAllItemsUseCase extends UseCase<List<ItemsResponseModel>, Map<String, dynamic>> {
  final Repository repository;

  GetAllItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ItemsResponseModel>>> call(Map<String, dynamic> params) async {
    return await repository.getAllItems(/*params*/);
  }
}
