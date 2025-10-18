import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NoNotificationsWidget extends StatelessWidget {
  const NoNotificationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.isArabic ? 'لا يوجد إشعارات' : 'There are no notifications',
        style: Styles.headerText(),
      ),
    );
  }
}
