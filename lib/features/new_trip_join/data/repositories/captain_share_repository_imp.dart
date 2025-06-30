import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/join_to_route_use_case.dart';

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

  @override
  Future<Either<Failure, List<MyBookingEntity>>> getMyBooking(PaginationParams params) async {
    return await shippingRemoteDataSource.getMyBooking(params);
  }

  @override
  Future<Either<Failure, List<MyBookingEntity>>> getAvailableBooking(PaginationParams params) async {
    return await shippingRemoteDataSource.getAvailableBooking(params);
  }

  @override
  Future<Either<Failure, MyBookingEntity>> getRouteDetails(String params) async {
    return await shippingRemoteDataSource.getRouteDetails(params);
  }


  @override
  Future<Either<Failure, List<MyBookingEntity>>> getRunningBooking(PaginationParams params) async {
    return await shippingRemoteDataSource.getRunningBooking(params);
  }


  @override
  Future<Either<Failure, List<MyBookingEntity>>> getExpiredBooking(PaginationParams params) async {
    return await shippingRemoteDataSource.getExpiredBooking(params);
  }

  @override
  Future<Either<Failure, bool>> cancelMyBooking(String id) async {
    return await shippingRemoteDataSource.cancelMyBooking(id);

  }

  @override
  Future<Either<Failure, MyBookingEntity>> joinToRoute(JoinToRouteParams params) async{
    return await shippingRemoteDataSource.joinToRoute(params);
  }


}