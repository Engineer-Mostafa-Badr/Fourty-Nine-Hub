import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import 'join_club_voice_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../repositories/club_voice_repository.dart';

class LeaveClubVoiceUseCase extends UseCase<void, RoomMetaParams> {
  final ClubVoiceRepository clubVoiceRepository;

  LeaveClubVoiceUseCase(this.clubVoiceRepository);

  @override
  Future<Either<Failure, void>> call(RoomMetaParams params) {
    return clubVoiceRepository.leave(params);
  }
}
