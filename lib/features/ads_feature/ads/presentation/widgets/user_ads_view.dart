import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/user_ads.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class UserAdsView extends StatelessWidget {
  const UserAdsView({
    super.key,
    required this.params,
    required this.userType,
    required this.onScrollChanged,
  });
  final AdsViewParams params;
  final String userType;
  final Function(bool) onScrollChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
      print('userType $userType');
      final controller = context.read<AdvertisementCubit>();
      return Column(children: [
        const Sizer(),
        Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
                margin: EdgeInsetsDirectional.all(10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: BadgedLabel(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          label: LocaleKeys.filter.localize,
                          icon: Icons.filter_alt_rounded,
                          style: Styles.headerText(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w400),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 5.w),
                          iconLeading: Icons.keyboard_arrow_down_rounded,
                          onTap: () async {
                            dynamic data = await context.push(Routes.FILTERADS,
                                extra: CategorizationEntity(
                                    mainCategory: params.mainCategory,
                                    subCategory: params.subCategory));
                            if (data != null) {
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
                          style: Styles.headerText(
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor),
                          width: 170.h,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 5.w),
                          iconLeading: Icons.keyboard_arrow_down_rounded,
                          onTap: () async {
                            dynamic data = await context.push(
                                Routes.GOVERNORATEFILTERADS,
                                extra: CategorizationEntity(
                                    mainCategory: params.mainCategory,
                                    subCategory: params.subCategory));
                            if (data != null) {
                              controller.state.city = data.cityId;
                              controller.state.governorate = data.governorateId;
                              controller.loadFilterAdsData(
                                  model: data, filter: userType);
                            }
                          }),
                    ),
                  ],
                ))),
        Expanded(
            child:
                //  controller.ads.isEmpty
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
                UserAds(
          params: params,
          userType: userType,
          onScrollChanged: onScrollChanged,
        ))
      ]);
    });
  }
}
