import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/auth_interceptor.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:tf_dio_cache/tf_dio_cache.dart';

abstract class ApiConsumer {
  Future<Either<Failure, Map<String, dynamic>>> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      bool refresh = false});

  Future<Either<Failure, Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false});

  Future<Either<Failure, Map<String, dynamic>>> put(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false});

  Future<Either<Failure, Map<String, dynamic>>> patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false});

  Future<Either<Failure, Map<String, dynamic>>> delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false});

  void attachToken(UserTokensEntity? token);
  void removeTokenFromHeader();
  void setTokenRefreshCallback(Function(UserTokensEntity) callback);
}

class BaseApiConsumer extends ApiConsumer {
  final Dio _dio;
  late AuthInterceptor _authInterceptor;

  BaseApiConsumer(this._dio) {
    _authInterceptor = AuthInterceptor(_dio, null);
    _dio.interceptors.add(_authInterceptor);
  }

  @override
  void attachToken(UserTokensEntity? token) {
    _authInterceptor.attachToken(token);
  }

  @override
  void removeTokenFromHeader() {
    _authInterceptor.removeTokenFromHeader();
  }

  @override
  void setTokenRefreshCallback(Function(UserTokensEntity) callback) {
    _authInterceptor.setTokenRefreshCallback(callback);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      bool refresh = false}) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      bool offline = connectivityResult == ConnectivityResult.none;

      final result = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: buildCacheOptions(
          const Duration(hours: 3),
          maxStale: const Duration(days: 7),
          forceRefresh: offline ? true : refresh,
          options: Options(headers: headers),
        ),
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false}) async {
    try {
      final result = await _dio.post(url,
          data: formData ?? data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false}) async {
    try {
      final result = await _dio.put(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false}) async {
    try {
      final result = await _dio.patch(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool refresh = false}) async {
    try {
      final result = await _dio.delete(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  Failure _getFailure(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      // Handle 504 Gateway Timeout - return specific failure type
      if (statusCode == 504) {
        return ServerFailure(
          message: 'Server is temporarily unavailable. Please try again later.',
          name: 'Service Unavailable',
          statusCode: 504,
        );
      }

      // Handle HTML responses (non-JSON)
      if (data is String) {
        return ServerFailure(
          message: 'Server error occurred',
          name: 'Server Error',
          statusCode: statusCode,
        );
      }

      // Handle nested error structure like { "success": false, "error": { "message": "...", "name": "..." } }
      if (data is Map && data['error'] is Map) {
        final error = data['error'] as Map;
        return ServerFailure(
          message: error['message']?.toString() ?? 'Unknown Error',
          name: error['name']?.toString() ?? 'Server Error',
          statusCode: statusCode,
        );
      }

      // Handle direct error structure like { "message": "...", "name": "..." }
      if (data is Map) {
        return ServerFailure(
          message: data['message']?.toString() ?? 'Unknown Error',
          name: data['name']?.toString() ?? 'Server Error',
          statusCode: statusCode,
        );
      }

      return ServerFailure(
        message: 'Unknown Error',
        name: 'Server Error',
        statusCode: statusCode,
      );
    }
    return UnknownFailure(e.toString());
  }
}
