import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../helper/youtube_style_video_player.dart';
import '../common/options_bottom_sheet.dart';

class TalentHistoryItem extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final int index;

  const TalentHistoryItem({
    super.key,
    required this.talent,
    required this.cubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TalentVideoPlayer(
              talent: talent,
              videoUrl: mediaUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail + Overlays
            _buildThumbnailWithOverlays(140, 90),
            const SizedBox(width: 12),

            // Video info
            Expanded(
              child: _buildVideoInfoColumn(context, talent, createdAt),
            ),

            // More options button
            _buildMoreOptionsButton(context, talent, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailWithOverlays(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sound icon in top left
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
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '7:54',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfoColumn(
    BuildContext context,
    StarEntity talent,
    DateTime createdAt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          talent.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "${talent.user.firstName} ${talent.user.lastName}",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        _showHistoryOptions(context, talent, cubit);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Icon(
          Icons.more_vert,
          size: 20,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _showHistoryOptions(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.delete_outline,
          title:
              context.isArabic ? 'حذف من التاريخ' : 'Remove from watch history',
          onTap: () {
            Navigator.pop(context);
            // Add remove from history logic
          },
        ),
        OptionItem(
          icon: Icons.playlist_play_rounded,
          title: context.isArabic
              ? 'تشغيل التالي في قائمة التشغيل'
              : 'Play next in queue',
          onTap: () {
            Navigator.pop(context);
            // Add play next logic
          },
        ),
        OptionItem(
          icon: cubit.isFavorite(talent.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(talent.id)
              ? (context.isArabic ? 'حذف من المفضلة' : 'Remove from favorites')
              : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite(talent.id);
          },
        ),
      ],
    );
  }
}
