import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';

class EditEmergencyContactsUseCase extends UseCase<EmergencyContactEntity, EmergencyContactEntity> {
  final TripRepository repository;

  EditEmergencyContactsUseCase(this.repository);

  @override
  Future<Either<Failure, EmergencyContactEntity>> call(params) async {
    return await repository.editEmergencyContacts(params);
  }
}
