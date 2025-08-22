
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/client_not_shown_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/drop_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/pick_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/join_to_route_use_case.dart';

abstract class CaptainShareRepository {
  Future<Either<Failure, CreatePricePerSeatEntity>> createPricePerSeat(CreatePricePerSeatParams params);
  Future<Either<Failure, bool>> createRoute(CreatePricePerSeatParams params);
  Future<Either<Failure, List<MyBookingEntity>>> getMyBooking(PaginationParams params);
  Future<Either<Failure, List<MyBookingEntity>>> getAvailableBooking(PaginationParams params);
  Future<Either<Failure, List<MyBookingEntity>>> getDriverAvailableBooking(PaginationParams params);
  Future<Either<Failure, List<MyBookingEntity>>> getDriverPastBooking(PaginationParams params);
  Future<Either<Failure, MyBookingEntity>> getDriverRunningRoute();
  Future<Either<Failure, MyBookingEntity>> getRouteDetails(String params);
  Future<Either<Failure, RunningRouteEntity>> getRunningRoute();
  Future<Either<Failure, List<MyBookingEntity>>> getExpiredBooking(PaginationParams params);
  Future<Either<Failure, List<MyBookingEntity>>> getRunningBooking(PaginationParams params);
  Future<Either<Failure, bool>> cancelMyBooking(String id);
  Future<Either<Failure, bool>> acceptRoute(String id);
  Future<Either<Failure, bool>> completeRoute(String id);
  Future<Either<Failure, String>> pickClient(PickClientParams params);
  Future<Either<Failure, bool>> dropClient(DropClientParams params);
  Future<Either<Failure, String>> clientNotShown(ClientNotShownParams params);
  Future<Either<Failure, String>> arrivedToClient(ClientNotShownParams params);
  Future<Either<Failure, MyBookingEntity>> joinToRoute(JoinToRouteParams params);
 }