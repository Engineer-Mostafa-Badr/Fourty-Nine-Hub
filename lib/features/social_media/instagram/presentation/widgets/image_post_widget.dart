import 'package:flutter/material.dart';
import '../../domain/entities/instagram_post_entity.dart';
import 'auto_play_video_widget.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../helpers/media_helper.dart';

class ImagePostWidget extends StatelessWidget {
  final InstagramPostEntity instagramPostEntity;
  final bool isVisible;
  final int currentIndex;

  const ImagePostWidget({
    super.key,
    required this.instagramPostEntity,
    required this.currentIndex,
    this.isVisible = false,

  });

  bool _mediaIsVideo() =>
      (MediaHelper.getMediaTypeFromExtension(
          instagramPostEntity.medias[currentIndex])) ==
      MediaType.video;

  @override
  Widget build(BuildContext context) {
    if (_mediaIsVideo()) {
      return AutoplayVideoWidget(
        videoUrl: instagramPostEntity.medias[currentIndex],
        videoId:
            instagramPostEntity.medias[currentIndex], // استخدام رابط الفيديو كمعرّف
        showControls: true,
        isReel: _mediaIsVideo(),
        instagramPostEntity: instagramPostEntity,
      );
    }
    return ImageFromInternet(
      image: instagramPostEntity.medias[currentIndex],
      height: 400,
      width: double.infinity,
    );
  }
}

// class ImagePostWidget extends StatefulWidget {
//   const ImagePostWidget({
//     super.key,
//     required this.imageUrl,
//   });
//   final String imageUrl;
//   @override
//   State<ImagePostWidget> createState() => _ImagePostWidgetState();
// }
// class _ImagePostWidgetState extends State<ImagePostWidget> {
//   // VideoPlayerController? _videoController;
//   // bool _isPlaying = false;
//   bool mediaIsVideo() =>
//       (MediaHelper.getMediaTypeFromExtension(widget.imageUrl)) ==
//       MediaType.video;
//   @override
//   Widget build(BuildContext context) {
//     if (mediaIsVideo()) {
//       return VideoWidget(
//         url: widget.imageUrl,
//       );
//     }
//     return ImageFromInternet(
//       image: widget.imageUrl,
//       height: 400,
//       width: double.infinity,
//     );
//   }
// }
