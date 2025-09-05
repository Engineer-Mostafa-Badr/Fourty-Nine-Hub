import 'package:dartz/dartz.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../domain/use_case/comment_use_cases.dart';
import '../model/banner_talent_model.dart';
import '../model/comment_model.dart';
import '../model/star_model.dart';
import '../model/star_winner_model.dart';
import '../model/tube_video_models.dart'; // New import
import '../../domain/entity/banner_talent_entity.dart';
import '../../domain/entity/star_entity.dart';
import '../../domain/entity/star_winner_entity.dart';
import '../../domain/use_case/fetch_all_star_use_case.dart';
import '../../domain/use_case/upload_my_star_use_case.dart';

abstract class StarRemoteDataSource {
  // Existing methods
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params);
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params);
  Future<Either<Failure, List<StarEntity>>> fetchMyStar();
  Future<Either<Failure, bool>> uploadMyStar(StarParams params);
  Future<Either<Failure, bool>> deleteMyStar({required String id});
  Future<Either<Failure, BannerTalentEntity>> fetchBanner();

  // New Tube Video methods
  Future<Either<Failure, TubeVideoListResponse>> fetchAllTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, TubeVideoListResponse>> fetchMyTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, StarEntity>> fetchTubeVideoDetails(String videoId);
  Future<Either<Failure, bool>> likeTubeVideo(String videoId);
  Future<Either<Failure, bool>> dislikeTubeVideo(String videoId);
  Future<Either<Failure, bool>> incrementTubeVideoView(String videoId);
  Future<Either<Failure, bool>> deleteTubeVideo(String videoId);

  // New Comment methods
  Future<Either<Failure, String>> createComment(CreateCommentParams params);
  Future<Either<Failure, CommentsListResponse>> getVideoComments(GetCommentsParams params);
  Future<Either<Failure, String>> updateComment(UpdateCommentParams params);
  Future<Either<Failure, String>> deleteComment(String commentId);
  Future<Either<Failure, String>> likeComment(String commentId);
  Future<Either<Failure, String>> dislikeComment(String commentId);
}

class StarRemoteDataSourceImpl extends StarRemoteDataSource {
  final ApiConsumer _apiConsumer;

  StarRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.allStar(params),
    );
    return response.fold(
      (failure) {
        print(failure);
        return Left(failure);
      },
      (response) {
        print("Get All Talents ${response['data']['talents']}");
        return Right((response['data']['talents'] as List)
            .map((e) => StarModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, List<StarEntity>>> fetchMyStar() async {
    final response = await _apiConsumer.get(EndPoints.myStar);

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['data']['talents'] as List)
            .map((e) => StarModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, bool>> uploadMyStar(StarParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.uploadStar,
      data: params.toJson(),
      queryParameters: {
        // "subCategory": "6723913b74f292b91ad2de54",
        // "subCategory": "6723913b74f292b91ad2de54",
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['status']));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteMyStar({required String id}) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteMyStar(id: id),
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['status']));
      },
    );
  }

  @override
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.winnerStar(params),
      queryParameters: {
        // "subCategory": "",
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['data'] as List)
            .map((e) => StarWinnerModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, BannerTalentEntity>> fetchBanner() async {
    final response = await _apiConsumer.get(
      EndPoints.bannerTalent,
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((BannerTalentModel.fromJson(response['data'])));
      },
    );
  }

  // NEW TUBE VIDEO IMPLEMENTATIONS
  @override
  Future<Either<Failure, TubeVideoListResponse>> fetchAllTubeVideos(
      StarPaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getAllTubeVideosWithPagination(
        page: params.page,
        limit: params.limit,
      ),
    );

    return response.fold(
      (failure) {
        print("Fetch All Tube Videos Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Get All Tube Videos Success: ${response['data']['videos']}");
        try {
          final tubeResponse = TubeVideoListResponse.fromJson(response);
          return Right(tubeResponse);
        } catch (e) {
          print("Parse Tube Videos Error: $e");
          return Left(ServerFailure(
            message: 'Failed to parse video data',
            name: 'Parse Error',
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, TubeVideoListResponse>> fetchMyTubeVideos(
      StarPaginationParams params) async {
    // Debug: Print the endpoint being called
    final endpoint = EndPoints.getMyTubeVideosWithPagination(
      page: params.page,
      limit: params.limit,
    );
    print("🔍 My Tube Videos Endpoint: $endpoint");

    final response = await _apiConsumer.get(endpoint);

    return response.fold(
      (failure) {
        print("❌ Fetch My Tube Videos Error: $failure");
        return Left(failure);
      },
      (response) {
        print("✅ Get My Tube Videos Success: ${response['data']}");
        try {
          // Debug: Print the raw response structure
          print("🔍 Raw Response Keys: ${response.keys.toList()}");
          print("🔍 Data Keys: ${response['data']?.keys?.toList()}");
          print("🔍 Videos Count: ${response['data']?['videos']?.length}");

          final tubeResponse = TubeVideoListResponse.fromJson(response);
          print("🔍 Parsed Videos Count: ${tubeResponse.videos.length}");
          return Right(tubeResponse);
        } catch (e, stackTrace) {
          print("❌ Parse My Tube Videos Error: $e");
          print("❌ Stack Trace: $stackTrace");
          return Left(ServerFailure(
            message: 'Failed to parse video data: $e',
            name: 'Parse Error',
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, StarEntity>> fetchTubeVideoDetails(
      String videoId) async {
    final response = await _apiConsumer.get(
      EndPoints.getTubeVideoDetails(videoId),
    );

    return response.fold(
      (failure) {
        print("Fetch Tube Video Details Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Get Tube Video Details Success: ${response['data']}");
        try {
          final video = TubeVideoModel.fromJson(response['data']);
          return Right(video);
        } catch (e) {
          print("Parse Tube Video Details Error: $e");
          return Left(ServerFailure(
            message: 'Failed to parse video details',
            name: 'Parse Error',
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> likeTubeVideo(String videoId) async {
    final response = await _apiConsumer.post(
      EndPoints.likeTubeVideo(videoId),
    );

    return response.fold(
      (failure) {
        print("Like Tube Video Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Like Tube Video Success: ${response['message']}");
        return Right(response['status'] == true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> dislikeTubeVideo(String videoId) async {
    final response = await _apiConsumer.post(
      EndPoints.dislikeTubeVideo(videoId),
    );

    return response.fold(
      (failure) {
        print("Dislike Tube Video Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Dislike Tube Video Success: ${response['message']}");
        return Right(response['status'] == true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> incrementTubeVideoView(String videoId) async {
    final response = await _apiConsumer.post(
      EndPoints.incrementTubeVideoView(videoId),
    );

    return response.fold(
      (failure) {
        print("Increment Tube Video View Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Increment Tube Video View Success: ${response['message']}");
        return Right(response['status'] == true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteTubeVideo(String videoId) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteTubeVideo(videoId),
    );

    return response.fold(
      (failure) {
        print("Delete Tube Video Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Delete Tube Video Success: ${response['message']}");
        return Right(response['status'] == true);
      },
    );
  }
  // NEW COMMENT IMPLEMENTATIONS
  @override
  Future<Either<Failure, String>> createComment(CreateCommentParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.createTubeComment,
      data: params.toJson(),
    );

    return response.fold(
      (failure) {
        print("Create Comment Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Create Comment Success: ${response['data']}");
        return Right(response['data'] ?? 'Comment created successfully');
      },
    );
  }

  @override
  Future<Either<Failure, CommentsListResponse>> getVideoComments(GetCommentsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getTubeVideoComments(
        params.videoId,
        page: params.page,
        limit: params.limit,
      ),
    );

    return response.fold(
      (failure) {
        print("Get Video Comments Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Get Video Comments Success: ${response['data']}");
        try {
          final commentsResponse = CommentsListResponse.fromJson(response);
          return Right(commentsResponse);
        } catch (e) {
          print("Parse Comments Error: $e");
          return Left(ServerFailure(
            message: 'Failed to parse comments data',
            name: 'Parse Error',
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, String>> updateComment(UpdateCommentParams params) async {
    final response = await _apiConsumer.put(
      EndPoints.updateTubeComment(params.commentId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) {
        print("Update Comment Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Update Comment Success: ${response['message']}");
        return Right(response['message'] ?? 'Comment updated successfully');
      },
    );
  }

  @override
  Future<Either<Failure, String>> deleteComment(String commentId) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteTubeComment(commentId),
    );

    return response.fold(
      (failure) {
        print("Delete Comment Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Delete Comment Success: ${response['message']}");
        return Right(response['message'] ?? 'Comment deleted successfully');
      },
    );
  }

  @override
  Future<Either<Failure, String>> likeComment(String commentId) async {
    final response = await _apiConsumer.post(
      EndPoints.likeTubeComment(commentId),
    );

    return response.fold(
      (failure) {
        print("Like Comment Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Like Comment Success: ${response['message']}");
        return Right(response['message'] ?? 'Comment liked successfully');
      },
    );
  }

  @override
  Future<Either<Failure, String>> dislikeComment(String commentId) async {
    final response = await _apiConsumer.post(
      EndPoints.dislikeTubeComment(commentId),
    );

    return response.fold(
      (failure) {
        print("Dislike Comment Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Dislike Comment Success: ${response['message']}");
        return Right(response['message'] ?? 'Comment disliked successfully');
      },
    );
  }
}
