import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/meal_category_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MealCategories extends StatelessWidget {
  const MealCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      final controller = context.read<RestaurantsListCubit>();

      if (state.categories != null && state.categories!.isNotEmpty) {
        return SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: 'Meals',
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
                      subCategory: state.categories?[index]),
                  itemCount: state.categories?.length ?? 0,
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
