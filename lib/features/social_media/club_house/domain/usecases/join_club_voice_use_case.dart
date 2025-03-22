// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../repositories/club_voice_repository.dart';

class JoinClubVoiceUseCase extends UseCase<void, RoomMetaParams> {
  final ClubVoiceRepository clubVoiceRepository;

  JoinClubVoiceUseCase(this.clubVoiceRepository);

  @override
  Future<Either<Failure, void>> call(RoomMetaParams params) {
    return clubVoiceRepository.join(params);
  }
}

class RoomMetaParams extends Equatable {
  final String roomId;
  const RoomMetaParams({
    required this.roomId,
  });
  Map<String, dynamic> toJson() => {
        'roomId': roomId,
      };
  @override
  List<Object?> get props => [
        roomId,
      ];
}
