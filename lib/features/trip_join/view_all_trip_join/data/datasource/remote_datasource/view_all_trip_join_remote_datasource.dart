// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/trip_join_card_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';

abstract class ViewAllTripJoinRemoteDataSource {
  Future<Either<Failure, List<TripJoinCardEntity>>> fetchAllTripJoin({
    required String subCategory,
    required PaginationParams paginationParams,
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
        // print(' ============= $failure');
        return Left(failure);
      },
      (data) {
        List rawData = data['data'];
        if (rawData.isEmpty) {
          // print(' ============= No data found');
          return const Right([]);
        }
        List<TripJoinCardEntity> allCards =
            rawData.map<TripJoinCardEntity>((e) => TripJoinCardModel.fromJson(e)).toList();
        // print(' ============= ${allCards[0].startingAddressAr}');
        return Right(allCards);
      },
    );
  }
}
