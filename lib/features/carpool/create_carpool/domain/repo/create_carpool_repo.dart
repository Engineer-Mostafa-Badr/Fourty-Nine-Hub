import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/models/create_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';

abstract class CreateCarpoolRepo {
  Future<Either<Failure, CreateCarPoolModel>> createCarpool(
      {required CreateCarpoolParam createCarpoolParam});
}
