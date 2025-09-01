import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

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
    print('🔐 AuthInterceptor: attachToken called with token: ${token?.accessToken?.substring(0, 20)}...');
    print('🔐 AuthInterceptor: attachToken refresh token: ${token?.refreshToken?.substring(0, 20)}...');
    
    _token = token;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      _dio.options.headers['x-api-key'] =
      '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      print('🔐 AuthInterceptor: Token attached to Dio headers');
    } else {
      _dio.options.headers.remove('Authorization');
      print('🔐 AuthInterceptor: Token removed from Dio headers');
    }
  }

  /// إزالة التوكين من الـ headers
  void removeTokenFromHeader() {
    _token = null;
    _dio.options.headers.remove('Authorization');
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
            final response = await _dio.fetch(originalRequestOptions);
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
                
                final retryResponse = await _dio.fetch(retryRequestOptions);
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
      print('🔄 AuthInterceptor: Calling refresh token API with clean Dio instance (no expired token)');
      
      // Check if refresh token exists
      if (_token?.refreshToken == null || _token!.refreshToken.isEmpty) {
        print('❌ AuthInterceptor: No refresh token available');
        return null;
      }
      
      print('🔄 AuthInterceptor: Using refresh token: ${_token?.refreshToken?.substring(0, 20)}...');
      
      // Create a completely isolated Dio instance for refresh token request
      final refreshDio = Dio(BaseOptions(
        baseUrl: 'https://49backend.com',
        headers: {
          "x-api-key": "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
          "Content-Type": "application/json",
        },
        validateStatus: (status) {
          return status != null && status < 500; // Don't throw for 4xx errors
        },
      ));
      
      // Don't add any interceptors to this Dio instance
      
      final response = await refreshDio.post(
        "/api/v1/auth/refresh-token",
        data: {
          'refreshToken': _token?.refreshToken,
        },
      );

      print('🔄 AuthInterceptor: Refresh token response status: ${response.statusCode}');
      print('🔄 AuthInterceptor: Refresh token response data: ${response.data}');

      // Check if the response was successful
      if (response.statusCode == 200 && response.data['data'] != null) {
        final accessToken = response.data['data']['accessToken'] as String;
        final refreshToken = response.data['data']['refreshToken'] as String;
        final newToken = _token!.copyWith(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        
        print('🔐 AuthInterceptor: New tokens received - Access: ${accessToken.substring(0, 10)}..., Refresh: ${refreshToken.substring(0, 10)}...');
        
        // Save both tokens to cache
        await CacheManager.saveAccessToken(accessToken);
        await CacheManager.saveRefreshToken(refreshToken);
        
        return newToken;
      } else {
        print('❌ AuthInterceptor: Refresh token API returned invalid response: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      if (e is DioException) {
        print('❌ AuthInterceptor: Dio error details - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        print('❌ AuthInterceptor: Dio error request - Method: ${e.requestOptions.method}, Path: ${e.requestOptions.path}');
      }
      return null;
    }
  }
}
