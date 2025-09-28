import 'logging_helper.dart';

/// SSL Certificate Helper for logging certificate validation events
/// Similar to the SSLCertificateHelper shown in the logs
class SSLCertificateHelper {
  static const String _tag = 'SSLCertificateHelper';
  
  /// Log SSL certificate validation success
  static void logCertificateValidationSuccess({
    required String host,
    required int port,
    required String subject,
    required String issuer,
    required DateTime validFrom,
    required DateTime validTo,
  }) {
    LoggingHelper.logFormatted(
      '$_tag: SSL Certificate validation successful for $host:$port',
      {
        'Certificate Subject': subject,
        'Certificate Issuer': issuer,
        'Valid From': validFrom.toIso8601String(),
        'Valid To': validTo.toIso8601String(),
      },
    );
  }
  
  /// Log SSL certificate validation failure
  static void logCertificateValidationFailure({
    required String host,
    required int port,
    required String subject,
    required String issuer,
    required DateTime validFrom,
    required DateTime validTo,
    String? reason,
  }) {
    final details = {
      'Certificate Subject': subject,
      'Certificate Issuer': issuer,
      'Valid From': validFrom.toIso8601String(),
      'Valid To': validTo.toIso8601String(),
    };
    
    if (reason != null) {
      details['Failure Reason'] = reason;
    }
    
    LoggingHelper.logFormatted(
      '$_tag: SSL Certificate validation failed for $host:$port',
      details,
    );
  }
  
  /// Log development mode certificate bypass
  static void logDevelopmentModeBypass({
    required String host,
    required int port,
  }) {
    LoggingHelper.info('$_tag: Allowing connection in development mode for $host:$port');
  }
  
  /// Log certificate expiration warning
  static void logCertificateExpirationWarning({
    required String host,
    required int port,
    required DateTime validTo,
    required int daysUntilExpiration,
  }) {
    LoggingHelper.warning(
      '$_tag: Certificate for $host:$port expires in $daysUntilExpiration days',
      data: {
        'Valid To': validTo.toIso8601String(),
        'Days Until Expiration': daysUntilExpiration,
      },
    );
  }
  
  /// Log certificate chain validation
  static void logCertificateChainValidation({
    required String host,
    required int port,
    required List<String> chain,
    required bool isValid,
  }) {
    final details = {
      'Chain Length': chain.length,
      'Is Valid': isValid,
    };
    
    for (int i = 0; i < chain.length; i++) {
      details['Certificate $i'] = chain[i];
    }
    
    final status = isValid ? 'successful' : 'failed';
    LoggingHelper.logFormatted(
      '$_tag: Certificate chain validation $status for $host:$port',
      details,
    );
  }
  
  /// Log certificate pinning events
  static void logCertificatePinning({
    required String host,
    required int port,
    required bool isPinned,
    String? pinHash,
  }) {
    final details = <String, dynamic>{
      'Is Pinned': isPinned,
    };
    
    if (pinHash != null) {
      details['Pin Hash'] = pinHash;
    }
    
    LoggingHelper.logFormatted(
      '$_tag: Certificate pinning for $host:$port',
      details,
    );
  }
  
  /// Log TLS handshake events
  static void logTLSHandshake({
    required String host,
    required int port,
    required String protocol,
    required String cipherSuite,
    required bool isSuccessful,
  }) {
    final details = {
      'Protocol': protocol,
      'Cipher Suite': cipherSuite,
      'Is Successful': isSuccessful,
    };
    
    final status = isSuccessful ? 'successful' : 'failed';
    LoggingHelper.logFormatted(
      '$_tag: TLS handshake $status for $host:$port',
      details,
    );
  }
  
  /// Log certificate trust store events
  static void logTrustStoreEvent({
    required String event,
    required String host,
    required int port,
    Map<String, dynamic>? details,
  }) {
    final logData = {
      'Host': host,
      'Port': port,
      ...?details,
    };
    
    LoggingHelper.info('$_tag: Trust store event: $event', data: logData);
  }
  
  /// Log certificate revocation check
  static void logCertificateRevocationCheck({
    required String host,
    required int port,
    required bool isRevoked,
    String? revocationReason,
  }) {
    final details = <String, dynamic>{
      'Is Revoked': isRevoked,
    };
    
    if (revocationReason != null) {
      details['Revocation Reason'] = revocationReason;
    }
    
    LoggingHelper.logFormatted(
      '$_tag: Certificate revocation check for $host:$port',
      details,
    );
  }
  
  /// Log certificate transparency events
  static void logCertificateTransparency({
    required String host,
    required int port,
    required bool isCTValid,
    List<String>? logEntries,
  }) {
    final details = <String, dynamic>{
      'Is CT Valid': isCTValid,
    };
    
    if (logEntries != null) {
      details['Log Entries Count'] = logEntries.length;
      for (int i = 0; i < logEntries.length; i++) {
        details['Log Entry $i'] = logEntries[i];
      }
    }
    
    LoggingHelper.logFormatted(
      '$_tag: Certificate transparency for $host:$port',
      details,
    );
  }
  
  /// Log certificate validation timing
  static void logCertificateValidationTiming({
    required String host,
    required int port,
    required Duration validationTime,
    required bool isSuccessful,
  }) {
    LoggingHelper.info(
      '$_tag: Certificate validation timing for $host:$port',
      data: {
        'Validation Time (ms)': validationTime.inMilliseconds,
        'Is Successful': isSuccessful,
      },
    );
  }
  
  /// Log certificate policy violations
  static void logCertificatePolicyViolation({
    required String host,
    required int port,
    required String policy,
    required String violation,
  }) {
    LoggingHelper.warning(
      '$_tag: Certificate policy violation for $host:$port',
      data: {
        'Policy': policy,
        'Violation': violation,
      },
    );
  }
  
  /// Log certificate hostname mismatch
  static void logHostnameMismatch({
    required String host,
    required int port,
    required String expectedHostname,
    required String actualHostname,
  }) {
    LoggingHelper.warning(
      '$_tag: Hostname mismatch for $host:$port',
      data: {
        'Expected Hostname': expectedHostname,
        'Actual Hostname': actualHostname,
      },
    );
  }
  
  /// Log certificate date validation
  static void logCertificateDateValidation({
    required String host,
    required int port,
    required DateTime currentTime,
    required DateTime validFrom,
    required DateTime validTo,
    required bool isDateValid,
  }) {
    final details = <String, dynamic>{
      'Current Time': currentTime.toIso8601String(),
      'Valid From': validFrom.toIso8601String(),
      'Valid To': validTo.toIso8601String(),
      'Is Date Valid': isDateValid,
    };
    
    if (!isDateValid) {
      if (currentTime.isBefore(validFrom)) {
        details['Issue'] = 'Certificate not yet valid';
      } else if (currentTime.isAfter(validTo)) {
        details['Issue'] = 'Certificate expired';
      }
    }
    
    LoggingHelper.logFormatted(
      '$_tag: Certificate date validation for $host:$port',
      details,
    );
  }
}
