import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../res/style/app_colors.dart';

class HealthSubCategoryCard extends StatelessWidget {
  final HealthSubcategoryEntity subCategory;

  const HealthSubCategoryCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    print(subCategory.id);
    return GestureDetector(
      onTap: () {
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            subCategory;
        context.push(Routes.VISITADOCTORLIST,
            extra: DoctorsListParams(
                fromHome: true, subCategoryId: subCategory.id));
      },
      child: Container(
        width: 0.55.sw,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsetsDirectional.only(
            end: 10.w, bottom: 10.h, top: 10.h, start: 5.w),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.fitWidth,
                      radius: 10,
                      url: subCategory.image,
                    ),
                  ),
                  if (context.read<UserCubit>().isLoggedIn)
                    Positioned(
                        top: 5,
                        right: 5,
                        child: IconAppButton(
                            size: 20,
                            icon: subCategory.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: ThemeCubit.get(context).isDarkTheme
                                ? AppColors.QUANTITY_COLOR
                                : AppColors.PRIMARY_COLOR_DARK,
                            onPressed: () {
                              if (context.read<UserCubit>().isLoggedIn) {
                                log("${subCategory.isFavorite}777777777777777777777777777777777");

                                context
                                    .read<HealthCubit>()
                                    .toggleFavoriteSubcategory(subCategory.id);

                                log("${subCategory.isFavorite}777777777777777777777777777777777");
                              } else {
                                context.push(Routes.REGISTER);
                              }
                            })),
                ],
              ),
            )),
            const Sizer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Sizer(
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                Label(
                  text: context.isArabic
                      ? subCategory.nameAr
                      : subCategory.nameEn,
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
