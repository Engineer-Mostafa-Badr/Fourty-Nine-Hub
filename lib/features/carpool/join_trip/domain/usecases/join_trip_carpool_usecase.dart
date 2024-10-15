import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/repo/join_trip_carpool_repo.dart';

import '../../../../../core/error/failure.dart';

class JoinTripCarpoolUsecase {
  final JoinTripCarpoolRepo joinTripCarpoolRepo;

  JoinTripCarpoolUsecase({required this.joinTripCarpoolRepo});

  Future<Either<Failure, JoinTripCarpoolModel>> call({
    required JoinTripCarPoolParam joinTripCarPoolParam,
  }) {
    return joinTripCarpoolRepo.joinTripCarpool(
        joinTripCarPoolParam: joinTripCarPoolParam);
  }
}
