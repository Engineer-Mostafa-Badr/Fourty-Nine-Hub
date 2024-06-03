import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';

import '../error/failure.dart';
import 'end_points.dart';

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

  void attachToken(UserTokensEntity? token);

  bool get isTokenAttached;
}

class BaseApiConsumer extends ApiConsumer {
  final Dio _dio;
  final AuthLocalDataSource _authLocalDataSource;

  UserTokensEntity? _token;

  BaseApiConsumer(
    this._dio,
    this._authLocalDataSource,
  );

  @override
  void attachToken(UserTokensEntity? token) {
    _token = token;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 401 &&
          isTokenAttached) {
        return refreshToken().then(
          (_) => delete(
            url,
            queryParameters: queryParameters,
            data: data,
          ),
        );
      } else {
        return Left(_getFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
            // TODO reset condition after stable backend

      // if (e is DioException &&
      //     e.response?.statusCode == 401 &&
      //     isTokenAttached) {
      //   return refreshToken().then(
      //     (_) => get(
      //       url,
      //       queryParameters: queryParameters,
      //     ),
      //   );
      // } else {
        return Left(_getFailure(e));
      // }
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
      final result = await _dio.post(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      // TODO reset condition after stable backend
      // if (e is DioException &&
      //     e.response?.statusCode == 401 &&
      //     isTokenAttached && false) {
      //   return refreshToken().then(
      //     (_) => post(
      //       url,
      //       queryParameters: queryParameters,
      //       data: data,
      //     ),
      //   );
      // } else {
                      return Left(_getFailure(e));

      // }

    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(result.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 401 &&
          isTokenAttached) {
        return refreshToken().then(
          (_) => put(
            url,
            queryParameters: queryParameters,
            data: data,
          ),
        );
      } else {
        return Left(_getFailure(e));
      }
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

  Future<void> refreshToken() async {
    if (_token == null) return;
    try {
      final result = await post(
        EndPoints.refreshToken,
        data: {
          'refreshToken': _token!.refreshToken,
        },
      );
      result.fold(
        (_) {},
        (response) {
          final accessToken = response['data']['accessToken'] as String;
          final newToken = _token!.copyWith(accessToken: accessToken);
          attachToken(newToken);
          _authLocalDataSource.saveUserTokens(newToken.toModel());
        },
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        _authLocalDataSource.saveUserTokens(null);
        attachToken(null);
      }
      rethrow;
    }
  }

  @override
  bool get isTokenAttached => _token != null;
}
