import 'package:dio/dio.dart';

import 'logging_helper.dart';

/// Network Logging Helper for Dio interceptor
/// Provides structured logging similar to the format shown in the logs
class NetworkLoggingHelper {
  static const String _tag = 'NetworkLoggingHelper';

  /// Log network request in the format shown in the logs
  static void logRequest(RequestOptions options) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();

    // Log the main request line
    LoggingHelper.info('╔╣ Request ║ $method');
    LoggingHelper.info('║  $url');
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');

    // Log headers
    if (options.headers.isNotEmpty) {
      LoggingHelper.info('╔ Headers');
      options.headers.forEach((key, value) {
        // Truncate long authorization tokens for security
        String displayValue = value.toString();
        if (key.toLowerCase() == 'authorization' && displayValue.length > 50) {
          displayValue = '${displayValue.substring(0, 50)}...';
        }
        LoggingHelper.info('╟ $key: $displayValue');
      });
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log extras/options
    if (options.extra.isNotEmpty) {
      LoggingHelper.info('╔ Extras');
      options.extra.forEach((key, value) {
        LoggingHelper.info('╟ $key: $value');
      });
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log request data if present
    if (options.data != null) {
      LoggingHelper.info('╔ Request Data');
      LoggingHelper.info('║ ${options.data}');
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log query parameters if present
    if (options.queryParameters.isNotEmpty) {
      LoggingHelper.info('╔ Query Parameters');
      options.queryParameters.forEach((key, value) {
        LoggingHelper.info('╟ $key: $value');
      });
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }
  }

  /// Log network response
  static void logResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final url = response.requestOptions.uri.toString();
    final statusEmoji = _getStatusEmoji(statusCode);

    LoggingHelper.info('╔╣ Response ║ $statusEmoji $statusCode');
    LoggingHelper.info('║  $url');
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');

    // Log response headers
    if (response.headers.map.isNotEmpty) {
      LoggingHelper.info('╔ Response Headers');
      response.headers.map.forEach((key, values) {
        LoggingHelper.info('╟ $key: ${values.join(', ')}');
      });
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log response data
    if (response.data != null) {
      LoggingHelper.info('╔ Response Data');
      LoggingHelper.info('║ ${response.data}');
      LoggingHelper.info(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }
  }

  /// Log network error
  static void logError(DioException error) {
    final errorType = error.type.toString();
    final url = error.requestOptions.uri.toString();

    LoggingHelper.error('╔╣ DioError ║ $errorType');
    LoggingHelper.error('║  $url');
    LoggingHelper.error(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');

    // Log error details
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 0;
      LoggingHelper.error('╔ Error Response');
      LoggingHelper.error('╟ Status Code: $statusCode');
      LoggingHelper.error('╟ Response Data: ${error.response!.data}');
      LoggingHelper.error(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log error message
    if (error.message != null) {
      LoggingHelper.error('╔ Error Message');
      LoggingHelper.error('║ ${error.message}');
      LoggingHelper.error(
          '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    }

    // Log stack trace if available
    LoggingHelper.error('╔ Stack Trace');
    LoggingHelper.error('║ ${error.stackTrace}');
    LoggingHelper.error(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Get emoji for HTTP status code
  static String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return '✅';
    } else if (statusCode >= 300 && statusCode < 400) {
      return '🔄';
    } else if (statusCode >= 400 && statusCode < 500) {
      return '⚠️';
    } else if (statusCode >= 500) {
      return '❌';
    } else {
      return '❓';
    }
  }

  /// Log connection timing
  static void logConnectionTiming({
    required String url,
    required Duration connectTime,
    required Duration totalTime,
    required bool isSuccessful,
  }) {
    final statusEmoji = isSuccessful ? '✅' : '❌';
    LoggingHelper.info('╔╣ Connection Timing ║ $statusEmoji');
    LoggingHelper.info('║  $url');
    LoggingHelper.info('╟ Connect Time: ${connectTime.inMilliseconds}ms');
    LoggingHelper.info('╟ Total Time: ${totalTime.inMilliseconds}ms');
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log retry attempts
  static void logRetryAttempt({
    required String url,
    required int attemptNumber,
    required int maxAttempts,
    required String reason,
  }) {
    LoggingHelper.warning('╔╣ Retry Attempt ║ $attemptNumber/$maxAttempts');
    LoggingHelper.warning('║  $url');
    LoggingHelper.warning('╟ Reason: $reason');
    LoggingHelper.warning(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log cache operations
  static void logCacheOperation({
    required String operation,
    required String url,
    required bool isHit,
    Duration? age,
  }) {
    final statusEmoji = isHit ? '💾' : '🌐';
    LoggingHelper.info('╔╣ Cache $operation ║ $statusEmoji');
    LoggingHelper.info('║  $url');
    if (age != null) {
      LoggingHelper.info('╟ Age: ${age.inMinutes} minutes');
    }
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log authentication events
  static void logAuthEvent({
    required String event,
    required String url,
    Map<String, dynamic>? details,
  }) {
    LoggingHelper.info('╔╣ Auth Event ║ $event');
    LoggingHelper.info('║  $url');
    if (details != null) {
      details.forEach((key, value) {
        LoggingHelper.info('╟ $key: $value');
      });
    }
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log SSL/TLS events
  static void logSSLEvent({
    required String event,
    required String url,
    required bool isSuccessful,
    Map<String, dynamic>? details,
  }) {
    final statusEmoji = isSuccessful ? '🔒' : '🔓';
    LoggingHelper.info('╔╣ SSL Event ║ $statusEmoji $event');
    LoggingHelper.info('║  $url');
    if (details != null) {
      details.forEach((key, value) {
        LoggingHelper.info('╟ $key: $value');
      });
    }
    LoggingHelper.info(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log rate limiting events
  static void logRateLimitEvent({
    required String url,
    required int remainingRequests,
    required int resetTime,
  }) {
    LoggingHelper.warning('╔╣ Rate Limit ║ ⏰');
    LoggingHelper.warning('║  $url');
    LoggingHelper.warning('╟ Remaining Requests: $remainingRequests');
    LoggingHelper.warning(
        '╟ Reset Time: ${DateTime.fromMillisecondsSinceEpoch(resetTime * 1000)}');
    LoggingHelper.warning(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }

  /// Log timeout events
  static void logTimeoutEvent({
    required String url,
    required Duration timeout,
    required String timeoutType,
  }) {
    LoggingHelper.error('╔╣ Timeout ║ ⏱️');
    LoggingHelper.error('║  $url');
    LoggingHelper.error('╟ Timeout Type: $timeoutType');
    LoggingHelper.error('╟ Timeout Duration: ${timeout.inSeconds}s');
    LoggingHelper.error(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝');
  }
}
