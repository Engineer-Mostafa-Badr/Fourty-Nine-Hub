import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ClientOffersWidget extends StatelessWidget {
  final String modeType;
  final TripEntity? offers;
  const ClientOffersWidget(
      {super.key, this.modeType = 'truk', this.offers});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        offers?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(20)
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
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: offers?.clientDetails?.profilePictureUrl ==
                                      null ||
                                  offers!
                                      .clientDetails!.profilePictureUrl.isEmpty
                              ? Image.asset(
                                  Assets.maleImagePlaceholder,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  offers!.clientDetails!.profilePictureUrl,
                                )),
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
                                  SvgPicture.asset(Assets.star2,
                                      width: 8, height: 8),
                                  const Sizer(width: 4),
                                  Label(
                                      text: offers
                                              ?.clientDetails?.rating?.count
                                              .toString() ??
                                          '0',
                                      style: Styles.smallText())
                                ]))))
                  ],
                ),
                Label(
                    text: offers?.clientDetails?.firstName ?? '',
                    style: Styles.mediumText()),
                Label(
                    text:
                        '(${offers?.clientDetails?.rating?.average ?? 0})',
                    style: Styles.smallText())
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
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(Assets.rideFrom,
                                      width: 24, height: 24),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDetails
                                                ?.startLocation.title ??
                                            'Cairo International Airport',
                                        style: Styles.headerText()))
                              ],
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(Assets.rideTo,
                                        width: 24, height: 24)),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDetails
                                                ?.targetLocation.title ??
                                            'Cairo International Airport',
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.w300)))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              offers?.clientDetails?.profilePictureUrl ==
                                          null ||
                                      offers!.clientDetails!
                                          .profilePictureUrl.isEmpty
                                  ? Image.asset(Assets.rideIcon,
                                      width: 40, height: 40, fit: BoxFit.cover)
                                  : Image.network(
                                      offers!.subCategory!.pictureUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.contain),
                              Label(
                                  text: context.isArabic
                                      ? (offers?.subCategory?.nameAr ?? '')
                                      : (offers?.subCategory?.nameEn ?? ''),
                                  style: Styles.mediumText(fontSize: 25))
                            ],
                          )),
                    ],
                  ),
                  Label(
                    text: modeType == 'truk'
                        ? "${LocaleKeys.cargoDescription.tr()} : Car"
                        : '${LocaleKeys.passenger.tr()} : ${offers?.tripDetails?.passengers ?? 0}',
                    style: Styles.mediumText(fontSize: 32),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                          text: "${offers?.tripDetails?.price ?? 300}",
                          style:
                              Styles.mediumText(fontWeight: FontWeight.w700)),
                      const Sizer(width: 4),
                      Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: formattedTime, //'10 AM',
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Label(
                        text: formattedDate, //'20/2/2025',
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
                          onPressed: () {

      ManageVibration.vibrate();
                          },
                          backColor: AppColors.PRIMARY_COLOR
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: AppButton(
                          radius: 15,
                          height: 30,
                          label: LocaleKeys.refuse.tr(),
                          style: Styles.mediumText(
                              color: Colors.white, fontSize: 23),
                          onPressed: () {

      ManageVibration.vibrate();
                          },
                          backColor: AppColors.SECONDARY_COLOR_DARK2
                             
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