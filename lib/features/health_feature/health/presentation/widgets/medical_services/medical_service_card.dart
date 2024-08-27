import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
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
    return InkWell(
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
                          icon: subCategory.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: ThemeCubit.get(context).isDarkTheme
                              ? AppColors.QUANTITY_COLOR
                              : AppColors.PRIMARY_COLOR_DARK,
                          onPressed: () {
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
                Column(
                  children: [
                    Label(
                      text: subCategory.name,
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                    Label(
                      text:
                          '${subCategory.numberOfContent.toShortScale} ${LocaleKeys.ads.localize}',
                      style: Styles.mediumText(),
                    ),
                  ],
                ),
                IconAppButton(
                  icon: Icons.add,
                  isCircle: true,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
