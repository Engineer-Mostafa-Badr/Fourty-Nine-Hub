import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';

class ThumbnailWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final String? duration;
  final bool showVolumeIcon;
  final bool showPlayIcon;
  final VoidCallback? onTap;

  const ThumbnailWidget({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.duration,
    this.showVolumeIcon = true,
    this.showPlayIcon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: Stack(
          children: [
            // Main image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/testforvideo.jpg',
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/testforvideo.jpg',
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
            ),

            // Volume icon
            if (showVolumeIcon)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

            // Duration overlay
            if (duration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration!.toArabicNumbers(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Play icon
            if (showPlayIcon)
              Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
