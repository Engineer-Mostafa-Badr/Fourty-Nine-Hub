import 'dart:developer';

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
    Map<String, dynamic>? data,
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
  Dio _dio;
  final AuthLocalDataSource _authLocalDataSource;

  UserTokensEntity? _token;

  BaseApiConsumer(
    this._dio,
    this._authLocalDataSource,
  );

  @override
  void attachToken(UserTokensEntity? token) {
    log(token?.accessToken.toString() ?? "Token", name: "TOKETOKEN");
    _token = token;
    // log("${token?.accessToken}", name: "Token");
    if (token != null) {
      // _dio = Dio(BaseOptions(headers: {
      //   'Authorization':
      //       'Bearer ${"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjNjZTEyYjY0LTBiMGUtNDVjNi1iZTBkLTk5MWYwNDBiMDI0MCIsImlhdCI6MTcyNDcyMzM3NCwiZXhwIjo1NTcyNDcyMzM3NCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.8N3NfdXD3m5Ll-P-geBZlb5GwEWL6kIFiYiokE71ryI"}'
      // }
      //     // 'Bearer ${token.accessToken}'}
      //     ));
      // _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      // _dio.options.headers['Authorization'] =
      //     'Bearer ${"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjUyNWNiOGE1LWY0MDYtNDljMC1hMjc1LWQwMWM2OTIyN2UwNiIsImlhdCI6MTcyMzkxMjQ0MywiZXhwIjo1NTcyMzkxMjQ0Mywic3ViIjoiNjZiNDY1OWQxYzljNGIxY2IzNWJmZWU0In0.i3W6jdhIRhOK8JSpaKNHBrl5bFCU4YtV8ca74-EdkqY"}';
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
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjJlNmQyNjIyLTVjNjItNDIxOS1hMzM3LTQ2MWI5OGJkODEzZiIsImlhdCI6MTcyNTMyNjY0OCwiZXhwIjo1NTcyNTMyNjY0OCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.N-dzSJOiTglVNoQ9xn9J6SUtv-Us-nvg4Ed2aeSGl-Y"
            // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6Ijc3NTc3MGJlLTI1YjUtNGZlMS04OThmLTk1NmNiZDZmNmMzMyIsImlhdCI6MTcyNTMyNzYxOSwiZXhwIjo1NTcyNTMyNzYxOSwic3ViIjoiNjZiNzYwNjVhYjNiNmY1YTNkMjI3M2VkIn0.yhVguyP7hGGW5Hr_9p1TJsgpD5NeHi5Z50dr0Wml3Fg" //Rider
          },
        ),
        // options: Options(headers: {
        //   "Authorization":
        //       'Bearer ${}'
        // }
        // )
      );
      // log(url);
      // log(_dio.options.headers['Authorization'], name: "Authorization$url");
      if (result.data['status']) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        if (result.data['endPointSubscription'] == true &&
            result.data['userSubscription'] == false) {
          log("kdddddddddddddddddddddddddddddddddddddd");
        }
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
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjJlNmQyNjIyLTVjNjItNDIxOS1hMzM3LTQ2MWI5OGJkODEzZiIsImlhdCI6MTcyNTMyNjY0OCwiZXhwIjo1NTcyNTMyNjY0OCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.N-dzSJOiTglVNoQ9xn9J6SUtv-Us-nvg4Ed2aeSGl-Y"
            // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6Ijc3NTc3MGJlLTI1YjUtNGZlMS04OThmLTk1NmNiZDZmNmMzMyIsImlhdCI6MTcyNTMyNzYxOSwiZXhwIjo1NTcyNTMyNzYxOSwic3ViIjoiNjZiNzYwNjVhYjNiNmY1YTNkMjI3M2VkIn0.yhVguyP7hGGW5Hr_9p1TJsgpD5NeHi5Z50dr0Wml3Fg"
          },
        ),
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
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjJlNmQyNjIyLTVjNjItNDIxOS1hMzM3LTQ2MWI5OGJkODEzZiIsImlhdCI6MTcyNTMyNjY0OCwiZXhwIjo1NTcyNTMyNjY0OCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.N-dzSJOiTglVNoQ9xn9J6SUtv-Us-nvg4Ed2aeSGl-Y"
            // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6Ijc3NTc3MGJlLTI1YjUtNGZlMS04OThmLTk1NmNiZDZmNmMzMyIsImlhdCI6MTcyNTMyNzYxOSwiZXhwIjo1NTcyNTMyNzYxOSwic3ViIjoiNjZiNzYwNjVhYjNiNmY1YTNkMjI3M2VkIn0.yhVguyP7hGGW5Hr_9p1TJsgpD5NeHi5Z50dr0Wml3Fg"
          },
        ),
      );
      log(result.data.toString(), name: "url");
      if (result.data['status']) {
        log('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        if (result.data is Map<String, dynamic>) {
          return Right(result.data as Map<String, dynamic>);
        } else {
          return Right({"data": result.data});
        }
      } else {
        if (result.data['endPointSubscription'] == true &&
            result.data['userSubscription'] == false) {
          log("kdddddddddddddddddddddddddddddddddddddd");
        }
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
      log(e.toString(),
          name:
              "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
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
