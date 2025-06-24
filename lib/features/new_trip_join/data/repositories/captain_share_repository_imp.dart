import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';

import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';

import '../../domain/repositories/captain_share_repository.dart';
import '../datasources/captain_share_remote_data_source.dart';

class CaptainShareRepositoryImplementation extends CaptainShareRepository {

  final CaptainShareRemoteDataSource shippingRemoteDataSource;

  CaptainShareRepositoryImplementation(this.shippingRemoteDataSource);

  @override
  Future<Either<Failure, CreatePricePerSeatEntity>> createPricePerSeat(CreatePricePerSeatParams params) async {
    return await shippingRemoteDataSource.createPricePerSeat(params);
  }

  @override
  Future<Either<Failure, bool>> createRoute(CreatePricePerSeatParams params) async {
    return await shippingRemoteDataSource.createRoute(params);
  }

  // @override
  // Future<Either<Failure, bool>> createLoadingTrip(CreateLoadingTripParams params) async {
  //   return await shippingRemoteDataSource.createLoadingTrip(params);
  //
  // }


}