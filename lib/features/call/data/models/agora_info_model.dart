import 'package:fourtyninehub/features/call/domain/entities/agora_info_entity.dart';

class AgoraInfoModel extends AgoraInfoEntity {
  const AgoraInfoModel({
    required super.rtcToken,
    required super.channelName,
    required super.uid,
  });

  factory AgoraInfoModel.fromJson(Map<String, dynamic> json) {
    return AgoraInfoModel(
        rtcToken: json['token'].toString(),
        channelName: json['channelName'].toString(),
        uid: json['uid']);
  }
}
