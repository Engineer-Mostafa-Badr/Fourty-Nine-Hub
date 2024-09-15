import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../repositories/club_voice_repository.dart';

class GetClubVoiceUseCase
    extends UseCase<List<ClubVoiceRoomEntity>, PaginationParams> {
  final ClubVoiceRepository clubVoiceRepository;

  GetClubVoiceUseCase(this.clubVoiceRepository);

  @override
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> call(
      PaginationParams params) {
    return clubVoiceRepository.getRooms(params);
  }
}
