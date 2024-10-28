import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_category_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../res/style/app_colors.dart';
import '../../../cubit/restaurants_list_cubit.dart';

class MealCategories extends StatefulWidget {
  const MealCategories({super.key, required});


  @override
  State<MealCategories> createState() => _MealCategoriesState();
}

class _MealCategoriesState extends State<MealCategories> {

  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent ) {
      context.read<RestaurantsCubit>().fetchSubCategories();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
      builder: (context, state) {
        final controller = context.read<RestaurantsCubit>();
        final mealCategories = state.mealCategories;
        if (controller.subCategories != []) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    // Scroll to a specific pixel position
                    _scrollController.animateTo(
                      context.isArabic
                          ? _scrollController.position.pixels - 0.8.sw
                          : _scrollController.position.pixels + 0.8.sw,
                      // Pixel offset to scroll to
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        context.isArabic ? 'عرض المزيد' : 'More',
                        style: const TextStyle(
                            color: AppColors.PRIMARY_COLOR_DARK,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.PRIMARY_COLOR_DARK,
                        size: 0.06.sw,
                      ),
                      const Sizer()
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 0.25.sh,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: context.read<RestaurantsCubit>().subCategories.length + (context.read<RestaurantsCubit>().isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == context.read<RestaurantsCubit>().subCategories.length) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final subCategory = context.read<RestaurantsCubit>().subCategories[index];
                          return MealCategoryCard(
                              onTap: (String id) {
                                context.read<RestaurantsCubit>().getSubCategoryRestaurants(id: id);
                              },
                              subCategory: subCategory);
                        },
                      )

                    ),
                  ),
        // if (state.isLoadingMore==true)  const Center(child: CircularProgressIndicator())
                ],
              ),

            ],
          );
        } else if(mealCategories?.isEmpty??false){
          return const SizedBox.shrink();
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 50.0,
                        height: 20.0,
                        color: Colors.white, // Shimmer placeholder for text
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        color: Colors.white, // Shimmer placeholder for icon
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.25.sh,
                  width: double.infinity,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of shimmer placeholders
                    itemBuilder: (context, index) {
                      return Container(
                        width: 0.55.sw,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
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
