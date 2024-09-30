import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

class FetchPrivacyUseCase extends UseCase<PrivacyEntity,NoParams>{
 final PrivacyRepository _privacyRepository;

  FetchPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, PrivacyEntity>> call(NoParams params)async {
    return await _privacyRepository.fetchDataPrivacy();
  }

}