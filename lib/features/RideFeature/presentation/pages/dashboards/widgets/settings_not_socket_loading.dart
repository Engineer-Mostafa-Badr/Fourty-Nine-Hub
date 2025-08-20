import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/personal_documents_loading_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/vehicle_information_loading_screen.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../domain/entities/loading/settings_driver_loading_entity.dart';
import '../../../../domain/usecases/dashboards/loading/update_driver_loading_settings_use_case.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../../loading_dashboard/loading_dashboard_details_screen.dart';
import 'drivers_license_loading_screen.dart';
import 'update_personal_info_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';


class SettingsNotSocketLoading extends StatefulWidget {
  final DriverSettingLoadingEntity? settings;
  const SettingsNotSocketLoading({super.key, this.settings});

  @override
  State<SettingsNotSocketLoading> createState() => _SettingsNotSocketLoadingState();
}

class _SettingsNotSocketLoadingState extends State<SettingsNotSocketLoading> {
  late bool enableSound;
  late bool isReady;

  late bool originalEnableSound;
  late bool originalIsReady;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() {
    enableSound = widget.settings?.isVoiceCommentAlertsEnabled ?? false;
    isReady = widget.settings?.isReady ?? false;

    originalEnableSound = enableSound;
    originalIsReady = isReady;
  }

  @override
  void didUpdateWidget(covariant SettingsNotSocketLoading oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update state if new settings come from API
    if (widget.settings != oldWidget.settings && widget.settings != null) {
      setState(() {
        _initializeSettings();
      });
    }
  }

  bool hasChanges() {
    return enableSound != originalEnableSound || isReady != originalIsReady;
  }

  void submitChanges() {
    final params = UpdateDriverSettingsLoadingParams(
      isReady: isReady,
      isVoiceCommentAlertsEnabled: enableSound,
    );

    context.read<DashboardsCubit>().updateDriverLoadingSettings(
      params: params,
      context: context,
    );

    // Update original values
    setState(() {
      originalEnableSound = enableSound;
      originalIsReady = isReady;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
            },
          ),
          switchWidget(
            title: context.isArabic ? 'اشعارات صوتية' : 'Voice notify',
            subText: enableSound
                ? (context.isArabic ? 'تفعيل' : 'Enabled')
                : (context.isArabic ? 'تعطيل' : 'Disabled'),
            valuee: enableSound,
            onChanged: (value) {
              setState(() {
                enableSound = value;
              });
            },
          ),
          if (hasChanges())
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: AppButton(
                backColor: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR_DARK
                    : AppColors.PRIMARY_COLOR,
                color: AppColors.LIGHT_COLOR,
                onPressed: submitChanges,
                label: context.isArabic ? 'تحديث' : 'Update',
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              children: [
                Text(
                  LocaleKeys.myRating.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                RatingBar(
                  initialRating: widget.settings?.rating?.average ?? 2.5,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(Assets.star1),
                    half: SvgPicture.asset(Assets.halfStar),
                    empty: SvgPicture.asset(Assets.starEmpty),
                  ),
                  itemSize: 13,
                  onRatingUpdate: (double value) {},
                ),
                const SizedBox(width: 5),
                Text(
                formatPrice(widget.settings?.rating?.average?.toDouble() ?? 2.5,context),

                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.totalProfit.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${formatPrice(widget.settings?.profit ?? 0,context)} ${LocaleKeys.egp.tr()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.totalTrips.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  formatPrice(widget.settings?.countTrips ?? 0,context),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: PersonalDocumentsLoadingScreen(),
                ),
              ));
            },
            child: UpdatePersonalInfoWidget(title: LocaleKeys.id.tr(), exdIn: 6),
          ),
          ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: DriversLicenseLoadingScreen(),
                ),
              ));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.driversLicense.tr(), exdIn: 6),
          ),
          ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: VehicleInformationLoadingScreen(),
                ),
              ));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.carLicense.tr(), exdIn: 6),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 5,
            children: [
              Expanded(
                flex: 2,
                child: AppButton(
                  label: LocaleKeys.deleteRegistration.tr(),
                  backColor: AppColors.SECONDARY_COLOR_DARK2,
                  onPressed: () {

      ManageVibration.vibrate();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget switchWidget({
    required String? title,
    required String? subText,
    required bool? valuee,
    bool isText = true,
    Function(bool)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: Row(
        spacing: 8,
        children: [
          isText
              ? Text(
            title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
              : Image.network(title ?? '', width: 60, height: 25),
          const Spacer(),
          Text(
            subText ?? '',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
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
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}


/*
class SettingsNotSocketLoading extends StatefulWidget {
  final DriverSettingLoadingEntity? settings;
  const SettingsNotSocketLoading({super.key, this.settings});

  @override
  State<SettingsNotSocketLoading> createState() => _SettingsNotSocketLoadingState();
}

class _SettingsNotSocketLoadingState extends State<SettingsNotSocketLoading> {
  late bool enableSound;
  late bool isReady;

  late bool originalEnableSound;
  late bool originalIsReady;

  @override
  void initState() {
    super.initState();

    enableSound = widget.settings?.isVoiceCommentAlertsEnabled ?? false;
    isReady = widget.settings?.isReady ?? false;

    // Save original values
    originalEnableSound = enableSound;
    originalIsReady = isReady; 
  }

  bool hasChanges() {
    return enableSound != originalEnableSound || isReady != originalIsReady;
  }

  void submitChanges() {
    final params = UpdateDriverSettingsLoadingParams(
      isReady: isReady,
      isVoiceCommentAlertsEnabled: enableSound,
    );

    context.read<DashboardsCubit>().updateDriverLoadingSettings(
      params: params,
      context: context,
    );

    // After submit, update originals to match new state so the button hides
    setState(() {
      originalEnableSound = enableSound;
      originalIsReady = isReady;
    });
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
            },
          ),
          switchWidget(
            title: context.isArabic ? 'اشعارات صوتية' : 'Voice notify',
            subText: enableSound
                ? (context.isArabic ? 'تفعيل' : 'Enabled')
                : (context.isArabic ? 'تعطيل' : 'Disabled'),
            valuee: enableSound,
            onChanged: (value) {
              setState(() {
                enableSound = value;
              });
            },
          ),

          // Show Update button if changes exist
          if (hasChanges())
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: AppButton(
                backColor: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR,
                color:  AppColors.LIGHT_COLOR,
                onPressed: submitChanges,
                label: context.isArabic ? 'تحديث' : 'Update',
              ),
            ),


          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              children: [
                Text(LocaleKeys.myRating.tr(),
                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const Spacer(),
                RatingBar(
                  initialRating: widget.settings?.rating?.average ?? 2.5,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(Assets.star1),
                    half: SvgPicture.asset(Assets.halfStar),
                    empty: SvgPicture.asset(Assets.starEmpty),
                  ),
                  itemSize: 13,
                  onRatingUpdate: (double value) {},
                ),
                const SizedBox(width: 5),
                Text(widget.settings?.rating?.average == null ? "" :widget.settings?.rating?.average.toString() ?? '2.5',
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
                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                ),
                Text('${widget.settings?.profit ?? '0'} ${LocaleKeys.egp.tr()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                )
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
          ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: PersonalDocumentsLoadingScreen())));
            },
              child: UpdatePersonalInfoWidget(title: LocaleKeys.id.tr(), exdIn: 6)),
          ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: DriversLicenseLoadingScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.driversLicense.tr(), exdIn: 6),
          ),
            ClickableWidget(
            onTap: () async {
      ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: VehicleInformationLoadingScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.carLicense.tr(), exdIn: 6),
          ),


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
      ManageVibration.vibrate();
              ),
            ],
          ),
        ],
      ),
    );
  }



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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
          )
              : Image.network(title ?? '', width: 60, height: 25),
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
*/