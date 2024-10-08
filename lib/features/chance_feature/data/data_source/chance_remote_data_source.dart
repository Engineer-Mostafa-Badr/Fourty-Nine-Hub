import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/chance_model.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/chance_entity.dart';

abstract class ChanceRemoteDataSource {
  Future<Either<Failure, List<ChanceEntity>>> fetchChance();
}

class ChanceRemoteDataSourceImpl extends ChanceRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ChanceRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ChanceEntity>>> fetchChance() async {
    final response = await _apiConsumer.get(EndPoints.chance);

    return response.fold(
      (failure)=>Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => ChanceModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }
}
