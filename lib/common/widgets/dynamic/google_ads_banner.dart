import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../res/style/app_colors.dart';

class GoogleAddsBanner extends StatelessWidget {
  final double margin;
  const GoogleAddsBanner({super.key, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: kToolbarHeight,
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: margin,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.GRAY_LIGHT_COLOR3,
                blurRadius: 5,
                spreadRadius: 5,
              )
            ]),
        child: const Center(child: Label(text: 'Ads'))
        // AdmobBanner(
        //         adUnitId: UIConst.adHomeUnitId,
        //         adSize: AdmobBannerSize.BANNER,
        //         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
        //       )
        );
  }
}
