import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/personal_documents_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/technical_examination_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/vehicle_information_non_socket_screen.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../domain/entities/dashboards/driver_settings_entity.dart';
import '../../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../../widgets/bottom_sheet/custom_bottom_sheet.dart';
import '../../widgets/fare_bottom_sheet_widget.dart';
import 'creminal_record_non_socket_screen.dart';
import 'drivers_license_non_socket_screen.dart';
import 'drug_analysis_non_socket.dart';
import 'update_personal_info_widget.dart';

class SettingsNotSocket extends StatefulWidget {
  final DriverSettingsEntity? settings;
  const SettingsNotSocket({super.key, this.settings});

  @override
  State<SettingsNotSocket> createState() => _SettingsNotSocketState();
}

class _SettingsNotSocketState extends State<SettingsNotSocket> {

  void initState() {
    super.initState();
    // enableSound =  widget.settings?.enableNotificationSound ?? false;
    enableSound =  true;

  }
  late bool enableSound;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: ListView(
        children: [
          switchWidget(
              title: LocaleKeys.ready.tr(),
              subText: widget.settings?.isReady != null  ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
              valuee: widget.settings?.isReady,
              onChanged: (value) {
                setState(() {
                  context.read<DashboardsCubit>().updateDriverSettings(value,context);
                });
              }),

          switchWidget(
              title: context.isArabic?'اشعارات صوتية':'Voice notify',
              subText: enableSound ? context.isArabic?'تفعيل':'Enabled' : context.isArabic?'تعطيل':'Disabled', //'Disable',
              valuee: enableSound,
              onChanged: (value) {
                setState(() {
                  enableSound = value;
                });
              }),


          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              children: [
                Text(LocaleKeys.myRating.tr(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
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
          ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: PersonalDocumentsNonSocketScreen())));
            },
              child: UpdatePersonalInfoWidget(title: LocaleKeys.id.tr(), exdIn: 6)),
          ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: DriversLicenseNonSocketScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.driversLicense.tr(), exdIn: 6),
          ),

            ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: VehicleInformationNonSocketScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.carLicense.tr(), exdIn: 6),
          ),

          // if(widget.settings?.isCriminalRecordEnabled == true)
          ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: CriminalRecordNonSocketScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.criminalRecord.tr(), exdIn: 6),
          ),
          // if(widget.settings?.isVehicleRecordEnabled == true)
            ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: TechnicalExaminationNonSocketScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.technicalExamination.tr(), exdIn: 6),
          ),
          // if(widget.settings?.isDrugAnalysisRecordEnabled == true)

            ClickableWidget(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: DragAnalyticsNonSocketScreen())));
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.drugAnalysis.tr(), exdIn: 6),
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
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500))
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
