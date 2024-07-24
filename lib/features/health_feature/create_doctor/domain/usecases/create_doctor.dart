import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';

class CreateDoctorUseCase extends UseCase<bool, CreateDoctorParams> {
  final CreateDoctorRepo _createDoctorRepo;
  CreateDoctorUseCase(this._createDoctorRepo);
  @override
  Future<Either<Failure, bool>> call(CreateDoctorParams params) {
    return _createDoctorRepo.createDoctor(params);
  }
}

class CreateDoctorParams {
  String firstName;
  String lastName;
  String subCategoryId;
  String phone;
  String email;
  // Address address;
  // Clinic clinic;
  // Clinic calls;
  String mediaId;
  String clinicPrice;
  String waitingTime;
  String callsPrice;
  String description;
  String idFrontKey;
  String idBehindKey;
  String idExpiryDate;
  String practicingBehind;
  String practicingFront;
  String practicingExpiryDate;

  CreateDoctorParams({
    required this.firstName,
    required this.lastName,
    required this.subCategoryId,
    required this.phone,
    required this.email,
    // required this.address,
    // required this.clinic,
    // required this.calls,
    required this.mediaId,
    required this.clinicPrice,
    required this.waitingTime,
    required this.callsPrice,
    required this.description,
    required this.idFrontKey,
    required this.idBehindKey,
    required this.idExpiryDate,
    required this.practicingBehind,
    required this.practicingFront,
    required this.practicingExpiryDate,
  });

  toJson() {}
}
