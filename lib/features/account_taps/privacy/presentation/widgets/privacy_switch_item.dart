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
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
                child: Label(
              text: label,
              style: Styles.mediumText(),
            )),
            Label(
              text: (privacy == PrivacyStatus.public ? 'On' : 'Off'),
              style: Styles.mediumText(),
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
