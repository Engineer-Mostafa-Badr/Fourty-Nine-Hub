import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        color: AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          Assets.maleImagePlaceholder,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: AppColors.SECONDARY_COLOR,
                          color: AppColors.cF5F5F5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.star2,
                                width: 8,
                                height: 8,
                              ),
                              const Sizer(
                                width: 4,
                              ),
                              Label(
                                text: '4.5',
                                style: Styles.smallText(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
            const Sizer(
              width: 32,
            ),
            Expanded(
              child: IntrinsicWidth(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        // const Sizer(),
                        const Spacer(),
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
                    false
                        ? Label(
                            text: 'Passenger : 10',
                            style: Styles.mediumText(fontSize: 32),
                          )
                        : Label(
                            text: 'Cargo Description : Car',
                            style: Styles.mediumText(fontSize: 32),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                          text: '300',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Sizer(
                          width: 4,
                        ),
                        Label(
                          text: 'EGP',
                          style: Styles.mediumText(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: '10 AM',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Label(
                          text: '20/2/2025',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppButton(
                                  height: 30,
                                  radius: 15,
                                  label: 'Accept',
                                  onPressed: () {},
                                  backColor: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              const Sizer(),
                              Expanded(
                                child: AppButton(
                                  radius: 15,
                                  height: 30,
                                  label: 'Refuse',
                                  onPressed: () {},
                                  backColor: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.call,
                                ),
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.mail_outline_outlined,
                                ),
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: Icon(
                              //     Icons.alert,
                              //   ),
                              //   color: AppColors.PRIMARY_COLOR,
                              // ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
