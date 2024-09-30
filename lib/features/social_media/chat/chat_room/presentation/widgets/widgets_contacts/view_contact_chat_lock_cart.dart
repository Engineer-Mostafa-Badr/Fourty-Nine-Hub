import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/toggle_icon_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ViewContactChatLockCart extends StatelessWidget {
  const ViewContactChatLockCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.speaker_notes_off,
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
                  LocaleKeys.chatLock.tr(),
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Text(
                    LocaleKeys.chatLockMessage.tr(),
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w400,
                      color: AppColors.DARK_GRAY_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ToggleIconButton(),
        ],
      ),
    );
  }
}
