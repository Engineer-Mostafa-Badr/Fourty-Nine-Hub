import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class InstagramUserFollowWidget extends StatelessWidget {
  const InstagramUserFollowWidget({
    super.key,
    this.inFriends = false,
    this.inFollowers = false,
    this.inBlock = false,
    required this.image,
    required this.userName,
    required this.fullName,
    required this.userId,
  });

  final bool inFriends;
  final bool inFollowers;
  final bool inBlock;
  final String? image;
  final String? userName;
  final String?fullName;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageFromInternet(
          width: 35,
          height: 35,
          image: image ?? testImage,
          isCircle: true,
          fit: BoxFit.cover,
        ),
        Sizer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: fullName??'ahmed ahmed'),
            Label(
              text: userName??'ahmed13',
              color: Colors.black45,
            ),
          ],
        ),
        Spacer(),
        if (inFriends)
          Row(
            children: [
              Container(
                width: 96,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.getTextColor(context), width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Label(
                    text: LocaleKeys.message.localize,
                    style: Styles.mediumText(),
                    color: AppColors.getTextColor(context),
                  ),
                ),
              ),
              Sizer(),
              PopupMenuButton(
                color: AppColors.getFillColor(context),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black45,
                  size: 16,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Label(
                        text: LocaleKeys.mute.localize,
                      ),
                    ),
                    PopupMenuItem(
                      child: Label(
                        text: LocaleKeys.unfollow.localize,
                        color: Colors.red,
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        if (inFollowers)
          Row(
            children: [
              Container(
                width: 96,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.getButtonPrimaryColor(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Label(
                    text: LocaleKeys.follow.localize,
                    style: Styles.mediumText(
                      color: AppColors.getReversedTextColor(context),
                    ),
                  ),
                ),
              ),
              Sizer(),
              Icon(
                Icons.close,
                color: Colors.black45,
                size: 18,
              ),
            ],
          ),
        if (inBlock)
          Container(
            width: 96,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.getButtonPrimaryColor(context),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Label(
                text: LocaleKeys.unblock.localize,
                style: Styles.mediumText(
                  color: AppColors.getReversedTextColor(context),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
