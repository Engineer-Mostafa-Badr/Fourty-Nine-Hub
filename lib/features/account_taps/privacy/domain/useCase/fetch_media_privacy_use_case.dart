import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/media_privacy_entity.dart';
import '../entities/personal_privacy_entity.dart';

class FetchMediaPrivacyUseCase extends UseCase<MediaPrivacyEntity , NoParams> {
  final PrivacyRepository _privacyRepository;

  FetchMediaPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, MediaPrivacyEntity >> call(NoParams params) async {
    return await _privacyRepository.fetchDataMediaPrivacy();
  }
}
