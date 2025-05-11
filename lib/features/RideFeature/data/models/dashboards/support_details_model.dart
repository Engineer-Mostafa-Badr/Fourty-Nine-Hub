import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';

class SupportDetailsModel extends SupportDetailsEntity {
  SupportDetailsModel({required super.name, required super.email, required super.phone, required super.deviceId, required super.status});

  //fromJson
  factory SupportDetailsModel.fromJson(Map<String, dynamic> json) {
    return SupportDetailsModel(
      name: json['supportData']!=null?json['supportData']['name'] ?? '':'',
      email: json['supportData']!=null?json['supportData']['email'] ?? '':'',
      phone: json['supportData']!=null?json['supportData']['phone'] ?? '':'',
      deviceId: json['supportData']!=null?json['supportData']['deviceId'] ?? '':'',
      status:json['status'] ?? '',
    );
  }
}

