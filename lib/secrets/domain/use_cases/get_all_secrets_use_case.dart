import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/secrets/domain/repositories/secrets_repository_contract.dart';

import '../entities/secrets.dart';

class GetAllSecretsUseCase extends UseCase<Secrets, NoParams>{
  final SecretsRepository _secretsRepository;

  GetAllSecretsUseCase(SecretsRepository secretsRepository) : _secretsRepository = secretsRepository;


  @override
  Future<Either<Failure, Secrets>> call(NoParams noParams) {
    return _secretsRepository.getSecrets(noParams);
  }
}