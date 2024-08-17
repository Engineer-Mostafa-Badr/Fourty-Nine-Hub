import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';

abstract class InstagramRemoteDataSource {
  Future<Either<Failure, List<PostEntity>>> getFeed({required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getReels({required TwitterFeedParams params});

}

class InstagramRemoteDataSourceImpl implements InstagramRemoteDataSource {
  final ApiConsumer _apiConsumer;
  InstagramRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getInstagramPosts(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getReels({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['reels'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }


}
