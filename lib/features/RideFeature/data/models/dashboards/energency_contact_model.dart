import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';

class EmergencyContactModel extends EmergencyContactEntity{
  EmergencyContactModel({required super.id, required super.name, required super.phoneNumber});

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['_id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}