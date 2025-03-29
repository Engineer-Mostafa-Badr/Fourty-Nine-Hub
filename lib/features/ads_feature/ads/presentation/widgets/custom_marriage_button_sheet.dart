import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CustomMarriageButtonSheet extends StatelessWidget {
  const CustomMarriageButtonSheet({
    super.key,
    required this.marriageAds,
  });

  final AdModel marriageAds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<AdvertisementCubit>(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                // borderRadius: BorderRadius.circular(100),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.c0B1035,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          PremiumRequestButton(
            adId: marriageAds.id,
            subCategoryId: marriageAds.subCategoryId ?? '',
            subscriptionStatus: marriageAds.subscriptionStatus ?? '',
          ),
          const SizedBox(height: 8),
          RequestButton(
            adId: marriageAds.id,
            subscriptionStatus: marriageAds.subscriptionStatus ?? '',
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
    // return BlocProvider.value(
    //   value: serviceLocator<AdvertisementCubit>(),
    //   child: AnimatedPadding(
    //     padding: MediaQuery.of(context).viewInsets,
    //     duration: const Duration(milliseconds: 50),
    //     child: Container(
    //       height: 150.h,
    //       padding: EdgeInsets.symmetric(
    //         vertical: 10.h,
    //         horizontal: 10,
    //       ),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             flex: 3,
    //             child: PremiumRequestButton(
    //               adId: marriageAds.id,
    //               subCategoryId: marriageAds.subCategoryId ?? '',
    //               subscriptionStatus: marriageAds.subscriptionStatus ?? '',
    //             ),
    //           ),
    //           const Sizer(width: 5),
    //           Expanded(
    //             flex: 3,
    //             child: RequestButton(
    //               adId: marriageAds.id,
    //               subscriptionStatus: marriageAds.subscriptionStatus ?? '',
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
