import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';

abstract class ViewAllTripJoinRepo {
  Future<Either<Failure, List<TripJoinCardEntity>>> getAllTripJion({
    required String subCategory,
    required PaginationParams paginationParams,
  });
  Future<Either<Failure, bool>> requestTripJoin({
    required String addId,
    required String mobile,
    bool premuimRequest = false,
  });
}
