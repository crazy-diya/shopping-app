
import '../features/domain/entities/error_response_entity.dart';

class ServerException implements Exception {
  final ErrorResponseEntity? errorResponse;

  ServerException({this.errorResponse});
}

class APIFailException implements Exception {
  final ErrorResponseEntity? errorResponseModel;

  APIFailException({this.errorResponseModel});
}

class DioExceptionError implements Exception {
  final ErrorResponseEntity? errorResponse;

  DioExceptionError({this.errorResponse});
}
