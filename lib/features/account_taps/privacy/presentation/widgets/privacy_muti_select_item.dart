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
                  Label(text: getPrivacyName(privacyToPrivacyStatus(privacy))),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    getPrivacyIcon(privacyToPrivacyStatus(privacy)),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PrivacyStatus privacyToPrivacyStatus(String privacy) {
    switch (privacy) {
      case 'only-me':
        return PrivacyStatus.onlyMe;
      case 'public':
        return PrivacyStatus.public;
      case 'friends':
        return PrivacyStatus.friends;
      case 'followers':
        return PrivacyStatus.followers;
      case 'friends/followers':
        return PrivacyStatus.friendsAndFollowers;
      default:
        return PrivacyStatus.public; // Default to a known status
    }
}
  String getPrivacyName(PrivacyStatus status) {
    switch (status){
      case PrivacyStatus.onlyMe:
        return 'Only Me';
      case PrivacyStatus.public:
        return 'Public';
      case PrivacyStatus.friends:
        return 'Friends';
      case PrivacyStatus.followers:
        return 'Followers'; // Adjust if needed
      case PrivacyStatus.friendsAndFollowers:
        return 'Friends / Followers';

    }
  }

  IconData getPrivacyIcon(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return Icons.lock;
      case PrivacyStatus.public:
        return Icons.language;
      case PrivacyStatus.friends:
        return Icons.family_restroom;
      case PrivacyStatus.followers:
        return Icons.accessibility_sharp; // Adjust if needed
      case PrivacyStatus.friendsAndFollowers:
        return Icons.supervised_user_circle_outlined;
    }
  }
}
