import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class RideWidget extends StatelessWidget {
  const RideWidget(
      {super.key, required this.isTruck, required this.isDriver, required this.isSubscribed});

  final bool isTruck;
  final bool isDriver;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                            decoration:
                            const BoxDecoration(shape: BoxShape.circle),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
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
                  width: 16,
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
                        isTruck
                            ? GestureDetector(
                          onTap: () {
                            showAnimatedDialog(
                              context,
                              AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    Label(
                                      text: 'Cargo Description:',
                                      style: Styles.headerText(),
                                    ),
                                    Label(
                                      text: 'Car',
                                      style: Styles.headerText(),
                                    ),
                                    AppButton(
                                      label: LocaleKeys.close.localize,
                                      backColor: AppColors.PRIMARY_COLOR,
                                      onPressed: () {
                                        context.pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Label(
                            text: 'Cargo Description : Car',
                            style: Styles.mediumText(fontSize: 32),
                          ),
                        )
                            : Label(
                          text: 'Passenger : 10',
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
                        true
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
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
                                label: isDriver
                                    ? 'Accept another price'
                                    : 'Refuse',
                                style: isDriver
                                    ? Styles.mediumText(
                                    color: Colors.white, fontSize: 24)
                                    : Styles.mediumText(
                                    color: Colors.white),
                                onPressed: () {},
                                backColor: AppColors.SECONDARY_COLOR,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                bottomSheet(
                                  context: context,
                                  widget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            12.0),
                                                        child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle),
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          child:
                                                          Image.asset(
                                                            Assets
                                                                .maleImagePlaceholder,
                                                            fit: BoxFit
                                                                .cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            color: AppColors
                                                                .cF5F5F5,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                4.0),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  Assets
                                                                      .star2,
                                                                  width:
                                                                  8,
                                                                  height:
                                                                  8,
                                                                ),
                                                                const Sizer(
                                                                  width:
                                                                  4,
                                                                ),
                                                                Label(
                                                                  text:
                                                                  '4.5',
                                                                  style: Styles
                                                                      .smallText(),
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
                                                    style: Styles
                                                        .mediumText(),
                                                  ),
                                                ],
                                              ),
                                              Label(
                                                text: 'Connecting Ahmed',
                                                style:
                                                Styles.headerText(),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              Assets.close,
                                              width: 24,
                                              height: 24,
                                            ),
                                            onPressed: () =>
                                                context.pop(),
                                          ),
                                        ],
                                      ),
                                      AppButton(
                                        label:
                                        '${LocaleKeys.free
                                            .localize} ${LocaleKeys.call
                                            .localize}',
                                        style: Styles.headerText(
                                            color: Colors.white),
                                        backColor:
                                        AppColors.PRIMARY_COLOR,
                                        onPressed: () {},
                                      ),
                                      AppButton(
                                        label:
                                        '${LocaleKeys.regular
                                            .localize} ${LocaleKeys.call
                                            .localize}',
                                        color: AppColors.PRIMARY_COLOR,
                                        style: Styles.headerText(),
                                        backColor: AppColors.cF5F5F5,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.call,
                              ),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.mail_outline_rounded,
                              ),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                Assets.reportRounded,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if(isSubscribed == false)
        Positioned.fill(
          child: GestureDetector(
            onTap: () =>
                showAnimatedDialog(
                    context,
                    AlertDialog(
                      content: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Label(
                            text: LocaleKeys.alert.localize,
                            style: Styles.headerText(
                              color: AppColors.SECONDARY_COLOR,
                            ),
                          ),
                          Label(
                            text: 'Please subscribe for more trips',
                            style: Styles.headerText(fontSize: 35),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: LocaleKeys.close.localize,
                                  onPressed: () {},
                                  backColor: AppColors.SECONDARY_COLOR_DARK2,
                                  height: 40,
                                ),
                              ),
                              Sizer(),
                              Expanded(
                                child: AppButton(
                                  label: LocaleKeys.subscribe.localize,
                                  onPressed: () {},
                                  backColor: AppColors.PRIMARY_COLOR,
                                  height: 40,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
