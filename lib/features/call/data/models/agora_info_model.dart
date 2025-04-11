

import 'package:fourtyninehub/features/call/domain/entities/agora_info_entity.dart';

class AgoraInfoModel extends AgoraInfoEntity {
  const AgoraInfoModel({
    required super.rtcToken,
    required super.channel,
    required super.channelId,
    required super.permission,
    required super.expiresAt,
  });

  factory AgoraInfoModel.fromJson(Map<String, dynamic> json) {
    return AgoraInfoModel(
      rtcToken: json['token'].toString(),
      channel: json['channelName'].toString(),
      channelId: json['channelId'].toString(),
      permission: "",
      // json['permission'].toString(),
      expiresAt: "",
      // json['expiresAt'].toString(),
    );
  }
}
