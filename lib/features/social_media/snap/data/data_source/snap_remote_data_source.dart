import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/snap/data/model/filter_model.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/entity/filter_entity.dart';

abstract class SnapRemoteDataSource {
  Future<Either<Failure, List<FilterEntity>>> fetchFilter();
}

class SnapRemoteDataSourceImpl extends SnapRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SnapRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<FilterEntity>>> fetchFilter() async {
    final response = await _apiConsumer.get(EndPoints.snap);

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => FilterModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }
}
