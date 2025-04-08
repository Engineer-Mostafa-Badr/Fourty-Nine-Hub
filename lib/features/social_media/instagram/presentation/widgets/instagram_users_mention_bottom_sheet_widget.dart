import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/follow_button_instagram.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramUsersMentionBottomSheetWidget extends StatelessWidget {
  const InstagramUsersMentionBottomSheetWidget({
    super.key,
    required this.userTags,
  });

  final List<UserTagEntity> userTags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 57,
            height: 4,
            color: const Color(0xFF6F787D),
            // decoration: BoxDecoration(
            //   color: const Color(0xFF6F787D),
            //   borderRadius: BorderRadius.circular(30),
            // ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            LocaleKeys.taggedPeople.localize,
            style: Styles.headerText(fontSize: 40),
          ),
          const SizedBox(
            height: 13,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userTags.length,
              itemBuilder: (context, index) {
                final userTag = userTags[index];
                return ListTile(
                  title: Label(
                    text: userTag.username,
                    style: Styles.headerText(
                      fontSize: 32,
                    ),
                  ),
                  leading: ImageFromInternet(
                    image: userTag.profilePictureUrl,
                    height: 50,
                    width: 50,
                    isCircle: true,
                  ),
                  trailing: FollowButtonInstagram(
                    isReel: false,
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
          // Row(
          //   children: [
          //     Container(
          //       width: 80,
          //       height: 80,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.red,
          //       ),
          //     ),
          //     const Sizer(),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "edwardfouad",
          //           style: Styles.headerText(),
          //         ),
          //         Text(
          //           "Edward",
          //           style: Styles.mediumText(
          //               color: Colors.grey, fontWeight: FontWeight.w300),
          //         ),
          //       ],
          //     ),
          //     const Spacer(),
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(5),
          //           color: AppColors.PRIMARY_COLOR),
          //       child: Text(
          //         "Follow",
          //         style: Styles.headerText(
          //             fontWeight: FontWeight.w500, color: Colors.white),
          //       ),
          //     )
          //   ],
          // ),
          // const Sizer(),
          // Row(
          //   children: [
          //     Container(
          //       width: 80,
          //       height: 80,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.red,
          //       ),
          //     ),
          //     const Sizer(),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "edwardfouad",
          //           style: Styles.headerText(),
          //         ),
          //         Text(
          //           "Edward",
          //           style: Styles.mediumText(
          //               color: Colors.grey, fontWeight: FontWeight.w300),
          //         ),
          //       ],
          //     ),
          //     const Spacer(),
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(5),
          //           color: AppColors.PRIMARY_COLOR),
          //       child: Text(
          //         "Follow",
          //         style: Styles.headerText(
          //             fontWeight: FontWeight.w500, color: Colors.white),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
