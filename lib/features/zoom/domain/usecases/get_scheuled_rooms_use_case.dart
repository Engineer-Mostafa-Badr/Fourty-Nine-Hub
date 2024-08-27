import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/repositories/meeting_repository.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

class GetScheduledRoomsUseCase extends UseCase<List<ScheduledMeeting>,MeetingParams>{
final MeetingRepository repo;

  GetScheduledRoomsUseCase(this.repo);
  @override
  Future<Either<Failure, List<ScheduledMeeting>>> call(MeetingParams params) {
    return repo.getScheduledMeetings(params);
  }
}