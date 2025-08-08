import 'package:dartz/dartz.dart';
import '../entities/scheduled_meeting.dart';
import '../usecases/add_room_use_case.dart';
import '../usecases/send_gift_use_case.dart';
import '../usecases/send_points_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class MeetingRepository {
  Future<Either<Failure, bool>> addRoom(MeetingParams params);
  Future<Either<Failure, bool>> sendPoints(SendPointsParams params);
  Future<Either<Failure, bool>> sendGift(SendLiveGiftParams params);
  Future<Either<Failure, bool>> join(MeetingParams params);
  Future<Either<Failure, void>> end(MeetingParams params);
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params);
}
