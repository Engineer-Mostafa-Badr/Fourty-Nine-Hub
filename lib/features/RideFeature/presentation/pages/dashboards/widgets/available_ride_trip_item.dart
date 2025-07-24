import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'edit_price_widget.dart';
import 'package:fourtyninehub/routes/pages.dart';

class AvailableRideTripItem extends StatelessWidget {
  final AvailableRideTripEntity tripEntity;
  final RideModeParams params;
  final Function(String id) onRefuseTrip;
  const AvailableRideTripItem({super.key, required this.tripEntity,required this.params,required this.onRefuseTrip});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
      var cubit = context.read<DashboardsCubit>();
      return Container(
        width: context.screenWidth,
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.isDarkMode?AppColors.whiteColor:AppColors.GREY_DARK_COLOR, width: 1.w),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: tripEntity.clientGender == 'male'
                                  ? Image.asset(
                                      Assets.maleImagePlaceholder,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      Assets.femaleImagePlacehlder,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            PositionedDirectional(
                              start: -28.w,
                              child: Row(
                                children: [
                                  Container(
                                    // height: 32.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: AppColors.GRAY_LIGHT_COLOR3,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 6.w),
                                    child: Row(
                                      children: [
                                        Baseline(
                                          baseline: 22.h,
                                          baselineType: TextBaseline.alphabetic,

                                          child: Text('4.0',style: TextStyle(
                                            fontSize: FontSize.s14,
                                            color: context.isDarkMode?AppColors.black:AppColors.black
                                          ),),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Baseline(
                                          baseline: 22.h,
                                            baselineType: TextBaseline.alphabetic,
                                            child: Icon(Icons.star,color: Colors.yellow,size: 30.w,))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Label(
                        text: tripEntity.clientName, //'Ahmed',
                        style: Styles.mediumText(),
                      ),
                      const SizedBox(height: 4),
                      Label(
                        text: TimeUtils.getRelativeTime(tripEntity.createdAt),
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      // const SizedBox(height: 25),

                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(spacing: 0, children: [
                        Expanded(
                          flex: 1,
                          child: Image.asset(Assets.rideFrom, width: 20, height: 20),
                        ),
                        Expanded(
                          flex: 9,
                          child: Label(
                            text: tripEntity.fromAddress, //'Tariaq Bedon Esm',
                            style: Styles.headerText(fontSize: 28),
                            maxLines: 2,
                          ),
                        )
                      ]),
                      Row(spacing: 0, children: [
                        Expanded(flex: 1, child: Image.asset(Assets.rideTo, width: 20, height: 20)),
                        Expanded(
                            flex: 9,
                            child: Label(
                                text: tripEntity.toAddress, //'Open Air Mall - Madinaty',
                                maxLines: 2,
                                style: Styles.mediumText(fontWeight: FontWeight.w300,fontSize: 24)))
                      ]),
                      const SizedBox(height: 5),
                      // Align(
                      //   alignment: AlignmentDirectional.centerEnd,
                      //   child: RichText(
                      //     text: TextSpan(
                      //       style: const TextStyle(color: AppColors.black),
                      //       children: <TextSpan>[
                      //         TextSpan(text: '${(tripEntity.distance / 1000).toStringAsFixed(1)} ${LocaleKeys.KM.tr()}'),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                ),
              ],
            ),
            state.isLoadingAcceptOffer
                ? const Center(child: CustomCircularProgressIndicator())
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Sizer(width: 40,),
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: context.isDarkMode?AppColors.whiteColor:AppColors.black),
                      children: <TextSpan>[
                        TextSpan(text: '${(tripEntity.distance / 1000).toStringAsFixed(1)} ${LocaleKeys.KM.tr()}',
                            style: TextStyle(color: context.isDarkMode?AppColors.whiteColor:AppColors.black)
                        ),
                      ],
                    ),
                  ),
                ),
                Sizer(),
                Expanded(
                  flex: 2,
                    child: ClickableWidget(
                      onTap: () {
                        print("tripEntity.isPremium ${tripEntity.isPremium}");
                        print("tripEntity.isButtonEnabled ${tripEntity.isButtonEnabled}");
                        if(tripEntity.isPremium==true||tripEntity.isButtonEnabled==true){
                          if (tripEntity.isAutoAccept == false) {
                            cubit.createOffer(tripId: tripEntity.id, price: (tripEntity.price ?? 0), context: context, subCategoryId: tripEntity.subcategoryId, onSuccess: () {
                              final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
                              currentContext.pop();
                              toastification.show(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentContext.isArabic?"تم ارسال العرض بنجاح":"Offer sent successfully",
                                      style: TextStyle(color: currentContext.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                autoCloseDuration: const Duration(seconds: 5),
                                progressBarTheme: ProgressIndicatorThemeData(
                                    color: AppColors.SECONDARY_COLOR
                                ),
                                primaryColor: AppColors.SECONDARY_COLOR,
                                backgroundColor: Theme.of(currentContext).dialogBackgroundColor,
                                showProgressBar: true,

                              );
                            });
                          } else {
                            cubit.autoAcceptTrip(context, tripEntity.id,params);
                          }
                        }else{
                          SubscriptionMethod().subscribe(
                              subscribeId: tripEntity.subcategoryId,
                              showRegular: true,
                              title: LocaleKeys.premiumRequest.localize);
                        }
                      },
                      child: Container(
                        height: 30,
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: tripEntity.isPremium||tripEntity.isButtonEnabled?AppColors.PRIMARY_COLOR:AppColors.GREYBG,
                        ),
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: AppColors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${LocaleKeys.Accept.tr()} ${(tripEntity.price??0).ceil()}  ',
                                  style: Styles.mediumText(
                                    color: Colors.white,
                                  )),
                              TextSpan(
                                  text: LocaleKeys.egp.tr(),
                                  style: Styles.smallText(
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )),
                const Sizer(),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    radius: 15,
                    height: 30,
                    label: tripEntity.isAutoAccept == false ? LocaleKeys.acceptAnothePrice.tr() : LocaleKeys.refuse.tr(),
                    style: Styles.mediumText(color: Colors.white, fontSize: tripEntity.isAutoAccept == false ? 28 : 28),
                    onPressed: () {
                      if(tripEntity.isPremium||tripEntity.isButtonEnabled){
                        if (tripEntity.isAutoAccept == false) {
                          showModalBottomSheet(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            context: context,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                            isScrollControlled: true,
                            builder: (BuildContext context) => EditPriceWidget(
                              price: (tripEntity.price ?? 0).ceil(),
                              tripEntity: tripEntity,
                              onSendOffer: (num offer) {
                                context.pop();
                                cubit.createOffer(tripId: tripEntity.id, price: offer, context: context, subCategoryId: tripEntity.subcategoryId, onSuccess: () {
                                  final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
                                  currentContext.pop();
                                  toastification.show(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(currentContext.isArabic?"تم ارسال العرض بنجاح":"Offer sent successfully",
                                          style: TextStyle(color: currentContext.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    autoCloseDuration: const Duration(seconds: 5),
                                    progressBarTheme: ProgressIndicatorThemeData(
                                        color: AppColors.SECONDARY_COLOR
                                    ),
                                    primaryColor: AppColors.SECONDARY_COLOR,
                                    backgroundColor: Theme.of(currentContext).dialogBackgroundColor,
                                    showProgressBar: true,

                                  );
                                });
                              },
                            ),
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
                                  Text(context.isArabic?'هل أنت متأكد من أنك تريد رفض الرحلة؟':'Are you sure you want to refuse the trip?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: context.isDarkMode ? Colors.white : Colors.black,
                                      )),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                            width: context.screenWidth / 1.9,
                                            label: context.isArabic?'رجوع':'Back',
                                            backColor: AppColors.PRIMARY_COLOR,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                      SizedBox(width: 15,),
                                      Expanded(
                                        child: AppButton(
                                            width: context.screenWidth / 1.9,
                                            label: context.isArabic?'نعم':'Yes',
                                            backColor: AppColors.SECONDARY_COLOR_DARK2,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              onRefuseTrip(tripEntity.id);
                                            }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ));
                        }
                      }

                    },
                    backColor:tripEntity.isPremium||tripEntity.isButtonEnabled?AppColors.SECONDARY_COLOR_DARK2:AppColors.GREYBG,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
