// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/repo/trip_join_request_history_repo.dart';

class FetchMyTripJoinAdsUseCase {
  final TripJoinRequestHistoryRepo tripJoinRequestHistoryRepo;
  FetchMyTripJoinAdsUseCase({
    required this.tripJoinRequestHistoryRepo,
  });

  Future<Either<Failure, List<TripJoinMyRequestEntity>>> call(
      {required int page}) {
    return tripJoinRequestHistoryRepo.fetchMyTripJoinAds(page: page);
  }
}
