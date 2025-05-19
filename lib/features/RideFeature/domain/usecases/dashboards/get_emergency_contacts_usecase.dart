import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';

class GetEmergencyContactsUseCase extends UseCase<List<EmergencyContactEntity>, NoParams> {
  final TripRepository repository;

  GetEmergencyContactsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EmergencyContactEntity>>> call(params) async {
    return await repository.getEmergencyContacts();
  }
}
