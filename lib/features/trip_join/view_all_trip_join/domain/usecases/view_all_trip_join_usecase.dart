import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../entities/trip_join_card_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

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
