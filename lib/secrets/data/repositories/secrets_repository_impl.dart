import 'package:dartz/dartz.dart';
import '../../../core/abstract/use_case.dart';
import '../../../core/error/failure.dart';
import '../../domain/entities/secrets.dart';
import '../../domain/repositories/secrets_repository_contract.dart';

import '../data_source/secrets_data_source.dart';

class SecretRepositoryImpl implements SecretsRepository {
  final SecretsDataSource _secretsDataSource;

  SecretRepositoryImpl(SecretsDataSource secretsDataSource)
      : _secretsDataSource = secretsDataSource;

  @override
  Future<Either<Failure, Secrets>> getSecrets(NoParams noParams) =>
      _secretsDataSource.getSecrets(noParams);
}
