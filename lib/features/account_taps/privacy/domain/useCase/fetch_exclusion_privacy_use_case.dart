import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/communication_privacy_entity.dart';
import '../entities/exclusion_entity.dart';
import '../entities/personal_privacy_entity.dart';

class FetchExclusionPrivacyUseCase extends UseCase<ExclusionEntity  , ExclusionParams> {
  final PrivacyRepository _privacyRepository;

  FetchExclusionPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, ExclusionEntity >> call(ExclusionParams params) async {
    return await _privacyRepository.fetchDataExclusionPrivacy(params: params);
  }
}

class ExclusionParams{
  final String feature;

  ExclusionParams({required this.feature});
}