import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramAdWidget extends StatelessWidget {
  const InstagramAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
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
            color: AppColors.PRIMARY_COLOR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sign Up", style: Styles.headerText(color: Colors.white, fontWeight: FontWeight.w400)),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,)
              ],
            ),
          ),
          const Sizer(),
          const InstagramPostReviewWidget()
        ],
      ),
    );
  }
}