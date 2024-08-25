import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../core/localization/locale_keys.g.dart';
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
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.GRAY_LIGHT_COLOR3,
                blurRadius: 5,
                spreadRadius: 5,
              )
            ]),
        child: Center(
            child: Label(
          text: LocaleKeys.ads.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ))
        // AdmobBanner(
        //         adUnitId: UIConst.adHomeUnitId,
        //         adSize: AdmobBannerSize.BANNER,
        //         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
        //       )
        );
  }
}
