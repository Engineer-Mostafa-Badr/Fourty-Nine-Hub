import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:tf_dio_cache/tf_dio_cache.dart';

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
    bool refresh = false,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  });

  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  });

  void attachToken(UserTokensEntity? token);

  bool get isTokenAttached;

  void removeTokenFromHeader();
}

class BaseApiConsumer extends ApiConsumer {
  final Dio _dio;

  // final AuthLocalDataSource _authLocalDataSource;

  UserTokensEntity? _token;

  BaseApiConsumer(
    this._dio,
    // this._authLocalDataSource,
  );

  @override
  void attachToken(UserTokensEntity? token) async {
    log(token?.accessToken.toString() ?? "Token", name: "Token");
    _token = token;
    log(_token?.accessToken.toString() ?? "Okkkk",
        name: "lskdjflskdjflskdjflskjdf");
    // CacheServiceImpl().saveUserToken(_token?.accessToken??"Token");
    log("${await CacheManager.getAccessToken()} attached", name: "Token");
    if (token != null) {
      log(token.accessToken.toString(), name: "Token");
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      _dio.options.headers['x-api-key'] =
          '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      // _dio.options.headers['Authorization'] = 'Bearer ${await CacheManager.getAccessToken()}';
      // _dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImEzMWEyNzkzLWFiYTEtNDliOC1iZTgzLTlkYzM2NWZhOTk1OCIsImlhdCI6MTczMjA1MTYzMywiZXhwIjo1NTczMjA1MTYzMywic3ViIjoiNjZkODZhODJlOWNkMzk5NzAwMmY2MzM2In0.Mcl_dnYecdxc2htakepeWmZUYMDjfdjYkvgwWb4p9ok';
    }
  }

  //addAll({"x-api-key":"2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06"})
  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  }) async {
    try {
      final result = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: {
          ...?headers,
          "x-api-key":
              "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
          // Your custom header
        }),
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
            headers: {
              ...?headers,
              "x-api-key":
                  "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
              // Your custom header
            },
          ),
        );
      } else {
        return Left(_getFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  }) async {
    try {
      final result = await _dio.delete(
        url,
        data: data,
        options: Options(headers: {
          ...?headers,
          "x-api-key":
              "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
          // Your custom header
        }),
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
    Map<String, dynamic>? headers,
    bool refresh = false,
  }) async {
    try {
      log(data.toString());
      final connectivityResult = await Connectivity().checkConnectivity();

      bool networkStatus = connectivityResult == ConnectivityResult.none;
      log("result.toString()$networkStatus");

      final result = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: buildCacheOptions(
          const Duration(hours: 3),
          maxStale: const Duration(days: 7),
          forceRefresh: networkStatus ? true : refresh,
          options: Options(headers: {
            ...?headers,
            "x-api-key":
                "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
          }),
        ),
      );
      log("result.toString()${result.toString()}", name: url);
      log('Welcome ${result.data['status']}');
      if (result.data['status']) {
        log('result os io');
        return Right(result.data as Map<String, dynamic>);
      } else {
        log('reselt 2');
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 401&&
          isTokenAttached ) {
        return refreshToken().then(
              (_) => patch(
            url,
            queryParameters: queryParameters,
            data: data,
            headers: {
              ...?headers,
              "x-api-key":
              "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
              // Your custom header
            },
          ),
        );
      } else {
        return Left(_getFailure(e));
      }
      log('result 3');
      log(e.toString());
      if (e is DioException) {
        pr(e.response?.data);
      }
      return Left(_getFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  }) async {
    try {
      log(data.toString());
      if (url.contains('/chat/get-chats')) {
        log("post get chats");
      }
      final result = await _dio.post(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: buildCacheOptions(
          const Duration(hours: 3),
          maxStale: const Duration(days: 7),
          forceRefresh: refresh,
          options: Options(headers: {
            ...?headers,
            "x-api-key":
                "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
          }),
        ),
      );
      log(result.data.toString(), name: "url");
      if (result.data['status']) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        return Left(ValidationFailure(
            result.data['message'] ?? result.data['error']['message']));
      }
    } catch (e) {
      if (e is DioException &&
          isTokenAttached) {
        if (e.response?.statusCode == 401) {
          return refreshToken().then(
                (_) => put(
              url,
              queryParameters: queryParameters,
              data: data,
              headers: headers,
            ),
          );
        }
        return Left(_getFailure(e));
        // return refreshToken().then(
        //   (_) => post(
        //     url,
        //     queryParameters: queryParameters,
        //     data: data,
        //   ),
        // );
      } else {
        // if (e is DioException) {
        //   pr('${e.response?.data}');
        // }
        return Left(_getFailure(e));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool refresh = false,
  }) async {
    try {
      final result = await _dio.put(url,
          data: data,
          queryParameters: queryParameters,
          options: buildCacheOptions(
            const Duration(hours: 3),
            maxStale: const Duration(days: 7),
            forceRefresh: refresh,
            options: Options(headers: {
              ...?headers,
              "x-api-key":
                  "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
            }),
          )
          // options: Options(headers: {
          //   ...?headers,
          //   // Your custom header
          // })
          );
      log(result.data.toString(), name: "url");
      if (getSuccessState(result.data)) {
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

      if (e is DioException && isTokenAttached) {
        if (e.response?.statusCode == 401&&
            isTokenAttached) {
          return refreshToken().then(
                (_) => put(
              url,
              queryParameters: queryParameters,
              data: data,
              headers: headers,
            ),
          );
        }
        return Left(_getFailure(e));
      } else {
        log(e.toString(), name: "The Exception");
        return Left(_getFailure(e));
      }
    }
  }

  Failure _getFailure(dynamic e) {
    final errorData = e.response?.data; // Get the entire response data safely
    final error = (errorData is Map && errorData['error'] is Map)
        ? errorData['error'] as Map
        : null;

    log("Error: $error");

    if (e is DioException) {
      if (e.response?.statusCode == 413) {
        return const ServerFailure(
          message: 'File size is too large',
          name: 'Unknown Error',
        );
      } else if (e.response?.statusCode == 401) {
        if (error != null) {
          return UnauthorizedFailure(
            error['message'] as String? ?? 'Unauthorized request',
          );
        }
      } else if (errorData is Map && errorData['message'] is String) {
        return ServerFailure(
          message: errorData['message'] as String,
          name: errorData['name'] as String? ?? 'Unknown Error',
          statusCode: e.response?.statusCode,
        );
      } else if (error != null) {
        List<String>? errors;
        if (error['data'] is List) {
          final data = error['data'] as List;
          errors = data
              .where((e) => e is Map && e.containsKey('message'))
              .map((e) => e['message'] as String)
              .toList();
        }
        return ServerFailure(
          message: error['message'] as String? ?? 'Unknown server error',
          name: error['name'] as String? ?? 'Unknown Error',
          statusCode: e.response?.statusCode,
          errors: errors,
        );
      } else if (errorData is Map && errorData['data'] is String) {
        return ServerFailure(
          message: errorData['data'] as String,
          name: errorData['name'] as String? ?? 'Unknown Error',
          statusCode: e.response?.statusCode,
        );
      }
    }

    return UnknownFailure(
        error?['message']?.toString() ?? 'Unknown error occurred');
  }


  // Future<void> refreshToken() async {
  //   log('==> refreshToken');
  //
  //   try {
  //     final dio = Dio();
  //
  //     final response = await dio.post(
  //       "https://49backend.com/api/v1/auth/refresh-token",
  //       data: {
  //         'refreshToken': _token?.refreshToken??'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoicmVmcmVzaCIsImp0aSI6IjMzYmRkN2FmLWU1ZWItNDA0Ny1hNGY1LTVmNzdkMGU1NDA3NCIsImlhdCI6MTc1NjEyNTUxNywiZXhwIjoxNzU2NzMwMzE3LCJzdWIiOiI2N2U1Mjc5NTNlMjQ5MmRmOWQ2ZDNiY2QifQ.Y9InSU2ZdT_cK_2TMRpyuoyuwTnKon5_SuflCqbc9-s',
  //       },
  //       options: Options(
  //         headers: {
  //           "x-api-key":"2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
  //           "Content-Type": "application/json",
  //         },
  //       ),
  //     );
  //
  //     log("responseToooo ${response.data}");
  //
  //     final accessToken = response.data['data']['accessToken'] as String;
  //     final newToken = _token!.copyWith(accessToken: accessToken);
  //
  //     attachToken(newToken);
  //     CacheManager.saveAccessToken(accessToken);
  //
  //   } on DioError catch (e) {
  //     log("failureToooo ${e.response?.data ?? e.message}");
  //     attachToken(null);
  //   } catch (e) {
  //     log("failureToooo ${e.toString()}");
  //     attachToken(null);
  //   }
  // }
  Future<void> refreshToken() async {
    log('==> refreshToken');
    if (_token == null) return;
    final result = await post(
      EndPoints.refreshToken,
      data: {
        'refreshToken': _token?.refreshToken??'',
      },
    );
    result.fold(
      (_) {
        // _authLocalDataSource.saveUserTokens(null);
        log("failureToooo ${_.toString()}");
        attachToken(null);
      },
      (response) {
        log('responseToooo $response');
        final accessToken = response['data']['accessToken'] as String;
        final newToken = _token!.copyWith(accessToken: accessToken);
        attachToken(newToken);
        // _authLocalDataSource.saveUserTokens(newToken.toModel());
        CacheManager.saveAccessToken(accessToken);
      },
    );
  }

  @override
  bool get isTokenAttached => _token != null;

  @override
  void removeTokenFromHeader() {
    _dio.options.headers['Authorization'] = null;
    CliLogger.info('Barear Token is  ${_dio.options.headers['Authorization']}');
  }

  bool getSuccessState(Map<String, dynamic> response) {
    if (response.containsKey("success")) {
      return response["success"];
    } else {
      if (response.containsKey("status")) {
        return response["status"];
      } else {
        return false;
      }
    }
  }
}
//dependency inversion
