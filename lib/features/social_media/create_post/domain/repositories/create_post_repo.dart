import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';

import '../../../../../core/error/failure.dart';
import '../entities/activity_entity.dart';
import '../entities/feeling_entity.dart';

abstract class CreatePostRepo {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList();
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList();
  Future<Either<Failure, bool>> postData({
    required Map<String,dynamic> data 
  });
  Future<Either<Failure, TwitterPostEntity>> createTwitterPost({required CreateTwitterPostParams params});

}
