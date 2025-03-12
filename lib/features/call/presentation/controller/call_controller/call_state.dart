import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';

abstract class CallState extends Equatable {}

class NoCalls extends CallState {
  @override
  List<Object?> get props => [];
}

class HasCall extends CallState {
  final RtcEngine? engine;
  final CallData callData;
  final bool isMute;
  final bool isSpeaker;
  final bool isVideoEnabled;
  final bool isZegoCloud;

  HasCall({
    this.engine,
    required this.callData,
    this.isMute = false,
    this.isSpeaker = false,
    this.isVideoEnabled = false,
    this.isZegoCloud = false,
  });

  HasCall copyWith({
    RtcEngine? engine,
    CallData? callData,
    bool? isMute,
    bool? isSpeaker,
    bool? isVideoEnabled,
    bool? isZegoCloud,
  }) {
    return HasCall(
      engine: engine ?? this.engine,
      callData: callData ?? this.callData,
      isMute: isMute ?? this.isMute,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isZegoCloud: isZegoCloud ?? this.isZegoCloud,
    );
  }

  @override
  List<Object?> get props => [
        engine,
        callData,
        isMute,
        isSpeaker,
        isVideoEnabled,
        isZegoCloud,
      ];
}
