import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/auto_play_video_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/helpers/media_helper.dart';

class ImagePostWidget extends StatelessWidget {
  final InstagramPostEntity instagramPostEntity;
  final bool isVisible;

  const ImagePostWidget({
    super.key,
    required this.instagramPostEntity,
    this.isVisible = false,
  });

  bool _mediaIsVideo() =>
      (MediaHelper.getMediaTypeFromExtension(
          instagramPostEntity.medias.first)) ==
      MediaType.video;

  @override
  Widget build(BuildContext context) {
    if (_mediaIsVideo()) {
      return AutoplayVideoWidget(
        videoUrl: instagramPostEntity.medias.first,
        videoId:
            instagramPostEntity.medias.first, // استخدام رابط الفيديو كمعرّف
        showControls: true,
        isReel: _mediaIsVideo(),
        instagramPostEntity: instagramPostEntity,
      );
    }
    return ImageFromInternet(
      image: instagramPostEntity.medias.first,
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
