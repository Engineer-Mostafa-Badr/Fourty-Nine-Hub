import 'package:equatable/equatable.dart';

class AgoraInfoEntity extends Equatable {
  final String rtcToken;
  final String channel;
  final String channelId;
  final String permission;
  // final String uid;
  final String expiresAt;

  const AgoraInfoEntity(
      {required this.rtcToken,
      required this.channel,
      required this.channelId,
      required this.permission,
      // required this.uid,
      required this.expiresAt});

  @override
  List<Object?> get props => [rtcToken, channel, channelId, permission, expiresAt];
}
