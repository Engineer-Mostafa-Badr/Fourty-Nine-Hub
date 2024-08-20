import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../res/style/styles.dart';

class CreatePostBanner extends StatelessWidget {
  const CreatePostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileImage(accountId: 0),
          const Sizer(
            width: 10,
          ),
          Expanded(
              child: InkWell(
            onTap: () => context.push(Routes.CREATEPOST, extra: 'facebook'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: .5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Label(
                text: 'What do you think about?',
                style: Styles.mediumText(color: Colors.grey),
              ),
            ),
          )),
          const Sizer(
            width: 10,
          ),
          InkWell(
            onTap: () => context.push(Routes.REELS),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.reels,
                  height: 20,
                ),
                const Sizer(
                  height: 3,
                ),
                Label(
                  text: 'Reel',
                  style: Styles.smallText(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
