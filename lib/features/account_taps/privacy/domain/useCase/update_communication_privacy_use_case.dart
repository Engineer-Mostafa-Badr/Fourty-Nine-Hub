import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/update_personal_privacy_entity.dart';

class UpdateCommunicationPrivacyUseCase extends UseCase<UpdatePersonalPrivacyDataEntity , UpdateCommunicationPrivacyParams> {
  final PrivacyRepository _privacyRepository;

  UpdateCommunicationPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> call(
      UpdateCommunicationPrivacyParams params) async {
    return await _privacyRepository.updateDataCommunicationPrivacy(params);
  }
}
class UpdateCommunicationPrivacyParams {
  final String feature;
  final String newPrivacyOption;

  UpdateCommunicationPrivacyParams({
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
