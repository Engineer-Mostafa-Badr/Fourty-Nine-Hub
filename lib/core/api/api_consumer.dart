import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

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
      if (result.data['status']) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
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
      //   return Left(_getFailure(e));
      // }
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
      final result = await _dio.post(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
      );

      if (result.data['status']) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 401 &&
          isTokenAttached) {
        return refreshToken().then(
          (_) => post(
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
      if (result.data['status']) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
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
      } else if (e.response?.data is Map && e.response?.data['error'] is Map) {
        final error = e.response?.data['error'] as Map;
        List<String>? errors;
        if (error['data'] is List) {
          final data = e.response?.data['error']['data'] as List;
          errors = data
              .map((e) => e['message'] as String)
              .whereType<String>()
              .toList();
        }
        return ServerFailure(
          message: error['message'] as String,
          errors: errors,
        );
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

    final result = await post(
      EndPoints.refreshToken,
      data: {
        'refreshToken': _token!.refreshToken,
      },
    );
    result.fold(
      (_) {
        _authLocalDataSource.saveUserTokens(null);
        attachToken(null);
      },
      (response) {
        final accessToken = response['data']['accessToken'] as String;
        final newToken = _token!.copyWith(accessToken: accessToken);
        attachToken(newToken);
        _authLocalDataSource.saveUserTokens(newToken.toModel());
      },
    );
  }

  @override
  bool get isTokenAttached => _token != null;
}
