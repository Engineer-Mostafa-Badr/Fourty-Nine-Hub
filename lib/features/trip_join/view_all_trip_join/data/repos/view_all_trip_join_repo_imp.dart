import "package:dartz/dartz.dart";
import "package:fourtyninehub/common/models/public/pagination_params.dart";
import "package:fourtyninehub/core/error/failure.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/data/datasource/remote_datasource/view_all_trip_join_remote_datasource.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart";

class ViewAllTripJoinRepoImp implements ViewAllTripJoinRepo {
  final ViewAllTripJoinRemoteDataSource viewripJoinRemoteDataSource;

  ViewAllTripJoinRepoImp({required this.viewripJoinRemoteDataSource});
  @override
  Future<Either<Failure, List<TripJoinCardEntity>>> getAllTripJion(
      {required String subCategory, required PaginationParams paginationParams}) {
    return viewripJoinRemoteDataSource.fetchAllTripJoin(
      subCategory: subCategory,
      paginationParams: paginationParams,
    );
  }
}
