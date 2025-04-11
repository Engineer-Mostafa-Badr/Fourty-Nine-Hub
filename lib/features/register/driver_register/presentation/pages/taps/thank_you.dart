import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/styles.dart';

class ThankYou extends StatelessWidget {
  final String label, title, subTitle;
  const ThankYou(
      {super.key,
      required this.label,
      required this.subTitle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: label,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.check,
                size: 40,
              ),
            ),
            const Sizer(),
            Label(
              text: title,
              style: Styles.headerText(),
            ),
            Label(
              text: subTitle,
              style: Styles.mediumText(),
            ),
          ],
        ),
      ),
    );
  }
}
