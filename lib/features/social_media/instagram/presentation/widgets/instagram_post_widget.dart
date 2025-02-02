import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instgram_images_post_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramPostWidget extends StatelessWidget {
  const InstagramPostWidget({super.key, required this.multiImage, required this.mechan});
  final bool multiImage;
  final bool mechan;
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Column(
        children: [
          Row(
            children: [
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),child: InstagramUserInfoWithMentionPostWidget(isMenchan: mechan,)),
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
          InstgramImagesPostWidget(
            images: multiImage?["https://s3-alpha-sig.figma.com/img/5e83/cdfd/ce7e32c5013518aa6e932c543a55a3c9?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=jmpIB5No3HV98vRcBvhx1fi37cVWck8LKeso2GDfo2~wg~uP-CPoQ1AeRqEpvM1N1QY3pFStGWQiYYriRQ1TgM6PajF-AGLKPWDW-gYxZVfUHehXmV2yiy1NwEMbyaWluTarHOv-PoLPuY~KDBR955FSqt1G1-yjvsDolhiYqeR4Fkngj3mQJNCuNob8XqKSzj2-njZM3iIgQW7YN-1yDtCqPihLauQqVpPep3Z2IBHFPq3kphlm2N9TDkRJXgqqYCkwh36IjWRRzCXottwxEkH-Jf5DLrR28dWLV6pte3LNTRGAezcERRNHwxl6geCGfSrrEBe7ft6MfEuxOUvy5A__"]: [
              "",
              "",
            ],
          ),
          const Sizer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),child: const InstagramPostReviewWidget())
        ],
      ),
    );
  }
}
