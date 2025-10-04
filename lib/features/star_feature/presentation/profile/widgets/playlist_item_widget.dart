import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'playlist_bottom_sheet_constants.dart';

class PlaylistItemWidget extends StatelessWidget {
  final PlaylistEntity playlist;
  final String uniqueId;
  final VoidCallback onTap;

  const PlaylistItemWidget({
    super.key,
    required this.playlist,
    required this.uniqueId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('playlist_item_${playlist.id}_$uniqueId'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                _buildPlaylistThumbnail(),
                const SizedBox(width: 12),
                _buildPlaylistInfo(context),
                const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.PRIMARY_COLOR,
                  size: PlaylistBottomSheetConstants.iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistThumbnail() {
    return SizedBox(
      width: PlaylistBottomSheetConstants.playlistThumbnailSize,
      height: PlaylistBottomSheetConstants.playlistThumbnailSize,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.smallBorderRadius),
              color: Colors.grey[300],
              image: playlist.thumbnail.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(playlist.thumbnail),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: playlist.thumbnail.isEmpty
                ? Icon(Icons.playlist_play, color: Colors.grey[600])
                : null,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '${playlist.videosCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playlist.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            context.isArabic ? '${playlist.videosCount} فيديو' : '${playlist.videosCount} videos',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          if (playlist.description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              playlist.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}