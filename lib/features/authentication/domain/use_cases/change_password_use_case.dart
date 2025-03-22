import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase extends UseCase<UserTokensEntity, ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(ChangePasswordParams params) {
    return _repository.changePassword(params);
  }
}

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword
      };
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        currentPassword,
      ];
}
