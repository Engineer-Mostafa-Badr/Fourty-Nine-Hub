import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instgram_images_post_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PostAdInstagram extends StatelessWidget {
  const PostAdInstagram({
    super.key,
    required this.instagramPostEntity,
    required this.userImageUrl,
    required this.userName,
    required this.images,
    required this.isReal,
    this.country,
    this.songName,
  });

  final InstagramPostEntity instagramPostEntity;

  final String userImageUrl;
  final String userName;
  final List<String> images;
  final bool isReal;
  final String? country;
  final String? songName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderPostInstagram(
          imageUrl: userImageUrl,
          userTags: [],
          userName: userName,
          isReel: isReal,
          country: country,
          songName: songName,
        ),
        // Container(
        //   child: Row(
        //     children: [
        //       const InstagramUserInfoWithMentionPostWidget(
        //         imageUrl: testImage,
        //         userName: 'Ruffles',
        //         isMenchan: false,
        //       ),
        //       const Spacer(),
        //       GestureDetector(
        //           onTap: () {
        //             showModalBottomSheet(
        //               backgroundColor: Colors.white,
        //               context: context,
        //               builder: (context) =>
        //                   const InstagramPostButtomSheetWithoutMentionWidget(),
        //             );
        //           },
        //           child: const Icon(Icons.more_horiz)),
        //     ],
        //   ),
        // ),

        const SizedBox(
          height: 5,
        ),
        // InstgramImagesPostWidget(
        //   // images: images,
        //   instagramPostEntity: ,
        // ),
        // Container(
        //   height: 350,
        //   color: Colors.red,
        // ),
        Container(
          width: double.infinity,
          height: 54,
          padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
          color: AppColors.PRIMARY_COLOR,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                text: LocaleKeys.sendMessage.localize,
                style: Styles.mediumText(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 11,
        ),
        InstagramPostReviewWidget(
          instagramPostEntity: instagramPostEntity,
        )
      ],
    );
  }
}
