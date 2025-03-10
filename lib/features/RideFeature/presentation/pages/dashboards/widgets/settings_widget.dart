import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../widgets/bottom_sheet/custom_bottom_sheet.dart';
import '../../widgets/fare_bottom_sheet_widget.dart';
import 'update_personal_info_widget.dart';

class SettingsWidget extends StatefulWidget {
  final String modeType;
  const SettingsWidget({super.key, required this.modeType});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isReady = false;
  bool isCaptainShare = false;
  bool isCaptain = false;
  bool isIntercity = false;
  bool isPremium = false;
  var planController = ExpansionTileController();
  var cityController = ExpansionTileController();
  List<String> subscriptionPlans = [
    'percentage'.tr(),
    'subscribePackage'.tr(),
  ];
  List<String> favoriteCity = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayoum',
    'Gharbia',
    'Ismailia',
    'Menoufia',
  ];
  String planTrailing = 'Percentage';
  String cityTrailing = 'Cairo';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: ListView(
        children: [
          switchWidget(
              title: LocaleKeys.ready.tr(),
              subText: isReady ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
              valuee: isReady,
              onChanged: (value) {
                setState(() {
                  isReady = value;
                });
              }),
          if (widget.modeType == 'ride') ...[
            switchWidget(
                title: LocaleKeys.captainShare.tr(), //'Captain share',
                subText:
                    isCaptainShare ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                valuee: isCaptainShare,
                onChanged: (value) {
                  setState(() {
                    isCaptainShare = value;
                  });
                }),
            switchWidget(
                title: Assets.greyCar,
                isText: false,
                subText: LocaleKeys.captain.tr(),
                valuee: isCaptain,
                onChanged: (value) {
                  setState(() {
                    isCaptain = value;
                  });
                }),
            switchWidget(
                title: Assets.greyCar,
                isText: false,
                subText: LocaleKeys.intercity.tr(),
                valuee: isIntercity,
                onChanged: (value) {
                  setState(() {
                    isIntercity = value;
                  });
                }),
            switchWidget(
                title: Assets.greyCar,
                isText: false,
                subText: LocaleKeys.premium.tr(), //'Premium',
                valuee: isPremium,
                onChanged: (value) {
                  setState(() {
                    isPremium = value;
                  });
                }),
            _expansionTileWidget(
              controller: planController,
              title: LocaleKeys.subscriptionPlan.tr(), //'Subscription plan',
              trailing: planTrailing,
              childrenList: List.generate(
                subscriptionPlans.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      planTrailing = subscriptionPlans[index];
                      planController.collapse();
                    });
                  },
                  child: List.generate(
                      subscriptionPlans.length,
                      (index) => Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Label(text: subscriptionPlans[index])))[index],
                ),
              ),
            ),
            _expansionTileWidget(
              controller: cityController,
              title: LocaleKeys.favoriteCity.tr(), //'Favorite city',
              trailing: cityTrailing,
              childrenList: List.generate(
                favoriteCity.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      cityTrailing = favoriteCity[index];
                      cityController.collapse();
                    });
                  },
                  child: List.generate(
                      favoriteCity.length,
                      (index) => Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Label(text: favoriteCity[index])))[index],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.pricingPerKm.tr(), //'Pricing Per Km',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  GestureDetector(
                      onTap: () {
                        customBottomSheet(context,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FareBottomSheetWidget(),
                            ),
                            title: LocaleKeys.acceptAnothePrice.tr());
                      },
                      child: Text('20 ${'change'.tr()}',
                          style: const TextStyle(fontSize: 12)))
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              children: [
                Text(LocaleKeys.myRating.tr(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const Spacer(),
                RatingBar(
                  initialRating: 2.5,
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(Assets.star1),
                    half: SvgPicture.asset(Assets.star1),
                    empty: SvgPicture.asset(Assets.starEmpty),
                  ),
                  itemSize: 13,
                  onRatingUpdate: (double value) {},
                ),
                const SizedBox(width: 5),
                const Text('2.5',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.totalProfit.tr(), //'Total Profit',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text('1050 ${LocaleKeys.egp.tr()}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.totalTrips.tr(), //'Total Trips',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const Text('38',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          UpdatePersonalInfoWidget(title: LocaleKeys.id.tr(), exdIn: 6),
          UpdatePersonalInfoWidget(
              title: LocaleKeys.driversLicense.tr(), exdIn: 6),
          if (widget.modeType == 'ride') ...[
            UpdatePersonalInfoWidget(
                title: LocaleKeys.carLicense.tr(), exdIn: 6),
            UpdatePersonalInfoWidget(
                title: LocaleKeys.criminalRecord.tr(), exdIn: 6),
            UpdatePersonalInfoWidget(
                title: LocaleKeys.drugAnalysis.tr(), exdIn: 6),
          ],
          UpdatePersonalInfoWidget(
              title: LocaleKeys.vehicleInspection.tr(), exdIn: 6),
          const SizedBox(height: 16),
          AppButton(
              label: LocaleKeys.deleteRegistration.tr(),
              backColor: AppColors.SECONDARY_COLOR_DARK2,
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget _expansionTileWidget(
          {required ExpansionTileController controller,
          required String title,
          required String trailing,
          required List<Widget> childrenList}) =>
      ExpansionTile(
        controller: controller,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.all(0),
        minTileHeight: 40,
        title: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailing, style: const TextStyle(fontSize: 12)),
            const Icon(Icons.keyboard_arrow_down_rounded)
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childrenList),
          ),
        ],
      );

  Widget switchWidget(
      {required String? title,
      required String? subText,
      required bool? valuee,
      bool isText = true,
      Function(bool)? onChanged}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: Row(
        spacing: 8,
        children: [
          isText
              ? Text(title ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500))
              : Image.asset(title ?? '', width: 60, height: 25),
          const Spacer(),
          Text(subText ?? '',
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: valuee ?? false,
              activeColor: AppColors.PRIMARY_COLOR,
              inactiveThumbColor: AppColors.PRIMARY_COLOR,
              trackOutlineColor: WidgetStateProperty.all<Color>(
                AppColors.PRIMARY_COLOR,
              ),
              activeTrackColor: const Color(0xff19D176),
              inactiveTrackColor: AppColors.whiteColor,
              onChanged: onChanged ??
                  (value) {
                    setState(() {
                      valuee = value;
                    });
                  },
            ),
          ),
        ],
      ),
    );
  }
}
