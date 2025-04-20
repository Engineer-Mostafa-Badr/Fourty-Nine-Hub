import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class AppBarCreatePostInstagram extends StatelessWidget {
  const AppBarCreatePostInstagram({
    super.key,
    required this.postType,
    required this.onPressed,
  });

  final String postType;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        const SizedBox(
          width: 12,
        ),
        Label(
          text: '${LocaleKeys.nnew.localize} $postType',
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
              fontSize: 40,
              color: AppColors.c1B2781,
            ),
          ),
        )
      ],
    );
  }
}
