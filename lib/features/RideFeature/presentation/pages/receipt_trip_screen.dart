import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class ReceiptTripScreen extends StatelessWidget {
  const ReceiptTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: Transform(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child:  Text(
              LocaleKeys.receipt.localize,
              style: const TextStyle(
                // color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50,),
            Image.asset(Assets.carBanner,
            fit: BoxFit.cover,
            ),
            const SizedBox(height: 74,),
            Label(text: LocaleKeys.total.localize,
            textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30
              ),
            ),
            const SizedBox(height: 24,),
            const Divider(color: AppColors.c6E6E70,),
            const SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Label(
                  text: "190",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(width: 4),
                Label(
                  text: "EGP",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ), 
            const SizedBox(height: 49,),
            const Divider(color: AppColors.c6E6E70,),
            const SizedBox(height: 8,),
            Padding(
              padding:  const EdgeInsetsDirectional.only(start:16),
              child: Label(text: LocaleKeys.payments.localize,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                ),
              ),
            ),
            Padding(
              padding:  const EdgeInsetsDirectional.only(start:16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 30, // Adjust based on your SVG size
                        child: SvgPicture.asset(Assets.cash),
                      ),
                      const SizedBox(width: 8), // Adds spacing between image and text
                      Padding(
                        padding: const EdgeInsets.only(top: 25), // Adjust this value for more top padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          mainAxisAlignment: MainAxisAlignment.center, // Align vertically
                          children: [
                            Label(text: LocaleKeys.cash.localize,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                            ),
                            ),
                             Label(text: "07/02/2025 22:31",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                color: AppColors.black.withOpacity(.75)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Label(
                    text: "EGP 190",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                  ),
                ],
              ),
            )


          ],

        ));
  }
}
