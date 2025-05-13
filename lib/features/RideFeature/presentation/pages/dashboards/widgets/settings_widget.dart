import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../../widgets/bottom_sheet/custom_bottom_sheet.dart';
import '../../widgets/fare_bottom_sheet_widget.dart';
import 'update_personal_info_widget.dart';

class SettingsWidget extends StatefulWidget {
  final String modeType;
  final SettingsDashboardEntity? settings;
  const SettingsWidget({super.key, required this.modeType, this.settings});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late bool isReady;
  late bool enableSound;
  late bool isCaptainShare;
  late bool isCaptain;
  late bool isIntercity;
  late bool isPremium;
  var planController = ExpansionTileController();
  var cityController = ExpansionTileController();
  List<String> subscriptionPlans = [
    'percentage',
    'subscribePackage',
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
  late String planTrailing;
  late String cityTrailing;
  @override
  void initState() {
    super.initState();
    planTrailing = widget.settings?.subscriptionType ?? '';
    cityTrailing = widget.settings?.city ?? '';
    isReady = widget.settings?.isReady ?? false;
    enableSound =  widget.settings?.enableNotificationSound ?? false;
    isCaptainShare = false;
    isCaptain = widget.settings?.categoryIds[0].isActive ?? false;
    isIntercity = widget.settings?.categoryIds[1].isActive ?? false;
    isPremium = widget.settings?.categoryIds[2].isActive ?? false;
  }

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
                title: "Enable Sound",
                subText: enableSound ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                valuee: enableSound,
                onChanged: (value) {
                  setState(() {
                    enableSound = value;
                  });
                }),
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
                title: widget
                    .settings?.categoryIds[0].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[0].nameAr
                    : widget.settings?.categoryIds[0]
                        .nameEn, //LocaleKeys.captain.tr(),
                valuee: isCaptain,
                onChanged: (value) {
                  setState(() {
                    isCaptain = value;
                  });
                }),
            switchWidget(
                title: widget
                    .settings?.categoryIds[1].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[1].nameAr
                    : widget.settings?.categoryIds[1]
                        .nameEn, //LocaleKeys.intercity.tr(),
                valuee: isIntercity,
                onChanged: (value) {
                  setState(() {
                    isIntercity = value;
                  });
                }),
            switchWidget(
                title: widget
                    .settings?.categoryIds[2].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[2].nameAr
                    : widget.settings?.categoryIds[2]
                        .nameEn, //LocaleKeys.premium.tr(), //'Premium',
                valuee: isPremium,
                onChanged: (value) {
                  setState(() {
                    isPremium = value;
                  });
                }),
            _expansionTileWidget(
              controller: planController,
              title: LocaleKeys.subscriptionPlan.tr(), //'Subscription plan',
              trailing: planTrailing.tr(),
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
                          child: Label(text: subscriptionPlans[index].tr())))[index],
                ),
              ),
            ),
            _expansionTileWidget(
              controller: cityController,
              title: LocaleKeys.favoriteCity.tr(), //'Favorite city',
              trailing: cityTrailing.tr(),
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
                        customBottomSheet2(context,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FareBottomSheetWidget(
                                rideCubit: context.read<RideCubit>(),
                                selectedCategoryPrice: 44,
                                selectedCategoryName: 'aaa',
                              ),
                            ),
                            title: LocaleKeys.acceptAnothePrice.tr());
                      },
                      child: Text(
                          '${widget.settings?.pricingPerKm ?? 0} ${'change'.tr()}',
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
                  initialRating: widget.settings?.rating.averageRating ?? 2.5,
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
                Text(widget.settings?.rating.averageRating.toString() ?? '2.5',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700))
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
                Text('${widget.settings?.profit ?? '0'} ${LocaleKeys.egp.tr()}',
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
                Text(widget.settings?.countTrips.toString() ?? '', //'38',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500))
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
          Row(
            spacing: 5,
            children: [
              Expanded(
                flex: 2,
                child: AppButton(
                    label: LocaleKeys.deleteRegistration.tr(),
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {}),
              ),
              Expanded(
                flex: 2,
                child: AppButton(
                    label: LocaleKeys.update.tr(),
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      context.read<DashboardsCubit>().updateSettings(
                          context,
                          UpdateSettingsDashboardUsecaseParam(
                              isReady: isReady,
                              enableSound: enableSound,
                              subscriptionPlan: planTrailing,
                              favoriteCity: cityTrailing,
                              subCategoriesActive: [
                                SubCategoriesActive(
                                    subcategoryId:
                                        widget.settings!.categoryIds[0].id,
                                    isActive: isCaptain),
                                SubCategoriesActive(
                                    subcategoryId:
                                        widget.settings!.categoryIds[1].id,
                                    isActive: isIntercity),
                                SubCategoriesActive(
                                    subcategoryId:
                                        widget.settings!.categoryIds[2].id,
                                    isActive: isPremium),
                              ]));
                    }),
              ),
            ],
          ),
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
              : ImageFromInternet(image:title ?? '', width: 60, height: 25),
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
