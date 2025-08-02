import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/update_personal_privacy_entity.dart';

class UpdateConnectionPrivacyUseCase extends UseCase<UpdatePersonalPrivacyDataEntity , UpdateConnectionPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdateConnectionPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> call(
      UpdateConnectionPrivacyParams params) async {
    return await _privacyRepository.updateDataConnectionPrivacy(params);
  }
}
class UpdateConnectionPrivacyParams {
  final String feature;
  final String newPrivacyOption;

  UpdateConnectionPrivacyParams({
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
