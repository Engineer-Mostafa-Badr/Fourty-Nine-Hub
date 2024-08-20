import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/reel_model.dart';

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, List<ReelModel>>> getExploreReels(int page);
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ReelsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ReelModel>>> getExploreReels(int page) async {
    final response = await _apiConsumer.get(
      EndPoints.getExploreReels,
      queryParameters: {
        'page': page,
        'limit': EndPoints.pageSize,
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        (response['data']['reels'] as List)
            .map((e) => ReelModel.fromJson(e))
            .toList(),
      ),
    );
  }
}
