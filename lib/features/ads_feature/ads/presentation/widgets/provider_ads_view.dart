import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_ads.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_filter_ads.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/filter_ads.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../../../res/style/styles.dart';

class ProviderAdsView extends StatelessWidget {
  const ProviderAdsView({
    super.key,
    required this.params,
    required this.userType,
    required this.controller,
    required this.onScrollChanged,
  });

  final AdsViewParams params;
  final String userType;
  final AdvertisementCubit controller;
  final Function(bool) onScrollChanged;

  @override
  Widget build(BuildContext context) {
    print('userType $userType');

    return controller.state.status == AdsStates.loading
        ? const CustomLoading()
        : Column(children: [
            const Sizer(),
            Container(
                margin: EdgeInsetsDirectional.all(10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: BadgedLabel(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          label: LocaleKeys.filter.localize,
                          style: Styles.headerText(
                              color: AppColors.getReversedTextColor(context),
                              fontWeight: FontWeight.w400),
                          color: AppColors.getButtonPrimaryColor(context),
                          width: 170.h,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 5.w),
                          iconLeading: Icons.keyboard_arrow_down_rounded,
                          textColor: AppColors.getReversedTextColor(context),
                          onTap: () async {
                            ManageVibration.vibrate();
                            dynamic data = await context.push(Routes.FILTERADS,
                                extra: FilterAdsParams(
                                  categorization: CategorizationEntity(
                                      mainCategory: params.mainCategory,
                                      subCategory: params.subCategory,fromMarriage: false),
                                  userType: userType,
                                ));
                            if (data != null) {
                              print("objectsdaa");
                              // Future.delayed(const Duration(seconds: 1), () =>
                              //     controller.changeState(data, data != null));
                              // context.read<AdvertisementCubit>().loadFilterData(
                              //     model: data,
                              //     filter: userType);
                              controller.loadFilterAdsData(
                                  model: data, filter: userType);
                            }
                          }),
                    ),
                    const Sizer(
                      width: 5,
                    ),
                    Expanded(
                      child: BadgedLabel(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          label: LocaleKeys.city.localize,
                          width: 170.h,
                          style: Styles.headerText(
                              fontWeight: FontWeight.w400,
                              color: AppColors.getReversedTextColor(context)),
                          textColor: AppColors.getReversedTextColor(context),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 5.w),
                          color: AppColors.getButtonPrimaryColor(context),
                          iconLeading: Icons.keyboard_arrow_down_rounded,
                          onTap: () async {
                            ManageVibration.vibrate();
                            dynamic data = await context.push(
                                Routes.GOVERNORATEFILTERADS,
                                extra: CategorizationEntity(
                                    mainCategory: params.mainCategory,
                                    subCategory: params.subCategory));
                            if (data != null) {
                              print("objectsdaa");
                              controller.state.city = data.cityId;
                              controller.state.governorate = data.governorateId;
                              // Future.delayed(const Duration(seconds: 1), () =>
                              //     controller.changeState(data, data != null));
                              // context.read<AdvertisementCubit>().loadFilterData(
                              //     model: data,
                              //     filter: userType);
                              controller.loadFilterAdsData(
                                  model: data, filter: userType);
                            }
                          }),
                    ),
                  ],
                )),
            Expanded(
                child:
                    // controller.state.ads?.isEmpty ?? false // true
                    //     ? Center(
                    //         child: Label(
                    //           text: LocaleKeys.noAds.localize,
                    //           style: Styles.mediumText(
                    //               color: context.isDarkMode
                    //                   ? AppColors.whiteColor
                    //                   : AppColors.PRIMARY_COLOR),
                    //         ),
                    //       )
                    //     :
                    controller.state.hasFilter == false
                        ? ProviderAds(
                            params: params,
                            userType: userType,
                            controller: controller,
                            onScrollChanged: onScrollChanged,
                          )
                        : ProviderFilterAds(
                            userType: userType,
                            params: params,
                            model: controller.state.filterModel!,
                            controller: controller,
                          ))
          ]);
  }
}
