import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class RideWidget extends StatelessWidget {
  const RideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BG_GRAY_COLOR,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    Assets.maleImagePlaceholder,
                    fit: BoxFit.cover,
                  ),
                ),
                Label(
                  text: 'Ahmed',
                  style: Styles.mediumText(),
                ),
                Label(
                  text: '(50)',
                  style: Styles.smallText(),
                ),
              ],
            ),
            const Sizer(width: 32,),
            IntrinsicWidth(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.rideFrom,
                                width: 24,
                                height: 24,
                              ),
                              Label(
                                text: 'Tariaq Bedon Esm',
                                style: Styles.headerText(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                Assets.rideTo,
                                width: 24,
                                height: 24,
                              ),
                              Label(
                                text: 'Open Air Mall - Madinaty',
                                style: Styles.mediumText(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Sizer(),
                      Column(
                        children: [
                          Image.asset(
                            Assets.rideIcon,
                            width: 60,
                            height: 60,
                          ),
                          Label(
                            text: 'Bus',
                            style: Styles.mediumText(),
                          ),
                        ],
                      )
                    ],
                  ),

                  Label(
                    text: ' Passenger : 10',
                    style: Styles.mediumText(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                        text: '300',
                        style: Styles.mediumText(),
                      ),
                      Label(
                        text: 'EGP',
                        style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: '10 AM',
                        style: Styles.mediumText(),
                      ),
                      Label(
                        text: '20/2/2025',
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Accept',
                          onPressed: () {},
                          backColor: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      Sizer(),
                      Expanded(
                        child: AppButton(
                          label: 'Refuse',
                          onPressed: () {},
                          backColor: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
