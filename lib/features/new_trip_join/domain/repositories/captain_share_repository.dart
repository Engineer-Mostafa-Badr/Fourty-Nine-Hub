
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';

abstract class CaptainShareRepository {
  Future<Either<Failure, CreatePricePerSeatEntity>> createPricePerSeat(CreatePricePerSeatParams params);
  Future<Either<Failure, bool>> createRoute(CreatePricePerSeatParams params);
 }