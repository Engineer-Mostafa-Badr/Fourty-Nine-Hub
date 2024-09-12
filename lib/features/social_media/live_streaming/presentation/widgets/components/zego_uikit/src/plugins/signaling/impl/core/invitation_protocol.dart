// Project imports:

import '../../../../services/defines/user.dart';

class ZegoUIKitInvitationSendProtocol {
  ZegoUIKitInvitationSendProtocol.empty();

  ZegoUIKitInvitationSendProtocol({
    required this.inviter,
    required this.type,
    required this.customData,
  });

  ZegoUIKitUser inviter = ZegoUIKitUser.empty();
  int type = -1;
  String customData = '';

  Map<String, dynamic> toJson() => {
        'inviter_id': inviter.id,
        'inviter_name': inviter.name,
        'type': type,
        'data': customData,
      };

  factory ZegoUIKitInvitationSendProtocol.fromJson(Map<String, dynamic> json) {
    return ZegoUIKitInvitationSendProtocol(
      inviter: ZegoUIKitUser(
        id: json['inviter_id'] as String? ?? '',
        name: json['inviter_name'] as String? ?? '',
      ),
      type: json['type'] as int? ?? -1,
      customData: json['data'] as String? ?? '',
    );
  }
}
