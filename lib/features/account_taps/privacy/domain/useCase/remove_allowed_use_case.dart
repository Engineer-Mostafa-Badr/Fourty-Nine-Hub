import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/remove_response_allowed_entity.dart';
import '../entities/update_personal_privacy_entity.dart';

class RemoveAllowedUseCase extends UseCase<RemoveDataEntity, RemoveAllowedParams> {
  final PrivacyRepository _privacyRepository;

  RemoveAllowedUseCase(this._privacyRepository);

  @override
  Future<Either<Failure, RemoveDataEntity>> call(RemoveAllowedParams params) async {
    return await _privacyRepository.removeAllowed(params);
  }
}

class RemoveAllowedParams {
  final String feature;
  final List<String> targetUserIds;

  RemoveAllowedParams({
    required this.feature,
    required this.targetUserIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "privacySettings": {
        "feature": feature,
        "targetUserIds": targetUserIds,
      },
    };
  }
}
