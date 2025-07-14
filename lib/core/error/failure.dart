import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  final String? name;
  final int? statusCode;
  final List<String>? errors;

  const ServerFailure({
    required this.message,
    this.name,
    this.errors,
    this.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  final String message;

  const UnauthorizedFailure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class UnknownFailure extends Failure {
  final String error;

  UnknownFailure(this.error);
}

class InvalidOtpFailure extends Failure {
  final String message;

  const InvalidOtpFailure(this.message);
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);
}

class SocialLoginFailure extends Failure {
  final dynamic exception;

  const SocialLoginFailure(this.exception,);
}

String getFailureMessage(Failure failure, BuildContext context) {
  String localizeMessage(String message) {
    if (message.contains('&&&')) {
      final parts = message.split('&&&');
      bool isArabic = context.isArabic;
      if (isArabic) {
        return parts.length > 1 ? parts[1].trim() : parts[0].trim();
      } else {
        return parts[0].trim();
      }
    }
    return message;
  }

  if (failure is ServerFailure) {
    final message = localizeMessage(failure.message);
    if (failure.errors != null && failure.errors!.isNotEmpty) {
      final errors = failure.errors!.map(localizeMessage).join('\n');
      return '$message\n$errors';
    }
    return message;
  } else if (failure is InvalidOtpFailure) {
    return localizeMessage(failure.message);
  } else if (failure is UnauthorizedFailure) {
    return localizeMessage(failure.message);
  } else if (failure is SocialLoginFailure) {
    if (failure.exception is FirebaseException &&
        (failure.exception as FirebaseException).message != null) {
      return localizeMessage((failure.exception as FirebaseException).message!);
    }
    return localizeMessage(failure.exception.toString());
  } else if (failure is CacheFailure) {
    return localizeMessage('Cache Failure');
  } else if (failure is ValidationFailure) {
    return localizeMessage(failure.message);
  } else if (failure is UnknownFailure) {
    return localizeMessage(failure.error);
  } else {
    return localizeMessage('Unknown Failure');
  }
}


String getFailureName(Failure failure, BuildContext context) {
  if (failure is ServerFailure) {
    final message = failure.name;
    if (failure.errors != null && failure.errors!.isNotEmpty) {
      return '$message\n${failure.errors!.join('\n')}';
    }
    return failure.name??'Unknown Error';
  } else if (failure is InvalidOtpFailure) {
    return failure.message;
  } else if (failure is UnauthorizedFailure) {
    return failure.message;
  } else if (failure is SocialLoginFailure) {
    if (failure.exception is FirebaseException &&
        (failure.exception as FirebaseException).message != null) {
      return (failure.exception as FirebaseException).message!;
    }
    return failure.exception.toString();
  } else if (failure is CacheFailure) {
    return 'Cache Failure';
  } else if (failure is ValidationFailure) {
    return failure.message;
  } else if (failure is UnknownFailure) {
    return failure.error;
  } else {
    return 'Unknown Failure';
  }
}

int getStatusCode(Failure failure, BuildContext context) {
  if (failure is ServerFailure) {
    final message = failure.statusCode;

    return message ?? 0;
  } else {
    return 200;
  }
}
