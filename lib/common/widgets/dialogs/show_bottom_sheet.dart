import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';

void bottomSheet(
    {required BuildContext context,
    required Widget widget,
    Color? backColor,
    bool isFloating = false,
    bool isScrollControlled = false}) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(30.zW),
          // margin: const EdgeInsets.all(kToolbarHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.zR),
              topRight: Radius.circular(20.zR),
            ),
            color: backColor ?? Theme.of(context).dialogBackgroundColor,
          ),
          child: widget,
        );
      });
}
