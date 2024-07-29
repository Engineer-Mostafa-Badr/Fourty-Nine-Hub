import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import 'appointment_model.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel(
      {required super.id,
      required super.lastName,
      required super.firstName,
      required super.subCategoryId,
      required super.image,
      required super.phone,
      required super.email,
      required super.address,
      required super.clinic,
      required super.calls,
      required super.visitHome,
      required super.clinicPrice,
      required super.detectionPeriodClinic,
      required super.detectionPeriodCalls,
      required super.detectionPeriodvisitHome,
      required super.callsPrice,
      required super.visitHomePrice,
      required super.waitingTime,
      required super.isActive,
      required super.isPremium,
      required super.description,
      required super.rating,
      required super.createdAt,
      required super.updatedAt,
      required super.appointments});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      subCategoryId: json['subCategoryId'],
      image: json['mediaId']['mediaKey'],
      phone: json['phone'],
      email: json['email'],
      address: DoctorAddressModel.fromJson(json['address']),
      clinic: json['clinic'],
      calls: json['calls'],
      visitHome: json['visitHome'],
      clinicPrice: json['clinicPrice'] ?? '',
      detectionPeriodClinic: json['detectionPeriodClinic'] ?? '',
      detectionPeriodCalls: json['detectionPeriodCalls'] ?? '',
      detectionPeriodvisitHome: json['detectionPeriodvisitHome'] ?? '',
      callsPrice: json['callsPrice'] ?? '',
      visitHomePrice: json['visitHomePrice'] ?? '',
      waitingTime: json['waitingTime'] ?? '',
      isActive: json['isActive'],
      isPremium: json['isPremium'],
      description: json['description'],
      rating: json['rating'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      appointments: List<AppointmentModel>.from(
        json['appointments'].map((x) => AppointmentModel.fromJson(x)),
      ),
    );
  }
}
