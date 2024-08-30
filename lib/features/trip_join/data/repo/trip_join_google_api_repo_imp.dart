import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/data/remote_data_source/fetch_location_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_google_api_repo.dart';

class TripJoinGoogleApiRepoImp implements TripJoinGoogleApiRepo {
  final FetchLocationRemoteDataSource fetchLocationRemoteDataSource;

  TripJoinGoogleApiRepoImp({required this.fetchLocationRemoteDataSource});
  @override
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations(
      {required String address}) {
    return fetchLocationRemoteDataSource.fetchLocationCordinations(
        address: address);
  }
}
