import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/connection_privacy_entity.dart';

class FetchConnectionPrivacyUseCase extends UseCase<ConnectionPrivacyEntity , NoParams> {
  final PrivacyRepository _privacyRepository;

  FetchConnectionPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, ConnectionPrivacyEntity >> call(NoParams params) async {
    return await _privacyRepository.fetchDataConnectionPrivacy();
  }
}
