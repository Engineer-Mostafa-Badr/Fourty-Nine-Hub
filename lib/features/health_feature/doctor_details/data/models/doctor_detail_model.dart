import '../../domain/entities/doctor_detail_entity.dart';

class DoctorDetailModel extends DoctorDetailEntity {
  DoctorDetailModel(
      {required super.id, required super.label, required super.details});
  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      id : json['id'],
    label : json['label'],
    details : json['details'],
    );
  }
}
