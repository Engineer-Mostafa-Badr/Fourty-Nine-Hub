// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import 'package:fourtyninehub/core/enums/zego_request_state.dart';

import '../../domain/entities/club_voice_room_entity.dart';

extension MeetingStateX on ClubVoiceState {
  bool get isInitial => status == ZegoRequestState.initial;
  bool get isLoading => status == ZegoRequestState.loading;
  bool get isSuccess => status == ZegoRequestState.success;
  bool get isFailure => status == ZegoRequestState.failure;
}

@immutable
class ClubVoiceState {
  final ZegoRequestState status;
  final List<ClubVoiceRoomEntity> roomsList;
  final String roomId;
  ClubVoiceState copyWith({
    ZegoRequestState? requestState,
    List<ClubVoiceRoomEntity>? roomsList,
    String? roomId,
  }) {
    return ClubVoiceState(
      roomsList: roomsList ?? this.roomsList,
      status: requestState ?? status,
      roomId: roomId ?? this.roomId,
    );
  }

  const ClubVoiceState({
    this.status = ZegoRequestState.initial,
    this.roomsList = const [],
    this.roomId = '',
  });
}
