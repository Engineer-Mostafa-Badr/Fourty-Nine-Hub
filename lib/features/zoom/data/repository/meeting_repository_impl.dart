import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/zoom/data/data_source/meeting_data_source.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';

import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/send_points_use_case.dart';

import '../../domain/repositories/meeting_repository.dart';

class MeetingRepositoryImpl extends MeetingRepository {
  final MeetingDataSource meetingDataSource;

  MeetingRepositoryImpl(this.meetingDataSource);
  @override
  Future<Either<Failure, bool>> addRoom(MeetingParams params) {
    return meetingDataSource.addRoom(params);
  }

  @override
  Future<Either<Failure, void>> end(MeetingParams params) {
    return meetingDataSource.endRoom(params);
  }

  @override
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params) {
    return meetingDataSource.getScheduledMeetings(params);
  }

  @override
  Future<Either<Failure, bool>> join(MeetingParams params) {
    return meetingDataSource.joinRoom(params);
  }

  @override
  Future<Either<Failure, bool>> sendPoints(SendPointsParams params) {
    return meetingDataSource.sendPoints(params);
  }
}
