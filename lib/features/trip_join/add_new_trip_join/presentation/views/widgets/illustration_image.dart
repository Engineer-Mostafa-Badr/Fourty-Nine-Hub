import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class IllustrationImage extends StatelessWidget {
  const IllustrationImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 375.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(Assets.tripViewIllustration, fit: BoxFit.fill),
    );
  }
}
