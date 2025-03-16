import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/only_with_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/only_with_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/update_personal_privacy_entity.dart';

class UpdateOnlyWithPrivacyUseCase extends UseCase<OnlyWithEntity , UpdateOnlyWithPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdateOnlyWithPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, OnlyWithEntity >> call(
      UpdateOnlyWithPrivacyParams params) async {
    return await _privacyRepository.updateOnlyWithPrivacy(params);
  }
}

class UpdateOnlyWithPrivacyParams {
  final String feature;
  final List<String> allowedUsers;

  UpdateOnlyWithPrivacyParams({
    required this.feature,
    required this.allowedUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'privacySettings': {
        'feature': feature,
        'allowedUsers': allowedUsers,
      },
    };
  }
}