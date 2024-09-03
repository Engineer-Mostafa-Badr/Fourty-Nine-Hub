import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class MeetingRepository {
  Future<void> addRoom(MeetingParams params);
  Future<Response?> join(MeetingParams params);
  Future<Either<Failure, void>> end(MeetingParams params);
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params);
}
