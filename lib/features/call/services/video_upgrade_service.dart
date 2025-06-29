// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/core/utils/logging_service.dart';
// import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/plugins/signaling/impl/service/invitation_service_advance.dart';
// import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/services/uikit_service.dart';

// /// Service to handle video call upgrade functionality using ZegoCloud's advance invitation system
// class VideoUpgradeService {
//   static final VideoUpgradeService _instance = VideoUpgradeService._internal();
//   factory VideoUpgradeService() => _instance;
//   VideoUpgradeService._internal();

//   static const int VIDEO_UPGRADE_REQUEST_TYPE = 100; // Custom type for video upgrade
//   static const int UPGRADE_TIMEOUT_SECONDS = 30;

//   /// Send a video upgrade request to the other user
//   Future<bool> sendVideoUpgradeRequest({
//     required String receiverId,
//     required String receiverName,
//     required String callId,
//   }) async {
//     try {
//       LoggingService.info("📹 Sending video upgrade request to: $receiverId");

//       // Prepare the custom data for the video upgrade request
//       final upgradeData = {
//         'type': 'video_upgrade_request',
//         'call_id': callId,
//         'sender_name': ZegoUIKit().getLocalUser().name,
//         'message': 'wants to turn on the camera',
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };

//       final result = await ZegoSignalingPluginInvitationServiceAdvance()
//           .sendAdvanceInvitation(
//         inviterID: ZegoUIKit().getLocalUser().id,
//         inviterName: ZegoUIKit().getLocalUser().name,
//         invitees: [receiverId],
//         type: VIDEO_UPGRADE_REQUEST_TYPE,
//         data: jsonEncode(upgradeData),
//         timeout: UPGRADE_TIMEOUT_SECONDS,
//       );

//       if (result.error == null) {
//         LoggingService.info("✅ Video upgrade request sent successfully");
//         return true;
//       } else {
//         LoggingService.error("❌ Failed to send video upgrade request", error: result.error);
//         return false;
//       }
//     } catch (e) {
//       LoggingService.error("❌ Error sending video upgrade request", error: e);
//       return false;
//     }
//   }

//   /// Accept a video upgrade request
//   Future<bool> acceptVideoUpgradeRequest({
//     required String invitationId,
//     required String inviterId,
//     required String callId,
//   }) async {
//     try {
//       LoggingService.info("✅ Accepting video upgrade request: $invitationId");

//       final responseData = {
//         'type': 'video_upgrade_accepted',
//         'call_id': callId,
//         'accepter_name': ZegoUIKit().getLocalUser().name,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };

//       final result = await ZegoSignalingPluginInvitationServiceAdvance()
//           .acceptAdvanceInvitation(
//         inviterID: inviterId,
//         data: jsonEncode(responseData),
//         invitationID: invitationId,
//       );

//       if (result.error == null) {
//         LoggingService.info("✅ Video upgrade request accepted successfully");
//         return true;
//       } else {
//         LoggingService.error("❌ Failed to accept video upgrade request", error: result.error);
//         return false;
//       }
//     } catch (e) {
//       LoggingService.error("❌ Error accepting video upgrade request", error: e);
//       return false;
//     }
//   }

//   /// Reject a video upgrade request
//   Future<bool> rejectVideoUpgradeRequest({
//     required String invitationId,
//     required String inviterId,
//     required String callId,
//   }) async {
//     try {
//       LoggingService.info("❌ Rejecting video upgrade request: $invitationId");

//       final responseData = {
//         'type': 'video_upgrade_rejected',
//         'call_id': callId,
//         'rejecter_name': ZegoUIKit().getLocalUser().name,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };

//       final result = await ZegoSignalingPluginInvitationServiceAdvance()
//           .refuseAdvanceInvitation(
//         inviterID: inviterId,
//         data: jsonEncode(responseData),
//         invitationID: invitationId,
//       );

//       if (result.error == null) {
//         LoggingService.info("✅ Video upgrade request rejected successfully");
//         return true;
//       } else {
//         LoggingService.error("❌ Failed to reject video upgrade request", error: result.error);
//         return false;
//       }
//     } catch (e) {
//       LoggingService.error("❌ Error rejecting video upgrade request", error: e);
//       return false;
//     }
//   }

//   /// Cancel a video upgrade request (for sender)
//   Future<bool> cancelVideoUpgradeRequest({
//     required String invitationId,
//     required List<String> invitees,
//   }) async {
//     try {
//       LoggingService.info("🚫 Canceling video upgrade request: $invitationId");

//       final cancelData = {
//         'type': 'video_upgrade_cancelled',
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       };

//       final result = await ZegoSignalingPluginInvitationServiceAdvance()
//           .cancelAdvanceInvitation(
//         invitees: invitees,
//         data: jsonEncode(cancelData),
//         invitationID: invitationId,
//       );

//       if (result.error == null) {
//         LoggingService.info("✅ Video upgrade request cancelled successfully");
//         return true;
//       } else {
//         LoggingService.error("❌ Failed to cancel video upgrade request", error: result.error);
//         return false;
//       }
//     } catch (e) {
//       LoggingService.error("❌ Error canceling video upgrade request", error: e);
//       return false;
//     }
//   }

//   /// Check if the invitation is a video upgrade request
//   static bool isVideoUpgradeRequest(Map<String, dynamic> invitationData) {
//     final type = invitationData['type'] as int?;
//     return type == VIDEO_UPGRADE_REQUEST_TYPE;
//   }

//   /// Parse video upgrade request data
//   static Map<String, dynamic>? parseVideoUpgradeData(String data) {
//     try {
//       final parsed = jsonDecode(data) as Map<String, dynamic>;
//       final type = parsed['type'] as String?;
      
//       if (type != null && type.startsWith('video_upgrade')) {
//         return parsed;
//       }
//       return null;
//     } catch (e) {
//       LoggingService.error("❌ Error parsing video upgrade data", error: e);
//       return null;
//     }
//   }

//   /// Show video upgrade request dialog
//   static void showVideoUpgradeDialog(
//     BuildContext context, {
//     required String senderName,
//     required String invitationId,
//     required String inviterId,
//     required String callId,
//     required VoidCallback onAccept,
//     required VoidCallback onReject,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1E1E1E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               const Icon(
//                 Icons.videocam,
//                 color: Colors.blue,
//                 size: 28,
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Text(
//                   'Video Call',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: senderName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const TextSpan(text: ' wants to turn on the camera'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Do you want to enable video for this call?',
//                 style: TextStyle(
//                   color: Colors.white60,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 onReject();
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               child: const Text(
//                 'Decline',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 onAccept();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Accept',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Show video upgrade waiting dialog (for sender)
//   static void showVideoUpgradeWaitingDialog(
//     BuildContext context, {
//     required String receiverName,
//     required VoidCallback onCancel,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1E1E1E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Row(
//             children: [
//               Icon(
//                 Icons.videocam,
//                 color: Colors.blue,
//                 size: 28,
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Video Request',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(
//                 color: Colors.blue,
//                 strokeWidth: 3,
//               ),
//               const SizedBox(height: 20),
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                   children: [
//                     const TextSpan(text: 'Waiting for '),
//                     TextSpan(
//                       text: receiverName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const TextSpan(text: ' to respond...'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 onCancel();
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
