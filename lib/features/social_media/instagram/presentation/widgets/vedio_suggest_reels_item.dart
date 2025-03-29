import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/videos/video_player.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:video_player/video_player.dart';

class VedioSuggestReelsItem extends StatefulWidget {
  const VedioSuggestReelsItem({
    super.key,
    required this.videoReelUrl,
  });

  final String videoReelUrl;

  @override
  State<VedioSuggestReelsItem> createState() => _VedioSuggestReelsItemState();
}

class _VedioSuggestReelsItemState extends State<VedioSuggestReelsItem> {
  // late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;

  @override
  // void initState() {
  //   inializePlayer();
  //   super.initState();
  // }

  // Future<void> inializePlayer() async {
  //   _videoPlayerController =
  //       VideoPlayerController.networkUrl(Uri.parse(widget.videoReelUrl));

  //   await _videoPlayerController.initialize();

  //     _chewieController = ChewieController(
  //       videoPlayerController: _videoPlayerController,
  //       autoPlay: true,
  //       looping: true,
  //       allowFullScreen: true,
  //       allowMuting: true,
  //     );

  //   setState(() {});
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   _chewieController?.dispose();
  //   super.dispose();
  // }
  // TODO: implement build
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 222 / 340,
      // child: LayoutBuilder(
      //   builder: (context, constraints) {
      //     final chewieController = _chewieController;
      //     if (chewieController != null) {
      //       return Chewie(controller: chewieController);
      //     } else {
      //       return const SizedBox();
      //     }
      //   },
      // ),
      child: VideoPlayerWidget(
        url: widget.videoReelUrl,
      ),
      // child: ImageFromInternet(
      //   image: widget.videoReelUrl,
      //   borderRadius: BorderRadius.circular(4),
      // ),
    );
  }
}
