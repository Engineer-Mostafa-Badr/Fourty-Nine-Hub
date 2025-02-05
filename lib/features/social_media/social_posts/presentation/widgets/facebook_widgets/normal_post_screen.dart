import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../data/models/post_model.dart';
import '../../../domain/entities/post_entity.dart';

class NormalPostScreen extends StatelessWidget {
  const NormalPostScreen({super.key, required this.postEntity});

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User profile and post header

          Row(
            children: [
              ImageFromInternet(
                image: postEntity.user.image,
                isCircle: true,
                defaultLogo: false,
                width: 80.w,
                height: 80.h,
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    text: postEntity.user.firstName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.PRIMARY_COLOR),
                  ),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: postEntity.sinceTime,
                            style:  const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.PRIMARY_COLOR)),
                         WidgetSpan(
                          child: SizedBox(width: 6.w) ,
                        ),
                        const WidgetSpan(
                            child: Icon(
                              Icons.group,
                              size: 14,
                              color:  AppColors.PRIMARY_COLOR,
                            ))
                      ]))
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Post content
          ReadMoreLabel(
            text: postEntity.content!,
            // textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                fontSize: 16,
                fontWeight:FontWeight.w500,
                color:AppColors.black),
          ),
          const SizedBox(height:12),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 14, // Adjust position for overlap
                    child: Image.asset(
                      Assets.loveReact,
                      width: 20,  // Set a fixed width
                      height: 20, // Set a fixed height
                    ),
                  ),
                  Image.asset(
                    Assets.likeReact,
                    width: 20,  // Set a fixed width to ensure it's not cut off
                    height: 20, // Set a fixed height to match the other image
                  ),
                ],
              ),
              const SizedBox(width: 16), // Increased space between reactions and text
              const Label(
                text: "Claude-Arthur Mbonzi And 276 Others",
                style: TextStyle(
                  color: AppColors.c46484B,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),


          const SizedBox(height: 10.0),

          // Post interactions (like, comment, share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the items to the start
            children: [
              // Like button
              Row(
                children: [
                  SvgPicture.asset(Assets.likeIcon), // Like Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(text: LocaleKeys.like.localize,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  ), // Like Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Comment button
              Row(
                children: [
                  SvgPicture.asset(Assets.commentIcon), // Comment Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(text: LocaleKeys.comment.localize,  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),), // Comment Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Send button
              Row(
                children: [
                  SvgPicture.asset(Assets.sendIcon), // Send Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(text: LocaleKeys.send.localize,  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),), // Send Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Share button
              Row(
                children: [
                  SvgPicture.asset(Assets.shareIcon), // Share Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(text: LocaleKeys.share.localize,  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),), // Share Text
                ],
              ),
            ],
          )

        ],
      ),
    );
  }
}
