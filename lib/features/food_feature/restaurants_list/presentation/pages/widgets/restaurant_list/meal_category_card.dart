import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_meal_list_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../../../common/theme/cubit/cubit.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../social_media/reels/presentation/widgets/comments.dart';
import '../../../cubit/restaurants_list_cubit.dart';

class MealCategoryCard extends StatelessWidget {
  final FoodCategoryEntity? subCategory;
  final Function(String) onTap;

  const MealCategoryCard({super.key, this.subCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkTheme(context)?Colors.transparent:Colors.white,
              boxShadow: [
            BoxShadow(
                color: isDarkTheme(context) ? Colors.black54 : Colors.grey,
                blurRadius: 2.0,
                offset: Offset(1, 1))
          ]),
          // elevation: 2,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(15.0),
          // ),
          child: Container(
            width: 0.38.sw,
            child: InkWell(
              onTap: () => onTap(subCategory?.id ?? ""),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Heart image
                      Container(
                        height: 300.h,
                        width: 300.h,
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          image: DecorationImage(
                            image: NetworkImage(
                              subCategory!
                                  .picture!, // Replace with your image URL
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      // Favorite Icon (Heart)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconAppButton(
                            size: 25,
                            icon: subCategory?.isFavorite ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.PRIMARY_COLOR_DARK,
                            onPressed: () {
                              context
                                  .read<RestaurantsCubit>()
                                  .toggleFavoriteSubcategory(
                                      subCategory?.id ?? "");
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Label(
                      text: (getLang() == "ar"
                              ? subCategory?.nameAr
                              : subCategory?.nameEn) ??
                          "",
                      style:Styles.headerText(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Label(
                      text:
                          '${subCategory?.numberOfRestaurant ?? "0"} ${LocaleKeys.restaurants.tr()}',
                      style:Styles.mediumText(),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
Container(
  width: 200,
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
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

        ],
      ),
    ],
  ),
),
*/
