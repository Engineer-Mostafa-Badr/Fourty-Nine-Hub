import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
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
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String specialityId = '';
  String doctorProfilePicMediaId = '';
  String description = '';
  DoctorAddressModel address =
      DoctorAddressModel(governorateId: '', cityId: '', address: '');
  List<DetectionParams> detections = [];
  List<DocumentParams> documents = [];

  // Helper getters for backward compatibility
  bool get hasClinic => detections.any((d) => d.type == 'clinic_visit');
  bool get hasHomeVisit => detections.any((d) => d.type == 'home_visit');
  bool get hasCalls => detections.any((d) => d.type == 'video_call');

  // Legacy getters for maximum compatibility
  bool get clinic => hasClinic;
  bool get homeVisit => hasHomeVisit;
  bool get calls => hasCalls;

  // Get specific detection by type
  DetectionParams? getClinicDetection() {
    try {
      return detections.firstWhere((d) => d.type == 'clinic_visit');
    } catch (e) {
      return null;
    }
  }

  DetectionParams? getHomeVisitDetection() {
    try {
      return detections.firstWhere((d) => d.type == 'home_visit');
    } catch (e) {
      return null;
    }
  }

  DetectionParams? getCallsDetection() {
    try {
      return detections.firstWhere((d) => d.type == 'video_call');
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'specialityId': specialityId,
      'doctorProfilePicMediaId': doctorProfilePicMediaId,
      'description': description,
      'address': address.toJson(),
      'detections': detections.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }

  String? isFilled() {
    if (specialityId.isEmpty) return 'Please choose your specialty';
    if (doctorProfilePicMediaId.isEmpty) return 'Please upload your photo';
    if (firstName.isEmpty) return 'Please enter your first name';
    if (lastName.isEmpty) return 'Please enter your last name';
    if (phoneNumber.isEmpty) return 'Please enter your phone number';
    if (description.isEmpty) return 'Please enter your description';
    if (address.governorateId.isEmpty) return 'Please enter your governorate';
    if (address.cityId.isEmpty) return 'Please enter your city';
    if (address.address.isEmpty) return 'Please enter your address';
    if (detections.isEmpty) return 'Please add at least one detection type';
    return null;
  }
}

class DetectionParams {
  String type; // clinic_visit | video_call | home_visit
  num price;
  int detectionPeriod;
  String description;
  List<DoctorDayModel> availability; // mapped to new keys in toJson

  DetectionParams({
    required this.type,
    required this.price,
    required this.detectionPeriod,
    required this.description,
    required this.availability,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'price': price,
        'detectionPeriod': detectionPeriod,
        'description': description,
        'availability': availability.map((e) => e.toJson()).toList(),
      };
}

class DocumentParams {
  String type; // id_card | license
  String frontMediaId;
  String backMediaId;
  String expiryDate; // ISO8601

  DocumentParams({
    required this.type,
    required this.frontMediaId,
    required this.backMediaId,
    required this.expiryDate,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'frontMediaId': frontMediaId,
        'backMediaId': backMediaId,
        'expiryDate': expiryDate,
      };
}

class WorkDaysParams {
  List<DoctorDayModel> workDays;

  WorkDaysParams(this.workDays);

  factory WorkDaysParams.fromJson(Map<String, dynamic> json) {
    return WorkDaysParams(List<DoctorDayModel>.from(
        json['workDays'].map((x) => DoctorDayModel.fromJson(x))));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['workDays'] = workDays.map((v) => v.toJson()).toList();

    return data;
  }
}
