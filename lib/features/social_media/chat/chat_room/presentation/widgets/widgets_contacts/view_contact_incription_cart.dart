import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../res/assets/assets.dart';

class ViewContactEncryptionCart extends StatelessWidget {
  const ViewContactEncryptionCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        'title': LocaleKeys.textAndVoiceMessages.localize,
        'icon': Icons.message_outlined,
      },
      {
        'title': LocaleKeys.audioAndVideoCalls.localize,
        'icon': Icons.phone,
      },
      {
        'title': LocaleKeys.photoVideosAndDocuments.localize,
        'icon': Icons.attach_file_rounded,
      },
      {
        'title': LocaleKeys.audioAndVideoCalls.localize,
        'icon': Icons.location_pin,
      },
      {
        'title': LocaleKeys.audioAndVideoCalls.localize,
        'icon': null,
        'image': Assets.chatStatus,
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          bottomSheet(
            context: context,
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Sizer(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: context.isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  width: 64,
                  height: 4,
                ),
                const Sizer(height: 24),
                Label(
                  text: LocaleKeys.yourChatsAndCallArePrivate.localize,
                  style: Styles.headerText(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const Sizer(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Label(
                      text: LocaleKeys.endToEndDescription.localize,
                      style: Styles.mediumText(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 4,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Sizer(height: 24),
                ...List.generate(
                  5,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (items[index]['icon'] != null)
                          Icon(
                            items[index]['icon'],
                            color: context.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          )
                        else
                          Image.asset(
                            items[index]['image'],
                            width: 24,
                            height: 24,
                            color: context.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        const Sizer(),
                        Label(
                          text: items[index]['title'],
                          style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock,
              color: AppColors.GREY_DARK_COLOR,
              size: 24,
            ),
            const SizedBox(
              width: 32.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.encryption.tr(),
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode
                          ? AppColors.BACKGROUND_COLOR
                          : AppColors.PRIMARY_COLOR,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Text(
                      LocaleKeys.chatEncryptionMessage.tr(),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w400,
                        color: AppColors.DARK_GRAY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
