import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/localization/locale_keys.g.dart';

class VideoInfoSection extends StatelessWidget {
  final StarEntity talent;
  final Function(int)? onRatingChanged;

  const VideoInfoSection({
    super.key,
    required this.talent,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Avatar
          _buildProfileAvatar(),
          SizedBox(width: 12),

          // Video Information
          Expanded(
            child: _buildVideoInfo(context),
          ),

          // Star Rating
          _buildStarRating(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[300],
      backgroundImage: talent.user.image.isNotEmpty
          ? CachedNetworkImageProvider(talent.user.image)
          : null,
      child: talent.user.image.isEmpty
          ? Icon(Icons.person, color: Colors.grey, size: 24)
          : null,
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          talent.title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),

        // Author Name
        Text(
          '${talent.user.firstName} ${talent.user.lastName}',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 14),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),

        // Views and Date
        Text(
          context.isArabic
              ? '${_formatDate(talent.createdAt, context)} • ${_formatViews(talent.totalViews.toInt(), context)} ${LocaleKeys.views.localize}'
              : '${_formatViews(talent.totalViews.toInt(), context)} views • ${_formatDate(talent.createdAt, context)}',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 12),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null
              ? () {
                  ManageVibration.vibrate();
                  onRatingChanged!(index + 1);
                }
              : null,
          child: Icon(
            index < talent.averageRating ? Icons.star : Icons.star_border,
            color: index < talent.averageRating
                ? Colors.amber[600]
                : Colors.grey[400],
            size: _getResponsiveIconSize(20),
          ),
        );
      }),
    );
  }

  String _formatViews(int views, BuildContext context) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString().toArabicNumbers(context);
  }

  String _formatDate(DateTime? date, BuildContext context) {
    if (date == null) return 'Unknown';
    return timeago
        .format(date, locale: context.locale.languageCode)
        .toArabicNumbers(context);
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsiveIconSize(double baseSize) {
    // Could add responsive logic here if needed
    return baseSize;
  }
}
