// Project imports:


import '../../../../services/defines/user.dart';

class ZegoUIKitAdvanceInvitationSendProtocol {
  ZegoUIKitAdvanceInvitationSendProtocol.empty();

  ZegoUIKitAdvanceInvitationSendProtocol({
    required this.inviter,
    required this.invitees,
    required this.type,
    required this.customData,
  });

  ZegoUIKitUser inviter = ZegoUIKitUser.empty();
  List<String> invitees = const [];
  int type = -1;
  String customData = '';

  Map<String, dynamic> toJson() => {
        'inviter': inviter,
        'invitees': invitees,
        'type': type,
        'custom_data': customData,
      };

  factory ZegoUIKitAdvanceInvitationSendProtocol.fromJson(
      Map<String, dynamic> json) {
    return ZegoUIKitAdvanceInvitationSendProtocol(
      inviter: ZegoUIKitUser.fromJson(
        json['inviter'] as Map<String, dynamic>? ?? {},
      ),
      invitees: List<String>.from(json['invitees']),
      type: json['type'] as int? ?? -1,
      customData: json['custom_data'] as String? ?? '',
    );
  }
}

class ZegoUIKitAdvanceInvitationAcceptProtocol {
  ZegoUIKitAdvanceInvitationAcceptProtocol.empty();

  ZegoUIKitAdvanceInvitationAcceptProtocol({
    required this.inviter,
    required this.customData,
  });

  /// accept invitation from [inviter]
  ZegoUIKitUser inviter = ZegoUIKitUser.empty();

  /// [invitee]'s [customData]
  String customData = '';

  Map<String, dynamic> toJson() => {
        'inviter': inviter,
        'custom_data': customData,
      };

  factory ZegoUIKitAdvanceInvitationAcceptProtocol.fromJson(
      Map<String, dynamic> json) {
    return ZegoUIKitAdvanceInvitationAcceptProtocol(
      inviter: ZegoUIKitUser.fromJson(
        json['inviter'] as Map<String, dynamic>? ?? {},
      ),
      customData: json['custom_data'],
    );
  }
}
