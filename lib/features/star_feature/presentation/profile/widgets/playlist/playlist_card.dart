import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/common/thumbnail_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class PlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;
  final VoidCallback? onTap;
  final bool showMenu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int? overrideVideoCount; // أضف دي عشان تقدر تديله العدد الصحيح

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
    this.showMenu = true,
    this.onEdit,
    this.onDelete,
    this.overrideVideoCount, // أضف دي
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
          // color: Colors.white,
          borderRadius:
              BorderRadius.circular(_getResponsiveBorderRadius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
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
    // استخدم العدد المخصص أو العدد من الـ playlist
    final videoCount =
        overrideVideoCount ?? playlist.videosCount ?? playlist.videos.length;

    return Container(
      width: thumbnailSize * 1.5,
      height: thumbnailSize,
      margin: EdgeInsets.all(_getResponsiveSpacing(context, 12)),
      child: Stack(
        children: [
          // Main thumbnail
          ThumbnailWidget(
            imageUrl: playlist.thumbnail,
            width: thumbnailSize * 1.5,
            height: thumbnailSize,
          ),

          // Video count overlay - هنا التحديث
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.playlist_play,
                    color: Colors.white,
                    size: _getResponsiveFontSize(context, 12),
                  ),
                  SizedBox(width: _getResponsiveSpacing(context, 4)),
                  Text(
                    videoCount.toString().toArabicNumbers(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistInfo(BuildContext context) {
    final videoCount =
        overrideVideoCount ?? playlist.videosCount ?? playlist.videos.length;

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
              color: context.isDarkMode ? Colors.white : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: _getResponsiveSpacing(context, 4)),

          // Video count and creation date
          Text(
            context.isArabic
                ? '${videoCount.toString().toArabicNumbers(context)} فيديو • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}'
                : '$videoCount videos • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 13),
              color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: _getResponsiveSpacing(context, 6)),

          // Description (if available)
          if (playlist.description.isNotEmpty)
            Text(
              playlist.description,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 12),
                color: context.isDarkMode ? Colors.grey[400] : Colors.grey[500],
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
            ManageVibration.vibrate();
            onEdit?.call();
            context.pop();
            break;
          case 'delete':
            ManageVibration.vibrate();
            onDelete?.call();
            context.pop();
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
          color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
