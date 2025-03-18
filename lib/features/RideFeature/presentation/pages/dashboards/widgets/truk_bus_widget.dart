import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/edit_price_widget.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../widgets/dialog_widget/show_custom_dialog_trip.dart';
import '../../widgets/font_manager.dart';

class TrukBusWidget extends StatelessWidget {
  final bool isWithAnotherPrice;
  final String modeType;
  const TrukBusWidget(
      {super.key, this.isWithAnotherPrice = false, this.modeType = 'truk'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Column(children: [
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
                              color: AppColors.cF5F5F5,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(children: [
                                  SvgPicture.asset(
                                    Assets.star2,
                                    width: 8,
                                    height: 8,
                                  ),
                                  const Sizer(
                                    width: 4,
                                  ),
                                  Label(text: '4.5', style: Styles.smallText())
                                ]))))
                  ],
                ),
                Label(text: 'Ahmed', style: Styles.mediumText()),
                Label(text: '(50)', style: Styles.smallText())
              ])),
          const Sizer(width: 32),
          Expanded(
            flex: 8,
            child: IntrinsicWidth(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(spacing: 5, children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(Assets.rideFrom,
                                    width: 24, height: 24),
                              ),
                              Expanded(
                                  flex: 8,
                                  child: Label(
                                      text: 'Tariaq Bedon Esm Tariaq Bedon Esm',
                                      style: Styles.headerText()))
                            ]),
                            Row(spacing: 5, children: [
                              Expanded(
                                  flex: 1,
                                  child: Image.asset(Assets.rideTo,
                                      width: 24, height: 24)),
                              Expanded(
                                  flex: 8,
                                  child: Label(
                                      text: 'Open Air Mall - Madinaty',
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.w300)))
                            ]),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(children: [
                            Image.asset(Assets.rideIcon, width: 40, height: 40),
                            Label(
                                text: modeType == 'truk'
                                    ? LocaleKeys.transporte.tr()
                                    : LocaleKeys.bus.tr(),
                                style: Styles.mediumText(fontSize: 25))
                          ]))
                    ],
                  ),
                  Label(
                    text: modeType == 'truk'
                        ? "${LocaleKeys.cargoDescription.tr()} : Car"
                        : '${LocaleKeys.passenger.tr()} : 10',
                    style: Styles.mediumText(fontSize: 32),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Label(
                        text: '300',
                        style: Styles.mediumText(fontWeight: FontWeight.w700)),
                    const Sizer(width: 4),
                    Label(
                        text: LocaleKeys.egp.tr(),
                        style: Styles.mediumText(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w700))
                  ]),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 30,
                          radius: 15,
                          label: LocaleKeys.Accept.tr(),
                          onPressed: () {},
                          backColor: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: AppButton(
                          radius: 15,
                          height: 30,
                          label: isWithAnotherPrice
                              ? LocaleKeys.acceptAnothePrice.tr()
                              : LocaleKeys.refuse.tr(),
                          style: Styles.mediumText(
                              color: Colors.white,
                              fontSize: isWithAnotherPrice ? 23 : 28),
                          onPressed: () {
                            if (isWithAnotherPrice) {
                              showModalBottomSheet(
                                backgroundColor: AppColors.whiteColor,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15))),
                                isScrollControlled: true,
                                builder: (BuildContext context) =>
                                    const EditPriceWidget(),
                              );
                            } else {
                              showCustomDialogTrip(
                                  context,
                                  Column(
                                    spacing: 12,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        LocaleKeys.alert.localize,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          'You have got a free trip today from 49',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: FontSize.s16,
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          )),
                                      AppButton(
                                          width: context.screenWidth / 1.9,
                                          label: 'Go to Ride',
                                          backColor:
                                              AppColors.SECONDARY_COLOR_DARK2,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      const SizedBox(height: 16),
                                    ],
                                  ));
                            }
                          },
                          backColor: AppColors.SECONDARY_COLOR_DARK2,
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
    );
  }
}
