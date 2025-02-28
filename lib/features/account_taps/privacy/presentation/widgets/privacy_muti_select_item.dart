import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () async {
          var groupValue = privacy;
          showAnimatedDialog(
              context,
              AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Label(text: 'Who Can See My $label'),
                    Row(
                      children: [
                        Radio(
                          value: 'public',
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.public.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.friends.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.friends.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.contacts.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.contacts.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.followers.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.followers.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value:
                              '${LocaleKeys.friends.localize}and${LocaleKeys.followers.localize}',
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text:
                              '${LocaleKeys.friends.localize} and ${LocaleKeys.followers.localize}',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.except_from.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.except_from.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.only_with.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.only_with.localize,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: LocaleKeys.onlyMe.localize,
                          groupValue: groupValue,
                          onChanged: (value) {
                            groupValue = value!;
                          },
                        ),
                        Label(
                          text: LocaleKeys.onlyMe.localize,
                        )
                      ],
                    ),
                  ],
                ),
              ));
          // final res =
          //     await CustomVerticalSheetItem.normal<PrivacyStatus>(context, [
          //   CustomSheetModel(
          //     text: LocaleKeys.public.localize,
          //     value: PrivacyStatus.public,
          //     iconData: Icons.language,
          //   ),
          //   CustomSheetModel(
          //     text: LocaleKeys.friends.localize,
          //     value: PrivacyStatus.friends,
          //     iconData: Icons.family_restroom,
          //   ),
          //   CustomSheetModel(
          //     text: LocaleKeys.followers.localize,
          //     value: PrivacyStatus.followers,
          //     iconData: Icons.accessibility_sharp,
          //   ),
          //   CustomSheetModel(
          //     text:
          //         "${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}",
          //     value: PrivacyStatus.friendsAndFollowers,
          //     iconData: Icons.supervised_user_circle_outlined,
          //   ),
          //   CustomSheetModel(
          //     text: LocaleKeys.onlyMe.localize,
          //     value: PrivacyStatus.onlyMe,
          //     iconData: Icons.lock,
          //   ),
          // ]);
          // if (res != null) {
          //   onChoose(res);
          //   log(res.toString());
          // }
        },
        child: Row(
          children: [
            Expanded(
              child: Label(
                text: label,
                style:
                    TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              children: [
                Label(
                  text: getPrivacyName(privacyToPrivacyStatus(privacy)),
                  style: TextStyle(
                      fontSize: 30.sp, color: AppColors.DIVIDER_GRAY_COLOR2),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Icon(
                  getPrivacyIcon(privacyToPrivacyStatus(privacy)),
                  color: AppColors.GREY_DARK_COLOR,
                ),
              ],
            ),
            SizedBox(
              width: 15.w,
            ),
          ],
        ),
      ),
    );
  }

//TODO
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
      case 'contacts':
        return PrivacyStatus.contacts;
      case 'only-with':
        return PrivacyStatus.onlyWith;
      case 'friends-except':
        return PrivacyStatus.exceptFrom;
      default:
        return PrivacyStatus.public; // Default to a known status
    }
  }

  String getPrivacyName(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return LocaleKeys.onlyMe.localize;
      case PrivacyStatus.public:
        return LocaleKeys.public.localize;
      case PrivacyStatus.friends:
        return LocaleKeys.friends.localize;
      case PrivacyStatus.followers:
        return LocaleKeys.followers.localize; // Adjust if needed
      case PrivacyStatus.friendsAndFollowers:
        return '${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}';
      case PrivacyStatus.exceptFrom:
        return LocaleKeys.except_from.localize;
      case PrivacyStatus.onlyWith:
        return LocaleKeys.only_with.localize;
      case PrivacyStatus.contacts:
        return LocaleKeys.contacts.localize;
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
      case PrivacyStatus.exceptFrom:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.onlyWith:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.contacts:
        return Icons.supervised_user_circle_outlined;
    }
  }
}
