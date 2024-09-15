import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../domain/entities/privacy_status_enum.dart';

class PrivacyMultiSelectItem extends StatelessWidget {
  final String label;
  final String privacy;
  final Function(PrivacyStatus value) onChoose;
  final bool isFriendEnable;

  const PrivacyMultiSelectItem({
    super.key,
    required this.label,
    required this.privacy,
    required this.onChoose,
    this.isFriendEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final res =
              await CustomVerticalSheetItem.normal<PrivacyStatus>(context, [
            CustomSheetModel(
              text: "Public",
              value: PrivacyStatus.public,
              iconData: Icons.language,
            ),
            CustomSheetModel(
              text: "Friends",
              value: PrivacyStatus.friends,
              iconData: Icons.family_restroom,
            ),
            CustomSheetModel(
              text: "Followers",
              value: PrivacyStatus.followers,
              iconData: Icons.accessibility_sharp,
            ),
            CustomSheetModel(
              text: "Friends / Followers",
              value: PrivacyStatus.friendsAndFollowers,
              iconData: Icons.supervised_user_circle_outlined,
            ),
            CustomSheetModel(
              text: "Only Me",
              value: PrivacyStatus.onlyMe,
              iconData: Icons.lock,
            ),
          ]);
          if (res != null) {
            onChoose(res);
            log(res.toString());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Label(text: label),
              ),
              Row(
                children: [
                  Label(text: privacy),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    getPrivacyIcon(),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPrivacyName() {
    return privacy == PrivacyStatus.onlyMe
        ? 'Only Me'
        : privacy == PrivacyStatus.public
            ? 'Public'
            : privacy == PrivacyStatus.friends
                ? 'Friends'
                : privacy == PrivacyStatus.followers
                    ? 'Followers'
                    : 'Friends / Followers';
  }

  IconData getPrivacyIcon() {
    return privacy == PrivacyStatus.onlyMe
        ? Icons.lock
        : privacy == PrivacyStatus.friendsAndFollowers
            ? Icons.supervised_user_circle_outlined
            : privacy == PrivacyStatus.friends
                ? Icons.accessibility_sharp
                : privacy == PrivacyStatus.followers
                    ? Icons.family_restroom
                    : Icons.language;
  }
}
