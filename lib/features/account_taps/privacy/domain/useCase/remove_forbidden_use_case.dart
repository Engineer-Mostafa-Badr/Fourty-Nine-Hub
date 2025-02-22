import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/remove_allowed_use_case.dart';

import '../entities/remove_response_allowed_entity.dart';
import '../entities/remove_response_forbidden_entity.dart';
import '../entities/update_personal_privacy_entity.dart';

class RemoveForbiddenUseCase extends UseCase<RemoveForbiddenDataEntity, RemoveAllowedParams> {
  final PrivacyRepository _privacyRepository;

  RemoveForbiddenUseCase(this._privacyRepository);

  @override
  Future<Either<Failure, RemoveForbiddenDataEntity>> call(RemoveAllowedParams params) async {
    return await _privacyRepository.removeForbidden(params);
  }
}

