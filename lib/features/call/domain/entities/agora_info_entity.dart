import 'package:equatable/equatable.dart';

class AgoraInfoEntity extends Equatable {
  final String rtcToken;
  final String channelName;
  final String uid;

  const AgoraInfoEntity(
      {required this.rtcToken, required this.channelName, required this.uid});

  @override
  List<Object?> get props => [rtcToken, channelName, uid];
}
