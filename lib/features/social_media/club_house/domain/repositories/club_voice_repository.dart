import 'package:dartz/dartz.dart';
import '../entities/club_voice_room_entity.dart';
import '../usecases/join_club_voice_use_case.dart';
import '../usecases/search_club_voice_use_case.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/create_voice_room_model.dart';
import '../usecases/add_club_voice_use_case.dart';

abstract class ClubVoiceRepository {
  Future<Either<Failure, ZegoResponseModel>> addRoom(AddRoomParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> getRooms(
      PaginationParams params);
  Future<Either<Failure, void>> join(RoomMetaParams params);
  Future<Either<Failure, void>> leave(RoomMetaParams params);
  Future<Either<Failure, void>> end(RoomMetaParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> search(
      SearchParams params);
}
