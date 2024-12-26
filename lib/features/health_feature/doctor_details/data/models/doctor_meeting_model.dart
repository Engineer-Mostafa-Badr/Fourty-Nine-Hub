import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_meeting_entity.dart';

class DoctorMeetingModel extends DoctorMeetingEntity {
  DoctorMeetingModel(
      {required super.id,
      required super.roomId,
      required super.userId,
      required super.isFinish,
      required super.startDate,
      required super.endDate,
      required super.title,
      super.members,
      required super.createdAt,
      required super.updatedAt});

  //fromJson
  factory DoctorMeetingModel.fromJson(Map<String, dynamic> json) {
    return DoctorMeetingModel(
      id: json['_id'] ?? '',
      roomId: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      isFinish: json['isFinish'] ?? false,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      title: json['title'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
