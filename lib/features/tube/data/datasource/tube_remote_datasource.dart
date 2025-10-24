import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/add_favorite_tube_entity.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/usecases/add_favorite_tube_use_case.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../../domain/usecases/search_tube_use_case.dart';
import '../models/add_favorite_tube_model.dart';
import '../models/get_all_tube_videos_model.dart';



abstract class TubeRemoteDataSource {
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos({required GetAllTubeVideosParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube({required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube({required FavoriteTubeParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo({required SearchTubeParams params});

}

class TubeRemoteDataSourceImpl
    implements TubeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TubeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params})async {
    final url = "${EndPoints.getTubeHomeVideos}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos({required GetAllTubeVideosParams params})async {
    final url = "${EndPoints.getTubeFavorites}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube({required FavoriteTubeParams params}) async{
    final url = "${EndPoints.addTubeFavorite}${params.id}";
    final response = await _apiConsumer.post(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube({required FavoriteTubeParams params}) async{
    final url = "${EndPoints.addTubeFavorite}${params.id}";
    final response = await _apiConsumer.delete(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = AddFavoriteTubeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo({required SearchTubeParams params}) async{
    final url = "${EndPoints.searchTubeVideo}?page=${params.page}&limit=${params.limit}&query=${params.searchQuery}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }




}
