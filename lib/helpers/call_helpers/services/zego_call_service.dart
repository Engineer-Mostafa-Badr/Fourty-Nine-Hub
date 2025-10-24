// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'call_service.dart';
//
// class ZegoCallService implements CallService {
//   late ZegoUIKitPrebuiltCall _callKit;
//   final String appID;
//   final String appSign;
//   final String userID;
//   final String userName;
//   final bool isVideoCall;
//
//   ZegoCallService({
//     required this.appID,
//     required this.appSign,
//     required this.userID,
//     required this.userName,
//     required this.isVideoCall,
//   });
//
//   @override
//   Future<void> initializeService() async {
//     // ZegoCloud initialization is handled by the widget itself
//   }
//
//   @override
//   Widget buildCallView() {
//     return ZegoUIKitPrebuiltCall(
//       appID: int.parse(appID),
//       appSign: appSign,
//       userID: userID,
//       userName: userName,
//       callID: "unique_call_id",
//       config: isVideoCall
//           ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//           : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//     );
//   }
//
//   @override
//   Future<void> joinCall(String channelName, int uid) async {
//     // Handled by ZegoUIKitPrebuiltCall widget
//   }
//
//   @override
//   Future<void> leaveCall() async {
//     // Handled by ZegoUIKitPrebuiltCall widget
//   }
//
//   @override
//   Future<void> toggleMute() async {
//     // Handled by ZegoUIKitPrebuiltCall widget
//   }
//
//   @override
//   Future<void> toggleVideo() async {
//     // Handled by ZegoUIKitPrebuiltCall widget
//   }
//
//   @override
//   Future<void> switchCamera() async {
//     // Handled by ZegoUIKitPrebuiltCall widget
//   }
// }
