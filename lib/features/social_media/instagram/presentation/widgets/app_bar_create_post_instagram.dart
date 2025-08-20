import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';

class AppBarCreatePostInstagram extends StatelessWidget {
  const AppBarCreatePostInstagram({
    super.key,
    required this.postIndex,
    required this.onPressed,
  });

  final int postIndex;
  final void Function()? onPressed;

  String getTitle(int postIndex) {
    switch (postIndex) {
      case 0:
        return LocaleKeys.newPost.localize;
      case 1:
        return LocaleKeys.newStory.localize;
      case 2:
        return LocaleKeys.newReel.localize;
      default:
        return LocaleKeys.post.localize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
      ManageVibration.vibrate();
            context.pop();
          },
        ),
        const SizedBox(
          width: 12,
        ),
        Label(
          text: getTitle(postIndex),
          style: Styles.headerText(
            fontSize: 40,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onPressed,
          child: Label(
            text: LocaleKeys.next.localize,
            style: Styles.headerText(
              color: context.isDarkMode ? Colors.white : AppColors.c1B2781,
            ),
          ),
        )
      ],
    );
  }
}