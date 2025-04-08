import 'package:flutter/material.dart';

import '../../../../res/assets/assets.dart';

class StatusIconBuilder extends StatelessWidget {
  const StatusIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Image.asset(
        Assets.status,
        height: 30,
      );
    });
  }
}
