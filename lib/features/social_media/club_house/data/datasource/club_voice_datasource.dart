import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../model/club_voice_room_model.dart';
import '../model/create_voice_room_model.dart';
import '../../domain/entities/club_voice_room_entity.dart';
import '../../domain/usecases/add_club_voice_use_case.dart';
import '../../domain/usecases/join_club_voice_use_case.dart';
import '../../domain/usecases/search_club_voice_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

abstract class ClubVoiceDataSource {
  Future<Either<Failure, ZegoResponseModel>> addRoom(AddRoomParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> getRooms(
      PaginationParams params);
  Future<Either<Failure, void>> join(RoomMetaParams params);
  Future<Either<Failure, void>> leave(RoomMetaParams params);

  Future<Either<Failure, void>> end(RoomMetaParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> search(
      SearchParams subject);
}

class ClubVoiceDataSourceImpl extends ClubVoiceDataSource {
  final ApiConsumer apiConsumer;

  ClubVoiceDataSourceImpl(this.apiConsumer);

  @override
  Future<Either<Failure, ZegoResponseModel>> addRoom(
      AddRoomParams params) async {
    final result = await apiConsumer.post(EndPoints.createClubVoiceRoom,
        data: params.toJson());
    return result.fold(
        (l) => Left(l), (r) => Right(ZegoResponseModel.fromJson(r)));
  }

  @override
  Future<Either<Failure, void>> end(RoomMetaParams params) async {
    final result =
        await apiConsumer.delete(EndPoints.endVoiceRoom(params.roomId));
    return result.fold((l) => Left(l), (r) => result);
  }

  @override
  Future<Either<Failure, List<ClubVoiceRoomModel>>> getRooms(
      PaginationParams params) async {
    try {
      final result = await apiConsumer.get(EndPoints.allClubVoiceRooms,
          queryParameters: params.toJson());
      // print('list is  ${rooms.toString()}');
      return result.fold((l) => Left(l), (r) => Right(_returnListOfRooms(r)));
    } catch (e) {
      CliLogger.error('failure  $e');

      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> join(RoomMetaParams params) async {
    final result =
        await apiConsumer.put(EndPoints.joinVoiceRoom(params.roomId));
    return result.fold((l) => Left(l), (r) => result);
  }

  @override
  Future<Either<Failure, void>> leave(RoomMetaParams params) async {
    final result =
        await apiConsumer.put(EndPoints.leaveVoiceRoom(params.roomId));
    return result.fold((l) => Left(l), (r) => result);
  }

  @override
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> search(
      SearchParams params) async {
    final result =
        await apiConsumer.get(EndPoints.searchVoiceRooms(params.roomSubject));
    return result.fold((l) => Left(l), (r) => Right(_returnListOfRooms(r)));
  }

  List<ClubVoiceRoomModel> _returnListOfRooms(Map<String, dynamic> r) {
    var list = List.from(r['data']['voice'] as List)
        .map((e) => ClubVoiceRoomModel.fromJson(e))
        .toList();
    return list;
  }
}
