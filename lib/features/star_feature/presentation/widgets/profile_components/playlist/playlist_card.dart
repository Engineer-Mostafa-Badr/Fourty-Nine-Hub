import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/thumbnail_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

class PlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;
  final VoidCallback? onTap;
  final bool showMenu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
    this.showMenu = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 16),
          vertical: _getResponsiveSpacing(context, 8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(_getResponsiveBorderRadius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Playlist Thumbnail
            _buildPlaylistThumbnail(context),

            SizedBox(width: _getResponsiveSpacing(context, 16)),

            // Playlist Info
            Expanded(
              child: _buildPlaylistInfo(context),
            ),

            // Menu or Play Button
            if (showMenu && (onEdit != null || onDelete != null))
              _buildMenuButton(context)
            else
              _buildPlayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistThumbnail(BuildContext context) {
    final thumbnailSize = _getResponsivePadding(context, 80);

    return Container(
      width: thumbnailSize,
      height: thumbnailSize,
      margin: EdgeInsets.all(_getResponsiveSpacing(context, 12)),
      child: Stack(
        children: [
          // Main thumbnail
          ThumbnailWidget(
            imageUrl: playlist.thumbnail,
            width: thumbnailSize,
            height: thumbnailSize,
            showPlayIcon: true,
          ),

          // Video count overlay
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSpacing(context, 6),
                vertical: _getResponsiveSpacing(context, 2),
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${playlist.videosCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getResponsiveFontSize(context, 10),
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
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: _getResponsiveSpacing(context, 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist Name
          Text(
            playlist.name,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: _getResponsiveSpacing(context, 4)),

          // Video count and creation date
          Text(
            context.isArabic
                ? '${playlist.videosCount} فيديو • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}'
                : '${playlist.videosCount} videos • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 13),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: _getResponsiveSpacing(context, 6)),

          // Description (if available)
          if (playlist.description.isNotEmpty)
            Text(
              playlist.description,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 12),
                color: Colors.grey[500],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        ManageVibration.vibrate();
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onEdit != null)
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20, color: Colors.grey[700]),
                SizedBox(width: 12),
                Text(
                  context.isArabic ? 'تعديل' : 'Edit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        if (onDelete != null)
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  context.isArabic ? 'حذف' : 'Delete',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
        child: Icon(
          Icons.more_vert,
          size: _getResponsiveIconSize(context, 24),
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
      child: Icon(
        Icons.play_arrow,
        size: _getResponsiveIconSize(context, 28),
        color: Colors.grey[600],
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }

  double _getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8;
    }
    return baseRadius;
  }
}
