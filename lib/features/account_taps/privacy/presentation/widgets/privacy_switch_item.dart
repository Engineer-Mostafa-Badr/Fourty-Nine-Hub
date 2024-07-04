import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/privacy_status_enum.dart';

class PrivacySwitchItem extends StatelessWidget {
  final String label;
  final PrivacyStatus privacy;
  final Function(bool value) onPress;

  const PrivacySwitchItem({
    super.key,
    required this.label,
    required this.privacy,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
                child: Label(
              text: label,
              style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            )),
            Label(
              text: (privacy == PrivacyStatus.public ? 'On' : 'Off'),
              style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            ),
            Switch(
              value: privacy == PrivacyStatus.public,
              onChanged: onPress,
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
