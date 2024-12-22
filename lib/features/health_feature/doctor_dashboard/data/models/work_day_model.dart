import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/work_day_entity.dart';

class WorkDayModel extends WorkDayEntity{
  WorkDayModel({required super.id, required super.day, required super.workFrom, required super.workTo});

  //fromJson
  factory WorkDayModel.fromJson(Map<String, dynamic> json) {
    return WorkDayModel(
      id: json['_id']??'',
      day: json['day']??'',
      workFrom: json['workFrom']??'',
      workTo: json['workTo']??'',
    );
  }

}