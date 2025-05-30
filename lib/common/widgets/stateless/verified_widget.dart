import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/assets/assets.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
        bottom: 3,
         end: 0,
        child: SvgPicture.asset(Assets.verifiedAccountMarkIcon,
          height: 15,
        ));
  }
}
