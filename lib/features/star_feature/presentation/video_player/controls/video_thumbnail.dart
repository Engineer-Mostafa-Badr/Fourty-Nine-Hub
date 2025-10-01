import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Video thumbnail widget with loading and error states
class VideoThumbnail extends StatelessWidget {
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;

  const VideoThumbnail({
    super.key,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget thumbnailWidget;

    if (thumbnailUrl == null || thumbnailUrl!.isEmpty || !thumbnailUrl!.startsWith('http')) {
      // No valid thumbnail - show placeholder
      thumbnailWidget = errorWidget ??
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(
                Icons.video_library,
                color: Colors.white38,
                size: 64,
              ),
            ),
          );
    } else {
      // Load network thumbnail
      thumbnailWidget = CachedNetworkImage(
        imageUrl: thumbnailUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white38,
                ),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white38,
                  size: 64,
                ),
              ),
            ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: thumbnailWidget,
      );
    }

    return thumbnailWidget;
  }
}
