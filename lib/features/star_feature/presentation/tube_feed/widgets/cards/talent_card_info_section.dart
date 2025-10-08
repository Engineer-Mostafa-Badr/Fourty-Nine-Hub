import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../helpers/manage_vibration.dart';
import '../../../../domain/entity/star_entity.dart';
import '../../../presentation_exports.dart';
import '../../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class TalentCardInfoSection extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreOptionsTap;

  const TalentCardInfoSection({
    super.key,
    required this.talent,
    required this.cubit,
    required this.onProfileTap,
    required this.onMoreOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = talent.createdAt ?? DateTime.now();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              onProfileTap();
            },
            child: ImageFromInternet(
              image: talent.user.image,
              width: 50,
              height: 50,
              isCircle: true,
              isMale: true, // Default to male avatar if no gender info
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),

          // Title and Info - Use Expanded with flex
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                onProfileTap();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${talent.user.firstName} ${talent.user.lastName}",
                    style: TextStyle(
                      fontSize: 13,
                      color: context.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  // Views and time row
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: context.isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // More Options and Stars - Constrain this section
          SizedBox(
            width: 80,
            child: OptionsAndRatingSection(
              talent: talent,
              cubit: cubit,
              onMoreOptionsTap: onMoreOptionsTap,
            ),
          ),
        ],
      ),
    );
  }
}
