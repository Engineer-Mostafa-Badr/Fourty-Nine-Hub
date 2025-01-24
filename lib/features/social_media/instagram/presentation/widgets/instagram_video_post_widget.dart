import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_users_mention_bottom_sheet_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramVideoPostWidget extends StatelessWidget {
  const InstagramVideoPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      
      child: Column(
        children: [
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    
                    const InstagramUserInfoWithMentionPostWidget(isMenchan: false,),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) =>
                                const InstagramPostButtomSheetWithoutMentionWidget(),
                          );
                        },
                        child: const Icon(Icons.more_horiz)),
                  ],
                ),
                const Sizer(),
          Container(
            height: 400,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) {
                  return const InstagramUsersMentionBottomSheetWidget();
                },
              );
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.person, size: 15, color: Colors.white,)),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Icon(Icons.volume_off_rounded, size: 14, color: Colors.white,)),
              )
            ],
          )
              ],
            ),
          ),
          
          const Sizer(height: 10,),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_outline,
                      size: 35,
                    ),
                    const Sizer(
                      width: 3,
                    ),
                    Text(
                      "30",
                      style: Styles.headerText(fontSize: 45),
                    ),
                    const Sizer(
                      width: 25,
                    ),
                    Image.asset(
                      Assets.instagramCommentIcon,
                      width: 30,
                    ),
                    const Sizer(
                      width: 30,
                    ),
                    Image.asset(
                      Assets.instagramSharePostIcon,
                      width: 30,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.bookmark_border_outlined,
                      size: 35,
                    )
                  ],
                ),
                const Sizer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Liked by ",
                          style: Styles.headerText(fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: "ahmedshede_official and athers",
                          style: Styles.headerText())
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "maihelmy.official ",
                          style: Styles.headerText(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "Post description",
                          style: Styles.headerText(fontWeight: FontWeight.w400))
                    ])),
                  ],
                ),
                const Sizer(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "1 day ago",
                      style: Styles.mediumText(),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}