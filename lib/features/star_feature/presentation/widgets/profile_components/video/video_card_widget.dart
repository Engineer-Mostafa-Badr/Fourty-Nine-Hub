import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/thumbnail_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/options_bottom_sheet.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../controller/star_cubit/star_cubit.dart';

class VideoCardWidget extends StatelessWidget {
  final StarEntity video;
  final int index;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const VideoCardWidget({
    super.key,
    required this.video,
    required this.index,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null
          ? () => _navigateToVideo(context)
          : () {
              ManageVibration.vibrate();
              onTap?.call();
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // إضافة هذا
        children: [
          // Video Thumbnail
          Flexible(
            // تغيير من عادي إلى Flexible
            child: _buildThumbnail(context),
          ),
          SizedBox(height: _getResponsiveSpacing(context, 12)),
          // Video Info
          _buildVideoInfo(context),
        ],
      ),
    );
  }

  Widget _buildThumbnail(context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(_getResponsiveBorderRadius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main thumbnail
            ThumbnailWidget(
              imageUrl: video.mediaUrl.isNotEmpty
                  ? video.mediaUrl.first.mediaKey
                  : null,
              width: double.infinity,
              height: double.infinity,
              duration: '7:54',
              showVolumeIcon: true,
              onTap: () {
                ManageVibration.vibrate();
                _navigateToVideo(context);
              },
            ),

            // Favorite icon overlay
            Positioned(
              top: _getResponsiveSpacing(context, 10),
              left: _getResponsiveSpacing(context, 10),
              child: _buildFavoriteButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<StarCubit, dynamic>(
      builder: (context, state) {
        final isFavorite = context.read<StarCubit>().isFavorite(video.id);

        return GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            context.read<StarCubit>().toggleFavorite(video.id);
          },
          child: Container(
            padding: EdgeInsets.all(_getResponsiveSpacing(context, 6)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey[600],
              size: _getResponsiveIconSize(context, 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: _getResponsiveSpacing(context, 4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          _buildProfilePicture(context),
          SizedBox(width: _getResponsiveSpacing(context, 12)),

          // Video Details
          Expanded(
            child: _buildVideoDetails(context),
          ),

          // Options and Rating
          _buildOptionsAndRating(context),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () => ManageVibration.vibrate(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          backgroundImage: video.user.image.isNotEmpty
              ? NetworkImage(video.user.image)
              : null,
          child: video.user.image.isEmpty
              ? Icon(
                  Icons.person,
                  size: _getResponsiveIconSize(context, 14),
                  color: Colors.grey[600],
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildVideoDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          video.title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getResponsiveSpacing(context, 6)),

        // Author
        Text(
          "${video.user.firstName} ${video.user.lastName}",
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 13),
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getResponsiveSpacing(context, 4)),

        // Views and Date
        Row(
          children: [
            Icon(
              Icons.visibility,
              size: _getResponsiveIconSize(context, 14),
              color: Colors.grey[600],
            ),
            SizedBox(width: _getResponsiveSpacing(context, 4)),
            Expanded(
              child: Text(
                "${video.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode)}",
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 12),
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsAndRating(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // More Options Button
        Container(
          padding: EdgeInsets.all(2),
          child: IconButton(
            onPressed: () {
              ManageVibration.vibrate();
              _showVideoOptions(context);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
              size: _getResponsiveIconSize(context, 22),
            ),
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ),
        SizedBox(height: _getResponsiveSpacing(context, 4)),

        // Star Rating
        _buildStarRating(context),
      ],
    );
  }

  Widget _buildStarRating(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (starIndex) => GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            context.read<StarCubit>().updateRating(video.id, starIndex + 1);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsiveSpacing(context, 1),
            ),
            child: Icon(
              starIndex < video.averageRating ? Icons.star : Icons.star_border,
              color: starIndex < video.averageRating
                  ? Colors.amber[600]
                  : Colors.grey[400],
              size: _getResponsiveIconSize(context, 18),
            ),
          ),
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

  void _showVideoOptions(BuildContext context) {
    final cubit = context.read<StarCubit>();

    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'إنشاء قائمة' : 'Play next in queue',
          onTap: () => Navigator.pop(context),
        ),
        OptionItem(
          icon: Icons.block,
          title: context.isArabic ? 'غير مهتم' : 'Not interested',
          onTap: () => Navigator.pop(context),
        ),
        OptionItem(
          icon: cubit.isFavorite(video.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(video.id)
              ? (context.isArabic
                  ? 'إزالة من المفضلة'
                  : 'Remove from favorites')
              : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite(video.id);
          },
        ),
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'إبلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () => Navigator.pop(context),
        ),
      ],
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
