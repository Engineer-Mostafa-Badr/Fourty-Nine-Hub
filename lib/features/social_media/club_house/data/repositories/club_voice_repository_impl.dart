import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../datasource/club_voice_datasource.dart';
import '../model/create_voice_room_model.dart';
import '../../domain/entities/club_voice_room_entity.dart';
import '../../domain/repositories/club_voice_repository.dart';
import '../../domain/usecases/add_club_voice_use_case.dart';
import '../../domain/usecases/join_club_voice_use_case.dart';
import '../../domain/usecases/search_club_voice_use_case.dart';

import '../../../../../common/models/public/pagination_params.dart';

class ClubVoiceRepositoryImpl extends ClubVoiceRepository {
  final ClubVoiceDataSource clubVoiceDataSource;

  ClubVoiceRepositoryImpl({required this.clubVoiceDataSource});

  @override
  Future<Either<Failure, ZegoResponseModel>> addRoom(AddRoomParams params) {
    return clubVoiceDataSource.addRoom(params);
  }

  @override
  Future<Either<Failure, void>> end(RoomMetaParams params) {
    return clubVoiceDataSource.end(params);
  }

  @override
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> getRooms(
      PaginationParams params) {
    return clubVoiceDataSource.getRooms(params);
  }

  @override
  Future<Either<Failure, void>> join(RoomMetaParams params) {
    return clubVoiceDataSource.join(params);
  }

  @override
  Future<Either<Failure, void>> leave(RoomMetaParams params) {
    return clubVoiceDataSource.leave(params);
  }

  @override
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> search(
      SearchParams params) {
    return clubVoiceDataSource.search(params);
  }
}
