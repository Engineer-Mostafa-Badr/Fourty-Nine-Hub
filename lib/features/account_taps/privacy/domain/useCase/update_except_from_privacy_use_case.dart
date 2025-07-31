import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/except_from_entity.dart';

class UpdateExceptFromPrivacyUseCase extends UseCase<ExceptFromEntity , UpdateExceptFromPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdateExceptFromPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, ExceptFromEntity >> call(
      UpdateExceptFromPrivacyParams params) async {
    return await _privacyRepository.updateExceptFromPrivacy(params);
  }
}

class UpdateExceptFromPrivacyParams {
  final String feature;
  final List<String> allowedUsers;

  UpdateExceptFromPrivacyParams({
    required this.feature,
    required this.allowedUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'privacySettings': {
        'feature': feature,
        'forbiddenUsers': allowedUsers,
      },
    };
  }
}