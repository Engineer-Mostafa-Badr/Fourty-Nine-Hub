import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class HeaderSuggestReelsInstagram extends StatelessWidget {
  const HeaderSuggestReelsInstagram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 21, end: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Label(
            text: LocaleKeys.suggestReels.localize,
            style: Styles.headerText(
              fontSize: 32,
              height: 1.25,
            ),
          ),
          InkWell(
            onTap: () {

      ManageVibration.vibrate();
            },
            child: Label(
              text: LocaleKeys.watchAll.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}