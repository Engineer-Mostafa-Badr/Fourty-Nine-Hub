import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(UIConst.socialImagePlaceHolder),
        ),
        const Sizer(
          height: 5,
        ),
        Label(text: 'H&M', style: Styles.mediumText()),
      ],
    );
  }
}
