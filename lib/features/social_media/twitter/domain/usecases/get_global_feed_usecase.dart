import 'package:dartz/dartz.dart';
import '../../data/datasources/twitter_remote_datasource.dart';
import '../../presentation/bloc/twitter_bloc.dart';
import '../entities/twitter_post_entity.dart';
import 'get_feed_usecase.dart';

import '../../../../../core/error/failure.dart';

class GetTwitterGlobalFeedUseCase {
  final TwitterRemoteDataSource repo;
  GetTwitterGlobalFeedUseCase(this.repo);

  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> call(
      TwitterFeedParams params) {
    return repo.getGlobalFeed(params: params);
  }
}
