import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/models/fetch_my_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/domain/repo/fetch_my_pick_me_repo.dart';

class FetchMyPickMeUseCase {
  final FetchMyPickMeRepo fetchMyPickMeRepo;

  FetchMyPickMeUseCase({required this.fetchMyPickMeRepo});

  Future<Either<Failure, List<TripData>>> call({required int page}) async {
    return await fetchMyPickMeRepo.fetchMyPickMeTrips(page: page);
  }
}
