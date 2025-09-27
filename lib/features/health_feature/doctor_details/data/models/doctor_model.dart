import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_meeting_model.dart';
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
    required super.meetingData,
    required super.subCategory,
    required super.image,
    required super.phone,
    required super.email,
    required super.address,
    required super.clinic,
    required super.isAfterEnd,
    required super.isBetweenStartAndEnd,
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
    required super.timeToStart,
    required super.isPremium,
    required super.description,
    required super.classification,
    required super.rating,
    required super.createdAt,
    required super.updatedAt,
    required super.appointments,
    required super.clinicDays,
    required super.callDays,
    required super.currencyEn,
    required super.currencyAr,
    required super.homeVisitDays,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']??json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      description: json['description'] ?? '',
      timeToStart: json['timeToStart'] ?? '0h 0m',
      isAfterEnd: json['isAfterEnd'] ?? false,
      isBetweenStartAndEnd: json['isBetweenStartAndEnd'] ?? false,
      meetingData: json['roomMeeting'] != null
          ? DoctorMeetingModel.fromJson(json['roomMeeting'])
          : null,
      subCategory: json['subCategoryId'] != null
          ? SubCategoryModel.fromJson(json['subCategoryId'])
          : SubCategoryEntity(
              id: '',
              nameAr: '',
              nameEn: '',
              image: '',
              isFavorite: false,
            ),
      image: json['mediaId']['mediaKey'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      classification: json['classification'] ?? '',
      address: json['address'] != null
          ? DoctorAddressModel.fromJson(json['address'])
          : DoctorAddressEntity(governorateId: '', cityId: '', address: ''),
      clinic: json['clinic'] ?? false,
      calls: json['calls'] ?? false,
      visitHome: json['visitHome'] ?? false,
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
      clinicPrice: json['clinicPrice'].toString() ?? '',
      detectionPeriodClinic: json['detectionPeriodClinic'] ?? '',
      detectionPeriodCalls: json['detectionPeriodCalls'] ?? '',
      detectionPeriodvisitHome: json['detectionPeriodvisitHome'] ?? '',
      callsPrice: json['callsPrice'].toString() ?? '',
      visitHomePrice: json['visitHomePrice'].toString() ?? '',
      waitingTime: json['waitingTime'].toString() ?? '',
      isActive: json['isActive'] ?? false,
      isPremium: json['isPremium'] ?? false,
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
