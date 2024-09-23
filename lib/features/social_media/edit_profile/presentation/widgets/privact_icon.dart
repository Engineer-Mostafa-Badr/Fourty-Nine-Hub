import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_status_enum.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class PrivacyIcon extends StatelessWidget {
  const PrivacyIcon({super.key, required this.selectPrivacy});
  final Function(String) selectPrivacy;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final res =
              await CustomVerticalSheetItem.normal<PrivacyStatus>(context, [
            CustomSheetModel(
              text: LocaleKeys.public.localize,
              value: PrivacyStatus.public,
              iconData: Icons.language,
            ),
            CustomSheetModel(
              text: LocaleKeys.friends.localize,
              value: PrivacyStatus.friends,
              iconData: Icons.family_restroom,
            ),
            CustomSheetModel(
              text: LocaleKeys.followers.localize,
              value: PrivacyStatus.followers,
              iconData: Icons.accessibility_sharp,
            ),
            CustomSheetModel(
              text: LocaleKeys.friendsAndFollowers.localize,
              value: PrivacyStatus.friendsAndFollowers,
              iconData: Icons.supervised_user_circle_outlined,
            ),
            CustomSheetModel(
              text: LocaleKeys.onlyMe.localize,
              value: PrivacyStatus.onlyMe,
              iconData: Icons.lock,
            ),
          ]);
          print(res?.name);
          print("============>");
          selectPrivacy(res?.name ?? 'public');
        },
        icon: const Icon(
          Icons.privacy_tip,
          color: AppColors.PRIMARY_COLOR,
          size: 30,
        ));
  }
}
