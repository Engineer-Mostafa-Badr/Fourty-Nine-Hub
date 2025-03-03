import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';

class CallData extends Equatable {
  final bool isCaller;
  final String isRealCall;
  final String callerName;
  final String callerImage;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String rtcToken;
  final String channel;
  final String serviceType;
  final String zegoAppId;
  final String zegoAppSign;
  final String agoraAppId;
  final String uid;
  final String fcmToken;
  final String callType;
  final String channelId;
  final String permission;
  final String expiresAt;

  const CallData({
    required this.isCaller,
    required this.isRealCall,
    required this.callerName,
    required this.callerImage,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.rtcToken,
    required this.channel,
    required this.serviceType,
    required this.zegoAppId,
    required this.zegoAppSign,
    required this.agoraAppId,
    required this.uid,
    required this.fcmToken,
    required this.callType,
    required this.channelId,
    required this.permission,
    required this.expiresAt,
  });

  factory CallData.fromMap( Map<String, dynamic> map,  bool isCaller) {
    return CallData(
      isCaller: isCaller,
      isRealCall: map['is_real_call']?? true,
      callerName: map['caller_name'] ?? '',
      callerImage: map['caller_image'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      receiverName: map['receiver_name'] ?? '',
      receiverImage: map['receiver_image'] ?? '',
      serviceType: map['service_type'] ?? '',
      zegoAppId: map['zego_app_id'].toString(),
      zegoAppSign: map['zego_app_sign'] ?? '',
      agoraAppId: map['agora_app_id'] ?? '',
      uid: map['uid'] ?? '',
      fcmToken: map['fcm_token'] ?? '',
      callType: map['call_type'] ?? CallType.audio.name.toString(),
      rtcToken: map['rtc_token'] ?? '',
      channel: map['channel'] ?? '',
      channelId: map['channelId'] ?? '',
      permission: map['permission'] ?? '',
      expiresAt: map['expires_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap(
      {
      required String isRealCall,
      String? fcmToken,
      String? rtcToken,
      String? channel,
      String? channelId,
      String? permission,
      String? expiresAt}) {
    return {
      'is_real_call': isRealCall,
      'caller_name': callerName.toString(),
      'caller_image': callerImage.toString(),
      'receiver_id': receiverId.toString(),
      'receiver_name': receiverName.toString(),
      'receiver_image': receiverImage.toString(),
      'rtc_token': rtcToken ?? this.rtcToken.toString(),
      'channel': channel ?? this.channel.toString(),
      'channelId': channelId ?? this.channelId.toString(),
      'permission': permission ?? this.permission.toString(),
      'expires_at': expiresAt ?? this.expiresAt.toString(),
      'service_type': serviceType.toString(),
      'zego_app_id': zegoAppId.toString(),
      'zego_app_sign': zegoAppSign.toString(),
      'agora_app_id': agoraAppId.toString(),
      // 'uid': uid,
      'fcm_token': fcmToken ?? this.fcmToken.toString(),
      'call_type': callType,
    };
  }

  @override
  List<Object?> get props => [
        isCaller,
        callerName,
        callerImage,
        receiverName,
        receiverImage,
        rtcToken,
        channel,
        // uid,
        fcmToken,
        callType,
        isCaller,
        serviceType,
        zegoAppId,
        zegoAppSign,
        agoraAppId,
      ];
}
