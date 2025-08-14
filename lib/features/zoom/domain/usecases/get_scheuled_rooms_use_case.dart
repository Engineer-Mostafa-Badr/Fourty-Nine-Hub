import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/scheduled_meeting.dart';
import '../repositories/meeting_repository.dart';
import 'add_room_use_case.dart';

class GetScheduledRoomsUseCase
    extends UseCase<List<ScheduledMeeting>, MeetingParams> {
  final MeetingRepository repo;

  GetScheduledRoomsUseCase(this.repo);
  @override
  Future<Either<Failure, List<ScheduledMeeting>>> call(MeetingParams params) {
    return repo.getScheduledMeetings(params);
  }
}
