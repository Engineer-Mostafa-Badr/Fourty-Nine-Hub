import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/communication_privacy_entity.dart';

class FetchCommunicationPrivacyUseCase extends UseCase<CommunicationPrivacyEntity , NoParams> {
  final PrivacyRepository _privacyRepository;

  FetchCommunicationPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, CommunicationPrivacyEntity >> call(NoParams params) async {
    return await _privacyRepository.fetchDataCommunicationPrivacy();
  }
}
