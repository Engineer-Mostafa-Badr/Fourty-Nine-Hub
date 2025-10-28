import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Logging service to replace print statements throughout the application
/// Provides different log levels and conditional logging based on debug mode
class LoggingService {
  static const String _tag = 'FourtyNineHub';

  /// Log an info message
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Log a debug message
  static void debug(String message, {String? tag}) {
    _log('DEBUG', message, tag: tag);
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    _log('WARNING', message, tag: tag);
  }

  /// Log an error message
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, tag: tag);
    if (error != null) {
      _log('ERROR', 'Exception: $error', tag: tag);
    }
    if (stackTrace != null) {
      _log('ERROR', 'StackTrace: $stackTrace', tag: tag);
    }
  }

  /// Internal logging method
  static void _log(String level, String message, {String? tag}) {
    if (kDebugMode) {
      final String logTag = tag ?? _tag;
      final String timestamp = DateTime.now().toIso8601String();
      final String logMessage = '[$timestamp] [$level] [$logTag] $message';
      
      developer.log(
        message,
        time: DateTime.now(),
        level: _getLevelInt(level),
        name: logTag,
      );
      
      // Also print to console in debug mode for immediate visibility
      if (kDebugMode) {
        // ignore: avoid_print
        print(logMessage);
      }
    }
  }

  /// Convert string level to integer for developer.log
  static int _getLevelInt(String level) {
    switch (level) {
      case 'DEBUG':
        return 500;
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

  /// Log method calls for debugging
  static void methodCall(String className, String methodName, {String? params}) {
    if (kDebugMode) {
      final String message = params != null 
        ? '$className.$methodName($params)' 
        : '$className.$methodName()';
      debug(message, tag: 'MethodCall');
    }
  }

  /// Log state changes in Cubits/Blocs
  static void stateChange(String cubitName, String oldState, String newState) {
    if (kDebugMode) {
      debug('$cubitName: $oldState -> $newState', tag: 'StateChange');
    }
  }

  /// Log network requests
  static void network(String method, String url, {int? statusCode, String? response}) {
    if (kDebugMode) {
      String message = '$method $url';
      if (statusCode != null) {
        message += ' - Status: $statusCode';
      }
      if (response != null) {
        message += ' - Response: ${response.length > 100 ? '${response.substring(0, 100)}...' : response}';
      }
      info(message, tag: 'Network');
    }
  }

  /// Log timing for performance analysis
  static void timing(String operation, Duration duration) {
    if (kDebugMode) {
      info('$operation took ${duration.inMilliseconds}ms', tag: 'Performance');
    }
  }
}
