import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/failure.dart';

abstract class ApiConsumer {
  const ApiConsumer();

  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  });

  void attachToken(String? token);

  bool get isTokenAttached;
}

class BaseApiConsumer extends ApiConsumer {
  final Dio dio;

  String? _token;

  BaseApiConsumer({
    required this.dio,
  });

  @override
  void attachToken(String? token) {
    _token = token;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await dio.get(
        url,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await dio.post(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  Failure _getFailure(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 413) {
        return const ServerFailure(
          message: 'File size is too large',
        );
      } else if (e.response?.statusCode == 401) {
        return const UnauthorizedFailure();
      } else if (e.response?.data is Map &&
          e.response?.data['message'] is String) {
        return ServerFailure(
          message: e.response?.data['message'] as String,
        );
      } else if (e.response?.data is Map &&
          e.response?.data['error'] is String) {
        final error = e.response?.data['error'] as String;
        return error.toLowerCase().contains('otp')
            ? InvalidOtpFailure(error)
            : ServerFailure(message: error);
      } else if (e.response?.data is Map &&
          e.response?.data['data'] is String) {
        return ServerFailure(
          message: e.response?.data['data'] as String,
        );
      }
    }
    return const UnknownFailure();
  }

  @override
  bool get isTokenAttached => _token != null;
}
