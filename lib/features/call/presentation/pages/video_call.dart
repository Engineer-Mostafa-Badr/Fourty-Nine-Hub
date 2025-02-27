// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
// import 'package:fourtyninehub/helpers/call_helpers/services/call_service.dart';
// import 'package:fourtyninehub/helpers/call_helpers/services/zego_call_service.dart';
// import 'package:fourtyninehub/res/style/const.dart';

// class WhatsAppVideoCallScreen extends StatefulWidget {
//   final UserModel receiver;
//   final UserModel sender;
//   final String serviceType;
//   final String channelName;

//   const WhatsAppVideoCallScreen({
//     super.key,
//     required this.receiver,
//     required this.sender,
//     required this.serviceType,
//     required this.channelName,
//   });

//   @override
//   State<WhatsAppVideoCallScreen> createState() => _WhatsAppVideoCallScreenState();
// }

// class _WhatsAppVideoCallScreenState extends State<WhatsAppVideoCallScreen> {
//   late CallService _callService;
//   bool _isMuted = false;
//   bool _isVideoEnabled = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCallService();
//   }

//   void _initializeCallService() {
//     if (widget.serviceType == 'zegocloud') {
//       _callService = ZegoCallService(
//         appID: UIConst.zegoAppId,
//         appSign: UIConst.zegoAppSign,
//         userID: widget.sender.id,
//         userName: widget.sender.fullName ?? 'Unknown',
//         isVideoCall: true,
//       );
//     } else {
//       // Initialize Agora service (existing implementation)
//     }
//     _callService.initializeService();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Main call view
//           _callService.buildCallView(),
          
//           // Controls overlay
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _builTopAppBar(context: context),
//               _buildButtonButtons(context: context),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   _buildButtonButtons({required BuildContext context}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 22.sp, left: 28.w, right: 28.w),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFF11191C),
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CallControlButton(
//               icon: Icons.switch_camera,
//               onPressed: () => _callService.switchCamera(),
//             ),
//             _fixedWidth(),
//             CallControlButton(
//               icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
//               onPressed: () {
//                 setState(() => _isVideoEnabled = !_isVideoEnabled);
//                 _callService.toggleVideo();
//               },
//             ),
//             _fixedWidth(),
//             CallControlButton(
//               icon: _isMuted ? Icons.mic_off : Icons.mic,
//               onPressed: () {
//                 setState(() => _isMuted = !_isMuted);
//                 _callService.toggleMute();
//               },
//             ),
//             _fixedWidth(),
//             CallControlButton(
//               icon: Icons.call_end,
//               onPressed: () {
//                 _callService.leaveCall();
//                 Navigator.pop(context);
//               },
//               backgroundColor: Colors.red,
//               iconColor: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _fixedWidth() {
//     return SizedBox(
//       width: 12.w,
//     );
//   }

//   _builTopAppBar({required BuildContext context}) {
//     return Padding(
//       padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 40.h),
//       child: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 10.w,
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       widget.sender.fullName ?? "Unknown",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Ringing ...',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                       ),
//                     )
//                   ],
//                 ),
//                 CallControlButton(
//                   icon: Icons.person_add_alt_rounded,
//                   onPressed: () {},
//                   size: 57.sp,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 14.h,
//             ),
//             CallControlButton(
//               icon: Icons.flip_camera_ios_rounded,
//               onPressed: () {},
//             ),
//             SizedBox(
//               height: 14.h,
//             ),
//             CallControlButton(
//               icon: Icons.edit,
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CallControlButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final double? size;

//   const CallControlButton({
//     super.key,
//     required this.icon,
//     required this.onPressed,
//     this.backgroundColor,
//     this.iconColor,
//     this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: size ?? 52,
//         height: size ?? 52,
//         decoration: BoxDecoration(
//           color: backgroundColor ?? Color(0xFF1E282A),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           color: iconColor ?? Colors.white,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }
