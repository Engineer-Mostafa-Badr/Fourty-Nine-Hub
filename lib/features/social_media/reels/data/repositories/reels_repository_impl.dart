import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/audio_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/share_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/repositories/reels_repository.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_reply_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/reels_with_same_audia_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../data_sources/reels_remote_data_source.dart';

class ReelsRepositoryImpl extends ReelsRepository {
  final ReelsRemoteDataSource _reelsRemoteDataSource;

  ReelsRepositoryImpl(this._reelsRemoteDataSource);

  @override
  Future<Either<Failure, ReelsResponse>> getExploreReels(int page) {
    return _reelsRemoteDataSource.getExploreReels(page);
  }

  @override
  Future<Either<Failure, bool>> createReel(CreateReelParams params) {
    return _reelsRemoteDataSource.createReel(params);
  }

  @override
  Future<Either<Failure, bool>> createAdvertisement(CreateAdvertisementParams params) {
    return _reelsRemoteDataSource.createAdvertisement(params);
  }

  @override
  Future<Either<Failure, ReelsResponse>> getFollowersReels(int page) {
    return _reelsRemoteDataSource.getFollowersReels(page);
  }

  @override
  Future<Either<Failure, ReelSaveResponse>> saveReel(String reelId) {
    return _reelsRemoteDataSource.saveReel(reelId);
  }
  @override
  Future<Either<Failure, ReelShareResponse>> shareReel(String reelId) {
    return _reelsRemoteDataSource.shareReel(reelId);
  }

  @override
  Future<Either<Failure, ReelLikeResponse>> likeReel(String reelId) {
    return _reelsRemoteDataSource.likeReel(reelId);
  }

  @override
  Future<Either<Failure, AddCommentResponse>> addComment(AddReelCommentParams params) {
    return _reelsRemoteDataSource.addComment(params);
  }

  @override
  Future<Either<Failure, AddCommentResponse>> addReply(AddReelReplyParams params) {
    return _reelsRemoteDataSource.addReply(params);
  }

  @override
  Future<Either<Failure, GetCommentsResponse>> getComments(String reelId) {
    return _reelsRemoteDataSource.getComments(reelId);
  }

  @override
  Future<Either<Failure, String>> toggleCommentLike(String commentId) {
    return _reelsRemoteDataSource.toggleCommentLike(commentId);
  }

  @override
  Future<Either<Failure, ReelsForAudioResponse>> getReelsWithSameAudio(ReelsWithSameAudioParams params) {
    return _reelsRemoteDataSource.getReelsWithSameAudio(params);
  }
}
