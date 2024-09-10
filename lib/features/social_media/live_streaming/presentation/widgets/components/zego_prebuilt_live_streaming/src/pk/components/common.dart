// Flutter imports:
import 'package:flutter/material.dart';

import '../../../../zego_uikit/src/services/defines/user.dart';

// Package imports:

Widget defaultPKBackgroundBuilder(
  BuildContext context,
  Size size,
  ZegoUIKitUser? user,
  Map<String, dynamic> extraInfo,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
      ),
    ),
  );
}
