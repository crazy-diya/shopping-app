import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../error/exception.dart';
import '../../features/domain/entities/error_response_entity.dart';
import 'network_config.dart';

class APIHelper {
  late Dio dio;

  APIHelper({required this.dio}) {
    _initAPIClient();
  }

  void _initAPIClient() {
    final logInterceptor = LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: false,
      requestHeader: false,
      responseHeader: false,
    );

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      baseUrl: NetworkConfig.getNetworkConfig(),
      contentType: 'application/json',
    );

    dio
      ..options = options
      ..interceptors.add(logInterceptor);

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient dioClient = HttpClient(
          context: SecurityContext(
            withTrustedRoots: false,
          ),
        );
        dioClient.badCertificateCallback = (cert, host, port) => true;
        return dioClient;
      },
      validateCertificate: (cert, host, port) {
        return true;
      },
    );
  }

  Future<dynamic> postOnly(String tag, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(
        // NetworkConfig.getNetworkConfig() + tag,
        tag,
        data: data,
      );
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionError(
        errorResponse: ErrorResponseEntity(
          responseCode: error.response!.statusCode.toString(),
          responseError: error.message!,
        ),
      );
    }
  }

  Future<dynamic> putOnly(String tag, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(
        // NetworkConfig.getNetworkConfig() + tag,
        tag,
        data: data,
      );
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionError(
        errorResponse: ErrorResponseEntity(
          responseCode: error.response!.statusCode.toString(),
          responseError: error.message!,
        ),
      );
    }
  }

  Future<dynamic> deleteOnly(String tag, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(
        // NetworkConfig.getNetworkConfig() + tag,
        tag,
        data: data,
      );
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionError(
        errorResponse: ErrorResponseEntity(
          responseCode: error.response!.statusCode.toString(),
          responseError: error.message!,
        ),
      );
    }
  }

  Future<dynamic> get(String tag, {Map<String, dynamic>? param}) async {
    try {
      final response = await dio.get(
        NetworkConfig.getNetworkConfig() + tag,
        queryParameters: param,
      );
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionError(
        errorResponse: ErrorResponseEntity(
          responseCode: error.response!.statusCode.toString(),
          responseError: error.message!,
        ),
      );
    }
  }

  Future<dynamic> getOnly(String tag, {Map<String, dynamic>? param}) async {
    try {
      final response = await dio.get(
        tag,
        queryParameters: param,
      );
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionError(
        errorResponse: ErrorResponseEntity(
          responseCode: error.response!.statusCode.toString(),
          responseError: error.message!,
        ),
      );
    }
  }
}
