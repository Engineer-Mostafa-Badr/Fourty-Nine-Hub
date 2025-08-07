import 'package:dartz/dartz.dart';
import '../../../core/abstract/use_case.dart';
import '../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../core/data/datasources/remote/api/end_points.dart';
import '../../domain/entities/secrets.dart';

import '../../../core/error/failure.dart';
import '../models/secrets_model.dart';

abstract class SecretsDataSource {
  Future<Either<Failure, Secrets>> getSecrets(NoParams params);
}

class SecretsDataSourceImpl implements SecretsDataSource {
  final ApiConsumer _apiConsumer;

  SecretsDataSourceImpl(ApiConsumer apiConsumer) : _apiConsumer = apiConsumer;

  @override
  Future<Either<Failure, Secrets>> getSecrets(NoParams noParams) async {
    final result = await _apiConsumer.get(EndPoints.getSecrets);
    return result.fold((l) => Left(l), (r) {
      final Secrets secrets = SecretsModel.fromJson(r['data']);
      return Right(secrets);
    });
  }
}
