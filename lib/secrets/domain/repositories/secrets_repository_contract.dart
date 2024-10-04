import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../core/error/failure.dart';
import '../entities/secrets.dart';

abstract class SecretsRepository {
  Future<Either<Failure, Secrets>> getSecrets(NoParams noParams);
}
