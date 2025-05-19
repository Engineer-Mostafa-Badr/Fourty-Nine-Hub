import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';
import 'get_available_ride_trips_use_case.dart';

class GetSupportDetailsUseCase
    extends UseCase<SupportDetailsEntity, GetSupportDetailsParams>{
  final TripRepository repository;

  GetSupportDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, SupportDetailsEntity>> call(params) async {
    return await repository.getSupportDetails(params);
  }
}

class GetSupportDetailsParams{
  final String tripId;
  final String tripType;
  final String userType;

  GetSupportDetailsParams({required this.tripId, required this.tripType, required this.userType});

  //toJson
  Map<String, dynamic> toJson() => {"tripId": tripId, "tripType": tripType, "userType": userType};
}