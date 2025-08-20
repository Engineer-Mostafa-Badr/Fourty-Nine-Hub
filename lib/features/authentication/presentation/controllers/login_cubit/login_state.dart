import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';

import '../../../domain/entities/user_tokens_entity.dart';

// auth_status.dart
enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

final class LoginError extends LoginState {
  final Failure failure;

  const LoginError(this.failure);
}

class LoginGuestSuccess extends LoginState {
  final UserEntity user;

  const LoginGuestSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

@immutable
sealed class LoginState {
  const LoginState();
}

final class LoginSuccess extends LoginState {
  final UserTokensEntity userTokensEntity;

  const LoginSuccess({required this.userTokensEntity});
}

// final class SocialAuthState extends LoginState {
//   final AuthStatus status;
//   final UserTokensEntity?
//       userTokensEntity; // This will be used to store the token if available

//   const SocialAuthState({
//     required this.status,
//     this.userTokensEntity,
//   });
// }

class SocialAuthState extends LoginState {
  final AuthStatus status;
  final UserTokensEntity? userTokensEntity;
  final Failure? error;

  const SocialAuthState({
    required this.status,
    this.userTokensEntity,
    this.error,
  });

  @override
  List<Object?> get props => [status, userTokensEntity, error];
}

// part of 'login_cubit.dart';
//
// @immutable
// sealed class LoginState {
//   const LoginState();
// }
//
// final class LoginInitial extends LoginState {}
//
// final class LoginLoading extends LoginState {}
//
// final class LoginError extends LoginState {
//   final Failure failure;
//
//   const LoginError(this.failure);
// }
//
// final class LoginSuccess extends LoginState {
//   final UserTokensEntity userTokensEntity;
//
//   const LoginSuccess({required this.userTokensEntity});
// }
