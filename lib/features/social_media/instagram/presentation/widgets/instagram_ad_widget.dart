import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramAdWidget extends StatelessWidget {
  const InstagramAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const InstagramUserInfoWithMentionPostWidget(
                subTitle: "Sponsored",
                isMenchan: false,
              ),
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
            height: 350,
            color: Colors.red,
          ),
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sign Up", style: Styles.headerText(color: Colors.white)),
                const Icon(Icons.arrow_forward_ios, color: Colors.white,)
              ],
            ),
          ),
          const Sizer(),
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
                width: 30,
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
          )
        ],
      ),
    );
  }
} 