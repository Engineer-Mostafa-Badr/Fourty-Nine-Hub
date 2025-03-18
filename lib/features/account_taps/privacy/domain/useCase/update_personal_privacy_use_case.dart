import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/update_personal_privacy_entity.dart';

class UpdatePersonalPrivacyUseCase extends UseCase<UpdatePersonalPrivacyDataEntity , UpdatePersonalPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdatePersonalPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> call(
      UpdatePersonalPrivacyParams params) async {
    return await _privacyRepository.updateDataPersonalPrivacy(params);
  }
}
class UpdatePersonalPrivacyParams {
  final String feature;
  final String newPrivacyOption;

  UpdatePersonalPrivacyParams({
    required this.feature,
    required this.newPrivacyOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'privacySettings': [
        {
          'feature': feature,
          'newPrivacyOption': _mapPrivacyValue(newPrivacyOption),
        },
      ],
    };
  }

  String _mapPrivacyValue(String value) {
    if (value == "except-from" || value == "only-with") {
      return "only-me";
    }
    return value;
  }
}
