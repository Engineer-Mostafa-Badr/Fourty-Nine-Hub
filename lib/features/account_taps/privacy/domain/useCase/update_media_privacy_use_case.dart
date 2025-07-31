import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/update_personal_privacy_entity.dart';

class UpdateMediaPrivacyUseCase extends UseCase<UpdatePersonalPrivacyDataEntity , UpdateMediaPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdateMediaPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> call(
      UpdateMediaPrivacyParams params) async {
    return await _privacyRepository.updateDataMediaPrivacy(params);
  }
}
class UpdateMediaPrivacyParams {
  final String feature;
  final String newPrivacyOption;

  UpdateMediaPrivacyParams({
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
