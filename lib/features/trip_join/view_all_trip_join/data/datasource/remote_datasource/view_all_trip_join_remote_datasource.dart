// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/trip_join_card_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';

abstract class ViewAllTripJoinRemoteDataSource {
  Future<Either<Failure, List<TripJoinCardEntity>>> fetchAllTripJoin({
    required String subCategory,
    required PaginationParams paginationParams,
  });
  Future<Either<Failure, bool>> requestTripJoin({
    required String addId,
    required String mobile,
  });
}

class ViewAllTripJoinRemoteDataSourceImp implements ViewAllTripJoinRemoteDataSource {
  final ApiConsumer apiConsumer;

  ViewAllTripJoinRemoteDataSourceImp({required this.apiConsumer});
  @override
  Future<Either<Failure, List<TripJoinCardEntity>>> fetchAllTripJoin({
    required String subCategory,
    required PaginationParams paginationParams,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.getAllTripJoin,
      queryParameters: {
        'subCategory': subCategory,
        'page': paginationParams.page,
        'limit': paginationParams.limit,
      },
    );

    return response.fold(
      (failure) {
        // pr(failure);
        return Left(failure);
      },
      (data) {
        List rawData = data['data'];
        if (rawData.isEmpty) {
          // pr('No data found');
          return const Right([]);
        }
        List<TripJoinCardEntity> allCards =
            rawData.map<TripJoinCardEntity>((e) => TripJoinCardModel.fromJson(e)).toList();
        // pr(allCards, 'trip join remote datasource');
        return Right(allCards);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> requestTripJoin({
    required String addId,
    required String mobile,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.makeTripJoinRequest(addId),
      data: {
        'phone': mobile,
      },
    );

    return response.fold(
      (failure) {
        // pr(failure);
        return Left(failure);
      },
      (data) {
        // pr('request completed successfully');
        return const Right(true);
      },
    );
  }
}
