// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_google_api_repo.dart';

class FetchLocationCordinatesUseCase {
  final TripJoinGoogleApiRepo tripJoinGoogleApiRepo;

  FetchLocationCordinatesUseCase({
    required this.tripJoinGoogleApiRepo,
  });

  Future<Either<Failure, LocationEntity>> call(
      {required String address}) async {
    return await tripJoinGoogleApiRepo.fetchLocationCordinations(
        address: address);
  }
}
