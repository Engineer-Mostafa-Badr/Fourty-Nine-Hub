import 'package:dartz/dartz.dart';
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

import '../../../../../core/error/failure.dart';

abstract class ReelsRepository {
  Future<Either<Failure, ReelsResponse>> getExploreReels(int page);
  Future<Either<Failure, AddCommentResponse>> addComment(
      AddReelCommentParams params);
  Future<Either<Failure, GetCommentsResponse>> getComments(String reelId);
  Future<Either<Failure, String>> toggleCommentLike(String commentId);
  Future<Either<Failure, ReelsForAudioResponse>> getReelsWithSameAudio(
      ReelsWithSameAudioParams params);
  Future<Either<Failure, AddCommentResponse>> addReply(
      AddReelReplyParams params);
  Future<Either<Failure, ReelsResponse>> getFollowersReels(int page);
  Future<Either<Failure, ReelSaveResponse>> saveReel(String reelId);
  Future<Either<Failure, ReelShareResponse>> shareReel(String reelId);
  Future<Either<Failure, ReelLikeResponse>> likeReel(String reelId);
  // Future<Either<Failure, List<ReelEntity>>> fetchReels(int page);
  Future<Either<Failure, bool>> createReel(CreateReelParams params);
  Future<Either<Failure, bool>> createAdvertisement(
      CreateAdvertisementParams params);
}
