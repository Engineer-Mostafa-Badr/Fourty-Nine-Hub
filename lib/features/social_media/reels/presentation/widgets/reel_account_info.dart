import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';

class ReelAccountInfo extends StatelessWidget {
  final ReelEntity item;

  const ReelAccountInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ProfileImage(
              withBorder: true,
              accountId: 0,
              userId: '',
            ),
            Sizer(),
            TextAppButton(
              label: item.user?.fullName ?? '',
              style: Styles.mediumText(
                  fontWeight: FontWeight.bold, color: Colors.white),
              onPressed: () => context.push(Routes.OTHERSACCOUNT),
            ),
            Sizer(),
            AppButton(
              height: kToolbarHeight * .4,
              padding: 20,
              label: 'Follow',
              onPressed: () {},
            )
          ],
        ),
        ReadMoreLabel(
          text: item.description,
          style: Styles.mediumText(color: Colors.white),
        ),
      ],
    );
  }
}
