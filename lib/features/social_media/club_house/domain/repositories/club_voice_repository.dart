import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/search_club_voice_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../data/model/create_voice_room_model.dart';
import '../usecases/add_club_voice_use_case.dart';

abstract class ClubVoiceRepository {
  Future<Either<Failure, ZegoResponseModel>> addRoom(AddRoomParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> getRooms();
  Future<Either<Failure, void>> join(RoomMetaParams params);
  Future<Either<Failure, void>> leave(RoomMetaParams params);
  Future<Either<Failure, void>> end(RoomMetaParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> search(
      SearchParams params);
}
