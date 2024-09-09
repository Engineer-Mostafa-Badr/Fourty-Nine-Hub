import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';

class Sizer extends StatelessWidget {
  final double? height;
  final double? width;

  const Sizer({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 20.zH,
      width: width ?? 20.zW,
    );
  }
}
