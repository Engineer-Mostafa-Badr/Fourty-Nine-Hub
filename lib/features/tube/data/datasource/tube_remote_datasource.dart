import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/tube/data/models/get_active_category_model.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_active_category_entity.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/create_video_tube_use_case.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/add_favorite_tube_entity.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../../domain/usecases/add_favorite_tube_use_case.dart';
import '../../domain/usecases/create_comment_tube_video_use_case.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../../domain/usecases/get_related_tube_videos_use_case.dart';
import '../../domain/usecases/get_tube_video_comments_use_case.dart';
import '../../domain/usecases/rate_tube_video_use_case.dart';
import '../../domain/usecases/search_tube_use_case.dart';
import '../../domain/usecases/update_comment_tube_video_use_case.dart';
import '../../domain/usecases/update_tube_video_use_case.dart';
import '../models/add_favorite_tube_model.dart';
import '../models/get_all_tube_videos_model.dart';
import '../models/get_tube_video_commnets_model.dart';

abstract class TubeRemoteDataSource {
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos(
      {required GetAllTubeVideosParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos(
      {required GetAllTubeVideosParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube(
      {required FavoriteTubeParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo(
      {required SearchTubeParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getRelatedTubeVideos(
      {required GetRelatedTubeVideosParams params});
  Future<Either<Failure, TubeVideoCommentsEntity>> getTubeVideoComments(
      {required GetTubeCommentsParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> createCommentTube(
      {required CreateCommentTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> updateCommentTube(
      {required UpdateCommentTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeComment(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeComment(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeComment(
      {required FavoriteTubeParams params});

  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeVideo(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeVideo(
      {required FavoriteTubeParams params});

  Future<Either<Failure, ActiveCategoryResponseEntity>> getActiveCategories();
  Future<Either<Failure, AddFavoriteTubeEntity>> createVideoTube(
      {required CreateTubeVideoParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getMyTubeVideos(
      {required GetAllTubeVideosParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getHistoryTubeVideos(
      {required GetAllTubeVideosParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeVideo(
      {required FavoriteTubeParams params});

  Future<Either<Failure, AddFavoriteTubeEntity>> updateTubeVideo(
      {required UpdateTubeVideo params});
  Future<Either<Failure, AddFavoriteTubeEntity>> removeWatchLaterTube(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> addWatchLaterTube(
      {required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> rateTubeVideo(
      {required RateTubeVideoParams params});
}

class TubeRemoteDataSourceImpl implements TubeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TubeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos(
      {required GetAllTubeVideosParams params}) async {
    final url =
        "${EndPoints.getTubeHomeVideos}?page=${params.page}&limit=${params.limit}&userId=${params.userId}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos(
      {required GetAllTubeVideosParams params}) async {
    final url =
        "${EndPoints.getTubeFavorites}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addTubeFavorite}${params.id}";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addTubeFavorite}${params.id}";
    final response = await _apiConsumer.delete(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo(
      {required SearchTubeParams params}) async {
    final url =
        "${EndPoints.searchTubeVideo}?page=${params.page}&limit=${params.limit}&query=${params.searchQuery}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getRelatedTubeVideos(
      {required GetRelatedTubeVideosParams params}) async {
    final url =
        "${EndPoints.tubeRelatedVideos}${params.id}/?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, TubeVideoCommentsEntity>> getTubeVideoComments(
      {required GetTubeCommentsParams params}) async {
    final url =
        "${EndPoints.getTubeCommentVideo}${params.id}?page=${params.page}&limit=${params.limit}&userId=${params.userId}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        try {
          final model = TubeVideoCommentsModel.fromJson(data);
          return Right(model);
        } catch (e, st) {
          log("❌ Error parsing TubeVideoCommentsModel: $e");
          log(st.toString());
          return Left(ServerFailure(message: "Parsing error: $e"));
        }
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> createCommentTube(
      {required CreateCommentTubeParams params}) async {
    final url = EndPoints.addTubeComment;
    final response = await _apiConsumer.post(url, data: params.toJson());

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> updateCommentTube(
      {required UpdateCommentTubeParams params}) async {
    final url = "${EndPoints.addTubeComment}/edit/${params.commentId}";
    final response = await _apiConsumer.put(url, data: params.toJson());

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeComment(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addTubeComment}/${params.id}";
    final response = await _apiConsumer.delete(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeComment(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addTubeComment}/${params.id}/dislike";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeComment(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addTubeComment}/${params.id}/like";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeVideo(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addLikeTubeVideo}/${params.id}/dislike";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeVideo(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.addLikeTubeVideo}/${params.id}/like";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, ActiveCategoryResponseEntity>>
      getActiveCategories() async {
    final response = await _apiConsumer.get(EndPoints.getActiveCategories);

    return response.fold(
      (failure) {
        print("Get Active Categories Error: $failure");
        return Left(failure);
      },
      (response) {
        print("Get Active Categories Success: ${response['data']}");
        try {
          final activeCategoriesResponse =
              ActiveCategoryResponseModel.fromJson(response);
          return Right(activeCategoriesResponse);
        } catch (e) {
          print("Parse Active Categories Error: $e");
          return Left(ServerFailure(
            message: 'Failed to parse categories data: $e',
            name: 'Parse Error',
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> createVideoTube(
      {required CreateTubeVideoParams params}) async {
    final url = EndPoints.uploadVideoTube;
    final response = await _apiConsumer.post(url, data: params.toJson());

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getMyTubeVideos(
      {required GetAllTubeVideosParams params}) async {
    final url =
        "${EndPoints.getMyTubeVideo}?page=${params.page}&limit=${params.limit}&userId=${params.userId}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data']['videos'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getHistoryTubeVideos(
      {required GetAllTubeVideosParams params}) async {
    final url =
        "${EndPoints.getTubeHistory}?page=${params.page}&limit=${params.limit}&userId=${params.userId}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final rideList = (data['data'] as List)
            .map((e) =>
                GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeVideo(
      {required FavoriteTubeParams params}) async {
    final url = EndPoints.addLikeTubeVideo;
    final response = await _apiConsumer.delete(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> updateTubeVideo(
      {required UpdateTubeVideo params}) async {
    final url = "${EndPoints.addLikeTubeVideo}${params.videoId}";
    final response = await _apiConsumer.put(url, data: params.toJson());

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> addWatchLaterTube(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.tubeWatchLater}${params.id}";
    final response = await _apiConsumer.post(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> removeWatchLaterTube(
      {required FavoriteTubeParams params}) async {
    final url = "${EndPoints.tubeWatchLater}${params.id}";
    final response = await _apiConsumer.delete(
      url,
    );

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> rateTubeVideo(
      {required RateTubeVideoParams params}) async {
    final url = EndPoints.rateTubeVideo;
    final response = await _apiConsumer.post(url, data: params.toJson());

    return response.fold(
      (l) => Left(l),
      (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }
}
