import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_tokens_entity.dart';
import '../repositories/auth_repository.dart';
import 'login_use_case.dart';
import 'register_use_case.dart';

class ConvertGuestParams extends Equatable {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? token;
  final bool isNewAccount;

  const ConvertGuestParams({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.token,
    this.isNewAccount = false,
  });

  @override
  List<Object?> get props =>
      [email, password, firstName, lastName, token, isNewAccount];
}

class ConvertGuestToUserUseCase
    extends UseCase<UserTokensEntity, ConvertGuestParams> {
  final AuthRepository repository;

  ConvertGuestToUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(
      ConvertGuestParams params) async {
    if (params.isNewAccount) {
      // First register the user
      final registerResult = await repository.register(RegisterParams(
        userName: params.email.split('@')[0],
        firstName: params.firstName!,
        lastName: params.lastName!,
        email: params.email,
        password: params.password,
        confirmPassword: params.password,
        token: params.token ?? '',
        isMale: true,
      ));

      // Check if registration failed
      if (registerResult.isLeft()) {
        return registerResult.fold(
          (failure) => Left(failure),
          (_) => throw Exception('Unexpected state'), // This shouldn't happen
        );
      }

      // If registration succeeded, now login to get tokens
      final loginResult = await repository.login(LoginParams(
        email: params.email,
        password: params.password,
        token: params.token ?? '',
      ));

      return loginResult.fold(
        (failure) => Left(failure),
        (tokens) async {
          await repository.migrateGuestData();
          await repository.clearGuestState();
          return Right(tokens);
        },
      );
    } else {
      // Direct login for existing account
      final loginResult = await repository.login(LoginParams(
        email: params.email,
        password: params.password,
        token: params.token ?? '',
      ));

      return loginResult.fold(
        (failure) => Left(failure),
        (tokens) async {
          await repository.migrateGuestData();
          await repository.clearGuestState();
          return Right(tokens);
        },
      );
    }
  }
}
