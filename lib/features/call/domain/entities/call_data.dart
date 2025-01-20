import 'package:equatable/equatable.dart';

class CallData extends Equatable {
  final bool isCaller;
  final String callerName;
  final String callerImage;
  final String receiverName;
  final String receiverImage;
  final String rtcToken;
  final String channelName;
  final String uid;
  final String fcmToken;

  const CallData({
    required this.isCaller,
    required this.callerName,
    required this.callerImage,
    required this.receiverName,
    required this.receiverImage,
    required this.rtcToken,
    required this.channelName,
    required this.uid,
    required this.fcmToken,
  });

  factory CallData.fromMap(Map<String, dynamic> map, bool isCaller) {
    return CallData(
      isCaller: isCaller,
      callerName: map['caller_name'] ?? '',
      callerImage: map['caller_image'] ?? '',
      receiverName: map['receiver_name'] ?? '',
      receiverImage: map['receiver_image'] ?? '',
      rtcToken: map['rtc_token'] ?? '',
      channelName: map['channel_name'] ?? '',
      uid: map['uid'] ?? '',
      fcmToken: map['fcm_token'] ?? '',
    );
  }

  Map<String, dynamic> toMap({String? fcmToken}) {
    return {
      'caller_name': callerName,
      'caller_image': callerImage,
      'receiver_name': receiverName,
      'receiver_image': receiverImage,
      'rtc_token': rtcToken,
      'channel_name': channelName,
      'uid': uid,
      'fcm_token': fcmToken ?? this.fcmToken,
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
        channelName,
        uid,
        fcmToken,
      ];
}
