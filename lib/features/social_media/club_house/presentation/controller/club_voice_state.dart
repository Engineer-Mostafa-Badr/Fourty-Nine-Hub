// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import 'package:fourtyninehub/core/enums/zego_request_state.dart';

import '../../domain/entities/club_voice_room_entity.dart';

@immutable
sealed class ClubVoiceState {
  const ClubVoiceState();
}

//inital
class InitialClubVoiceState extends ClubVoiceState {
  const InitialClubVoiceState() : super();
}

//for adding room
class AddRoomState extends ClubVoiceState {
  final ZegoRequestState requestState;

  const AddRoomState({
    this.requestState = ZegoRequestState.initial,
  }) : super();
}

//for end leave search join
class RehashRoomState extends ClubVoiceState {
  final ZegoRequestState requestState;

  const RehashRoomState({this.requestState = ZegoRequestState.initial})
      : super();

  ClubVoiceState copyWith(ZegoRequestState? requestState) {
    return RehashRoomState(
      requestState: requestState ?? this.requestState,
    );
  }
}

//for get
class GetRoomState extends ClubVoiceState {
  final ZegoRequestState requestState;
  final List<ClubVoiceRoomEntity> roomsList;
  const GetRoomState({
    this.requestState = ZegoRequestState.initial,
    this.roomsList = const [],
  }) : super();

  ClubVoiceState copyWith(
      {ZegoRequestState? requestState, List<ClubVoiceRoomEntity>? roomsList}) {
    return GetRoomState(
      requestState: requestState ?? this.requestState,
      roomsList: roomsList ?? this.roomsList,
    );
  }
}
