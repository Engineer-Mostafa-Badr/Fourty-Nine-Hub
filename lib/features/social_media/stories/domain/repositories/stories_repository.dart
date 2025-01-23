import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/update_privacy_use_case.dart';

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
