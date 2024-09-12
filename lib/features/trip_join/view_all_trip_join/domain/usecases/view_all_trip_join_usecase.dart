import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart';

class ViewAllTripJoinUseCase {
  final ViewAllTripJoinRepo viewAllTripJoinRepo;

  ViewAllTripJoinUseCase({required this.viewAllTripJoinRepo});
  Future<Either<Failure, List<TripJoinCardEntity>>> call({
    required String subCategory,
    required PaginationParams paginationParams,
  }) {
    return viewAllTripJoinRepo.getAllTripJion(
      subCategory: subCategory,
      paginationParams: paginationParams,
    );
  }
}
