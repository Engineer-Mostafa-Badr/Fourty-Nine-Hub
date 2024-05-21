import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class CancelOrder extends StatelessWidget {
  final String id;
  const CancelOrder({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: ListView(
        shrinkWrap: true,
        children: [
          Label(text: 'Cancel this request?', style: Styles.mediumText()),
          const Sizer(),
          AppButton(
              label: 'Keep finding Driver!', onPressed: () => context.pop()),
          const Sizer(),
          AppButton(
              label: 'Cancel Request',
              backColor: Colors.grey[100] ?? Colors.grey,
              textColor: Colors.black,
              onPressed: () {}),
          const Sizer(),
        ],
      ),
    );
  }
}
