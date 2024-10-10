import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_ads.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_filter_ads.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ProviderAdsView extends StatelessWidget {
  const ProviderAdsView(
      {super.key, required this.params, required this.userType, required this.controller});

  final AdsViewParams params;
  final String userType;
  final AdvertisementCubit controller;

  @override
  Widget build(BuildContext context) {
    return controller.state.status == AdsStates.loading ? Center(
        child: CircularProgressIndicator()
    ) : Column(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                  margin: EdgeInsetsDirectional.all(10.w),
                  child: BadgedLabel(label: LocaleKeys.filter.localize,
                      onTap: () async {
                        dynamic data = await context.push(Routes.FILTERADS,
                            extra: CategorizationEntity(
                                mainCategory: params.mainCategory,
                                subCategory: params.subCategory));
                        if (data != null) {
                          print("objectsdaa");
                          // Future.delayed(const Duration(seconds: 1), () =>
                          //     controller.changeState(data, data != null));
                          // context.read<AdvertisementCubit>().loadFilterData(
                          //     model: data,
                          //     filter: userType);
                          controller.loadFilterData(model: data, filter: userType);
                        }
                      }
                  ))),
          Expanded(
              child: controller.state.hasFilter == false ? ProviderAds(
                params: params, userType: userType, controller: controller,) :
              ProviderFilterAds(
                userType: userType,
                params: params,
                model: controller.state.filterModel!,
                controller: controller,)
          )
        ]
    );
  }
}