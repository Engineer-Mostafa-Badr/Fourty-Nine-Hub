import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/subcategories_restaurant_card.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

class RestaurantForSelectedMeal extends StatefulWidget {
  final String mealId;

  const RestaurantForSelectedMeal({super.key, required this.mealId});

  @override
  State<RestaurantForSelectedMeal> createState() =>
      _RestaurantForSelectedMealState();
}

class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
  @override
  void initState() {
    super.initState();
    // Initialize data fetching if needed
    // context.read<RestaurantsCubit>().getSubCategoryRestaurants(id: widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.redAccent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.restaurantsForSelectedMeal.tr(),
        ),
      ),
      body: SafeArea(
        child: BlocProvider.value(
          value: serviceLocator<RestaurantsCubit>(),
          // ..getSubCategoryRestaurants(id: widget.mealId),
          child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
            builder: (context, state) {
              final subCategories = state.subCategories ?? [];
              if (subCategories.isEmpty) {
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1.001,
                ),
                itemCount: subCategories.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SubCategoriesRestaurantCard(
                    item: subCategories[index],
                    mealId: widget.mealId,
                    favouriteRestaurant: (String id) {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../cubit/restaurants_list_cubit.dart';
// import '../widgets/subcategories_restaurant_card.dart';
//
// class RestaurantForSelectedMeal extends StatefulWidget {
//   final String mealId;
//
//   const RestaurantForSelectedMeal({Key? key, required this.mealId})
//       : super(key: key);
//
//   @override
//   State<RestaurantForSelectedMeal> createState() =>
//       _RestaurantForSelectedMealState();
// }
//
// class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
//   @override
//   void initState() {
//     super.initState();
//     // context
//     //     .read<RestaurantsCubit>()
//     //     .getSubCategoryRestaurants(id: widget.mealId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // context
//     //     .read<RestaurantsCubit>()
//     //     .getSubCategoryRestaurants(id: widget.mealId);
//     return CustomScaffold(
//       backgroundColor: scaffoldDarkColor(context),
//       appBar: const BackAppBar(
//         label: "Restaurants",
//       ),
//       body: SafeArea(
//         child: BlocProvider.value(
//           value: serviceLocator<RestaurantsCubit>()
//             ..getSubCategoryRestaurants(id: widget.mealId),
//           child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
//             builder: (context, state) {
//               final subCategories = state.subCategories ?? [];
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1,
//                   mainAxisSpacing: 0,
//                   crossAxisSpacing: 0,
//                   childAspectRatio: 1.001,
//                 ),
//                 itemCount: subCategories.length,
//                 itemBuilder: (context, index) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SubCategoriesRestaurantCard(
//                     item: subCategories[index],
//                     mealId: widget.mealId,
//                   ),
//                 ),
//               );
//
//               //   ListView.builder(
//               //   shrinkWrap: true,
//               //   physics: const NeverScrollableScrollPhysics(),
//               //   itemCount: subCategories.length,
//               //   itemBuilder: (context, index) {
//               //     return Padding(
//               //       padding: const EdgeInsets.all(8.0),
//               //       child: SubCategoriesRestaurantCard(
//               //         item: subCategories[index],
//               //         mealId: widget.mealId,
//               //       ),
//               //     );
//               //   },
//               // );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// // import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcategories_restaurant_card.dart';
// // import '../../../../../common/widgets/dynamic/sizer.dart';
// // import '../../../../../service_locator/service_locator.dart';
// // import '../cubit/meal_cubit/restaurants_meal_list_cubit.dart';
// // import '../cubit/restaurants_list_cubit.dart';
// //
// // class RestaurantForSelectedMeal extends StatefulWidget {
// //   final mealId;
// //
// //   RestaurantForSelectedMeal({super.key, required this.mealId});
// //
// //   @override
// //   State<RestaurantForSelectedMeal> createState() =>
// //       _RestaurantForSelectedMealState();
// // }
// //
// // class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     context
// //         .read<RestaurantsCubit>()
// //         .getSubCategoryRestaurants(id: widget.mealId);
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = context.read<RestaurantsCubit>()
// //       ..getSubCategoryRestaurants(id: widget.mealId);
// //
// //     return SharedScaffold(
// //       // appBar: AppBar(),
// //       body: SafeArea(
// //         child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
// //             builder: (context, state) {
// //           return SizedBox(
// //               height: MediaQuery.of(context).size.height,
// //               child: ListView.separated(
// //                   shrinkWrap: true,
// //                   scrollDirection: Axis.vertical,
// //                   itemBuilder: (context, index) => Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: SubCategoriesRestaurantCard(
// //                             item: state.subCategories?[index],mealId:widget.mealId),
// //                       ),
// //                   separatorBuilder: (context, index) => const Sizer(),
// //                   itemCount: state.subCategories?.length ?? 0));
// //         }),
// //       ),
// //       mainCategoryId: 1,
// //     );
// //   }
// // }
