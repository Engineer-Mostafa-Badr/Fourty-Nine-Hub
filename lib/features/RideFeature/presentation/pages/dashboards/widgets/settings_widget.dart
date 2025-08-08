import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/record_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/creminal_record_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/drivers_license_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/drug_analysis_non_socket.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/personal_documents_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/technical_examination_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/vehicle_information_non_socket_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/update_fare_bottom_sheet_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/responsive/responsive.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../../widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'update_personal_info_widget.dart';

class SettingsWidget extends StatefulWidget {
  final String modeType;
  final RideModeParams params;
  final SettingsDashboardEntity? settings;
  const SettingsWidget({super.key, required this.modeType,required this.params, this.settings});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isReady=false;
  bool isComfort=false;
  bool isNonSmoking=false;
  bool enableSound=false;
  bool isCaptainShare=false;
  bool isCaptain=false;
  bool isIntercity=false;
  bool isPremium=false;
  num perKm=0;

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
  bool hasIdRequest = false;
  bool hasDriverLicenseRequest = false;
  bool hasCarLicenseRequest = false;
  bool hasCriminalRecordRequest = false;
  bool hasDrugAnalysisRequest = false;
  bool hasTechnicalExaminationRequest = false;
  String idRequestStatus = '';
  String driverLicenseRequestStatus = '';
  String carLicenseRequestStatus = '';
  String criminalRecordRequestStatus = '';
  String drugAnalysisRequestStatus = '';
  String technicalExaminationRequestStatus = '';
  @override
  void initState() {
    super.initState();
    planTrailing = widget.settings?.subscriptionType ?? '';
    cityTrailing = widget.settings?.city ?? '';
    perKm = widget.settings?.pricingPerKm ?? 0;
    isReady = widget.settings?.isReady ?? false;
    isComfort = widget.settings?.isComfort ?? false;
    isNonSmoking = widget.settings?.isNonSmoking ?? false;
    enableSound =  widget.settings?.enableNotificationSound ?? false;
    isCaptainShare =  widget.settings?.isCaptainShareEnabled ?? false;
    if((widget.settings?.categoryIds.length ?? 0) > 0)isCaptain = widget.settings?.categoryIds[0].isActive ?? false;
    if((widget.settings?.categoryIds.length ?? 0) > 1)isIntercity = widget.settings?.categoryIds[1].isActive ?? false;
    if((widget.settings?.categoryIds.length ?? 0) > 2)isPremium = widget.settings?.categoryIds[2].isActive ?? false;
    hasIdRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.nationalId.status);
    hasDriverLicenseRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.drivingLicense.status);
    hasCarLicenseRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.carLicense.status);
    hasCriminalRecordRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.criminalRecord.status);
    hasDrugAnalysisRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.drugAnalysis.status);
    hasTechnicalExaminationRequest = (widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.technicalExamination.status);
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.drivingLicense.status)){
      driverLicenseRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.drivingLicense.status).status??'';
    }
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.nationalId.status)){
      idRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.nationalId.status).status??'';
    }
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.carLicense.status)){
      carLicenseRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.carLicense.status).status??'';
    }
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.criminalRecord.status)){
      criminalRecordRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.criminalRecord.status).status??'';
    }
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.drugAnalysis.status)){
      drugAnalysisRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.drugAnalysis.status).status??'';
    }
    if((widget.settings?.requests??[]).any((e)=>e.recordName==RecordStatusEnum.technicalExamination.status)){
      technicalExaminationRequestStatus = widget.settings?.requests.firstWhere((e)=>e.recordName==RecordStatusEnum.technicalExamination.status).status??'';
    }
  }

  int calculateDaysUntilExpiry(String expiryDateString) {
    final expiryDate = DateTime.parse(expiryDateString).toUtc();
    final now = DateTime.now().toUtc();
    return expiryDate.difference(now).inDays;
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
              onChanged: (value) async {
                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if(!serviceEnabled){
                  showErrorMessage(context, context.isArabic?'الرجاء تفعيل خدمة الموقع':'Please enable location service');
                  return;
                }
                ManageVibration.vibrate();
                setState(() {
                  isReady = value;
                });
              }),
          switchWidget(
              title: LocaleKeys.comfort.tr(),
              subText: isComfort ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
              valuee: isComfort,
              onChanged: (value) {
                ManageVibration.vibrate();
                setState(() {
                  isComfort = value;
                });
              }),

          switchWidget(
              title: LocaleKeys.nonSmokerDriver.tr(),
              subText: isNonSmoking ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
              valuee: isNonSmoking,
              onChanged: (value) {
                ManageVibration.vibrate();
                setState(() {
                  isNonSmoking = value;
                });
              }),
          if (widget.modeType == 'ride') ...[
            switchWidget(
                title: context.isArabic?'اشعارات صوتية':'Voice notify',
                subText: enableSound ? context.isArabic?'تفعيل':'Enabled' : context.isArabic?'تعطيل':'Disabled', //'Disable',
                valuee: enableSound,
                onChanged: (value) {
                  ManageVibration.vibrate();
                  setState(() {
                    enableSound = value;
                  });
                }),

            switchWidget(
                title: LocaleKeys.captainShare.tr(), //'Captain share',
                subText:
                    isCaptainShare ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                valuee: isCaptainShare,
                onChanged: (value) async {
                  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if(!serviceEnabled){
                    showErrorMessage(context, context.isArabic?'الرجاء تفعيل خدمة الموقع':'Please enable location service');
                    return;
                  }
                  ManageVibration.vibrate();
                  setState(() {
                    isCaptainShare = value;
                  });
                }),
            if((widget.settings?.categoryIds.length ?? 0) >= 1)switchWidget(
                title: widget
                    .settings?.categoryIds[0].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[0].nameAr
                    : widget.settings?.categoryIds[0]
                        .nameEn, //LocaleKeys.captain.tr(),
                valuee: isCaptain,
                onChanged: (value) {
                  ManageVibration.vibrate();
                  setState(() {
                    isCaptain = value;
                  });
                }),
            if((widget.settings?.categoryIds.length ?? 0) > 1)switchWidget(
                title: widget
                    .settings?.categoryIds[1].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[1].nameAr
                    : widget.settings?.categoryIds[1]
                        .nameEn, //LocaleKeys.intercity.tr(),
                valuee: isIntercity,
                onChanged: (value) {
                  ManageVibration.vibrate();
                  setState(() {
                    isIntercity = value;
                  });
                }),
            if((widget.settings?.categoryIds.length ?? 0) > 2)switchWidget(
                title: widget
                    .settings?.categoryIds[2].pictureUrl, //Assets.greyCar,
                isText: false,
                subText: context.isArabic
                    ? widget.settings?.categoryIds[2].nameAr
                    : widget.settings?.categoryIds[2]
                        .nameEn, //LocaleKeys.premium.tr(), //'Premium',
                valuee: isPremium,
                onChanged: (value) {
                  ManageVibration.vibrate();
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
                    ManageVibration.vibrate();
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
              trailing: context.isArabic?(context.read<DashboardsCubit>().state.selectedGov?.nameAr??''):context.read<DashboardsCubit>().state.selectedGov?.nameEn??'',
              childrenList: List.generate(
                context.read<DashboardsCubit>().state.govs?.length??0,
                (index) => InkWell(
                  onTap: () {
                    ManageVibration.vibrate();
                    context.read<DashboardsCubit>().onSelectGovernorate(context.read<DashboardsCubit>().state.govs?[index]);
                    cityController.collapse();
                  },
                  child: List.generate(
                      context.read<DashboardsCubit>().state.govs?.length??0,
                      (index) => Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Label(text: context.isArabic?(context.read<DashboardsCubit>().state.govs?[index].nameAr??''):context.read<DashboardsCubit>().state.govs?[index].nameEn??''),
                          )))[index],
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
                        ManageVibration.vibrate();
                        customBottomSheet2(context,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: UpdateFareBottomSheetWidget(
                                isArabic:context.isArabic,
                                selectedCategoryPrice: widget.settings?.pricingPerKm ?? 0,
                                highCostPerKm: widget.settings?.highCostPerKm ?? 0,
                                lowCostPerKm: widget.settings?.lowCostPerKm ?? 0,
                                selectedCategoryName: 'aaa',
                                onChange: (price){
                                  ManageVibration.vibrate();
                                  context.read<DashboardsCubit>().updateSettings(
                                      context,
                                      UpdateSettingsDashboardUsecaseParam(
                                          isReady: isReady,
                                          isComfort: isComfort,
                                          isNonSmoking:isNonSmoking,
                                          enableSound: enableSound,
                                          isCaptainShare: isCaptainShare,
                                          subscriptionPlan: planTrailing,
                                          perKm:price,
                                          favoriteCity: context.isArabic?context.read<DashboardsCubit>().state.selectedGov?.nameAr??'':context.read<DashboardsCubit>().state.selectedGov?.nameEn??'',
                                          subCategoriesActive: List.generate(widget.settings?.categoryIds.length??0, (index)=>SubCategoriesActive(
                                              subcategoryId:
                                              widget.settings!.categoryIds[index].id,
                                              isActive: index==0?isCaptain:index==1?isIntercity:isPremium)))
                                      ,widget.params);
                                },
                              ),
                            ),
                            title: LocaleKeys.acceptAnothePrice.tr());
                      },
                      child: Row(
                        children: [
                          Text(
                              '${FormatNumbers().convertNumberToLocalizedString(widget.settings?.pricingPerKm.toString() ?? '0', isArabic: context.isArabic)} ',
                              style: const TextStyle(fontSize: 12,)),
                          Text(
                              'change'.tr(),
                              style: const TextStyle(fontSize: 12,color: AppColors.SECONDARY_COLOR)),
                        ],
                      ))
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
                Text(FormatNumbers().convertNumberToLocalizedString(widget.settings?.rating.totalRatings.toString() ?? '0.0', isArabic: context.isArabic),
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
                Text('${FormatNumbers().convertNumberToLocalizedString(widget.settings?.profit.toString() ?? '0', isArabic: context.isArabic)} ${LocaleKeys.egp.tr()}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500
                    ))
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
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(FormatNumbers().convertNumberToLocalizedString(widget.settings?.countTrips.toString() ?? '', isArabic: context.isArabic), //'38',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          ClickableWidget(
              onTap: () async {
                if(hasIdRequest&&(idRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                  return;
                }
                ManageVibration.vibrate();
                await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(
                    create:(context)=> serviceLocator<DashboardsCubit>(),
                    child: const PersonalDocumentsNonSocketScreen())));
                context.read<DashboardsCubit>().getSettings(context);
              },

              child: UpdatePersonalInfoWidget(title: LocaleKeys.id.tr(),
                  isEnabled: !(hasIdRequest&&(idRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                  exdIn: calculateDaysUntilExpiry(widget.settings?.idExpiryDate??''))),
          if(hasIdRequest&&(idRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
    style: const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
    ),
    ),
    ),
          ClickableWidget(
            onTap: () async {
              if(hasDriverLicenseRequest&&(driverLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                return;
              }
              ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(
                  create:(context)=> serviceLocator<DashboardsCubit>(),
                  child: const DriversLicenseNonSocketScreen())));
              context.read<DashboardsCubit>().getSettings(context);
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.driversLicense.tr(),
                isEnabled: !(hasDriverLicenseRequest&&(driverLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                exdIn: calculateDaysUntilExpiry(widget.settings?.drivingLicenseExpiryDate??'')),
          ),
          if(hasDriverLicenseRequest&&(driverLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
    style: const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
    ),
    ),
    ),
          if (widget.modeType == 'ride') ...[
            ClickableWidget(
              onTap: () async {
                if(hasCarLicenseRequest&&(carLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                  return;
                }
                ManageVibration.vibrate();
                await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(
                    create:(context)=> serviceLocator<DashboardsCubit>(),
                    child: const VehicleInformationNonSocketScreen())));
                context.read<DashboardsCubit>().getSettings(context);
              },
              child: UpdatePersonalInfoWidget(
                  title: LocaleKeys.carLicense.tr(),
                  isEnabled: !(hasCarLicenseRequest&&(carLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                  exdIn: calculateDaysUntilExpiry(widget.settings?.carLicenseExpiryDate??'')),
            ),
            if(hasCarLicenseRequest&&(carLicenseRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
                ),
              ),
            ),
            if(widget.settings?.isCriminalRecordEnabled == true)
              ...[ClickableWidget(
                onTap: () async {
                  if(hasCriminalRecordRequest&&(criminalRecordRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                    return;
                  }
                  ManageVibration.vibrate();
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                      value: serviceLocator<DashboardsCubit>(),
                      child: const CriminalRecordNonSocketScreen())));
                  context.read<DashboardsCubit>().getSettings(context);
                },
              child: UpdatePersonalInfoWidget(
                  title: LocaleKeys.criminalRecord.tr(),
                  isEnabled: !(hasCriminalRecordRequest&&(criminalRecordRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                  exdIn: 4),
            ),
                if(hasCriminalRecordRequest&&(criminalRecordRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
    style: const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
    ),
    ),
    ),
              ],
            if(widget.settings?.isDrugAnalysisRecordEnabled == true)
            ...[ClickableWidget(
              onTap: () async {
                if(hasDrugAnalysisRequest&&(drugAnalysisRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                  return;
                }
                ManageVibration.vibrate();
                await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                    value: serviceLocator<DashboardsCubit>(),
                    child: const DragAnalyticsNonSocketScreen())));
                context.read<DashboardsCubit>().getSettings(context);
              },
              child: UpdatePersonalInfoWidget(
                  title: LocaleKeys.drugAnalysis.tr(),
                  isEnabled: !(hasDrugAnalysisRequest&&(drugAnalysisRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                  exdIn: calculateDaysUntilExpiry(widget.settings?.drugAnalysisExpiryDate??'')),
            ),
              if(hasDrugAnalysisRequest&&(drugAnalysisRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
                  ),
                ),
              ),
            ],
          ],
          if(widget.settings?.isVehicleRecordEnabled == true)
          ...[ClickableWidget(
            onTap: () async {
              if(hasTechnicalExaminationRequest&&(technicalExaminationRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)){
                return;
              }
              ManageVibration.vibrate();
              await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                  value: serviceLocator<DashboardsCubit>(),
                  child: const TechnicalExaminationNonSocketScreen())));
              context.read<DashboardsCubit>().getSettings(context);
            },
            child: UpdatePersonalInfoWidget(
                title: LocaleKeys.vehicleInspection.tr(),
                isEnabled: !(hasTechnicalExaminationRequest&&(technicalExaminationRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name)),
                exdIn: calculateDaysUntilExpiry(widget.settings?.technicalExaminationExpiryDate??'')),
          ),
            if(hasTechnicalExaminationRequest&&(technicalExaminationRequestStatus==DriverUpdateRequestStatusEnum.PENDING.name))Text(context.isArabic?"طلبك تحت المراجعه":"Your request is under review",
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.SECONDARY_COLOR
              ),
            ),
          ],
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

                    }),
              ),
              Expanded(
                flex: 2,
                child: AppButton(
                    label: LocaleKeys.update.tr(),
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.read<DashboardsCubit>().updateSettings(
                          context,
                          UpdateSettingsDashboardUsecaseParam(
                              isReady: isReady,
                              isComfort: isComfort,
                              isNonSmoking:isNonSmoking,
                              enableSound: enableSound,
                              isCaptainShare: isCaptainShare,
                              subscriptionPlan: planTrailing,
                              perKm:perKm,
                              favoriteCity: context.isArabic?context.read<DashboardsCubit>().state.selectedGov?.nameAr??'':context.read<DashboardsCubit>().state.selectedGov?.nameEn??'',
                              subCategoriesActive: List.generate(widget.settings?.categoryIds.length??0, (index)=>SubCategoriesActive(
                                  subcategoryId:
                                  widget.settings!.categoryIds[index].id,
                                  isActive: index==0?isCaptain:index==1?isIntercity:isPremium))
                          ),widget.params);
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
            child: SizedBox(
              height: 200.hs,
              child: ListView(
                  // spacing: 8,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: childrenList),
            ),
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
                    ManageVibration.vibrate();
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
