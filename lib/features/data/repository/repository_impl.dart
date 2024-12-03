import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import '../../../core/network/network_info.dart';
import '../../../error/exception.dart';
import '../../../error/failures.dart';
import '../../domain/entities/error_response_entity.dart';
import '../../domain/repository/repository.dart';
import '../datasources/remote_datasource.dart';
import '../model/response/items_response_model.dart';

class RepositoryImpl extends Repository {
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  RepositoryImpl({required this.remoteDatasource, required this.networkInfo});

  @override
  Future<Either<Failure, List<ItemsResponseModel>>> getAllItems(
      /*Map<String, dynamic> data*/) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.getAllItems();
        return Right(response);
      } on DioExceptionError catch (e) {
        return Left(DioExceptionFailure(e.errorResponse!));
      } on Exception catch (e) {
        return Left(
          ServerFailure(
            errorResponse: ErrorResponseEntity(
              responseCode: "",
              responseError: e.toString(),
            ),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signIn(SignInEntity signIn) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.signIn(signIn);
        return Right(response);
      } on FirebaseAuthException catch (e) {
        return Left(APIFailure(
          ErrorResponseEntity(responseCode: "", responseError: e.toString()),
        ));
      } on FirebaseException catch (e) {
        return Left(APIFailure(
          ErrorResponseEntity(responseCode: "", responseError: e.toString()),
        ));
      } on Exception catch (e) {
        return Left(APIFailure(
          ErrorResponseEntity(responseCode: "", responseError: e.toString()),
        ));
      } catch (e) {
        return Left(APIFailure(
          ErrorResponseEntity(responseCode: "", responseError: e.toString()),
        ));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
