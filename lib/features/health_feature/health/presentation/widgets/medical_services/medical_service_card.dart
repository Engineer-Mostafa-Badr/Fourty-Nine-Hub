import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthMedicalServiceCard extends StatelessWidget {
  final HealthSubcategoryEntity subCategory;

  const HealthMedicalServiceCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.read<HealthCubit>().state.mainCategory != null) {
          context.push(
            Routes.ADS,
            extra: AdsViewParams(
                mainCategory: context.read<HealthCubit>().state.mainCategory!,
                subCategory: subCategory),
          );
        }
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsetsDirectional.only(end: 10.w,bottom: 10.h,top: 10.h,start: 5.w),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(10),
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
              ]
          ),
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
                    if(UserCubit.to.isLoggedIn)Positioned(
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
                              print(
                                  "555555555555555555555555555555555555555555555555${subCategory.id}");
                              context
                                  .read<HealthCubit>()
                                  .toggleFavoriteMedicalService(subCategory.id);
                            }))
                  ],
                ),
              )),
              const Sizer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                    text: context.isArabic?subCategory.nameAr:subCategory.nameEn,
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  ),
                  IconAppButton(
                    icon: Icons.add,
                    isCircle: true,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      if (context.read<HealthCubit>().state.mainCategory != null&&UserCubit.to.isLoggedIn) {
                        context.push(
                          Routes.CREATEAD,
                          extra: CategorizationEntity(
                              mainCategory: context.read<HealthCubit>().state.mainCategory!,
                              subCategory: subCategory),
                        );
                      }else{
                        context.push(Routes.LOGIN);
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
