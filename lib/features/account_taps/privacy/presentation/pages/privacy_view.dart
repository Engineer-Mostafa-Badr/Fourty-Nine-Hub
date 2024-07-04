import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../res/strings/labels.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../widgets/privacy_muti_select_item.dart';
import '../widgets/privacy_switch_item.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.policies,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PrivacyMultiSelectItem(
                  label: 'Country',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Phone',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Birth Date',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Social Status',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Job',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'City',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Gender',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Language',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Receive Messages',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Last Seen',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Friends List',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Followers List',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Activity',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacyMultiSelectItem(
                  label: 'Friend Request',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                  isFriendEnable: false,
                ),
                PrivacyMultiSelectItem(
                  label: 'Follow',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                  isFriendEnable: false,
                ),
                PrivacyMultiSelectItem(
                  label: 'Call',
                  privacy: PrivacyStatus.public,
                  onChoose: (PrivacyStatus value) {},
                ),
                PrivacySwitchItem(
                  label: 'Random Appearance',
                  privacy: PrivacyStatus.public,
                  onPress: (v) {},
                ),
              ],
            ),
          ),
        ));
  }
}
