// import 'dart:developer';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/utils/shared_pref.dart';
// import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
// import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
// import 'package:icons_launcher/utils/cli_logger.dart';
// import 'package:tf_dio_cache/tf_dio_cache.dart';
//
// // import 'dart:convert';
// // import 'package:flutter/services.dart' show rootBundle;
//
// import 'end_points.dart';
//
// abstract class ApiConsumer {
//   const ApiConsumer();
//
//   Future<Either<Failure, Map<String, dynamic>>> get(
//     String url, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? data,
//     bool refresh = false,
//   });
//
//   Future<Either<Failure, Map<String, dynamic>>> post(
//     String url, {
//     Map<String, dynamic>? data,
//     FormData? formData,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   });
//
//   Future<Either<Failure, Map<String, dynamic>>> patch(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   });
//
//   Future<Either<Failure, Map<String, dynamic>>> put(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   });
//
//   Future<Either<Failure, Map<String, dynamic>>> delete(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   });
//
//   void attachToken(UserTokensEntity? token);
//
//   bool get isTokenAttached;
//
//   void removeTokenFromHeader();
// }
//
// class BaseApiConsumer extends ApiConsumer {
//   final Dio _dio;
//
//   // final AuthLocalDataSource _authLocalDataSource;
//
//   UserTokensEntity? _token;
//
//   BaseApiConsumer(
//     this._dio,
//     // this._authLocalDataSource,
//   );
//
//   @override
//   void attachToken(UserTokensEntity? token) async {
//     log(token?.accessToken.toString() ?? "Token", name: "Token");
//     _token = token;
//     log(_token?.accessToken.toString() ?? "Okkkk",
//         name: "lskdjflskdjflskdjflskjdf");
//     // CacheServiceImpl().saveUserToken(_token?.accessToken??"Token");
//     log("${await CacheManager.getAccessToken()} attached", name: "Token");
//     if (token != null) {
//       log(token.accessToken.toString(), name: "Token");
//       _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
//       _dio.options.headers['x-api-key'] =
//           '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
//       // _dio.options.headers['Authorization'] = 'Bearer ${await CacheManager.getAccessToken()}';
//       // _dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImEzMWEyNzkzLWFiYTEtNDliOC1iZTgzLTlkYzM2NWZhOTk1OCIsImlhdCI6MTczMjA1MTYzMywiZXhwIjo1NTczMjA1MTYzMywic3ViIjoiNjZkODZhODJlOWNkMzk5NzAwMmY2MzM2In0.Mcl_dnYecdxc2htakepeWmZUYMDjfdjYkvgwWb4p9ok';
//     }
//   }
//
//   //addAll({"x-api-key":"2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06"})
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> patch(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   }) async {
//     try {
//       final result = await _dio.patch(
//         url,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(headers: {
//           ...?headers,
//           "x-api-key":
//               "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//           // Your custom header
//         }),
//       );
//
//       if (result.data['status']) {
//         return Right(result.data as Map<String, dynamic>);
//       } else {
//         return Left(ValidationFailure(
//             result.data['message'] ?? result.data['error']['message']));
//       }
//     } catch (e) {
//       if (e is DioException &&
//           e.response?.statusCode == 401 &&
//           isTokenAttached) {
//         return refreshToken().then(
//           (_) => patch(
//             url,
//             queryParameters: queryParameters,
//             data: data,
//             headers: {
//               ...?headers,
//               "x-api-key":
//                   "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//               // Your custom header
//             },
//           ),
//         );
//       } else {
//         return Left(_getFailure(e));
//       }
//     }
//   }
//
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> delete(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   }) async {
//     try {
//       final result = await _dio.delete(
//         url,
//         data: data,
//         options: Options(headers: {
//           ...?headers,
//           "x-api-key":
//               "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//           // Your custom header
//         }),
//         queryParameters: queryParameters,
//       );
//       return Right(result.data as Map<String, dynamic>);
//     } catch (e) {
//       if (e is DioException &&
//           e.response?.statusCode == 401 &&
//           isTokenAttached) {
//         return refreshToken().then(
//           (_) => delete(
//             url,
//             queryParameters: queryParameters,
//             data: data,
//           ),
//         );
//       } else {
//         return Left(_getFailure(e));
//       }
//     }
//   }
//
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> get(
//     String url, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   }) async {
//     try {
//       log(data.toString());
//       final connectivityResult = await Connectivity().checkConnectivity();
//
//       bool networkStatus = connectivityResult == ConnectivityResult.none;
//       log("result.toString()$networkStatus");
//
//       final result = await _dio.get(
//         url,
//         data: data,
//         queryParameters: queryParameters,
//         options: buildCacheOptions(
//           const Duration(hours: 3),
//           maxStale: const Duration(days: 7),
//           forceRefresh: networkStatus ? true : refresh,
//           options: Options(headers: {
//             ...?headers,
//             "x-api-key":
//                 "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//           }),
//         ),
//       );
//       log("result.toString()${result.toString()}", name: url);
//       log('Welcome ${result.data['status']}');
//       if (result.data['status']) {
//         log('result os io');
//         return Right(result.data as Map<String, dynamic>);
//       } else {
//         log('reselt 2');
//         return Left(ValidationFailure(
//             result.data['message'] ?? result.data['error']['message']));
//       }
//     } catch (e) {
//       log('result 3');
//       log(e.toString());
//       if (e is DioException) {
//         pr(e.response?.data);
//       }
//       return Left(_getFailure(e));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> post(
//     String url, {
//     Map<String, dynamic>? data,
//     FormData? formData,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   }) async {
//     try {
//       log(data.toString());
//       if (url.contains('/chat/get-chats')) {
//         log("post get chats");
//       }
//       final result = await _dio.post(
//         url,
//         data: formData ?? data,
//         queryParameters: queryParameters,
//         options: buildCacheOptions(
//           const Duration(hours: 3),
//           maxStale: const Duration(days: 7),
//           forceRefresh: refresh,
//           options: Options(headers: {
//             ...?headers,
//             "x-api-key":
//                 "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//           }),
//         ),
//       );
//       log(result.data.toString(), name: "url");
//       if (result.data['status']) {
//         return Right(result.data as Map<String, dynamic>);
//       } else {
//         return Left(ValidationFailure(
//             result.data['message'] ?? result.data['error']['message']));
//       }
//     } catch (e) {
//       if (e is DioException &&
//           isTokenAttached) {
//         if (e.response?.statusCode == 401) {
//           return refreshToken().then(
//                 (_) => put(
//               url,
//               queryParameters: queryParameters,
//               data: data,
//               headers: headers,
//             ),
//           );
//         }
//         return Left(_getFailure(e));
//         // return refreshToken().then(
//         //   (_) => post(
//         //     url,
//         //     queryParameters: queryParameters,
//         //     data: data,
//         //   ),
//         // );
//       } else {
//         // if (e is DioException) {
//         //   pr('${e.response?.data}');
//         // }
//         return Left(_getFailure(e));
//       }
//     }
//   }
//
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> put(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     bool refresh = false,
//   }) async {
//     try {
//       final result = await _dio.put(url,
//           data: data,
//           queryParameters: queryParameters,
//           options: buildCacheOptions(
//             const Duration(hours: 3),
//             maxStale: const Duration(days: 7),
//             forceRefresh: refresh,
//             options: Options(headers: {
//               ...?headers,
//               "x-api-key":
//                   "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
//             }),
//           )
//           // options: Options(headers: {
//           //   ...?headers,
//           //   // Your custom header
//           // })
//           );
//       log(result.data.toString(), name: "url");
//       if (getSuccessState(result.data)) {
//         log('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
//         if (result.data is Map<String, dynamic>) {
//           return Right(result.data as Map<String, dynamic>);
//         } else {
//           return Right({"data": result.data});
//         }
//       } else {
//         return Left(ValidationFailure(
//             result.data['message'] ?? result.data['error']['message']));
//       }
//     } catch (e) {
//
//       if (e is DioException && isTokenAttached) {
//         if (e.response?.statusCode == 401) {
//           return refreshToken().then(
//                 (_) => put(
//               url,
//               queryParameters: queryParameters,
//               data: data,
//               headers: headers,
//             ),
//           );
//         }
//         return Left(_getFailure(e));
//       } else {
//         log(e.toString(), name: "The Exception");
//         return Left(_getFailure(e));
//       }
//     }
//   }
//
//   Failure _getFailure(dynamic e) {
//     final errorData = e.response?.data; // Get the entire response data safely
//     final error = (errorData is Map && errorData['error'] is Map)
//         ? errorData['error'] as Map
//         : null;
//
//     log("Error: $error");
//
//     if (e is DioException) {
//       if (e.response?.statusCode == 413) {
//         return const ServerFailure(
//           message: 'File size is too large',
//           name: 'Unknown Error',
//         );
//       } else if (e.response?.statusCode == 401) {
//         if (error != null) {
//           return UnauthorizedFailure(
//             error['message'] as String? ?? 'Unauthorized request',
//           );
//         }
//       } else if (errorData is Map && errorData['message'] is String) {
//         return ServerFailure(
//           message: errorData['message'] as String,
//           name: errorData['name'] as String? ?? 'Unknown Error',
//           statusCode: e.response?.statusCode,
//         );
//       } else if (error != null) {
//         List<String>? errors;
//         if (error['data'] is List) {
//           final data = error['data'] as List;
//           errors = data
//               .where((e) => e is Map && e.containsKey('message'))
//               .map((e) => e['message'] as String)
//               .toList();
//         }
//         return ServerFailure(
//           message: error['message'] as String? ?? 'Unknown server error',
//           name: error['name'] as String? ?? 'Unknown Error',
//           statusCode: e.response?.statusCode,
//           errors: errors,
//         );
//       } else if (errorData is Map && errorData['data'] is String) {
//         return ServerFailure(
//           message: errorData['data'] as String,
//           name: errorData['name'] as String? ?? 'Unknown Error',
//           statusCode: e.response?.statusCode,
//         );
//       }
//     }
//
//     return UnknownFailure(
//         error?['message']?.toString() ?? 'Unknown error occurred');
//   }
//
//   Future<void> refreshToken() async {
//     log('==> refreshToken');
//     if (_token == null) return;
//     final result = await post(
//       EndPoints.refreshToken,
//       data: {
//         'refreshToken': _token!.refreshToken,
//       },
//     );
//     result.fold(
//       (_) {
//         // _authLocalDataSource.saveUserTokens(null);
//         attachToken(null);
//       },
//       (response) {
//         final accessToken = response['data']['accessToken'] as String;
//         final newToken = _token!.copyWith(accessToken: accessToken);
//         attachToken(newToken);
//         // _authLocalDataSource.saveUserTokens(newToken.toModel());
//         CacheManager.saveAccessToken(accessToken);
//       },
//     );
//   }
//
//   @override
//   bool get isTokenAttached => _token != null;
//
//   @override
//   void removeTokenFromHeader() {
//     _dio.options.headers['Authorization'] = null;
//     CliLogger.info('Barear Token is  ${_dio.options.headers['Authorization']}');
//   }
//
//   bool getSuccessState(Map<String, dynamic> response) {
//     if (response.containsKey("success")) {
//       return response["success"];
//     } else {
//       if (response.containsKey("status")) {
//         return response["status"];
//       } else {
//         return false;
//       }
//     }
//   }
// }
// //dependency inversion



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
  static const String _apiKey = '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';

  UserTokensEntity? _token;
  bool _isRefreshing = false;

  BaseApiConsumer(this._dio) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from cache if not already set
          if (_token == null) {
            final cachedToken = await CacheManager.getAccessToken();
            if (cachedToken != null) {
              _token = UserTokensEntity(accessToken: cachedToken, refreshToken: '');
            }
          }

          // Add authorization header if token exists
          if (_token?.accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${_token!.accessToken}';
          }

          // Always add API key
          options.headers['x-api-key'] = _apiKey;

          log("Request Headers: ${options.headers}", name: "API_REQUEST");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log("Response: ${response.statusCode}", name: "API_RESPONSE");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          return await _handleError(error, handler);
        },
      ),
    );
  }

  @override
  void attachToken(UserTokensEntity? token) {
    log("Attaching token: ${token?.accessToken}", name: "TOKEN_ATTACH");
    _token = token;

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      CacheManager.saveAccessToken(token.accessToken);
    } else {
      _dio.options.headers.remove('Authorization');
    }

    // Always ensure API key is present
    _dio.options.headers['x-api-key'] = _apiKey;
  }

  Future<dynamic> _handleError(DioException error, ErrorInterceptorHandler handler) async {
    log("Handling error: ${error.response?.statusCode}", name: "ERROR_HANDLER");

    if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: DioExceptionType.badResponse,
            error: error.response?.data,
          ));

        case 401:
          if (isTokenAttached && !_isRefreshing) {
            log("Attempting token refresh for 401 error", name: "TOKEN_REFRESH");

            String? newToken = await _refreshAuthToken();
            if (newToken != null) {
              // Retry the original request with new token
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';
              options.headers['x-api-key'] = _apiKey;

              try {
                final response = await _dio.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );
                return handler.resolve(response);
              } catch (e) {
                return handler.reject(DioException(
                  requestOptions: options,
                  error: e,
                  type: DioExceptionType.unknown,
                ));
              }
            } else {
              // Refresh failed, remove token and reject
              attachToken(null);
              return handler.reject(error);
            }
          }
          return handler.reject(error);

        case 403:
        case 404:
        case 413:
        case 500:
          return handler.reject(error);

        default:
          return handler.reject(error);
      }
    }
    return handler.next(error);
  }

  Future<String?> _refreshAuthToken() async {
    if (_isRefreshing || _token?.refreshToken == null) return null;

    _isRefreshing = true;
    try {
      log("Starting token refresh", name: "TOKEN_REFRESH");

      final response = await _dio.post(
        EndPoints.refreshToken,
        data: {'refreshToken': _token!.refreshToken},
        options: Options(headers: {
          'x-api-key': _apiKey,
          // Don't include Authorization header for refresh request
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final newAccessToken = response.data['data']['accessToken'] as String;
        final updatedToken = _token!.copyWith(accessToken: newAccessToken);

        // Update token
        attachToken(updatedToken);

        log("Token refreshed successfully", name: "TOKEN_REFRESH");
        return newAccessToken;
      } else {
        log("Token refresh failed: ${response.data}", name: "TOKEN_REFRESH");
        await _handleSessionExpired();
        return null;
      }
    } catch (e) {
      log("Token refresh error: $e", name: "TOKEN_REFRESH");
      await _handleSessionExpired();
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleSessionExpired() async {
    log("Session expired, clearing tokens", name: "SESSION_EXPIRED");

    // Clear tokens
    attachToken(null);
    await CacheManager.deleteAllTokens(); // Assuming this method exists

    // You can add navigation to login screen here if needed
    // Get.offAllNamed('/login');
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
      final connectivityResult = await Connectivity().checkConnectivity();
      bool hasNoNetwork = connectivityResult == ConnectivityResult.none;

      final result = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: buildCacheOptions(
          const Duration(hours: 3),
          maxStale: const Duration(days: 7),
          forceRefresh: hasNoNetwork ? false : refresh,
          options: Options(headers: {
            ...?headers,
            'x-api-key': _apiKey,
          }),
        ),
      );

      return _handleSuccessResponse(result);
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
        Map<String, dynamic>? headers,
        bool refresh = false,
      }) async {
    try {
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
            'x-api-key': _apiKey,
          }),
        ),
      );

      return _handleSuccessResponse(result);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

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
          'x-api-key': _apiKey,
        }),
      );

      return _handleSuccessResponse(result);
    } catch (e) {
      return Left(_getFailure(e));
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
      final result = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: buildCacheOptions(
          const Duration(hours: 3),
          maxStale: const Duration(days: 7),
          forceRefresh: refresh,
          options: Options(headers: {
            ...?headers,
            'x-api-key': _apiKey,
          }),
        ),
      );

      return _handleSuccessResponse(result);
    } catch (e) {
      return Left(_getFailure(e));
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
        queryParameters: queryParameters,
        options: Options(headers: {
          ...?headers,
          'x-api-key': _apiKey,
        }),
      );

      return _handleSuccessResponse(result);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  Either<Failure, Map<String, dynamic>> _handleSuccessResponse(Response result) {
    if (_getSuccessState(result.data)) {
      if (result.data is Map<String, dynamic>) {
        return Right(result.data as Map<String, dynamic>);
      } else {
        return Right({"data": result.data});
      }
    } else {
      return Left(ValidationFailure(
          result.data['message'] ??
              result.data['error']['message'] ??
              'Unknown error'
      ));
    }
  }

  bool _getSuccessState(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey("success")) {
        return response["success"] == true;
      } else if (response.containsKey("status")) {
        return response["status"] == true;
      }
    }
    return false;
  }

  Failure _getFailure(dynamic e) {
    final errorData = e.response?.data;
    final error = (errorData is Map && errorData['error'] is Map)
        ? errorData['error'] as Map
        : null;

    log("Error: $error", name: "API_ERROR");

    if (e is DioException) {
      switch (e.response?.statusCode) {
        case 413:
          return const ServerFailure(
            message: 'File size is too large',
            name: 'File Too Large',
          );
        case 401:
          if (error != null) {
            return UnauthorizedFailure(
              error['message'] as String? ?? 'Unauthorized request',
            );
          }
          return const UnauthorizedFailure('Unauthorized request');
        case 400:
        case 403:
        case 404:
        case 500:
          if (errorData is Map && errorData['message'] is String) {
            return ServerFailure(
              message: errorData['message'] as String,
              name: errorData['name'] as String? ?? 'Server Error',
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
              name: error['name'] as String? ?? 'Server Error',
              statusCode: e.response?.statusCode,
              errors: errors,
            );
          }
          break;
      }
    }

    return UnknownFailure(
        error?['message']?.toString() ?? 'Unknown error occurred'
    );
  }

  // Removed the old refreshToken method since it's now handled by interceptors

  @override
  bool get isTokenAttached => _token?.accessToken != null;

  @override
  void removeTokenFromHeader() {
    _token = null;
    _dio.options.headers.remove('Authorization');
    CliLogger.info('Bearer Token removed from headers');
  }
}