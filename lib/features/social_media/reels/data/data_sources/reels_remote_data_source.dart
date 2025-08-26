import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/add_comments_model.dart';
import '../models/audio_reels_model.dart';
import '../models/get_comments_model.dart';
import '../models/like_model.dart';
import '../models/new_reels_model.dart';
import '../models/save_reel_model.dart';
import '../models/share_reel_model.dart';
import '../../domain/use_case/add_reel_comment_use_case.dart';
import '../../domain/use_case/add_reel_reply_use_case.dart';
import '../../domain/use_case/create_advertisement_use_case.dart';
import '../../domain/use_case/create_reel_use_case.dart';
import '../../domain/use_case/reels_with_same_audia_use_case.dart';
import '../../domain/use_case/upload_reel_use_case.dart';
import '../../domain/use_case/upload_video_reel_use_case.dart';

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, ReelsResponse>> getExploreReels(
      PaginationParams params);
  Future<Either<Failure, ReelsResponse>> getGlobalReels(
      PaginationParams params);

  Future<Either<Failure, ReelsResponse>> getFollowingReels(int page);

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
  Future<Either<Failure, bool>> uploadReel(UploadReelParams params);
  Future<Either<Failure, bool>> uploadVideoReel(UploadVideoReelParams params);
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ReelsRemoteDataSourceImpl(this._apiConsumer);

  @override

  /// Use this instead of the real API to get a mocked HLS response.
  Future<Either<Failure, ReelsResponse>> getExploreReels(
    PaginationParams params,
  ) async {
    final urls = <String>[
      "https://vz-134bf9bf-f83.b-cdn.net/c7a273fd-264e-447b-a3a0-257bbed9fcab/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/8ae93b98-5c0a-4a44-945e-55ca05ab6567/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/9dee7645-b735-442c-88c3-7b2221786900/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/df6e766f-cee7-4156-98e6-fe942380af33/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/d23511b9-426b-4abd-b746-3400baf46c91/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/1583fae3-3335-4f7d-8fbb-02271cac5438/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/18fbb414-83a9-42fb-9b74-072507e17ff3/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/6c5be629-f4e4-4b47-a319-95fa54213dee/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/6bfa174a-3a0b-4a8e-a5f1-4fa7ecb3ba76/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/5b20bdcf-50aa-4cb7-bb1d-493f32ddfd5d/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/9b97cd2a-1ce1-488d-8778-76d855124722/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/615006b2-630a-42f1-afe2-70ea175889bd/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/58aa8092-18ae-428c-b87f-69796a68fc9f/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/96d15566-9992-4b46-97f1-e168181ac97e/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/47e62315-80c3-47b7-8c76-2fa65f4107c8/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/3d827556-2636-44ba-856f-952e0aa4528f/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/756ed4eb-fe32-4c09-b756-3b3a69f40616/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/8ee40536-ec35-4b47-860c-43b6a547ad27/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/73b56938-314f-4670-a7ef-1c2ee2183f85/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/9ca43f59-bc29-4e08-b0ee-ab81f00ead1b/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/6333fe2c-1651-4560-b13e-bb14ff693d1e/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/78beafe0-9cd0-46de-b7bf-a955c161b405/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/591b59fb-4d0f-4a5f-8372-639d7aa4c31d/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/c4f5754e-f530-4e5a-82c9-fd911cfe5580/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/990ee83e-5445-4ae0-a127-076c2b8eb685/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/71d47819-5e01-4889-9295-95136d323a28/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/93fcc6dc-2253-45ec-8ca8-bf18e081f283/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/a55b07f7-d2f9-41c0-ab2c-0708494812ef/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/872cd793-f7d9-4238-87bf-30afb3f935dd/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/d4ff5971-bfad-4a1d-a39b-bb64f8f60928/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/74ff4b3b-6351-4bcc-a8b8-afe2bb9b38b2/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/75fe6bb5-5fac-4317-960c-2a481f050078/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/6dc67514-7132-4f30-91c0-e42630b8e14c/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/44ea96c2-1c80-4c80-b0be-a7d659fab3f4/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/416cdd5b-93e2-4ac3-a790-fa76cc3271ce/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/bcc46f0c-f9f2-4584-9dc0-ac8a2ba7108f/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/3dce9fcb-2a0b-46c9-bc21-4e4d9435587f/playlist.m3u8",
      "https://vz-134bf9bf-f83.b-cdn.net/0fc10c28-92b1-476c-b01f-f07423e2b297/playlist.m3u8",
    ];

    // Simple pagination on the mocked list
    final page = params.page;
    final pageSize = params.limit;
    final start = (page - 1) * pageSize;
    final end = min(start + pageSize, urls.length);
    final pageUrls =
        (start < urls.length) ? urls.sublist(start, end) : <String>[];

    final reels = _buildMockReels(pageUrls);

    final json = {
      "status": true,
      "message": "success",
      "data": {
        "reels": reels,
        "pagination": {
          "countItem": urls.length,
          "pageCount": (urls.length / pageSize).ceil(),
          "currentPage": page,
        }
      }
    };

    return Right(ReelsResponse.fromJson(json));
  }

  /// Builds a list of reel maps matching your API shape, swapping videoMedia with HLS.
  List<Map<String, dynamic>> _buildMockReels(List<String> urls) {
    final now = DateTime.now().toUtc();
    final rnd = Random(42);

    return List.generate(urls.length, (i) {
      final createdAt = now.subtract(Duration(minutes: 2 * i));
      final id = _hex24(i); // 24-char hex (Mongo-like), but any string is fine.

      return {
        "_id": id,
        "videoMedia": urls[i], // <-- HLS URL here
        "images": [],
        "audioMedia":
            "https://d3j5umpuujp1ej.cloudfront.net/services/technology/reels-output/be6b9cff-a7e1-421d-9e5e-6cb40cb8eb42/be6b9cff-a7e1-421d-9e5e-6cb40cb8eb42.mp3",
        "likeCount": 0,
        "commentCount": 0,
        "shareCount": 0,
        "saveCount": 0,
        "viewCount": 0,
        "isLiked": false,
        "isSaved": false,
        "user": {
          "_id": _hex24(1000 + i),
          "firstName": "Mock",
          "lastName": "User$i",
          "isFriend": false,
          "privacy": "public",
          "story": false,
          "verified": false,
          "profilePictureSignedUrl":
              "https://d3j5umpuujp1ej.cloudfront.net/ride/captain/66b76065ab3b6f5a3d2273ed/c37b5bb9-1a2b-4bc3-bc3d-eb194e9e039f.png",
          "coverPictureSignedUrl": "",
          "bio": "",
          "birthday": "",
          "country": "",
          "countryPrivacy": "public",
          "job": "",
          "jobPrivacy": "public",
          "city": "",
          "cityPrivacy": "public",
          "gender": (i % 2 == 0) ? "male" : "female",
          "phone": "",
          "phonePrivacy": "public",
          "isLoading": false,
          "isRider": false,
          "isDoctor": false,
          "isRestaurant": false,
          "isFollowed": false,
          "areFriends": false,
          "isSenTRequest": false
        },
        "audio": {
          "_id": _hex24(2000 + i),
          "reelsCount": rnd.nextInt(20),
          "audioSignedUrl":
              "https://d3j5umpuujp1ej.cloudfront.net/services/technology/reels-output/be6b9cff-a7e1-421d-9e5e-6cb40cb8eb42/be6b9cff-a7e1-421d-9e5e-6cb40cb8eb42.mp3",
          "audioPicture":
              "https://d3j5umpuujp1ej.cloudfront.net/ride/captain/66b76065ab3b6f5a3d2273ed/c37b5bb9-1a2b-4bc3-bc3d-eb194e9e039f.png",
          "audioName": "be6b9cff-a7e1-421d-9e5e-6cb40cb8eb42",
          "username": "mock user"
        },
        "repost": [],
        "thumbnailSignedUrl":
            "https://d3j5umpuujp1ej.cloudfront.net/app/story/027d3cb3-4371-497d-ada3-6cc6930fa6d6.webp",
        "createdAt": createdAt.toIso8601String(),
      };
    });
  }

  /// Generates a 24-char hex string (not a real ObjectId, just looks like one).
  String _hex24(int seed) {
    final s = seed.toRadixString(16).padLeft(24, '0');
    return s.substring(s.length - 24);
  }
  // Future<Either<Failure, ReelsResponse>> getExploreReels(
  //     PaginationParams params) async {
  //   final response = await _apiConsumer.get(
  //     EndPoints.getExploreReels,
  //     queryParameters: params.toJson(),
  //   );
  //   return response.fold(
  //     (failure) => Left(failure),
  //     (response) => Right(ReelsResponse.fromJson(response)),
  //   );
  // }

  @override
  Future<Either<Failure, ReelsResponse>> getGlobalReels(
      PaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getGlobalReels,
      queryParameters: params.toJson(),
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
  Future<Either<Failure, ReelsResponse>> getFollowingReels(int page) async {
    final response = await _apiConsumer.get(
      EndPoints.fetchReelsForFollowing,
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

  @override
  Future<Either<Failure, bool>> uploadReel(UploadReelParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.uploadReel, data: params.toJson());

    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> uploadVideoReel(
      UploadVideoReelParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.uploadReel, data: params.toMap());

    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });
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
