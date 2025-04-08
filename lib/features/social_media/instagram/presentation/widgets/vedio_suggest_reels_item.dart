// import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
import 'package:video_player/video_player.dart';

class ReelCard extends StatelessWidget {
  final ReelEntity reel;
  final VideoPlayerController? controller;
  final bool isPlaying;

  const ReelCard({
    super.key,
    required this.reel,
    this.controller,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45, // عرض ~45% من الشاشة
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: controller != null && controller!.value.isInitialized
          ? VideoPlayer(controller!)
          : Image.network(
              reel.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.error)),
                );
              },
            ),
      //  Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     // الفيديو أو الصورة المصغرة
      //     controller != null && controller!.value.isInitialized
      //         ? VideoPlayer(controller!)
      //         : Image.network(
      //             reel.thumbnail,
      //             fit: BoxFit.cover,
      //             errorBuilder: (context, error, stackTrace) {
      //               return Container(
      //                 color: Colors.grey.shade300,
      //                 child: const Center(child: Icon(Icons.error)),
      //               );
      //             },
      //           ),

      //     // // طبقة شفافة سوداء
      //     // Container(
      //     //   decoration: BoxDecoration(
      //     //     gradient: LinearGradient(
      //     //       begin: Alignment.topCenter,
      //     //       end: Alignment.bottomCenter,
      //     //       colors: [
      //     //         Colors.transparent,
      //     //         Colors.black.withOpacity(0.7),
      //     //       ],
      //     //     ),
      //     //   ),
      //     // ),
      //     // // مؤشر التشغيل
      //     // if (isPlaying)
      //     //   Positioned(
      //     //     top: 8,
      //     //     right: 8,
      //     //     child: Container(
      //     //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //     //       decoration: BoxDecoration(
      //     //         color: Colors.black.withOpacity(0.6),
      //     //         borderRadius: BorderRadius.circular(4),
      //     //       ),
      //     //       child: const Text(
      //     //         'يعمل الآن',
      //     //         style: TextStyle(color: Colors.white, fontSize: 10),
      //     //       ),
      //     //     ),
      //     //   ),
      //   ],
      // ),
    );
  }
}

// class VedioSuggestReelsItem extends StatefulWidget {
//   const VedioSuggestReelsItem({
//     super.key,
//     required this.videoReelUrl,
//   });

//   final String videoReelUrl;

//   @override
//   State<VedioSuggestReelsItem> createState() => _VedioSuggestReelsItemState();
// }

// class _VedioSuggestReelsItemState extends State<VedioSuggestReelsItem> {
//   // late VideoPlayerController _videoPlayerController;
//   // ChewieController? _chewieController;

//   @override
//   // void initState() {
//   //   inializePlayer();
//   //   super.initState();
//   // }

//   // Future<void> inializePlayer() async {
//   //   _videoPlayerController =
//   //       VideoPlayerController.networkUrl(Uri.parse(widget.videoReelUrl));

//   //   await _videoPlayerController.initialize();

//   //     _chewieController = ChewieController(
//   //       videoPlayerController: _videoPlayerController,
//   //       autoPlay: true,
//   //       looping: true,
//   //       allowFullScreen: true,
//   //       allowMuting: true,
//   //     );

//   //   setState(() {});
//   // }

//   // @override
//   // void dispose() {
//   //   _videoPlayerController.dispose();
//   //   _chewieController?.dispose();
//   //   super.dispose();
//   // }
//   // TODO: implement build
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 222 / 340,
//       // child: LayoutBuilder(
//       //   builder: (context, constraints) {
//       //     final chewieController = _chewieController;
//       //     if (chewieController != null) {
//       //       return Chewie(controller: chewieController);
//       //     } else {
//       //       return const SizedBox();
//       //     }
//       //   },
//       // ),
//       child: VideoPlayerWidget(
//         url: widget.videoReelUrl,
//       ),
//       // child: ImageFromInternet(
//       //   image: widget.videoReelUrl,
//       //   borderRadius: BorderRadius.circular(4),
//       // ),
//     );
//   }
// }
