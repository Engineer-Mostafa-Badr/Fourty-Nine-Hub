import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import 'appointment_model.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.id,
    required super.lastName,
    required super.firstName,
    required super.subCategory,
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
    required super.appointments,
    required super.clinicDays,
    required super.callDays,
    required super.homeVisitDays,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      subCategory: json['subCategoryId'] != null
          ? SubCategoryModel.fromJson(json['subCategoryId'])
          : SubCategoryEntity(
              id: '',
              nameEn: '',
              nameAr: '',
              image: '',
              isFavorite: false,
            ),
      image: json['mediaId']['mediaKey'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] != null
          ? DoctorAddressModel.fromJson(json['address'])
          : DoctorAddressEntity(governorateId: '', cityId: '', address: ''),
      clinic: json['clinic'] ?? false,
      calls: json['calls'] ?? false,
      visitHome: json['visitHome'] ?? false,
      clinicPrice: json['clinicPrice'] ?? '',
      detectionPeriodClinic: json['detectionPeriodClinic'] ?? '',
      detectionPeriodCalls: json['detectionPeriodCalls'] ?? '',
      detectionPeriodvisitHome: json['detectionPeriodvisitHome'] ?? '',
      callsPrice: json['callsPrice'] ?? '',
      visitHomePrice: json['visitHomePrice'] ?? '',
      waitingTime: json['waitingTime'] ?? '',
      isActive: json['isActive'] ?? false,
      isPremium: json['isPremium'] ?? false,
      description: json['description'] ?? '',
      rating: json['rating'] ?? 1,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      appointments: json['appointments'] != null
          ? List<AppointmentEntity>.from(
              json['appointments'].map((x) => AppointmentModel.fromJson(x)),
            )
          : [],
      clinicDays: json['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(json['doctorAppointment']['clinic']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
      callDays: json['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(json['doctorAppointment']['calls']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
      homeVisitDays: json['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(json['doctorAppointment']['visitHome']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
    );
  }
}
