import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';

class MealCategoryCard extends StatelessWidget {
  final FoodCategoryEntity? subCategory;
  final Function(String) onTap;

  const MealCategoryCard({super.key, this.subCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(subCategory?.id ?? ""),
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
                      url: subCategory?.picture,
                    ),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: IconAppButton(
                          size: 20,
                          icon: subCategory?.isFavorite ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: ThemeCubit.get(context).isDarkTheme
                              ? Theme.of(context).scaffoldBackgroundColor
                              : AppColors.PRIMARY_COLOR_DARK,
                          onPressed: () {
                            context
                                .read<RestaurantsListCubit>()
                                .toggleFavoriteSubcategory(
                                    subCategory?.id ?? "");
                          })),
                ],
              ),
            )),
            Sizer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    Expanded(
                      child: Sizer(
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                Label(
                  text: (getLang() == "ar"
                          ? subCategory?.nameAr
                          : subCategory?.nameEn) ??
                      "",
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
                Label(
                  text:
                      '${subCategory?.numberOfRestaurant ?? "0"} ${LocaleKeys.restaurants.tr()}',
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
