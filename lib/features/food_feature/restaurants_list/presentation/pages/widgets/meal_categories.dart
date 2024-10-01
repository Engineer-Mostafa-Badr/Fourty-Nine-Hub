import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/meal_category_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealCategories extends StatelessWidget {
  const MealCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
      final controller = context.read<RestaurantsCubit>();

      if (state.mealCategories != null && state.mealCategories!.isNotEmpty) {
        return SizedBox(
          height: 200.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: LocaleKeys.meal.localize,
                style: Styles.headerText(),
              ),
              const Sizer(),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Sizer(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => MealCategoryCard(
                      onTap: (String id) {
                        controller.getSubCategoryRestaurants(id: id);
                      },
                      subCategory: state.mealCategories?[index]),
                  itemCount: state.mealCategories?.length ?? 0,
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
