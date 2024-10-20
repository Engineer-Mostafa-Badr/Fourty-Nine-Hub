import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/subcatigories_restaurant_card.dart';

class RestaurantForSelectedMeal extends StatefulWidget {
  final String mealId;

  const RestaurantForSelectedMeal({super.key, required this.mealId});

  @override
  State<RestaurantForSelectedMeal> createState() => _RestaurantForSelectedMealState();
}

class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantsCubit>().getSubCategoryRestaurants(id: widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      body: SafeArea(
        child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
          builder: (context, state) {
            final subCategories = state.subCategories ?? [];
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.001,
              ),
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SubCategoriesRestaurantCard(
                    item: subCategories[index],
                    mealId: widget.mealId,
                  ),
                );
              },
            );
          },
        ),
      ),
      mainCategoryId: 1,
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../cubit/meal_cubit/restaurants_meal_list_cubit.dart';
// import '../cubit/restaurants_list_cubit.dart';
//
// class RestaurantForSelectedMeal extends StatefulWidget {
//   final mealId;
//
//   RestaurantForSelectedMeal({super.key, required this.mealId});
//
//   @override
//   State<RestaurantForSelectedMeal> createState() =>
//       _RestaurantForSelectedMealState();
// }
//
// class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     context
//         .read<RestaurantsCubit>()
//         .getSubCategoryRestaurants(id: widget.mealId);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<RestaurantsCubit>()
//       ..getSubCategoryRestaurants(id: widget.mealId);
//
//     return SharedScaffold(
//       // appBar: AppBar(),
//       body: SafeArea(
//         child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
//             builder: (context, state) {
//           return SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: ListView.separated(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: SubCategoriesRestaurantCard(
//                             item: state.subCategories?[index],mealId:widget.mealId),
//                       ),
//                   separatorBuilder: (context, index) => const Sizer(),
//                   itemCount: state.subCategories?.length ?? 0));
//         }),
//       ),
//       mainCategoryId: 1,
//     );
//   }
// }
