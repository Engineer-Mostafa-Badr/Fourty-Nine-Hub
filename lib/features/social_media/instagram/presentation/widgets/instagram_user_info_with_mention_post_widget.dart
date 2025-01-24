
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_users_mention_bottom_sheet_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramUserInfoWithMentionPostWidget extends StatelessWidget {
  const InstagramUserInfoWithMentionPostWidget(
      {super.key, this.subTitle = "maihelmy.officialofficial", required this.isMenchan});
  final String subTitle;
  final bool isMenchan;
  @override
  Widget build(BuildContext context) {
    if (isMenchan) {
      return Row(
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 7,
                  left: 7,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Sizer(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "maihelmy.official",
                style: Styles.headerText(),
              ),
              Text(
                "maihelmy.officialofficial",
                style: Styles.headerText(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const Sizer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "maihelmy.official",
              style: Styles.headerText(),
            ),
            Text(
              subTitle,
              style: Styles.mediumText(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
