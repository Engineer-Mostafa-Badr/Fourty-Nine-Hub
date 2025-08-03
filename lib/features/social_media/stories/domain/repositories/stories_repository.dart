import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../data/models/followers_model.dart';
import '../../data/models/friends_stories_model.dart';
import '../../data/models/muted_stories_model.dart';
import '../../data/models/viewers_model.dart';
import '../use_case/update_privacy_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../use_case/create_story_use_case.dart';

abstract class StoriesRepository {
  Future<Either<Failure, bool>> makeViews(String id);
  Future<Either<Failure, bool>> createStory(CreateStoryParams params);
  Future<Either<Failure, bool>> deleteStory(String id);
  Future<Either<Failure, bool>> makeLike(String id);
  Future<Either<Failure, bool>> muteUserStories(String id);
  Future<Either<Failure, ViewersResponse>> getStoryViewers(String id);
  Future<Either<Failure, ResponseModel>> getFollowers();
  Future<Either<Failure, MutedStoriesResponse>> getMutedStories(
      PaginationParams params);
  Future<Either<Failure, StoriesResponse>> fetchStories(
      PaginationParams params);
  Future<Either<Failure, bool>> updatePrivacy(UpdateStoryPrivacyParams params);
}
