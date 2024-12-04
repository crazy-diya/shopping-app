import 'package:dartz/dartz.dart';
import 'package:shopingapp/features/domain/usecases/usecase.dart';

import '../../../error/failures.dart';
import '../repository/repository.dart';

class RetriveDataUseCase extends UseCase<String, String> {
  final Repository repository;

  RetriveDataUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.retrieveDataFromFirestore(params);
  }
}
