import 'package:dio/dio.dart';

import 'logging_helper.dart';
import 'network_logging_helper.dart';
import 'ssl_certificate_helper.dart';

/// Examples of how to use the logging helpers
class LoggingExamples {
  
  /// Example of basic logging
  static void basicLoggingExample() {
    // Basic logging with different levels
    LoggingHelper.verbose('This is a verbose message');
    LoggingHelper.debug('This is a debug message');
    LoggingHelper.info('This is an info message');
    LoggingHelper.warning('This is a warning message');
    LoggingHelper.error('This is an error message');
    
    // Logging with data
    LoggingHelper.info('User login attempt', data: {
      'userId': '12345',
      'timestamp': DateTime.now().toIso8601String(),
      'ipAddress': '192.168.1.1',
    });
    
    // Logging with custom tag
    LoggingHelper.info('Custom message', tag: 'MyCustomTag');
  }
  
  /// Example of network logging
  static void networkLoggingExample() {
    // Log API calls
    LoggingHelper.logApiCall('/api/v1/users', method: 'GET', params: {
      'page': 1,
      'limit': 10,
    });
    
    // Log network requests (similar to Dio format)
    NetworkLoggingHelper.logRequest(
      RequestOptions(
        method: 'GET',
        path: '/api/v1/settings',
        baseUrl: 'https://49backend.com',
        headers: {
          'Authorization': 'Bearer token123',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'page': 1,
          'limit': 10,
        },
      ),
    );
    
    // Log network responses
    NetworkLoggingHelper.logResponse(
      Response(
        requestOptions: RequestOptions(path: '/api/v1/settings'),
        statusCode: 200,
        data: {'success': true, 'data': 'some data'},
      ),
    );
    
    // Log network errors
    NetworkLoggingHelper.logError(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/settings'),
        type: DioExceptionType.unknown,
        message: 'Connection failed',
      ),
    );
  }
  
  /// Example of SSL certificate logging
  static void sslCertificateLoggingExample() {
    // Log certificate validation success
    SSLCertificateHelper.logCertificateValidationSuccess(
      host: '49backend.com',
      port: 443,
      subject: '/CN=49backend.com',
      issuer: '/C=US/O=Let\'s Encrypt/CN=E6',
      validFrom: DateTime.parse('2025-08-11T18:43:30.000Z'),
      validTo: DateTime.parse('2025-11-09T18:43:29.000Z'),
    );
    
    // Log certificate validation failure
    SSLCertificateHelper.logCertificateValidationFailure(
      host: '49backend.com',
      port: 443,
      subject: '/CN=49backend.com',
      issuer: '/C=US/O=Let\'s Encrypt/CN=E6',
      validFrom: DateTime.parse('2025-08-11T18:43:30.000Z'),
      validTo: DateTime.parse('2025-11-09T18:43:29.000Z'),
      reason: 'Certificate expired',
    );
    
    // Log development mode bypass
    SSLCertificateHelper.logDevelopmentModeBypass(
      host: '49backend.com',
      port: 443,
    );
    
    // Log certificate expiration warning
    SSLCertificateHelper.logCertificateExpirationWarning(
      host: '49backend.com',
      port: 443,
      validTo: DateTime.parse('2025-11-09T18:43:29.000Z'),
      daysUntilExpiration: 30,
    );
  }
  
  /// Example of authentication logging
  static void authenticationLoggingExample() {
    // Log auth events
    LoggingHelper.logAuthEvent('User login successful', data: {
      'userId': '12345',
      'loginMethod': 'email',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    LoggingHelper.logAuthEvent('Token refresh', data: {
      'oldTokenExpiry': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      'newTokenExpiry': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    });
    
    // Log auth errors
    LoggingHelper.error('Authentication failed', data: {
      'reason': 'Invalid credentials',
      'attemptCount': 3,
      'ipAddress': '192.168.1.1',
    });
  }
  
  /// Example of service locator logging
  static void serviceLocatorLoggingExample() {
    // Log service registration
    LoggingHelper.logServiceLocatorEvent('Service registered', data: {
      'serviceType': 'TenPercentRemoteDataSource',
      'registrationType': 'LazySingleton',
    });
    
    // Log service resolution
    LoggingHelper.logServiceLocatorEvent('Service resolved', data: {
      'serviceType': 'TenPercentRemoteDataSource',
      'resolutionTime': '5ms',
    });
    
    // Log service locator errors
    LoggingHelper.error('Service locator error', data: {
      'error': 'Type TenPercentRemoteDataSource is already registered',
      'serviceType': 'TenPercentRemoteDataSource',
    });
  }
  
  /// Example of navigation logging
  static void navigationLoggingExample() {
    // Log navigation events
    LoggingHelper.logNavigationEvent(
      'Route changed',
      from: '/splashScreen',
      to: '/home',
      data: {
        'navigationType': 'push',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    // Log navigation errors
    LoggingHelper.error('Navigation error', data: {
      'error': 'Route not found',
      'attemptedRoute': '/invalid-route',
    });
  }
  
  /// Example of performance logging
  static void performanceLoggingExample() {
    // Log performance metrics
    LoggingHelper.logPerformance(
      'API call to /api/v1/settings',
      Duration(milliseconds: 250),
      data: {
        'endpoint': '/api/v1/settings',
        'method': 'GET',
        'responseSize': '1.2KB',
      },
    );
    
    // Log database operation performance
    LoggingHelper.logDatabaseOperation(
      'SELECT query',
      table: 'users',
      data: {
        'queryTime': '15ms',
        'rowsReturned': 100,
      },
    );
  }
  
  /// Example of user action logging
  static void userActionLoggingExample() {
    // Log user actions
    LoggingHelper.logUserAction('Button clicked', data: {
      'buttonId': 'login_button',
      'screen': 'login_screen',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    LoggingHelper.logUserAction('Form submitted', data: {
      'formType': 'user_registration',
      'fieldCount': 5,
      'validationPassed': true,
    });
  }
  
  /// Example of cache logging
  static void cacheLoggingExample() {
    // Log cache operations
    LoggingHelper.logCacheOperation(
      'Cache hit',
      key: 'user_profile_12345',
      value: 'cached_data',
    );
    
    LoggingHelper.logCacheOperation(
      'Cache miss',
      key: 'user_profile_67890',
    );
    
    LoggingHelper.logCacheOperation(
      'Cache set',
      key: 'api_response_settings',
      value: 'response_data',
    );
  }
  
  /// Example of file operation logging
  static void fileOperationLoggingExample() {
    // Log file operations
    LoggingHelper.logFileOperation(
      'File read',
      path: '/storage/images/profile.jpg',
      size: 1024000,
    );
    
    LoggingHelper.logFileOperation(
      'File write',
      path: '/storage/cache/data.json',
      size: 512,
    );
  }
  
  /// Example of security logging
  static void securityLoggingExample() {
    // Log security events
    LoggingHelper.logSecurityEvent('Suspicious activity detected', data: {
      'activityType': 'multiple_failed_logins',
      'ipAddress': '192.168.1.1',
      'attemptCount': 5,
      'timeWindow': '5 minutes',
    });
    
    LoggingHelper.logSecurityEvent('Permission denied', data: {
      'resource': '/admin/settings',
      'userId': '12345',
      'reason': 'Insufficient privileges',
    });
  }
  
  /// Example of configuration logging
  static void configurationLoggingExample() {
    // Log configuration changes
    LoggingHelper.logConfigChange(
      'API_BASE_URL',
      oldValue: 'https://dev-api.example.com',
      newValue: 'https://api.example.com',
    );
    
    LoggingHelper.logConfigChange(
      'LOG_LEVEL',
      oldValue: 'DEBUG',
      newValue: 'INFO',
    );
  }
  
  /// Example of feature flag logging
  static void featureFlagLoggingExample() {
    // Log feature flags
    LoggingHelper.logFeatureFlag(
      'NEW_UI_ENABLED',
      true,
      data: {
        'userId': '12345',
        'rolloutPercentage': 50,
      },
    );
    
    LoggingHelper.logFeatureFlag(
      'BETA_FEATURE',
      false,
      data: {
        'reason': 'User not in beta group',
      },
    );
  }
  
  /// Example of custom formatted logging
  static void customFormattedLoggingExample() {
    // Log with custom format (similar to SSLCertificateHelper)
    LoggingHelper.logFormatted(
      'SSLCertificateHelper: SSL Certificate validation failed for 49backend.com:443',
      {
        'Certificate Subject': '/CN=49backend.com',
        'Certificate Issuer': '/C=US/O=Let\'s Encrypt/CN=E6',
        'Valid From': '2025-08-11 18:43:30.000Z',
        'Valid To': '2025-11-09 18:43:29.000Z',
      },
    );
    
    // Log with emoji
    LoggingHelper.logWithEmoji('🚀', 'App started successfully', data: {
      'version': '1.0.0',
      'buildNumber': '123',
    });
    
    // Log lifecycle events
    LoggingHelper.logLifecycleEvent('App started', data: {
      'startupTime': '2.5s',
      'memoryUsage': '45MB',
    });
  }
}
