import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/add_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
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
  ) : super(const ClubVoiceState());

  String roomId = '';
  Future<void> addRoom(String subject) async {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    if (!isClosed) {
      await addClubVoiceUseCase(AddRoomParams(subject: subject)).then((value) {
        value.fold((l) {
          emit(state.copyWith(requestState: ZegoRequestState.failure));
        }, (r) {
          roomId = r.roomId;
          emit(state.copyWith(requestState: ZegoRequestState.success));
        });
      }).catchError((onError) {
        print('error $onError');
        emit(state.copyWith(requestState: ZegoRequestState.failure));
      });
    }
  }

  void joinRoom(String roomId) {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    joinClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  void leaveRoom(String roomId) {
    leaveClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  void endRoom(String roomId) {
    endClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  List<ClubVoiceRoomEntity> searchedRooms = [];
  void searchRoom(String roomSubject) {
    searchClubVoiceUseCase(SearchParams(roomSubject: roomSubject))
        .then((value) {
      emit(state.copyWith(requestState: ZegoRequestState.success));
    }).catchError((onError) {
      emit(state.copyWith(requestState: ZegoRequestState.failure));
    });
  }

  int roomsLength = 0;
  List<ClubVoiceRoomEntity> rooms = [];
  Future<void> getAllRooms() async {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    getClubVoiceUseCase(const NoParams()).then((value) {
      value.fold((l) {
        // CliLogger.error('there is an error ${l.toString()}',
        //     level: CliLoggerLevel.two);
        emit(state.copyWith(
          requestState: ZegoRequestState.failure,
        ));
      }, (r) {
        CliLogger.success('there is an success', level: CliLoggerLevel.two);
        rooms = r;
        roomsLength = r.length;
        emit(
          state
              .copyWith(requestState: ZegoRequestState.success)
              .copyWith(roomsList: r),
        );
      });
    }).catchError((onError) {
      CliLogger.error('there is an error from catch',
          level: CliLoggerLevel.three);
    });
  }
}
