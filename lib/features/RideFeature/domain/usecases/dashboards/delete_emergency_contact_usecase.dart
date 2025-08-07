import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';

class DeleteEmergencyContactUseCase extends UseCase<bool, EmergencyContactEntity> {
  final TripRepository repository;

  DeleteEmergencyContactUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteEmergencyContact(params);
  }
}
