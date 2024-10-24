import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/data_source/join_trip_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/repo/join_trip_carpool_repo.dart';

class JoinTripCarpoolRepoImp extends JoinTripCarpoolRepo {
  final JoinTripRemoteDataSource joinTripRemoteDataSource;

  JoinTripCarpoolRepoImp({required this.joinTripRemoteDataSource});
  @override
  Future<Either<Failure, JoinTripCarpoolModel>> joinTripCarpool(
      {required JoinTripCarPoolParam joinTripCarPoolParam}) {
    return joinTripRemoteDataSource.joinTripCarpool(
      joinTripCarPoolParam: joinTripCarPoolParam,
    );
  }
}
