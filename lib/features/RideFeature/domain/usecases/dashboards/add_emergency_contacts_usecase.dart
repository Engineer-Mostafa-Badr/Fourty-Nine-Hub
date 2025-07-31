import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';

class AddEmergencyContactsUseCase extends UseCase<EmergencyContactEntity, EmergencyContactEntity> {
  final TripRepository repository;

  AddEmergencyContactsUseCase(this.repository);

  @override
  Future<Either<Failure, EmergencyContactEntity>> call(params) async {
    return await repository.addEmergencyContacts(params);
  }
}
