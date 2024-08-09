// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/repositories/club_voice_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entities/club_voice_room_entity.dart';

class SearchClubVoiceUseCase extends UseCase<void, SearchParams> {
  final ClubVoiceRepository clubVoiceRepository;

  SearchClubVoiceUseCase(this.clubVoiceRepository);
  @override
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> call(SearchParams params) {
    return clubVoiceRepository.search(params);
  }
}

class SearchParams extends Equatable {
  final String roomSubject;
  const SearchParams({
    required this.roomSubject,
  });

  @override
  List<Object?> get props => [
        roomSubject,
      ];
}
