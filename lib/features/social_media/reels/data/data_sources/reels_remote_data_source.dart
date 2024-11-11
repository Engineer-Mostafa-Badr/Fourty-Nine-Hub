import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
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

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, ReelsResponse>> getExploreReels(int page);

  Future<Either<Failure, ReelsResponse>> getFollowersReels(int page);

  Future<Either<Failure, ReelSaveResponse>> saveReel(String reelId);

  Future<Either<Failure, ReelShareResponse>> shareReel(String reelId);

  Future<Either<Failure, ReelLikeResponse>> likeReel(String reelId);

  Future<Either<Failure, AddCommentResponse>> addComment(
      AddReelCommentParams params);

  Future<Either<Failure, AddCommentResponse>> addReply(
      AddReelReplyParams params);

  Future<Either<Failure, GetCommentsResponse>> getComments(
      CommentParams params);

  Future<Either<Failure, String>> toggleCommentLike(String commentId);

  Future<Either<Failure, ReelsForAudioResponse>> getReelsWithSameAudio(
      ReelsWithSameAudioParams params);

  Future<Either<Failure, bool>> createReel(CreateReelParams params);

  Future<Either<Failure, bool>> createAdvertisement(
      CreateAdvertisementParams params);
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ReelsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ReelsResponse>> getExploreReels(int page) async {
    final response = await _apiConsumer.get(
      EndPoints.getExploreReels,
      queryParameters: {
        'page': page,
        'limit': EndPoints.pageSize,
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(ReelsResponse.fromJson(response)),
    );
  }

  @override
  Future<Either<Failure, bool>> createReel(CreateReelParams params) async {
    final response = await _apiConsumer.post(EndPoints.createReel(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      // final list = (data['data']['reels'] as List)
      //     .map((e) => PostModel.fromJson(e))
      //     .toList();
      // return Right(list);
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> createAdvertisement(
      CreateAdvertisementParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.createAdvertisement(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      // final list = (data['data']['reels'] as List)
      //     .map((e) => PostModel.fromJson(e))
      //     .toList();
      // return Right(list);
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, ReelsResponse>> getFollowersReels(int page) async {
    final response = await _apiConsumer.get(
      EndPoints.fetchReelsForFollowers,
      queryParameters: {
        'page': page,
        'limit': EndPoints.pageSize,
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ReelsResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, ReelSaveResponse>> saveReel(String reelId) async {
    final response = await _apiConsumer.post(
      EndPoints.saveReel(reelId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ReelSaveResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, ReelShareResponse>> shareReel(String reelId) async {
    final response = await _apiConsumer.post(
      EndPoints.shareReel(reelId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ReelShareResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, ReelLikeResponse>> likeReel(String reelId) async {
    final response = await _apiConsumer.post(
      EndPoints.likeReel(reelId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ReelLikeResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, AddCommentResponse>> addComment(
      AddReelCommentParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.addReelComment(params),
      data: params.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        AddCommentResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, AddCommentResponse>> addReply(
      AddReelReplyParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.addReelReply(params),
      data: params.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        AddCommentResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, GetCommentsResponse>> getComments(
      CommentParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getComments(params.reelId),
      queryParameters: params.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        GetCommentsResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, String>> toggleCommentLike(String commentId) async {
    final response = await _apiConsumer.post(
      EndPoints.toggleCommentLike(commentId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['message'],
      ),
    );
  }

  @override
  Future<Either<Failure, ReelsForAudioResponse>> getReelsWithSameAudio(
      ReelsWithSameAudioParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getReelsWithSameAudio(params),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ReelsForAudioResponse.fromJson(response),
      ),
    );
  }
}

class CommentParams extends Equatable {
  final String reelId;
  final PaginationParams pagingParams;

  const CommentParams({required this.reelId, required this.pagingParams});

  Map<String, dynamic> toJson() =>
      {'page': pagingParams.page, 'limit': pagingParams.limit};

  @override
  List<Object?> get props => [reelId, pagingParams];
}
