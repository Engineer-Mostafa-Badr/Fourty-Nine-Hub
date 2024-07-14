import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  final List<String>? errors;

  const ServerFailure({
    required this.message,
    this.errors,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class UnknownFailure extends Failure {
  const UnknownFailure();
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

  const SocialLoginFailure(
    this.exception,
  );
}

String getFailureMessage(Failure failure, BuildContext context) {
  if (failure is ServerFailure) {
    final message = failure.message;
    if (failure.errors != null && failure.errors!.isNotEmpty) {
      return '$message\n${failure.errors!.join('\n')}';
    }
    return failure.message;
  } else if (failure is InvalidOtpFailure) {
    return failure.message;
  } else if (failure is UnauthorizedFailure) {
    return 'Unauthorized';
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
    return 'Unknown Failure';
  } else {
    return 'Unknown Failure';
  }
}
