import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
            onTap: () {},
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
