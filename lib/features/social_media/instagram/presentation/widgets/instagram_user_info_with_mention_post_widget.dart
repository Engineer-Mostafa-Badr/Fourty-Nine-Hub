import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_users_mention_bottom_sheet_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/name_and_verified_mark.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/sub_title_header_post.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class InstagramUserInfoWithMentionPostWidget extends StatelessWidget {
  const InstagramUserInfoWithMentionPostWidget({
    super.key,
    required this.userTags,
    this.isReel = false,
    this.thereMusic = false,
    required this.imageUrl,
    required this.userName,
    this.country,
    this.songName,
    required this.userId,
  });
  final List<InstagramPostUserTagEntity> userTags;
  final bool isReel;
  final bool thereMusic;
  final String imageUrl;
  final String userName;
  final String? country;
  final String? songName;
  final String userId;

  @override
  Widget build(BuildContext context) {
    if (userTags.isNotEmpty) {
      return Row(
        // crossAxisAlignment: Cros,
        children: [
          GestureDetector(
            onTap: () {
              context.go(
                Routes.INSTAGRAMPROFILE,
                extra: userId,
              );
              // showModalBottomSheet(
              //   context: context,
              //   backgroundColor: Colors.white,
              //   builder: (context) {
              //     return InstagramUsersMentionBottomSheetWidget(
              //       userTags: userTags,
              //     );
              //   },
              // );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                PositionedDirectional(
                  // bottom: 7,
                  bottom: 5,
                  end: 7,
                  child: ImageFromInternet(
                    width: 25,
                    height: 25,
                    image: userTags.first.profilePictureUrl,
                    isCircle: true,
                    fit: BoxFit.cover,
                    // decoration: const BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colors.green,
                    // ),
                  ),
                ),
                PositionedDirectional(
                  child: ImageFromInternet(
                    width: 25,
                    height: 25,
                    image: imageUrl,
                    isCircle: true,
                    fit: BoxFit.cover,
                    // decoration: const BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colors.blue,
                    // ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 11,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) {
                  return InstagramUsersMentionBottomSheetWidget(
                    userTags: userTags,
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text.rich(
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: userTags.first.username,
                //         style: Styles.headerText(
                //           fontSize: 32,
                //           height: 1.25,
                //           color: isReel ? Colors.white : Colors.black,
                //         ),
                //       ),
                //       TextSpan(
                //         text: " ${LocaleKeys.and.localize} ",
                //         style: Styles.headerText(
                //           fontSize: 32,
                //           height: 1.25,
                //           fontWeight: FontWeight.w400,
                //           color: isReel ? Colors.white : Colors.black,
                //         ),
                //       ),
                //       TextSpan(
                //         text:
                //             "${userTags.length - 1} ${LocaleKeys.others.localize}",
                //         style: Styles.headerText(
                //           fontSize: 32,
                //           height: 1.25,
                //           color: isReel ? Colors.white : Colors.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Row(
                    children: [
                      Label(
                        text: userTags.first.username,
                        style: Styles.headerText(
                          fontSize: 32,
                          height: 1.25,
                          color: isReel ? Colors.white : Colors.black,
                        ),
                      ),
                      Label(
                        text: " ${LocaleKeys.and.localize} ",
                        style: Styles.headerText(
                          fontSize: 32,
                          height: 1.25,
                          fontWeight: FontWeight.w400,
                          color: isReel ? Colors.white : Colors.black,
                        ),
                      ),
                      Flexible(
                        child: Label(
                          text:
                              "${userTags.length - 1} ${LocaleKeys.others.localize}",
                          style: Styles.headerText(
                            fontSize: 32,
                            height: 1.25,
                            color: isReel ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SubTitleHeaderPost(
                  country: country ?? '',
                  isReel: isReel,
                  songName: songName,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        ImageFromInternet(
          height: 30,
          width: 30,
          isCircle: true,
          image: imageUrl,
          fit: BoxFit.cover,
        ),
        // Container(
        //   width: 30,
        //   height: 30,
        //   decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.green,
        //       image: DecorationImage(
        //           image: NetworkImage(
        //               "https://s3-alpha-sig.figma.com/img/1f61/ca60/cbc85c23d3705e0ea9b22359ff9489cc?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Uyugms~Fmw4vVcu1BrEVL5YlZLyB97nb4-coe-gLrCto0hRqLbU13MJyfj7TDtrbcj8Lduqdcq2YksEMH01--21mg~UNZ1uEBi4JWcbzHMV9Pk6sxt7qQKWINCezuAbam8~TBNkpJV3mzg5P4HTJ211hWNcnC86CT1B9Yj0O9ywIHM~W~SxE~Onla1PmcbRXhYmcWIL1GUMyPxwZfY9zQ3pa8PdPPTaKA-Y-WinGBeVfwZmxXFva0VmgNrBvl35bL40yjXx0WVKE01zPd5GENLH~iU4IdIj48eTeFK5NJNDYu7yZYViGhl322v3iUmQS~js-0wSqfaSVi1Pu6dLPyQ__"),
        //           fit: BoxFit.cover)),
        // ),
        const SizedBox(
          width: 11,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NameAndVerifiedMark(
              isReel: isReel,
              isVerified: true,
              name: userName,
            ),
            SubTitleHeaderPost(
              country: country ?? '',
              isReel: isReel,
              songName: songName,
            ),
          ],
        ),
      ],
    );
  }
}
