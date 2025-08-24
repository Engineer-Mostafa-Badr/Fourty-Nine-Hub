// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';

// class TalentVideo extends StatefulWidget {
//   const TalentVideo({super.key, required this.path});
//   final String path;
//   @override
//   State<TalentVideo> createState() => _TalentVideoState();
// }

// class _TalentVideoState extends State<TalentVideo> {
//   VideoPlayerController? _videoController;

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   initState(){
//     super.initState();
//     _initializeVideo(widget.path);
//   }


//   void _initializeVideo(String path) {
//     if (_videoController != null) {
//       _videoController!.dispose();
//     }
//     _videoController = VideoPlayerController.file(File(path))
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController!.play();
//         _videoController!.setLooping(true);
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         height: 300.h,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             SizedBox(
//               height: 300.h,
//               width: double.infinity,
//               child: AspectRatio(
//                 aspectRatio: _videoController!.value.aspectRatio,
//                 child: Container(
//                   height: 300.h,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                   ),
//                   child: FittedBox(
//                     fit: BoxFit.contain,
//                     child: SizedBox(
//                       width: _videoController!.value.size.width,
//                       height: _videoController!.value.size.height,
//                       child: VideoPlayer(_videoController!),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const Align(
//               alignment: Alignment.center,
//               child: Icon(
//                 Icons.play_arrow,
//                 color: Colors.white,
//                 size: 50,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
