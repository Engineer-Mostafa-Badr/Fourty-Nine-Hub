import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/data_source/fetch_my_all_pick_me_remote_data_source.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/models/fetch_my_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/domain/repo/fetch_my_pick_me_repo.dart';

class FetchMyPickMeRepoImp implements FetchMyPickMeRepo {
  final FetchMyAllPickMeRemoteDataSource fetchMyAllPickMeRemoteDataSource;

  FetchMyPickMeRepoImp({required this.fetchMyAllPickMeRemoteDataSource});

  @override
  Future<Either<Failure, List<TripData>>> fetchMyPickMeTrips(
      {required int page}) async {
    return await fetchMyAllPickMeRemoteDataSource.fetchMyPickMeTrips(
        page: page);
  }
}
