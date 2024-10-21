import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/data_sources/stories_data_source.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/repositories/stories_repository.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/update_privacy_use_case.dart';


class StoriesRepositoryImpl extends StoriesRepository {
  final StoriesRemoteDataSource _storiesRemoteDataSource;

  StoriesRepositoryImpl(this._storiesRemoteDataSource);

@override
Future<Either<Failure, bool>> makeViews(String id) {
  return _storiesRemoteDataSource.makeViews(id);
}

@override
Future<Either<Failure, bool>> deleteStory(String id) {
  return _storiesRemoteDataSource.deleteStory(id);
}

@override
Future<Either<Failure, bool>> muteUserStories(String id) {
  return _storiesRemoteDataSource.muteUserStories(id);
}

  @override
  Future<Either<Failure, MutedStoriesResponse>> getMutedStories(PaginationParams params) {
    return _storiesRemoteDataSource.getMutedStories(params);
  }

  @override
  Future<Either<Failure, ViewersResponse>> getStoryViewers(String id) {
    return _storiesRemoteDataSource.getStoryViewers(id);
  }
  @override
  Future<Either<Failure, ResponseModel>> getFollowers() {
    return _storiesRemoteDataSource.getFollowers();
  }

  @override
  Future<Either<Failure, bool>> updatePrivacy(UpdateStoryPrivacyParams params) {
    return _storiesRemoteDataSource.updatePrivacy(params);
  }

}