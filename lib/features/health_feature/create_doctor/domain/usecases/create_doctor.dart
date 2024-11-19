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
  String subCategoryId = '';
  String phone = '';
  DoctorAddressModel address =
      DoctorAddressModel(governorateId: '', cityId: '', address: '');
  bool hasClinic = false;
  bool hasHomeVisit = false;
  bool hasCalls = false;
  WorkDaysParams? clinic = WorkDaysParams([]);
  WorkDaysParams? calls = WorkDaysParams([]);
  WorkDaysParams? visitHome = WorkDaysParams([]);
  String? detectionPeriodClinic = '';
  String? detectionPeriodCalls = '';
  String? detectionPeriodvisitHome = '';
  String? clinicPrice = '';
  String? callsPrice = '';
  String? visitHomePrice = '';
  String mediaId = '';
  String waitingTime = '';
  String description = '';
  String idFrontKey = '';
  String idBehindKey = '';
  String idExpiryDate = '';
  String practicingBehind = '';
  String practicingFront = '';
  String practicingExpiryDate = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['subCategoryId'] = subCategoryId;
    data['phone'] = phone;
    data['address'] = address.toJson();
    if (hasClinic && clinic != null && clinic!.workDays.isNotEmpty) {
      data['clinic'] = clinic!.toJson();
    }
    if (hasCalls && calls != null && calls!.workDays.isNotEmpty) {
      data['calls'] = calls!.toJson();
    }
    if (hasHomeVisit && visitHome != null && visitHome!.workDays.isNotEmpty) {
      data['visitHome'] = visitHome!.toJson();
    }
    if (hasClinic &&
        detectionPeriodClinic != null &&
        detectionPeriodClinic!.isNotEmpty) {
      data['detectionPeriodClinic'] = '$detectionPeriodClinic min';
    }
    if (hasCalls &&
        detectionPeriodCalls != null &&
        detectionPeriodCalls!.isNotEmpty) {
      data['detectionPeriodCalls'] = '$detectionPeriodCalls min';
    }
    if (hasHomeVisit &&
        detectionPeriodvisitHome != null &&
        detectionPeriodvisitHome!.isNotEmpty) {
      data['detectionPeriodVisitHome'] = '$detectionPeriodvisitHome min';
    }
    if (hasClinic && clinicPrice != null && clinicPrice!.isNotEmpty) {
      data['clinicPrice'] = '$clinicPrice EGP';
    }
    if (hasCalls && callsPrice != null && callsPrice!.isNotEmpty) {
      data['callsPrice'] = '$callsPrice EGP';
    }
    if (hasHomeVisit && visitHomePrice != null && visitHomePrice!.isNotEmpty) {
      data['visitHomePrice'] = '$visitHomePrice EGP';
    }
    data['waitingTime'] = '$waitingTime min';
    data['mediaId'] = mediaId;
    data['description'] = description;
    data['idFrontKey'] = idFrontKey;
    data['idBehindKey'] = idBehindKey;
    data['idExpiryDate'] = idExpiryDate;
    data['practicingBehind'] = practicingBehind;
    data['practicingFront'] = practicingFront;
    data['practicingExpiryDate'] = practicingExpiryDate;
    return data;
  }

  String? isFilled() {
    if (subCategoryId.isEmpty) return "Please choose your specialty";

    if (mediaId.isEmpty) return "Please upload your photo";

    if (idFrontKey.isEmpty) return "Please upload your ID front photo";
    if (idBehindKey.isEmpty) return "Please upload your ID back photo";
    if (idExpiryDate.isEmpty) return "Please choose your ID expiry date";

    if (practicingFront.isEmpty) {
      return "Please upload your licence front photo";
    }
    if (practicingBehind.isEmpty) {
      return "Please upload your licence behind photo";
    }
    if (practicingExpiryDate.isEmpty) {
      return "Please choose your practicing expiry date";
    }

    // address
    if (address.governorateId.isEmpty) return "Please enter your governorate";
    if (address.cityId.isEmpty) return "Please enter your city";
    if (address.address.isEmpty) return "Please enter your address";

    // work days
    if (!hasClinic && !hasHomeVisit && !hasCalls) {
      return "Select at least one service (clinic or home visit or calls)";
    }
    if (hasClinic && (clinic == null || clinic!.workDays.isEmpty)) {
      return "Please choose your clinic days";
    }
    if (hasClinic &&
        ((clinicPrice ?? '').isEmpty ||
            waitingTime.isEmpty ||
            (detectionPeriodClinic ?? '').isEmpty)) {
      return "Please enter your clinic price, waiting time and examination period";
    }
    if (hasHomeVisit && (visitHome == null || visitHome!.workDays.isEmpty)) {
      return "Please choose your home visit days";
    }
    if (hasHomeVisit &&
        ((visitHomePrice ?? '').isEmpty ||
            (detectionPeriodvisitHome ?? '').isEmpty)) {
      return "Please enter your home visit price and examination period";
    }
    if (hasCalls && (calls == null || calls!.workDays.isEmpty)) {
      return "Please choose your calls days";
    }
    if (hasCalls &&
        ((callsPrice ?? "").isEmpty || (detectionPeriodCalls ?? "").isEmpty)) {
      return "Please enter your calls price and examination period";
    }

    if (firstName.isEmpty) return "Please enter your first name";
    if (lastName.isEmpty) return "Please enter your last name";
    if (phone.isEmpty) return "Please enter your phone number";

    if (description.isEmpty) return "Please enter your description";

    return null;
  }
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
