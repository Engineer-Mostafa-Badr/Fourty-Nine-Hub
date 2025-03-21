import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../domain/entities/dashboards/trip_entity.dart';
import '../../widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'edit_price_widget.dart';

class AvailableRideTripItem extends StatelessWidget {
  final AvailableRideTripEntity tripEntity;
  const AvailableRideTripItem(
      {super.key, required this.tripEntity});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Assets.personalImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Label(
                  text: tripEntity.clientName, //'Ahmed',
                  style: Styles.mediumText(),
                ),
                const SizedBox(height: 4),
                //  Label(
                //   text: '${(tripEntity.duration/120).toStringAsFixed(0)} Hour',
                //   style: const TextStyle(fontWeight: FontWeight.w300),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(spacing: 5,children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(Assets.rideFrom, width: 24, height: 24),
                  ),
                  Expanded(
                    flex: 9,
                    child: Label(
                      text:tripEntity.fromAddress, //'Tariaq Bedon Esm',
                      style: Styles.headerText(),
                    ),
                  )
                ]),
                Row(spacing: 5,children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset(Assets.rideTo, width: 24, height: 24)),
                  Expanded(
                      flex: 9,
                      child: Label(
                          text: tripEntity.toAddress,//'Open Air Mall - Madinaty',
                          style:
                              Styles.mediumText(fontWeight: FontWeight.w300)))
                ]),
               const SizedBox(height: 5), RichText(
                  text: TextSpan(
                    text: '${tripEntity.price} ',
                    style: const TextStyle(color: AppColors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: LocaleKeys.egp.tr(),
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.SECONDARY_COLOR_DARK2)),
                      TextSpan(
                          text:
                              // ' - ${tripEntity.distance / 1000} '
                                  '${LocaleKeys.KM.tr()}'),
                    ],
                  ),
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
                        label: !tripEntity.isAutoAccept
                            ? LocaleKeys.acceptAnothePrice.tr()
                            : LocaleKeys.refuse.tr(),
                        style: Styles.mediumText(
                            color: Colors.white,
                            fontSize: !tripEntity.isAutoAccept ? 23 : 28),
                        onPressed: () {
                          if (!tripEntity.isAutoAccept) {
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
                                      LocaleKeys.alert.tr(),
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
                                          fontSize: 16,
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
        ],
      ),
    );
  }
}
