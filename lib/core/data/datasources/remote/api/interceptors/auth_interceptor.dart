import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

// Global event stream for notifying data refresh
class DataRefreshEvent {
  static final StreamController<void> _controller = StreamController<void>.broadcast();
  static Stream<void> get stream => _controller.stream;
  
  static void notifyRefresh() {
    _controller.add(null);
  }
  
  static void dispose() {
    _controller.close();
  }
}

/// Mixin for cubits to automatically refresh data when tokens are refreshed
mixin AutoRefreshMixin {
  StreamSubscription<void>? _refreshSubscription;
  
  /// Initialize auto-refresh functionality
  void initializeAutoRefresh() {
    _refreshSubscription = DataRefreshEvent.stream.listen((_) {
      print('🔄 AutoRefreshMixin: Token refreshed, refreshing data for ${runtimeType}');
      onTokenRefreshed();
    });
  }
  
  /// Override this method to implement data refresh logic
  void onTokenRefreshed();
  
  /// Dispose auto-refresh subscription
  void disposeAutoRefresh() {
    _refreshSubscription?.cancel();
    _refreshSubscription = null;
  }
}

class AuthInterceptor extends Interceptor {
  UserTokensEntity? _token;
  Function(UserTokensEntity)? _onTokenRefreshed;

  bool _isRefreshing = false;
  bool _isInvalidSession = false;

  AuthInterceptor( this._token);

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
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      serviceLocator<Dio>().options.headers['x-api-key'] =
      '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      print('🔐 AuthInterceptor: Token attached to Dio headers');
    } else {
      serviceLocator<Dio>().options.headers.remove('Authorization');
      print('🔐 AuthInterceptor: Token removed from Dio headers');
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
    print('🔐 AuthInterceptor: onError called for ${err.requestOptions.method} ${err.requestOptions.path} with status: ${err.response?.statusCode}');
    
    if (err.response?.statusCode == 401 ) {
      final requestOptions = err.requestOptions;

      print("requestOptions.path.contains ${(requestOptions.path.contains('/auth/refresh-token') ||
          requestOptions.path.contains('refresh-token') ||
          requestOptions.uri.path.contains('/auth/refresh-token') ||
          requestOptions.uri.path.contains('refresh-token'))}");
      // Skip if this is the refresh token request itself
      if (requestOptions.path.contains('/auth/refresh-token') || 
          requestOptions.path.contains('refresh-token') ||
          requestOptions.uri.path.contains('/auth/refresh-token') ||
          requestOptions.uri.path.contains('refresh-token')) {
        print('🔐 AuthInterceptor: Refresh token request failed, not retrying - Path: ${requestOptions.path}');
        super.onError(err, handler);
        return;
      }
      
      print('🔐 AuthInterceptor: ${err.response?.statusCode} error for ${requestOptions.method} ${requestOptions.path}');

      if (_isRefreshing) {
        print('🔐 AuthInterceptor: Token refresh already in progress, skipping this request');
        super.onError(err, handler);
        return;
      }

      _isRefreshing = true;
      try {
        final result = await _refreshToken();
        if (result) {
          print('🔐 AuthInterceptor: Token refresh successful, retrying request');
          // final retryResult = await _retry(err, handler);
          // if (retryResult) {
          //   print('🔐 AuthInterceptor: Request retry successful');
          //   // Notify all active cubits to refresh their data
          //   _notifyDataRefresh();
          //   return;
          // } else {
          //   print('🔐 AuthInterceptor: Request retry failed');
          //   if (requestOptions.headers["requiresToken"] == true) {
          //     _isInvalidSession = true;
          //   }
          // }
        } else {
          print('🔐 AuthInterceptor: Token refresh failed');
          if (requestOptions.headers["requiresToken"] == true) {
            _isInvalidSession = true;
          }
        }
      } catch (e) {
        print('🔐 AuthInterceptor: Error during token refresh: $e');
        if (requestOptions.headers["requiresToken"] == true) {
          _isInvalidSession = true;
        }
      } finally {
        _isRefreshing = false;
      }
    }

    super.onError(err, handler);
  }

  /// Notify all active cubits to refresh their data
  void _notifyDataRefresh() {
    print('🔄 AuthInterceptor: Notifying all cubits to refresh data...');
    DataRefreshEvent.notifyRefresh();
  }

  Future<bool> _refreshToken() async {
    try {
      print('🔄 AuthInterceptor: _refreshToken method called!');
      
      // Get tokens from cache
      final refreshToken = await CacheManager.getRefreshToken();
      final accessToken = await CacheManager.getAccessToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ AuthInterceptor: No refresh token available');
        return false;
      }
      
      print('🔄 AuthInterceptor: Using refresh token: ${refreshToken.substring(0, 20)}...');
      
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
      
      print('🔄 AuthInterceptor: About to make refresh token request...');
      final response = await refreshDio.post(
        "/api/v1/auth/refresh-token",
        data: {
          'refreshToken': refreshToken,
        },
      );

      print('🔄 AuthInterceptor: Refresh token response status: ${response.statusCode}');
      print('🔄 AuthInterceptor: Refresh token response data: ${response.data}');

      // Check if the response was successful
      if (response.statusCode == 200 && response.data['data'] != null) {
        final newAccessToken = response.data['data']['accessToken'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;
        
        print('🔐 AuthInterceptor: New tokens received - Access: ${newAccessToken.substring(0, 10)}..., Refresh: ${newRefreshToken.substring(0, 10)}...');
        
        // Save both tokens to cache
        await CacheManager.saveAccessToken(newAccessToken);
        await CacheManager.saveRefreshToken(newRefreshToken);
        
        // Update the token entity
        final newToken = UserTokensEntity(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        
        // Update the interceptor's token
        _token = newToken;
        final accessToken = await CacheManager.getAccessToken();

        // Update Dio headers
        serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';
        print("🔐 AuthInterceptor: Token updated in Dio headers ${serviceLocator<Dio>().options.headers['Authorization']}");
        
        // Notify the app about the token refresh
        if (_onTokenRefreshed != null) {
          _onTokenRefreshed!(newToken);
        }
        
        // Notify all active cubits to refresh their data
        _notifyDataRefresh();
        
        print('🔐 AuthInterceptor: Token refresh completed successfully');
        return true;
      } else {
        print('❌ AuthInterceptor: Refresh token API returned invalid response: ${response.statusCode} - ${response.data}');
        return false;
      }
    } catch (e) {
      log('🔐 AuthInterceptor: refreshToken error: $e');
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      if (e is DioException) {
        print('❌ AuthInterceptor: Dio error details - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        print('❌ AuthInterceptor: Dio error request - Method: ${e.requestOptions.method}, Path: ${e.requestOptions.path}');
      }
      return false;
    }
  }

  Future<bool> _retry(DioException dioException, ErrorInterceptorHandler handler) async {
    try {
      print('🔄 AuthInterceptor: _retry called for ${dioException.requestOptions.method} ${dioException.requestOptions.path}');
      
      // Get the latest access token from cache
      final accessToken = await CacheManager.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        print('❌ AuthInterceptor: No access token available for retry');
        return false;
      }
      
      print('🔄 AuthInterceptor: Using access token: ${accessToken.substring(0, 20)}...');
      
      // Create a new Dio instance for the retry with base URL
      final dio = Dio(BaseOptions(
        baseUrl: 'https://49backend.com',
        headers: {
          'x-api-key': '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06',
        },
      ));
      
      // Update headers with new access token
      dioException.requestOptions.headers["Authorization"] = "Bearer $accessToken";
      dioException.requestOptions.headers['x-api-key'] = '2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06';
      
      print('🔄 AuthInterceptor: Retrying request with new token...');
      
      // Create request with new access token
      final opts = Options(
        method: dioException.requestOptions.method,
        headers: dioException.requestOptions.headers,
      );
      
      final cloneReq = await dio.request(
        dioException.requestOptions.path,
        options: opts,
        data: dioException.requestOptions.data,
        queryParameters: dioException.requestOptions.queryParameters,
      );

      print('✅ AuthInterceptor: Request retry successful');
      handler.resolve(cloneReq);
      return true;
    } catch (e) {
      log('🔐 AuthInterceptor: error happened in _retry: $e');
      print('❌ AuthInterceptor: Request retry failed: $e');
      return false;
    }
  }
}
