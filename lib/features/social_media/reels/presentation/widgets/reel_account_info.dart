import 'package:flutter/material.dart';
import '../../domain/entities/reel_entity.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../../../../helpers/manage_vibration.dart';

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
            const Sizer(),
            TextAppButton(
              label: item.user?.fullName ?? '',
              style: Styles.mediumText(
                  fontWeight: FontWeight.bold, color: Colors.white),
              onPressed: () => context.push(Routes.OTHERSACCOUNT),
            ),
            const Sizer(),
            AppButton(
              height: kToolbarHeight * .4,
              padding: 20,
              label: 'Follow',
              onPressed: () {

      ManageVibration.vibrate();
              },
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