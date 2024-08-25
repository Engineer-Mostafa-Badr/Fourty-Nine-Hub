import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';

class GoogleAddsBanner extends StatelessWidget {
  final double margin;
  const GoogleAddsBanner({super.key, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: kToolbarHeight *1.3.zH,
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: margin,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20.zR),
            boxShadow: const [
              BoxShadow(
                color: AppColors.GRAY_LIGHT_COLOR3,
                blurRadius: 5,
                spreadRadius: 5,
              )
            ]),
        child:  Center(child: Label(text: LocaleKeys.ads.tr(),
          style: TextStyle(
              fontSize: 34.zW,
              fontWeight: FontWeight.bold
          ),))
        // AdmobBanner(
        //         adUnitId: UIConst.adHomeUnitId,
        //         adSize: AdmobBannerSize.BANNER,
        //         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
        //       )
        );
  }
}
