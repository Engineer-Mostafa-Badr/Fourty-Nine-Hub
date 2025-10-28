import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// A comprehensive logging helper that provides structured logging similar to SSLCertificateHelper
class LoggingHelper {
  static const String _tag = 'LoggingHelper';
  
  /// Log levels for different types of messages
  static const int VERBOSE = 0;
  static const int DEBUG = 1;
  static const int INFO = 2;
  static const int WARNING = 3;
  static const int ERROR = 4;
  
  /// Current log level (can be adjusted based on build mode)
  static int _currentLogLevel = kDebugMode ? VERBOSE : INFO;
  
  /// Set the current log level
  static void setLogLevel(int level) {
    _currentLogLevel = level;
  }
  
  /// Log verbose messages (most detailed)
  static void verbose(String message, {String? tag, Map<String, dynamic>? data}) {
    if (_currentLogLevel <= VERBOSE) {
      _log('VERBOSE', message, tag: tag, data: data);
    }
  }
  
  /// Log debug messages
  static void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    if (_currentLogLevel <= DEBUG) {
      _log('DEBUG', message, tag: tag, data: data);
    }
  }
  
  /// Log info messages
  static void info(String message, {String? tag, Map<String, dynamic>? data}) {
    if (_currentLogLevel <= INFO) {
      _log('INFO', message, tag: tag, data: data);
    }
  }
  
  /// Log warning messages
  static void warning(String message, {String? tag, Map<String, dynamic>? data}) {
    if (_currentLogLevel <= WARNING) {
      _log('WARNING', message, tag: tag, data: data);
    }
  }
  
  /// Log error messages
  static void error(String message, {String? tag, Map<String, dynamic>? data, Object? error, StackTrace? stackTrace}) {
    if (_currentLogLevel <= ERROR) {
      _log('ERROR', message, tag: tag, data: data, error: error, stackTrace: stackTrace);
    }
  }
  
  /// Core logging method that formats and outputs the log message
  static void _log(String level, String message, {
    String? tag,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    final timestamp = DateTime.now().toIso8601String();
    
    // Format the main log message
    final formattedMessage = '$_tag: $message';
    
    // Log to console with proper formatting
    if (kDebugMode) {
      print(formattedMessage);
      
      // Log additional data if provided
      if (data != null && data.isNotEmpty) {
        data.forEach((key, value) {
          print('$_tag:   $key: $value');
        });
      }
      
      // Log error details if provided
      if (error != null) {
        print('$_tag: Error: $error');
      }
      
      // Log stack trace if provided
      if (stackTrace != null) {
        print('$_tag: StackTrace: $stackTrace');
      }
    }
    
    // Also log to developer console for better debugging
    developer.log(
      message,
      name: logTag,
      level: _getLogLevel(level),
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Convert string log level to developer log level
  static int _getLogLevel(String level) {
    switch (level.toUpperCase()) {
      case 'VERBOSE':
        return 500;
      case 'DEBUG':
        return 700;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 800;
    }
  }
  
  /// Log network requests (similar to Dio logger format)
  static void logNetworkRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    info('Network Request: $method $url');
    
    if (headers != null && headers.isNotEmpty) {
      info('Request Headers:');
      headers.forEach((key, value) {
        info('  $key: $value');
      });
    }
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      info('Query Parameters:');
      queryParameters.forEach((key, value) {
        info('  $key: $value');
      });
    }
    
    if (data != null) {
      info('Request Data: $data');
    }
  }
  
  /// Log network responses
  static void logNetworkResponse({
    required int statusCode,
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    Duration? duration,
  }) {
    final statusEmoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    info('Network Response: $statusEmoji $statusCode $url');
    
    if (duration != null) {
      info('Response Time: ${duration.inMilliseconds}ms');
    }
    
    if (headers != null && headers.isNotEmpty) {
      info('Response Headers:');
      headers.forEach((key, value) {
        info('  $key: $value');
      });
    }
    
    if (data != null) {
      info('Response Data: $data');
    }
  }
  
  /// Log network errors
  static void logNetworkError({
    required String method,
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? responseData,
  }) {
    LoggingHelper.error('Network Error: $method $url', error: error, stackTrace: stackTrace);
    
    if (responseData != null) {
      LoggingHelper.error('Error Response Data: $responseData');
    }
  }
  
  /// Log authentication events
  static void logAuthEvent(String event, {Map<String, dynamic>? data}) {
    info('Auth Event: $event', data: data);
  }
  
  /// Log service locator events
  static void logServiceLocatorEvent(String event, {Map<String, dynamic>? data}) {
    info('ServiceLocator Event: $event', data: data);
  }
  
  /// Log navigation events
  static void logNavigationEvent(String event, {String? from, String? to, Map<String, dynamic>? data}) {
    final message = from != null && to != null ? '$event: $from -> $to' : event;
    info('Navigation Event: $message', data: data);
  }
  
  /// Log performance metrics
  static void logPerformance(String operation, Duration duration, {Map<String, dynamic>? data}) {
    final performanceData = {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      ...?data,
    };
    info('Performance: $operation completed in ${duration.inMilliseconds}ms', data: performanceData);
  }
  
  /// Log user actions
  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    info('User Action: $action', data: data);
  }
  
  /// Log API endpoint calls
  static void logApiCall(String endpoint, {String? method, Map<String, dynamic>? params}) {
    final message = method != null ? '$method $endpoint' : endpoint;
    info('API Call: $message', data: params);
  }
  
  /// Log database operations
  static void logDatabaseOperation(String operation, {String? table, Map<String, dynamic>? data}) {
    final message = table != null ? '$operation on $table' : operation;
    info('Database Operation: $message', data: data);
  }
  
  /// Log cache operations
  static void logCacheOperation(String operation, {String? key, dynamic value}) {
    final data = <String, dynamic>{};
    if (key != null) data['key'] = key;
    if (value != null) data['value'] = value;
    
    info('Cache Operation: $operation', data: data);
  }
  
  /// Log file operations
  static void logFileOperation(String operation, {String? path, int? size}) {
    final data = <String, dynamic>{};
    if (path != null) data['path'] = path;
    if (size != null) data['size_bytes'] = size;
    
    info('File Operation: $operation', data: data);
  }
  
  /// Log security events
  static void logSecurityEvent(String event, {Map<String, dynamic>? data}) {
    warning('Security Event: $event', data: data);
  }
  
  /// Log configuration changes
  static void logConfigChange(String setting, {dynamic oldValue, dynamic newValue}) {
    final data = <String, dynamic>{};
    if (oldValue != null) data['old_value'] = oldValue;
    if (newValue != null) data['new_value'] = newValue;
    
    info('Config Change: $setting', data: data);
  }
  
  /// Log feature flags
  static void logFeatureFlag(String flag, bool enabled, {Map<String, dynamic>? data}) {
    final message = 'Feature Flag: $flag = ${enabled ? 'enabled' : 'disabled'}';
    info(message, data: data);
  }
  
  /// Log memory usage
  static void logMemoryUsage({String? context}) {
    // This would require platform-specific implementation
    final message = context != null ? 'Memory Usage: $context' : 'Memory Usage';
    debug(message);
  }
  
  /// Log custom formatted messages (similar to SSLCertificateHelper format)
  static void logFormatted(String title, Map<String, dynamic> details) {
    info('$title:');
    details.forEach((key, value) {
      info('  $key: $value');
    });
  }
  
  /// Log with custom emoji prefix
  static void logWithEmoji(String emoji, String message, {Map<String, dynamic>? data}) {
    info('$emoji $message', data: data);
  }
  
  /// Log startup/shutdown events
  static void logLifecycleEvent(String event, {Map<String, dynamic>? data}) {
    final emoji = event.toLowerCase().contains('start') ? '🚀' : '🛑';
    info('$emoji Lifecycle Event: $event', data: data);
  }
}
