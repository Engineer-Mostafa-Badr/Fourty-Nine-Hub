import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomWinnerAppbar extends StatelessWidget {
  const CustomWinnerAppbar({
    super.key,
    required this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 18),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Label(
              text: LocaleKeys.winners.localize,
              style: Styles.headerText(fontSize: 28),
            ),
            const SizedBox(
              width: 4,
            ),
            Image.asset(Assets.cupImage),
            // SvgPicture.asset(Assets.cupIcon),
          ],
        ),
      ),
    );
  }
}
