// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../repositories/club_voice_repository.dart';

class EndClubVoiceUseCase extends UseCase<void, RoomMetaParams> {
  final ClubVoiceRepository clubVoiceRepository;

  EndClubVoiceUseCase(this.clubVoiceRepository);

  @override
  Future<Either<Failure, void>> call(RoomMetaParams params) {
    return clubVoiceRepository.end(params);
  }
}
