import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  UserTokensEntity? _token;
  Function(UserTokensEntity)? _onTokenRefreshed;

  bool _isRefreshing = false;
  final List<Completer<Response>> _retryQueue = [];
  final List<RequestOptions> _queuedRequests = [];

  AuthInterceptor(this._dio, this._token);

  /// Set callback to be called when token is refreshed
  void setTokenRefreshCallback(Function(UserTokensEntity) callback) {
    _onTokenRefreshed = callback;
  }

  /// إضافة التوكين للـ headers
  void attachToken(UserTokensEntity? token) {
    _token = token;
    if (token != null) {
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      serviceLocator<Dio>().options.headers['x-api-key'] =
      '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
    } else {
      serviceLocator<Dio>().options.headers.remove('Authorization');
    }
  }

  /// إزالة التوكين من الـ headers
  void removeTokenFromHeader() {
    _token = null;
    serviceLocator<Dio>().options.headers.remove('Authorization');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer ${_token!.accessToken}';
    }
    options.headers['x-api-key'] =
    '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _token != null) {
      final requestOptions = err.requestOptions;

      // Skip if this is the refresh token request itself
      if (requestOptions.path.contains('/auth/refresh-token')) {
        print('🔐 AuthInterceptor: Refresh token request failed, not retrying');
        super.onError(err, handler);
        return;
      }

      print('🔐 AuthInterceptor: 401 error for ${requestOptions.method} ${requestOptions.path}');

      if (_isRefreshing) {
        // لو فيه refresh شغال بالفعل
        print('🔐 AuthInterceptor: Token refresh already in progress, queuing request: ${requestOptions.method} ${requestOptions.path}');
        final completer = Completer<Response>();
        _retryQueue.add(completer);
        _queuedRequests.add(requestOptions);

        return completer.future.then((r) => handler.resolve(r)).catchError((e) {
          handler.reject(e);
        });
      } else {
        print('🔐 AuthInterceptor: Starting token refresh');
        _isRefreshing = true;
        try {
          final newToken = await _refreshToken();

          if (newToken != null) {
            print('🔐 AuthInterceptor: Token refresh successful, updating headers');
            // Update the token immediately
            attachToken(newToken);

            // Notify the app about the token refresh
            if (_onTokenRefreshed != null) {
              _onTokenRefreshed!(newToken);
            }

            // retry للـ request الأصلي
            final originalRequestOptions = RequestOptions(
              method: requestOptions.method,
              path: requestOptions.path,
              baseUrl: requestOptions.baseUrl,
              headers: Map<String, dynamic>.from(requestOptions.headers),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              extra: requestOptions.extra,
            );

            // Update headers with new token
            originalRequestOptions.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

            print('🔄 AuthInterceptor: Retrying original request: ${requestOptions.method} ${requestOptions.path}');
            final response = await serviceLocator<Dio>().fetch(originalRequestOptions);
            print('✅ AuthInterceptor: Original request retried successfully');

            // retry للـ requests اللي كانوا في الـ queue
            print('🔄 AuthInterceptor: Retrying ${_retryQueue.length} queued requests');
            for (int i = 0; i < _retryQueue.length; i++) {
              try {
                final queuedRequestOptions = _queuedRequests[i];
                final completer = _retryQueue[i];

                print('🔄 AuthInterceptor: Retrying queued request ${i + 1}: ${queuedRequestOptions.method} ${queuedRequestOptions.path}');

                // Create a new request options for each queued request
                final retryRequestOptions = RequestOptions(
                  method: queuedRequestOptions.method,
                  path: queuedRequestOptions.path,
                  baseUrl: queuedRequestOptions.baseUrl,
                  headers: Map<String, dynamic>.from(queuedRequestOptions.headers),
                  data: queuedRequestOptions.data,
                  queryParameters: queuedRequestOptions.queryParameters,
                  extra: queuedRequestOptions.extra,
                );

                // Update headers with new token
                retryRequestOptions.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

                final retryResponse = await serviceLocator<Dio>().fetch(retryRequestOptions);
                completer.complete(retryResponse);
                print('✅ AuthInterceptor: Queued request ${i + 1} retried successfully');
              } catch (e) {
                print('❌ AuthInterceptor: Queued request ${i + 1} failed: $e');
                _retryQueue[i].completeError(e);
              }
            }
            _retryQueue.clear();
            _queuedRequests.clear();

            handler.resolve(response);
            return;
          } else {
            print('🔐 AuthInterceptor: Token refresh failed');
            _retryQueue.clear();
            _queuedRequests.clear();
            handler.reject(err);
            return;
          }
        } catch (e) {
          print('🔐 AuthInterceptor: Token refresh error: $e');
          _retryQueue.clear();
          _queuedRequests.clear();
          handler.reject(err);
          return;
        } finally {
          _isRefreshing = false;
        }
      }
    }

    super.onError(err, handler);
  }

  Future<UserTokensEntity?> _refreshToken() async {
    try {
      print('🔄 AuthInterceptor: Calling refresh token API');
      final response = await serviceLocator<Dio>().post(
        "https://49backend.com/api/v1/auth/refresh-token",
        data: {
          'refreshToken': _token?.refreshToken,
        },
        options: Options(
          headers: {
            "x-api-key":
            "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
            "Content-Type": "application/json",
          },
        ),
      );

      if(response.statusCode != 200) {
        var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
        currentContext.push(Routes.LOGIN);
        print('❌ AuthInterceptor: Refresh token API failed: ${response.data}');
        return null;
      }

      final accessToken = response.data['data']['accessToken'] as String;
      final refreshToken = response.data['data']['refreshToken'] as String;
      final newToken = _token!.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

      print('🔐 AuthInterceptor: New tokens received - Access: ${accessToken.substring(0, 10)}..., Refresh: ${refreshToken.substring(0, 10)}...');

      // Save both tokens to cache
      await CacheManager.saveAccessToken(accessToken);
      await CacheManager.saveRefreshToken(refreshToken);
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

      return newToken;
    } catch (e) {
      var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
      currentContext.push(Routes.LOGIN);
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      return null;
    }
  }
}