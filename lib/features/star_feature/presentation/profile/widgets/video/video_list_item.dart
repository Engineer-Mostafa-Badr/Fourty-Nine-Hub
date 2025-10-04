import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/common/thumbnail_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoListItem extends StatelessWidget {
  final StarEntity video;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const VideoListItem({
    super.key,
    required this.video,
    required this.index,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailWidth = MediaQuery.of(context).size.width * 0.4;
    final thumbnailHeight = thumbnailWidth * 0.56;

    return GestureDetector(
      onTap: onTap == null
          ? () => _navigateToVideo(context)
          : () {
              ManageVibration.vibrate();
              onTap?.call();
            },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 20),
          vertical: _getResponsivePadding(context, 12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail
            ThumbnailWidget(
              imageUrl: video.mediaUrl.isNotEmpty
                  ? video.mediaUrl.first.mediaKey
                  : null,
              width: thumbnailWidth,
              height: thumbnailHeight,
              duration: '7:54',
              showVolumeIcon: true,
              onTap: () {
                ManageVibration.vibrate();
                _navigateToVideo(context);
              },
            ),
            SizedBox(width: _getResponsiveSpacing(context, 16)),

            // Video Info
            Expanded(
              child: _buildVideoInfo(context),
            ),

            // More Options Button
            _buildMoreButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          video.title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getResponsiveSpacing(context, 6)),

        // Author
        Text(
          "${video.user.firstName} ${video.user.lastName}",
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 14),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: _getResponsiveSpacing(context, 4)),

        // Views and Date
        Text(
          "${video.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode)}",
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 13),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: onMorePressed == null
          ? () => _showMoreOptions(context)
          : () {
              ManageVibration.vibrate();
              onMorePressed?.call();
            },
      child: Padding(
        padding: EdgeInsets.only(top: _getResponsiveSpacing(context, 8)),
        child: Icon(
          Icons.more_vert,
          size: _getResponsiveIconSize(context, 20),
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _navigateToVideo(BuildContext context) {
    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'video': video,
        'mediaUrl': mediaUrl,
      },
    );
  }

  void _showMoreOptions(BuildContext context) {
    // Use the same options as VideoCardWidget
    // You can import and use the same options logic
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
}
