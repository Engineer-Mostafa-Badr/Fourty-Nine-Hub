import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class LoadingCustom {
  static customThreeBounce(BuildContext context,
      {Color color = AppColors.PRIMARY_COLOR, size = 20.0}) {
    return Center(
      child: SpinKitThreeBounce(
        color: color,
        size: size,
      ),
    );
  }
}
