import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';

class HealthSubCategoryCard extends StatelessWidget {
  final HealthSubcategoryEntity subCategory;

  const HealthSubCategoryCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            subCategory;
        context.push(Routes.VISITADOCTORLIST);
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
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
                            log("${subCategory.isFavorite}777777777777777777777777777777777");

                            context
                                .read<HealthCubit>()
                                .toggleFavoriteSubcategory(subCategory.id);

                            log("${subCategory.isFavorite}777777777777777777777777777777777");
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
                  text: context.isArabic?subCategory.nameAr:subCategory.nameEn,
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
                Label(
                  text: subCategory.numberOfContent.toShortScale == '1'
                      ? '${subCategory.numberOfContent.toShortScale} ${LocaleKeys.doctor.localize}'
                      : '${subCategory.numberOfContent.toShortScale} ${LocaleKeys.doctors.localize}',
                  style: Styles.mediumText(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
