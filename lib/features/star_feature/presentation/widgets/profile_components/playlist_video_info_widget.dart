import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'playlist_bottom_sheet_constants.dart';

class PlaylistVideoInfoWidget extends StatelessWidget {
  final StarEntity video;
  final String uniqueId;

  const PlaylistVideoInfoWidget({
    super.key,
    required this.video,
    required this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('video_info_$uniqueId'),
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          _buildVideoThumbnail(),
          const SizedBox(width: 12),
          _buildVideoInfo(),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    return Container(
      width: PlaylistBottomSheetConstants.videoThumbnailWidth,
      height: PlaylistBottomSheetConstants.videoThumbnailHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.smallBorderRadius),
        color: Colors.grey[300],
        image: const DecorationImage(
          image: AssetImage(PlaylistBottomSheetConstants.testVideoAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "${video.user.firstName} ${video.user.lastName}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}