import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../../dynamic/sizer.dart';

class EmptyPage extends StatelessWidget {
  final String? label;
  const EmptyPage({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.empty,
              height: kToolbarHeight,
            ),
            Sizer(),
            Label(text: label ?? 'Empty List', style: Styles.headerText())
          ],
        ),
      ),
    );
  }
}
