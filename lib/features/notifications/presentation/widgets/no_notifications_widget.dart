import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NoNotificationsWidget extends StatelessWidget {
  const NoNotificationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomEmptyWidget(label: LocaleKeys.thereAreNoNotifications.localize);
    // Center(
    //   child: Text(
    //     LocaleKeys.thereAreNoNotifications.localize,
    //     style: Styles.headerText(
    //       color: context.isDarkMode ? Colors.white : Colors.black,
    //     ),
    //   ),
    // );
  }
}
