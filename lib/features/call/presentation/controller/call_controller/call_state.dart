import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';

abstract class CallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoCalls extends CallState {}

class HasCall extends CallState {
  final RtcEngine engine;
  final CallData callData;
  final bool isSpeaker;
  final bool isMute;

  HasCall({
    required this.engine,
    required this.callData,
    this.isSpeaker = false,
    this.isMute = false,
  });

  HasCall copyWith({bool? isSpeaker, bool? isMute}) => HasCall(
        engine: engine,
        callData: callData,
        isSpeaker: isSpeaker ?? this.isSpeaker,
        isMute: isMute ?? this.isMute,
      );

  @override
  List<Object?> get props => [
        engine,
        callData,
        isSpeaker,
        isMute,
      ];
}
