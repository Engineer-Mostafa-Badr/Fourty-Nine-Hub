
import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel(
      {required super.id,
      required super.date,
      required super.fromTime,
      required super.toTime,
      required super.available});
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
    id : json['id'],
    date : json['date'],
    fromTime : json['from_time'],
    toTime : json['to_time'],
    available : json['available'],
    );
   
  }
}
