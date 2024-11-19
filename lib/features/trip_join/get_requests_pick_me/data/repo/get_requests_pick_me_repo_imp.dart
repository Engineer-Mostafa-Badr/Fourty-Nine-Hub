import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/data_source/get_requests_pick_me_remote_data_source.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/domain/repo/get_requests_pick_me_repo.dart';

class GetRequestsPickMeRepoImp implements GetRequestsPickMeRepo {
  final GetRequestsPickMeRemoteDataSource getRequestsPickMeRemoteDataSource;

  GetRequestsPickMeRepoImp({required this.getRequestsPickMeRemoteDataSource});
  @override
  Future<Either<Failure, List<TripDataWithRequests>>> getRequestsPickMe() {
    return getRequestsPickMeRemoteDataSource.getRequestPickMeTrips();
  }
}
