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
    return InkWell(
      onTap: (){
        // Card(
        //   child: Container(
        //     width: 200,
        //     height: 200,
        //     decoration: BoxDecoration(
        //       color: AppColors.AUTH_CONTAINER_COLOR,
        //       borderRadius: BorderRadius.circular(16)
        //     ),
        //     child: Column(
        //       children: [
        //         Text('Congratulation',
        //         style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        //         ),
        //         const SizedBox(
        //           height: 10,
        //         ),
        //         Text('You got a gift of 400 pounds as a welcome gift for registering on the 49 app.',
        //         style: Styles.mediumText(),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0.zR),
              ),
              child: Container(
                padding: EdgeInsets.all(30.0.zW),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Congtatulation',
                      style: Styles.headerText(color: AppColors.SECONDARY_COLOR,fontSize: 45),
                    ),
                    SizedBox(height: 16.0.zH),
                    Text(
                      'You got a gift of 400 pounds as a welcome gift for registering on the 49 app.',
                      textAlign: TextAlign.center,
                      style: Styles.mediumText(),
                    ),
                    SizedBox(height: 40.0.zH),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0.zR),
                        ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 40.0.zW,
                          vertical: 24.0.zH,
                        ),
                        child: Text(
                          'CLOSE',
                          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
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
          child:  Center(child: Label(text: LocaleKeys.Ads.tr(),
            style: TextStyle(
              fontSize: 34.zW,
              fontWeight: FontWeight.bold
          ),))
          // AdmobBanner(
          //         adUnitId: UIConst.adHomeUnitId,
          //         adSize: AdmobBannerSize.BANNER,
          //         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
          //       )
          ),
    );
  }
}


void _showCenterBox(BuildContext context,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome!'),
        content: Text('Registration successful!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}