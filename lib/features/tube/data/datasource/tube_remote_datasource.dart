import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../models/get_all_tube_videos_model.dart';



abstract class TubeRemoteDataSource {
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params});

}

class TubeRemoteDataSourceImpl
    implements TubeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TubeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params})async {
    final url = "${EndPoints.getAllTubeVideos}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data']['videos'] as List)
            .map((e) => GetAllTubeVideosModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }




}
