import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_category_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../cubit/restaurants_list_cubit.dart';
import '../../restaurant_for_meal.dart';

class MealCategories extends StatelessWidget {
  const MealCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
      builder: (context, state) {
        final mealCategories = state.mealCategories;
        if (mealCategories != null && mealCategories.isNotEmpty) {
          return SizedBox(
            height: 350.h,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              separatorBuilder: (context, index) => const Sizer(),
              scrollDirection: Axis.horizontal,
              itemCount: mealCategories.length,
              itemBuilder: (context, index) {
                final mealCategory = mealCategories[index];
                return MealCategoryCard(
                  onTap: (String id) async {
                    if (mealCategory.numberOfRestaurant != null &&
                        mealCategory.numberOfRestaurant! > 0) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: serviceLocator<RestaurantsCubit>(),
                            child: RestaurantForSelectedMeal(mealId: id),
                          ),
                        ),
                      );
                      // Refresh the restaurant list after returning
                      BlocProvider.of<RestaurantsCubit>(context)
                          .getAllRestaurant();
                    }
                  },
                  subCategory: mealCategory,
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_category_card.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../../../../service_locator/service_locator.dart';
// import '../../../cubit/restaurants_list_cubit.dart';
// import '../../restaurant_for_meal.dart';
//
// class MealCategories extends StatelessWidget {
//   const MealCategories({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<RestaurantsCubit, RestaurantsListState>(
//       builder: (context, state) {
//         final controller = context.read<RestaurantsCubit>();
//
//         if (state.mealCategories != null && state.mealCategories!.isNotEmpty) {
//           return SizedBox(
//             height: 350.h,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (context, index) => Sizer(),
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) => MealCategoryCard(
//                         onTap: (String id) async {
//                           // controller.getSubCategoryRestaurants(id: id);
//                           // if (state.subCategories!.isNotEmpty) {
//                           if (state.mealCategories![index].numberOfRestaurant! >
//                               0) {
//                             await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => BlocProvider.value(
//                                     value: serviceLocator<RestaurantsCubit>(),
//                                     child: RestaurantForSelectedMeal(
//                                       mealId: id,
//                                     ),
//                                   ),
//                                 ));
//                             await BlocProvider.of<RestaurantsCubit>(context)
//                                 .getAllRestaurant();
//                           }
//                         },
//                         subCategory: state.mealCategories?[index]),
//                     itemCount: state.mealCategories?.length ?? 0,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//       listener: (BuildContext context, RestaurantsListState state) {},
//     );
//   }
// }
