import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_review_model.dart';
import '../../../../requests_history/data/models/address_model.dart';
import 'appointment_model.dart';
import 'doctor_detail_model.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel(
      {required super.id,
      required super.name,
      required super.phone,
      required super.email,
      required super.bio,
      required super.rate,
      required super.numberOfReviews,
      required super.startPrice,
      required super.image,
      required super.clinicImages,
      required super.languages,
      required super.address,
      required super.available,
      required super.appointments,
      required super.reviews,
      required super.details,
       required super.waitingTime});
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      bio: json['bio'],
      rate: json['rate'],
      waitingTime: json['waiting_time']??0,
      numberOfReviews: json['number_of_reviews'],
      startPrice: json['start_price'],
      image: json['image'],
      clinicImages: json['clinic_images'].cast<String>(),
      languages: json['languages'].cast<String>(),
      available: json['available']??false,
      address: AddressModel.fromJson(json['address']),
      appointments:json['appointments']==null?null: (json['appointments'] as List)
          .map((e) => AppointmentModel.fromJson(e))
          .toList(),
      reviews: json['reviews']==null?null:(json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
           details: json['details']==null? null: (json['details'] as List)
          .map((e) => DoctorDetailModel.fromJson(e))
          .toList(),
    );
  }
}
