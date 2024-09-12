import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NoNotificationsWidget extends StatelessWidget {
  const NoNotificationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'There are no notifications',
        style: Styles.headerText(),
      ),
    );
  }
}
