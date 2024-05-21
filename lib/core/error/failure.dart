import 'package:flutter/cupertino.dart';

abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure({required this.message});
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

class SocialLoginFailure extends Failure {
  const SocialLoginFailure();
}

String getFailureMessage(Failure failure, BuildContext context) {
  if (failure is ServerFailure) {
    return failure.message;
  } else if (failure is InvalidOtpFailure) {
    return failure.message;
  } else if (failure is UnauthorizedFailure) {
    return 'Unauthorized';
  } else if (failure is SocialLoginFailure) {
    return 'Social Error';
  } else if (failure is CacheFailure) {
    return 'Cache Failure';
  } else if (failure is UnknownFailure) {
    return 'Unknown Failure';
  } else {
    return 'Unknown Failure';
  }
}
