import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/club_house/data/model/club_voice_room_model.dart';
import 'package:fourtyninehub/features/social_media/club_house/data/model/create_voice_room_model.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/create_room_response_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/add_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/search_club_voice_use_case.dart';

import '../../../../../core/api/api_consumer.dart';

abstract class ClubVoiceDataSource {
  Future<Either<Failure, CreateClubVoiceRoomResponseModel>> addRoom(
      AddRoomParams params);
  Future<Either<Failure, List<ClubVoiceRoomEntity>>> getRooms();
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
  Future<Either<Failure, CreateClubVoiceRoomResponseModel>> addRoom(
      AddRoomParams params) async {
    final result = await apiConsumer.post(EndPoints.createClubVoiceRoom,
        data: params.toJson());
    return result.fold((l) => Left(l),
        (r) => Right(CreateClubVoiceRoomResponseModel.fromJson(r)));
  }

  @override
  Future<Either<Failure, void>> end(RoomMetaParams params) async {
    final result =
        await apiConsumer.delete(EndPoints.endVoiceRoom(params.roomId));
    return result.fold((l) => Left(l), (r) => result);
  }

  @override
  Future<Either<Failure, List<ClubVoiceRoomModel>>> getRooms() async {
    try {
      final result = await apiConsumer.get(
        EndPoints.allClubVoiceRooms,
      );
      // print('list is  ${rooms.toString()}');
      return result.fold((l) => Left(l), (r) => Right(_returnListOfRooms(r)));
    } catch (e) {
      return const Left(UnknownFailure());
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
    var list = List.from(r['data']['docs'] as List)
        .map((e) => ClubVoiceRoomModel.fromJson(e))
        .toList();
    return list;
  }
}
