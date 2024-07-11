import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/activity_entity.dart';
import '../entities/feeling_entity.dart';

abstract class CreatePostRepo {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList();
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList();
  Future<Either<Failure, bool>> postData({
    required Map<String,dynamic> data 
  });
}
