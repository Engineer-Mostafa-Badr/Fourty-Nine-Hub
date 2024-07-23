import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/work_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/address_search_params_model.dart';

class CreateDoctorUseCase extends UseCase<void, CreateDoctorParams> {
  final CreateDoctorRepo _createDoctorRepo;
  CreateDoctorUseCase(this._createDoctorRepo);
  @override
  Future<Either<Failure, void>> call(CreateDoctorParams params) {
    return _createDoctorRepo.createDoctor(params);
  }
}

class CreateDoctorParams {
  String firstName;
  String lastName;
  String subCategoryId;
  String phone;
  String email;
  AddressSearchParamsModel address;
  List<DoctorWorkDayModel> clinicWorkDays;
  List<DoctorWorkDayModel> callsWorkDays;
  List<DoctorWorkDayModel> homeVisitWorkDays;
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

  CreateDoctorParams(
      {required this.firstName,
      required this.lastName,
      required this.subCategoryId,
      required this.phone,
      required this.email,
      required this.address,
      required this.callsWorkDays,
      required this.homeVisitWorkDays,
      required this.clinicWorkDays,
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
      required this.practicingExpiryDate});

  factory CreateDoctorParams.fromJson(Map<String, dynamic> json) {
    return CreateDoctorParams(
      firstName: json['firstName'],
      lastName: json['lastName'],
      subCategoryId: json['subCategoryId'],
      phone: json['phone'],
      email: json['email'],
      address: AddressSearchParamsModel.fromJson(json['address']),
      clinicWorkDays: (json['clinic'] as List)
          .map((e) => DoctorWorkDayModel.fromJson(e))
          .toList(),
      callsWorkDays: (json['calls'] as List)
          .map((e) => DoctorWorkDayModel.fromJson(e))
          .toList(),
      homeVisitWorkDays: (json['homeVisit'] as List)
          .map((e) => DoctorWorkDayModel.fromJson(e))
          .toList(),
      mediaId: json['mediaId'],
      clinicPrice: json['clinicPrice'],
      waitingTime: json['waitingTime'],
      callsPrice: json['callsPrice'],
      description: json['description'],
      idFrontKey: json['idFrontKey'],
      idBehindKey: json['idBehindKey'],
      idExpiryDate: json['idExpiryDate'],
      practicingBehind: json['practicingBehind'],
      practicingFront: json['practicingFront'],
      practicingExpiryDate: json['practicingExpiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['subCategoryId'] = subCategoryId;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address.toJson();
    if (clinicWorkDays.isNotEmpty) {
      data['clinic'] = clinicWorkDays.map((e) => e.toJson()).toList();
    }
    if (callsWorkDays.isNotEmpty) {
      data['calls'] = callsWorkDays.map((e) => e.toJson()).toList();
    }
    if (homeVisitWorkDays.isNotEmpty) {
      data['homeVisit'] = homeVisitWorkDays.map((e) => e.toJson()).toList();
    }
    data['mediaId'] = mediaId;
    data['clinicPrice'] = clinicPrice;
    data['waitingTime'] = waitingTime;
    data['callsPrice'] = callsPrice;
    data['description'] = description;
    data['idFrontKey'] = idFrontKey;
    data['idBehindKey'] = idBehindKey;
    data['idExpiryDate'] = idExpiryDate;
    data['practicingBehind'] = practicingBehind;
    data['practicingFront'] = practicingFront;
    data['practicingExpiryDate'] = practicingExpiryDate;
    return data;
  }
}
