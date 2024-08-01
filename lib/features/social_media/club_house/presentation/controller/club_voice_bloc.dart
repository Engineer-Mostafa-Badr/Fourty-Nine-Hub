import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/add_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import '../../../../../core/enums/zego_request_state.dart';
import '../../domain/usecases/end_club_voice_use_case.dart';
import '../../domain/usecases/get_club_voice_use_case.dart';
import '../../domain/usecases/leave_club_voice_use_case.dart';
import '../../domain/usecases/search_club_voice_use_case.dart';
import 'club_voice_state.dart'; // Assuming this is the file where your state classes are defined

class ClubVoiceCubit extends Cubit<ClubVoiceState> {
  final AddClubVoiceUseCase addClubVoiceUseCase;
  final GetClubVoiceUseCase getClubVoiceUseCase;
  final EndClubVoiceUseCase endClubVoiceUseCase;
  final LeaveClubVoiceUseCase leaveClubVoiceUseCase;
  final JoinClubVoiceUseCase joinClubVoiceUseCase;
  final SearchClubVoiceUseCase searchClubVoiceUseCase;
  ClubVoiceCubit(
    this.addClubVoiceUseCase,
    this.getClubVoiceUseCase,
    this.endClubVoiceUseCase,
    this.leaveClubVoiceUseCase,
    this.joinClubVoiceUseCase,
    this.searchClubVoiceUseCase,
  ) : super(const InitialClubVoiceState());

  void addRoom(String subject) {
    emit(const AddRoomState(requestState: ZegoRequestState.loading));
    addClubVoiceUseCase(AddRoomParams(subject: subject))
        .then((value) =>
            emit(const AddRoomState(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(const AddRoomState(requestState: ZegoRequestState.failure)));
  }

  void joinRoom(String roomId) {
    emit(const RehashRoomState(requestState: ZegoRequestState.loading));
    joinClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(const RehashRoomState(requestState: ZegoRequestState.success)))
        .catchError((onError) => emit(
            const RehashRoomState(requestState: ZegoRequestState.failure)));
  }

  void leaveRoom(String roomId) {
    leaveClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(const RehashRoomState(requestState: ZegoRequestState.success)))
        .catchError((onError) => emit(
            const RehashRoomState(requestState: ZegoRequestState.failure)));
  }

  void endRoom(String roomId) {
    endClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(const RehashRoomState(requestState: ZegoRequestState.success)))
        .catchError((onError) => emit(
            const RehashRoomState(requestState: ZegoRequestState.failure)));
  }

  void searchRoom(String roomSubject) {
    searchClubVoiceUseCase(SearchParams(roomSubject: roomSubject))
        .then((value) =>
            emit(const RehashRoomState(requestState: ZegoRequestState.success)))
        .catchError((onError) => emit(
            const RehashRoomState(requestState: ZegoRequestState.failure)));
  }
  int roomsLength = 0;
  List<ClubVoiceRoomEntity> rooms = [];
  void getAllRooms() {
    emit(const GetRoomState(requestState: ZegoRequestState.loading));
    getClubVoiceUseCase(const NoParams()).then((value) {
      value.fold(
          (l) => emit(const GetRoomState(
                requestState: ZegoRequestState.failure,
              )),
          (r) {
            rooms = r;
            roomsLength = r.length;
            emit(
                const GetRoomState(requestState: ZegoRequestState.success)
                    .copyWith(roomsList: r),
              );
          });
    }).catchError((onError) {});
  }
}
