import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

import 'end_points.dart';

abstract class ApiConsumer {
  const ApiConsumer();

  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
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
    log(token?.accessToken.toString() ?? "Token", name: "Token");
    _token = token;
    log(_token?.accessToken.toString()??"Okkkk", name: "lskdjflskdjflskdjflskjdf");
        CacheServiceImpl().saveUserToken(_token?.accessToken??"Token");
    log("${token?.accessToken}", name: "Token");
    if (token != null) {
      log(token.accessToken.toString(), name: "Token");
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final result = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
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
          (_) => patch(
            url,
            queryParameters: queryParameters,
            data: data,
            headers: headers,
          ),
        );
      } else {
        return Left(_getFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final result = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
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
  Future<Either<Failure, Map<String, dynamic>>> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers}) async {
    try {
      final result = await _dio.get(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers)
          // options: Options(headers: {
          //   "Authorization":
          //       'Bearer ${}'
          // }
          // )
          );
      log(result.toString());
      // log(_dio.options.headers['Authorization'], name: "Authorization$url");
      print('Welcome ${result.data['status']}');
      if (result.data['status']) {
        print('result os io');
        return Right(result.data as Map<String, dynamic>);
      } else {
        print('reselt 2');
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
      print('result 3');
      print(e.toString());
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
      if (e is DioException) {
        pr(e.response?.data);
      }
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      log(data.toString());
      final result = await _dio.post(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
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
        // if (e is DioException) {
        //   pr('${e.response?.data}');
        // }
        return Left(_getFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final result = await _dio.put(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      log(result.data.toString(), name: "url");
      if (result.data['status']) {
        log('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        if (result.data is Map<String, dynamic>) {
          return Right(result.data as Map<String, dynamic>);
        } else {
          return Right({"data": result.data});
        }
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
            headers: headers,
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
          statusCode: e.response?.statusCode,
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
          statusCode: e.response?.statusCode,
          errors: errors,
        );
      } else if (e.response?.data is Map &&
          e.response?.data['data'] is String) {
        return ServerFailure(
          message: e.response?.data['data'] as String,
          statusCode: e.response?.statusCode,
        );
      }
    }
    return UnknownFailure(e.toString());
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
//dependency inversion
