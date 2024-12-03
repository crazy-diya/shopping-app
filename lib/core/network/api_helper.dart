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

  Future<dynamic> post(T) async {}

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
}
