// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../data/model/create_voice_room_model.dart';
import '../repositories/club_voice_repository.dart';

class AddClubVoiceUseCase extends UseCase<ZegoResponseModel, AddRoomParams> {
  final ClubVoiceRepository clubVoiceRepository;

  AddClubVoiceUseCase(this.clubVoiceRepository);

  @override
  Future<Either<Failure, ZegoResponseModel>> call(AddRoomParams params) {
    return clubVoiceRepository.addRoom(params);
  }
}

class AddRoomParams extends Equatable {
  final String subject;

  const AddRoomParams({
    required this.subject,
  });
  //post method data
  Map<String, dynamic> toJson() => {
        'subject': subject,
      };

  @override
  List<Object?> get props => [
        subject,
      ];
}
