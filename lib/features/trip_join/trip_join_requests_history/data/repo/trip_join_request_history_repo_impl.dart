// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/data/datasource/trip_join_request_history_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/repo/trip_join_request_history_repo.dart';

class TripJoinRequestHistoryRepoImp implements TripJoinRequestHistoryRepo {
  final TripJoinRequestHistoryRemoteDataSource tripJoinRequestHistoryRemoteDataSource;
  TripJoinRequestHistoryRepoImp({
    required this.tripJoinRequestHistoryRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds({required int page}) {
    return tripJoinRequestHistoryRemoteDataSource.fetchMyTripJoinAds(page: page);
  }
}
