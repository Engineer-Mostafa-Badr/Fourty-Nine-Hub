import 'package:dio/dio.dart';
import 'package:fourtyninehub/helpers/network_logging_helper.dart';

/// Network Logging Interceptor for Dio
/// Provides structured logging similar to the format shown in the logs
class NetworkLoggingInterceptor extends Interceptor {
  final bool logRequests;
  final bool logResponses;
  final bool logErrors;
  final bool logHeaders;
  final bool logData;
  final bool logQueryParameters;
  final bool logExtras;
  
  NetworkLoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.logHeaders = true,
    this.logData = true,
    this.logQueryParameters = true,
    this.logExtras = true,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequests) {
      NetworkLoggingHelper.logRequest(options);
    }
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponses) {
      NetworkLoggingHelper.logResponse(response);
    }
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logErrors) {
      NetworkLoggingHelper.logError(err);
    }
    super.onError(err, handler);
  }
}

