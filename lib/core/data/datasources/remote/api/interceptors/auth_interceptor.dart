import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/service/storage.dart';
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
  Timer? _tokenStatusTimer;

  AuthInterceptor(this._dio, this._token);

  /// Set callback to be called when token is refreshed
  void setTokenRefreshCallback(Function(UserTokensEntity) callback) {
    _onTokenRefreshed = callback;
  }

  /// إضافة التوكين للـ headers
  void attachToken(UserTokensEntity? token) {
    _token = token;
    if (token != null) {
      serviceLocator<Dio>().options.headers['Authorization'] =
          'Bearer ${token.accessToken}';
      serviceLocator<Dio>().options.headers['x-api-key'] =
          '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      _startTokenStatusTimer();
    } else {
      serviceLocator<Dio>().options.headers.remove('Authorization');
      _stopTokenStatusTimer();
    }
  }

  /// إزالة التوكين من الـ headers
  void removeTokenFromHeader() {
    _token = null;
    serviceLocator<Dio>().options.headers.remove('Authorization');
    _stopTokenStatusTimer();
  }

  /// بدء مؤقت لطباعة حالة التوكن كل 20 ثانية
  void _startTokenStatusTimer() {
    _stopTokenStatusTimer(); // إيقاف أي مؤقت سابق
    _tokenStatusTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      _printTokenStatus();
    });
    // طباعة فورية عند البداية
    _printTokenStatus();
  }

  /// إيقاف مؤقت حالة التوكن
  void _stopTokenStatusTimer() {
    _tokenStatusTimer?.cancel();
    _tokenStatusTimer = null;
  }

  /// طباعة حالة التوكن
  void _printTokenStatus() {
    if (_token?.accessToken == null) {
      log('🔐 Token Status: No token available');
      return;
    }

    try {
      final parts = _token!.accessToken.split('.');
      if (parts.length != 3) {
        log('🔐 Token Status: Invalid token format');
        return;
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> tokenData = json.decode(decoded);

      if (tokenData['exp'] == null) {
        log('🔐 Token Status: No expiration time found');
        return;
      }

      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        (tokenData['exp'] as int) * 1000,
      );
      final timeRemaining = expirationTime.difference(DateTime.now());

      if (timeRemaining.isNegative) {
        log('⚠️ Token Status: EXPIRED ${timeRemaining.abs().inMinutes} minutes ago');
      } else {
        log('✅ Token Status: Valid - ${timeRemaining.inMinutes}m ${timeRemaining.inSeconds % 60}s remaining');
      }
    } catch (e) {
      log('❌ Token Status: Error reading token: $e');
    }
  }

  /// فحص انتهاء صلاحية التوكن
  bool _isTokenExpired() {
    if (_token?.accessToken == null) return true;

    try {
      // تحليل JWT token
      final parts = _token!.accessToken.split('.');
      if (parts.length != 3) return true;

      // فك تشفير payload
      final payload = parts[1];
      // إضافة padding إذا كان مطلوباً
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> tokenData = json.decode(decoded);

      // فحص exp field
      if (tokenData['exp'] == null) return true;

      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        (tokenData['exp'] as int) * 1000,
      );

      // إضافة buffer 30 ثانية قبل انتهاء الصلاحية
      final now = DateTime.now().add(Duration(seconds: 30));
      final timeRemaining = expirationTime.difference(DateTime.now());

      log('🕐 AuthInterceptor: Token expires at: $expirationTime, Current time: ${DateTime.now()}');
      log('⏰ AuthInterceptor: Time remaining: ${timeRemaining.inMinutes} minutes, ${timeRemaining.inSeconds % 60} seconds');
      return now.isAfter(expirationTime);
    } catch (e) {
      print('❌ AuthInterceptor: Error parsing token: $e');
      return true;
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // تخطي فحص التوكن للطلبات الخاصة بتجديد التوكن والـ login
    if (options.path.contains('/auth/refresh-token') ||
        options.path.contains('/auth/login')) {
      if (_token != null && !options.path.contains('/auth/login')) {
        options.headers['Authorization'] = 'Bearer ${_token!.accessToken}';
      }
      options.headers['x-api-key'] =
          '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      super.onRequest(options, handler);
      return;
    }

    // فحص انتهاء صلاحية التوكن قبل إجراء الطلب
    if (_token != null && _isTokenExpired()) {
      print('🔐 AuthInterceptor: Token expired, refreshing before request');

      if (_isRefreshing) {
        // لو فيه refresh شغال بالفعل، أضف الطلب للطابور
        print(
            '🔐 AuthInterceptor: Token refresh already in progress, queuing request: ${options.method} ${options.path}');
        final completer = Completer<Response>();
        _retryQueue.add(completer);
        _queuedRequests.add(options);

        return completer.future.then((r) => handler.resolve(r)).catchError((e) {
          handler.reject(
              e is DioException ? e : DioException(requestOptions: options));
        });
      }

      // ابدأ عملية تجديد التوكن
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          print(
              '🔐 AuthInterceptor: Token refreshed successfully before request');
          attachToken(newToken);

          // إشعار التطبيق بتجديد التوكن
          if (_onTokenRefreshed != null) {
            _onTokenRefreshed!(newToken);
          }

          // تحديث headers للطلب الحالي
          options.headers['Authorization'] = 'Bearer ${newToken.accessToken}';
          options.headers['x-api-key'] =
              '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';

          // معالجة الطلبات المؤجلة
          print(
              '🔄 AuthInterceptor: Processing ${_retryQueue.length} queued requests');
          for (int i = 0; i < _retryQueue.length; i++) {
            try {
              final queuedRequestOptions = _queuedRequests[i];
              final completer = _retryQueue[i];

              queuedRequestOptions.headers['Authorization'] =
                  'Bearer ${newToken.accessToken}';
              final retryResponse =
                  await serviceLocator<Dio>().fetch(queuedRequestOptions);
              completer.complete(retryResponse);
            } catch (e) {
              _retryQueue[i].completeError(e is DioException
                  ? e
                  : DioException(requestOptions: _queuedRequests[i]));
            }
          }
          _retryQueue.clear();
          _queuedRequests.clear();

          super.onRequest(options, handler);
        } else {
          print('❌ AuthInterceptor: Token refresh failed, rejecting request');
          handler.reject(DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
            ),
          ));
        }
      } catch (e) {
        print('❌ AuthInterceptor: Token refresh error: $e');
        handler.reject(DioException(
          requestOptions: options,
          error: e,
        ));
      } finally {
        _isRefreshing = false;
      }
    } else {
      // التوكن صالح أو غير موجود، تابع بشكل طبيعي
      if (_token != null) {
        options.headers['Authorization'] = 'Bearer ${_token!.accessToken}';
      }
      options.headers['x-api-key'] =
          '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      super.onRequest(options, handler);
    }
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

      print(
          '🔐 AuthInterceptor: 401 error for ${requestOptions.method} ${requestOptions.path}');

      if (_isRefreshing) {
        // لو فيه refresh شغال بالفعل
        print(
            '🔐 AuthInterceptor: Token refresh already in progress, queuing request: ${requestOptions.method} ${requestOptions.path}');
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
            print(
                '🔐 AuthInterceptor: Token refresh successful, updating headers');
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
            originalRequestOptions.headers['Authorization'] =
                'Bearer ${newToken.accessToken}';

            print(
                '🔄 AuthInterceptor: Retrying original request: ${requestOptions.method} ${requestOptions.path}');
            final response =
                await serviceLocator<Dio>().fetch(originalRequestOptions);
            print('✅ AuthInterceptor: Original request retried successfully');

            // retry للـ requests اللي كانوا في الـ queue
            print(
                '🔄 AuthInterceptor: Retrying ${_retryQueue.length} queued requests');
            for (int i = 0; i < _retryQueue.length; i++) {
              try {
                final queuedRequestOptions = _queuedRequests[i];
                final completer = _retryQueue[i];

                print(
                    '🔄 AuthInterceptor: Retrying queued request ${i + 1}: ${queuedRequestOptions.method} ${queuedRequestOptions.path}');

                // Create a new request options for each queued request
                final retryRequestOptions = RequestOptions(
                  method: queuedRequestOptions.method,
                  path: queuedRequestOptions.path,
                  baseUrl: queuedRequestOptions.baseUrl,
                  headers:
                      Map<String, dynamic>.from(queuedRequestOptions.headers),
                  data: queuedRequestOptions.data,
                  queryParameters: queuedRequestOptions.queryParameters,
                  extra: queuedRequestOptions.extra,
                );

                // Update headers with new token
                retryRequestOptions.headers['Authorization'] =
                    'Bearer ${newToken.accessToken}';

                final retryResponse =
                    await serviceLocator<Dio>().fetch(retryRequestOptions);
                completer.complete(retryResponse);
                print(
                    '✅ AuthInterceptor: Queued request ${i + 1} retried successfully');
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
      // التحقق من وجود refresh token قبل إرساله
      final refreshToken = _token?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        print(
            '❌ AuthInterceptor: No refresh token available, redirecting to login');
        removeTokenFromHeader();
        await CacheManager.clearTokens();
        try {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext;
          if (currentContext != null && currentContext.mounted) {
            currentContext.go(Routes.LOGIN);
          }
        } catch (e) {
          print('❌ Navigation error: $e');
        }
        return null;
      }

      print('🔄 AuthInterceptor: Calling refresh token API');
      final response = await serviceLocator<Dio>().post(
        "https://49backend.com/api/v1/auth/refresh-token",
        data: {
          'refreshToken': refreshToken,
        },
        options: Options(
          headers: {
            "x-api-key":
                "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        print('❌ AuthInterceptor: Refresh token API failed: ${response.data}');
        // Clear tokens and navigate to login
        removeTokenFromHeader();
        await CacheManager.clearTokens(); // Clear only tokens
        try {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext;
          if (currentContext != null && currentContext.mounted) {
            currentContext.go(Routes.LOGIN);
          }
        } catch (e) {
          print('❌ Navigation error: $e');
        }
        return null;
      }

      final accessToken = response.data['data']['accessToken'] as String;
      final newRefreshToken = response.data['data']['refreshToken'] as String;
      final newToken = _token!.copyWith(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );
      serviceLocator<Dio>().options.headers['Authorization'] =
          'Bearer $accessToken';

      print(
          '🔐 AuthInterceptor: New tokens received - Access: ${accessToken.substring(0, 10)}..., Refresh: ${newRefreshToken.substring(0, 10)}...');

      // Save both tokens to cache
      await CacheManager.saveAccessToken(accessToken);
      await CacheManager.saveRefreshToken(newRefreshToken);
      await Storage.setRefreshToken(refreshToken);
      serviceLocator<Dio>().options.headers['Authorization'] =
          'Bearer $accessToken';

      return newToken;
    } catch (e) {
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      // Clear tokens and navigate to login
      removeTokenFromHeader();
      await CacheManager.clearTokens(); // Clear only tokens
      try {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext;
        if (currentContext != null && currentContext.mounted) {
          currentContext.go(Routes.LOGIN);
        }
      } catch (navError) {
        print('❌ Navigation error: $navError');
      }
      return null;
    }
  }
}
