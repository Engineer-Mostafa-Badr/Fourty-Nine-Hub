import 'package:flutter/material.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../helpers/manage_vibration.dart';

class MessagesAreEndToEndEncrypted extends StatelessWidget {
  const MessagesAreEndToEndEncrypted({
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
        'title': LocaleKeys.locationSharing.localize,
        'icon': Icons.location_pin,
      },
      {
        'title': LocaleKeys.statusUpdates.localize,
        'icon': null,
        'image': Assets.chatStatus,
      },
    ];
    return GestureDetector(
      onTap: () {
      ManageVibration.vibrate();
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
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
            //   child: Divider(
            //     thickness: 1,
            //     color:context.isDarkMode?Colors.white12: Colors.black12,
            //     height: 5,
            //   ),
            //
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16,),
                  const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: AppColors.GREY_DARK_COLOR,
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Label(
                        text: "${LocaleKeys.yourPersonalMessages.localize} ",
                        style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color:context.isDarkMode?Colors.white: Colors.grey,
                        ),
                      ),
                      Label(
                        text: LocaleKeys.endToEndEncryption.localize,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: AppColors.PRIMARY_COLOR_DARK,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  // const Icon(
                  //   Icons.lock_outline,
                  //   size: 8,
                  //   color: Colors.transparent,
                  // ),
                  // SizedBox(
                  //   width: 16,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}