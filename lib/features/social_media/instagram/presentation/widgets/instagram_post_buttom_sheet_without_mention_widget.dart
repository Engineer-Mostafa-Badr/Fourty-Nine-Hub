import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstagramPostButtomSheetWithoutMentionWidget extends StatelessWidget {
  const InstagramPostButtomSheetWithoutMentionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            // decoration: BoxDecoration(
            //   color: Colors.grey.shade300,
            //   borderRadius: BorderRadius.circular(6),
            // ),
            child: Row(
              children: [
                const Icon(Icons.bookmark, size: 34,),
                const Sizer(),
                Text(
                  "Save",
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          const Sizer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            // decoration: BoxDecoration(
            //   color: Colors.grey.shade300,
            //   borderRadius: BorderRadius.circular(6),
            // ),
            child: Row(
            children: [
              const Icon(Icons.person_pin, size: 35,),
              const Sizer(),
              Text(
                "About this account",
                style: Styles.headerText(fontWeight: FontWeight.w400),
              )
            ],
          ),
          ),
          const Sizer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            // decoration: BoxDecoration(
            //   color: Colors.grey.shade300,
            //   borderRadius: BorderRadius.circular(6),
            // ),
            child: Row(
              children: [
                const Icon(Icons.person_remove_alt_1, size: 34,),
                const Sizer(),
                Text(
                  "Unfollow",
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          const Sizer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            // decoration: BoxDecoration(
            //   color: Colors.grey.shade300,
            //   borderRadius: BorderRadius.circular(6),
            // ),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.instagramHideIcon,
                  width: 44,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                const Sizer(),
                Text(
                  "Hide",
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          const Sizer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            // decoration: BoxDecoration(
            //   color: Colors.grey.shade300,
            //   borderRadius: BorderRadius.circular(6),
            // ),
            child: Row(
              children: [
                const Icon(
                  Icons.report,
                  color: Colors.red,
                  size: 40,
                ),
                const Sizer(),
                Text(
                  "Report",
                  style: Styles.headerText(
                      fontWeight: FontWeight.w400, color: Colors.red),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
