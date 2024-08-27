// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_repo.dart';

class FetchLocationCordinatesUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchLocationCordinatesUseCase({
    required this.tripJoinRepo,
  });

  Future<Either<Failure, LocationEntity>> call(
      {required String address}) async {
    return await tripJoinRepo.fetchLocationCordinations(address: address);
  }
}
