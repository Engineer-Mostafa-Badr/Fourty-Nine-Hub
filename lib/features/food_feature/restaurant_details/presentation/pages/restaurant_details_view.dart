import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../restaurant_details/presentation/widgets/restaurant_header.dart';
import '../cubit/restaurant_details_cubit.dart';

class RestaurantDetailsView extends StatefulWidget {
  final String id;

  const RestaurantDetailsView({super.key, required this.id});

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  @override
  void initState() {
    super.initState();
    // Initialize data fetching if needed
    // context.read<RestaurantDetailsCubit>().loadData(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.restaurantMenu.tr(),
      ),
      backgroundColor: scaffoldDarkColor(context),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _viewCartButton(),
      body: BlocProvider.value(
        value: serviceLocator<RestaurantDetailsCubit>()
          ..loadData(id: widget.id),
        child: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
          builder: (context, state) {
            return ListView(
              children: [
                if (state.restaurant != null)
                  RestaurantHeader(restaurant: state.restaurant!),
                const Sizer(),
                BuildFoodList(
                  restaurantId: widget.id,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _viewCartButton() {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                context.push(Routes.FOODCART);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: AppColors.SECONDARY_COLOR,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.view_cart.tr(),
                    style: Styles.headerText(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Sizer(),
                  const Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/style/styles.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../routes/routes.dart';
// import '../../../restaurant_details/presentation/widgets/restaurant_header.dart';
// import '../cubit/restaurant_details_cubit.dart';
//
// class RestaurantDetailsView extends StatefulWidget {
//   final String id;
//
//   const RestaurantDetailsView({super.key, required this.id});
//
//   @override
//   State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
// }
//
// class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BackAppBar(
//         label: 'Restaurant Menu',
//       ),
//       backgroundColor: scaffoldDarkColor(context),
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       bottomNavigationBar: _viewCartButton(),
//       body: BlocProvider.value(
//         value: serviceLocator<RestaurantDetailsCubit>()
//           ..loadData(id: widget.id),
//         child: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
//           builder: (context, state) {
//             return ListView(
//               children: [
//                 if (state.restaurant != null)
//                   RestaurantHeader(restaurant: state.restaurant!),
//                 const Sizer(),
//                 BuildFoodList(
//                   restaurantId: widget.id,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _viewCartButton() {
//     return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
//       builder: (context, state) {
//         return SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 context.push(Routes.FOODCART);
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 backgroundColor: AppColors.SECONDARY_COLOR,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     LocaleKeys.view_cart.tr(),
//                     style: Styles.headerText(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Sizer(),
//                   const Icon(
//                     Icons.shopping_cart_rounded,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// // import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// // import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import '../../../../../common/widgets/dynamic/sizer.dart';
// // import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // import '../../../../../common/widgets/stateless/labels/label.dart';
// // import '../../../../../res/style/styles.dart';
// // import 'package:go_router/go_router.dart';
// //
// // import '../../../../../res/style/app_colors.dart';
// // import '../../../../../routes/routes.dart';
// // import '../../../restaurant_details/presentation/widgets/restaurant_header.dart';
// // import '../cubit/restaurant_details_cubit.dart';
// //
// // class RestaurantDetailsView extends StatefulWidget {
// //   final String id;
// //
// //   const RestaurantDetailsView({super.key, required this.id});
// //
// //   @override
// //   State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
// // }
// //
// // class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
// //   @override
// //   void initState() {
// //     // context.read<RestaurantDetailsCubit>().loadData(id: widget.id);
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: BackAppBar(),
// //       extendBody: true,
// //       extendBodyBehindAppBar: true,
// //       bottomNavigationBar: _buildBuscketButton(),
// //       body: BlocProvider.value(
// //         value: serviceLocator<RestaurantDetailsCubit>()
// //           ..loadData(id: widget.id),
// //         child: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
// //             builder: (context, state) {
// //           return ListView(
// //             children: [
// //               if (state.restaurant != null)
// //                 RestaurantHeader(restaurant: state.restaurant!),
// //               const Divider(),
// //               BuildFoodList(
// //                 restaurantId: widget.id,
// //               ),
// //             ],
// //           );
// //         }),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBuscketButton() {
// //     return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
// //         builder: (context, state) {
// //       return SizedBox(
// //         width: double.infinity,
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// //           child: ElevatedButton(
// //             onPressed: () async {
// //               // if (state.selectedMeals?.isNotEmpty ?? false) {
// //               context.push(Routes.FOODCART);
// //               // }
// //             },
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// //               // Adjusted padding
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0), // Adjusted radius
// //               ),
// //               backgroundColor: AppColors.SECONDARY_COLOR,
// //             ),
// //             child: Text(
// //               LocaleKeys.view_cart.tr(),
// //               style: Styles.headerText(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //       /*Container(
// //           margin: const EdgeInsets.all(10),
// //           child: AppButton(
// //               color: AppColors.AUTH_CONTAINER_COLOR,
// //               backColor:
// //                   // state.selectedMeals?.isNotEmpty ?? false
// //                   //     ?
// //                   AppColors.SECONDARY_COLOR,
// //               // : AppColors.SECONDARY_COLOR.withOpacity(.7),
// //               label: 'View Cart - ${state.selectedMeals?.length ?? 0} Items',
// //               onPressed: () async {
// //                 // if (state.selectedMeals?.isNotEmpty ?? false) {
// //                 context.push(Routes.FOODCART);
// //                 // }
// //               }));*/
// //     });
// //   }
// //
// // // Widget _buildFilter() {
// // //   return Container(
// // //     height: kToolbarHeight * .5,
// // //     margin: const EdgeInsets.symmetric(horizontal: 10),
// // //     child: ListView.separated(
// // //         scrollDirection: Axis.horizontal,
// // //         itemBuilder: (context, index) =>
// // //             Column(
// // //               mainAxisAlignment: MainAxisAlignment.start,
// // //               children: [
// // //                 Label(text: 'Break Fast', style: Styles.mediumText()),
// // //                 if (index == 0)
// // //                   Container(
// // //                     margin: const EdgeInsets.only(top: 5),
// // //                     color: AppColors.SECONDARY_COLOR,
// // //                     height: 2.h,
// // //                     width: 80,
// // //                   ),
// // //               ],
// // //             ),
// // //         separatorBuilder: (context, index) => const Sizer(),
// // //         itemCount: 20),
// // //   );
// // // }
// // }
