import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/functions/helper/lang_helper.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../domain/entities/food_category_entity.dart';
import '../../cubit/restaurants_list_cubit.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
                            context
                                .read<RestaurantsCubit>()
                                .toggleFavoriteSubcategory(
                                    subCategory?.id ?? "");
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
                  text: (getLang() == "ar"
                          ? subCategory?.nameAr
                          : subCategory?.nameEn) ??
                      "",
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
                Label(
                  text:
                      '${subCategory?.numberOfRestaurant ?? "0"} ${LocaleKeys.restaurants.localize}',
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