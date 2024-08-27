// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ScheduledMeeting extends Equatable {
  final String title;
  final String startDate;
  final String endDate;
  final String roomId;

  const ScheduledMeeting(
      {required this.title,
      required this.startDate,
      required this.endDate,
      required this.roomId});

  @override
  List<Object> get props => [
        title,
        startDate,
        endDate,
        roomId,
      ];
}
