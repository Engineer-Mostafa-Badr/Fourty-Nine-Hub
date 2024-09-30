import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';

class ScheduledMeetingModel extends ScheduledMeeting {
  const ScheduledMeetingModel({
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.roomId,
  });
  //generate fromjson
  factory ScheduledMeetingModel.fromJson(Map<String, dynamic> json) {
    return ScheduledMeetingModel(
      title: json['title']??'',
      startDate: json['startDate'] ?? '2024-09-04T12:21:53.199Z',
      endDate: json['endDate'],
      roomId: json['roomId'],
    );
  }
}
