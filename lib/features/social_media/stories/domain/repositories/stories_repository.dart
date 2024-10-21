import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/audio_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/share_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_reply_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/reels_with_same_audia_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/update_privacy_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class StoriesRepository {
  Future<Either<Failure, bool>> makeViews(String id);
  Future<Either<Failure, bool>> deleteStory(String id);
  Future<Either<Failure, bool>> muteUserStories(String id);
  Future<Either<Failure, ViewersResponse>> getStoryViewers(String id);
  Future<Either<Failure, ResponseModel>> getFollowers();
  Future<Either<Failure, MutedStoriesResponse>> getMutedStories(PaginationParams params);
  Future<Either<Failure, bool>> updatePrivacy(UpdateStoryPrivacyParams params);
}
