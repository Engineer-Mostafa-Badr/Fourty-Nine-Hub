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
    // Support old and new booking doctor shapes
    final Map<String, dynamic> data =
        (json['doctor'] is Map<String, dynamic>) ? json['doctor'] : json;

    // Map specialty if provided under 'speciality'
    SubCategoryEntity subCategoryEntity;
    if (data['subCategoryId'] != null) {
      subCategoryEntity = SubCategoryModel.fromJson(data['subCategoryId']);
    } else if (data['speciality'] is Map<String, dynamic>) {
      final sp = data['speciality'] as Map<String, dynamic>;
      subCategoryEntity = SubCategoryEntity(
        id: (sp['id'] ?? sp['_id'] ?? '').toString(),
        nameAr: (sp['nameAr'] ?? '').toString(),
        nameEn: (sp['nameEn'] ?? '').toString(),
        image: '',
        isFavorite: false,
      );
    } else {
      subCategoryEntity = SubCategoryEntity(
        id: '',
        nameAr: '',
        nameEn: '',
        image: '',
        isFavorite: false,
      );
    }

    // Detections mapping (booking doctor API)
    String clinicPrice = '';
    String callsPrice = '';
    String visitHomePrice = '';
    String detectionPeriodClinic = '';
    String detectionPeriodCalls = '';
    String detectionPeriodvisitHome = '';
    if (data['detections'] is List) {
      for (final det in (data['detections'] as List)) {
        final type = (det['type'] ?? '').toString();
        final price = (det['price'] ?? '').toString();
        final period = (det['detectionPeriod'] ?? '').toString();
        if (type == 'clinic_visit') {
          clinicPrice = price;
          detectionPeriodClinic = period;
        } else if (type == 'video_call') {
          callsPrice = price;
          detectionPeriodCalls = period;
        } else if (type == 'home_visit') {
          visitHomePrice = price;
          detectionPeriodvisitHome = period;
        }
      }
    }

    return DoctorModel(
      id: data['id'] ?? data['_id'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      description: data['description'] ?? '',
      timeToStart: data['timeToStart'] ?? '0h 0m',
      isAfterEnd: data['isAfterEnd'] ?? false,
      isBetweenStartAndEnd: data['isBetweenStartAndEnd'] ?? false,
      meetingData: data['roomMeeting'] != null
          ? DoctorMeetingModel.fromJson(data['roomMeeting'])
          : null,
      subCategory: subCategoryEntity,
      image: (data['mediaId'] is Map && data['mediaId']['mediaKey'] != null)
          ? data['mediaId']['mediaKey']
          : (data['profilePicUrl'] ?? ''),
      phone: (data['phone'] ?? data['phoneNumber'] ?? '').toString(),
      email: data['email'] ?? '',
      classification: data['classification'] ?? '',
      address: data['address'] != null
          ? DoctorAddressModel.fromJson(data['address'])
          : DoctorAddressEntity(governorateId: '', cityId: '', address: ''),
      clinic: data['clinic'] ?? (clinicPrice.isNotEmpty),
      calls: data['calls'] ?? (callsPrice.isNotEmpty),
      visitHome: data['visitHome'] ?? (visitHomePrice.isNotEmpty),
      currencyEn: data['currencyEn'] ?? '',
      currencyAr: data['currencyAr'] ?? '',
      clinicPrice: (data['clinicPrice']?.toString() ?? clinicPrice),
      detectionPeriodClinic:
          data['detectionPeriodClinic'] ?? detectionPeriodClinic,
      detectionPeriodCalls:
          data['detectionPeriodCalls'] ?? detectionPeriodCalls,
      detectionPeriodvisitHome:
          data['detectionPeriodvisitHome'] ?? detectionPeriodvisitHome,
      callsPrice: (data['callsPrice']?.toString() ?? callsPrice),
      visitHomePrice: (data['visitHomePrice']?.toString() ?? visitHomePrice),
      waitingTime: (data['waitingTime']?.toString() ?? ''),
      isActive: data['isActive'] ?? true,
      isPremium: data['isPremium'] ?? false,
      rating: data['rating'] ?? 1,
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      appointments: data['appointments'] != null
          ? List<AppointmentEntity>.from(
              data['appointments'].map((x) => AppointmentModel.fromJson(x)),
            )
          : [],
      clinicDays: data['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(data['doctorAppointment']['clinic']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
      callDays: data['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(data['doctorAppointment']['calls']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
      homeVisitDays: data['doctorAppointment'] != null
          ? List<DoctorDayEntity>.from(data['doctorAppointment']['visitHome']
                  ['workDays']
              .map((x) => DoctorDayModel.fromJson(x)))
          : [],
    );
  }
}
