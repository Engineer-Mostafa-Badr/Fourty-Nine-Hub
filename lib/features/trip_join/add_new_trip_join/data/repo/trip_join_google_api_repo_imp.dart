import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../remote_data_source/fetch_location_remote_datasource.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repo/trip_join_google_api_repo.dart';

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
