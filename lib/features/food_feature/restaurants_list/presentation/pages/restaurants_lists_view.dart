// import 'dart:developer';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/strings/labels.dart';
// import '../../../../../res/style/styles.dart';
// import '../../../create_restaurant/cubit/create_resturant_cubit.dart';
// import '../../../create_restaurant/views/create_resturant_view.dart';
// import '../cubit/meal_cubit/restaurants_meal_list_cubit.dart';
// import '../cubit/restaurants_list_cubit.dart';
// import '../widgets/restaurant_card.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'dart:convert'; // For JSON decoding
// import 'package:http/http.dart' as http; // For HTTP requests
//
// class RestaurantsListsView extends StatefulWidget {
//   const RestaurantsListsView({super.key});
//
//   @override
//   State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
// }
//
// class _RestaurantsListsViewState extends State<RestaurantsListsView> {
//   NoAuthRestaurantCategory? restaurantCategory;
//
// // Define a function to fetch the data
//   Future<void> fetchData() async {
//     final url = Uri.parse(
//         'https://49dev.com/api/v1/restaurants/mainCategory/62c8b57e9332225799fe3308');
//
//     // Perform the GET request
//     final response = await http.get(url);
//
//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       // Parse the JSON data
//       final data = jsonDecode(response.body);
//       final restaurantCategory =
//           NoAuthRestaurantCategory.fromJson(data); // Since it's an array
//
//       setState(() {
//         this.restaurantCategory = restaurantCategory;
//       });
//       print(data); // Use the data as needed
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     fetchData();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (context) => serviceLocator<RestaurantsCubit>(),
//         child: SharedScaffold(
//           mainCategoryId: 1,
//           body: RefreshIndicator(
//             onRefresh: () async {
//               if (serviceLocator<UserCubit>().isLoggedIn) {
//                 // serviceLocator<RestaurantsCubit>().loadData();
//                 BlocProvider.of<RestaurantsCubit>(context).loadData();
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: BlocConsumer<RestaurantsCubit, RestaurantsListState>(
//                 listener: (BuildContext context, RestaurantsListState state) {},
//                 builder: (context, state) {
//                   // if (state.isLoading) {
//                   //   return const Center(
//                   //     child: CircularProgressIndicator.adaptive(),
//                   //   );
//                   // }
//                   if (!serviceLocator<UserCubit>().isLoggedIn) {
//                     print('from isNotLoggedIn');
//
//                     return restaurantCategory != null
//                         ? SizedBox(
//                             width: double.infinity,
//                             child: Column(
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Image.network(
//                                       restaurantCategory!.data.banner,
//                                       width: double.infinity,
//                                       height: 100.h,
//                                       fit: BoxFit.fitWidth,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               Shimmer.fromColors(
//                                         baseColor: Colors.grey[100]!,
//                                         highlightColor: Colors.white,
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 8.0),
//                                           child: Container(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.2,
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(10)),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     PositionedDirectional(
//                                       start: 8,
//                                       child: Label(
//                                         text:
//                                             '${restaurantCategory!.data.numberOfAds.toShortScale} ${LocaleKeys.ads.localize}',
//                                         style: Styles.mediumText(
//                                           shadows: const [
//                                             Shadow(
//                                               offset: Offset(1.0, 1.0),
//                                               blurRadius: 4.0,
//                                               color: Colors.black,
//                                             ),
//                                           ],
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Center(
//                                       child: Label(
//                                         text:
//                                             context.isArabic ? 'اكله' : 'Meal',
//                                         // text: restaurantCategory!.data.nameEn,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 45.sp),
//                                       ),
//                                     ),
//                                     PositionedDirectional(
//                                         end: 0,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: InkWell(
//                                             onTap: () {
//                                               log('88888888888888888888888888');
//                                               context.push(Routes.REGISTER);
//                                             },
//                                             child: Text(
//                                                 LocaleKeys.register.localize,
//                                                 style: Styles.mediumText(
//                                                     color: Colors.white,
//                                                     shadows: const [
//                                                       Shadow(
//                                                         offset:
//                                                             Offset(1.0, 1.0),
//                                                         blurRadius: 4.0,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ],
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ),
//                                         )),
//                                   ],
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (context.read<UserCubit>().isLoggedIn) {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => BlocProvider<
//                                                 CreateRestaurantCubit>(
//                                               create: (context) =>
//                                                   serviceLocator(),
//                                               child:
//                                                   const CreateRestaurantForm(),
//                                             ),
//                                           ));
//                                       // context.push(Routes.CREATERESTURANT);
//                                     } else {
//                                       context.push(Routes.REGISTER);
//                                     }
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5.0),
//                                     child: Text(
//                                       LocaleKeys
//                                           .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
//                                           .tr(),
//                                       style: Styles.mediumText(
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 8.0),
//                                     child: Shimmer.fromColors(
//                                       baseColor: Colors.grey[100]!,
//                                       highlightColor: Colors.white,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: List.generate(
//                                           3,
//                                           (index) => Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 8.0),
//                                             child: Container(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.2,
//                                               width: double.infinity,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                         : const SizedBox.shrink();
//                   }
//                   return context.watch<RestaurantsCubit>().user == null
//                       ? const Center(
//                           child: CircularProgressIndicator.adaptive(),
//                           //   child: Label(
//                           //   text: LocaleKeys.needToLogin.tr(),
//                           // ),
//                         )
//                       : Stack(
//                           children: [
//                             CustomScrollView(
//                               slivers: [
//                                 SliverToBoxAdapter(
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(
//                                           width: double.infinity,
//                                           child: MealBanner()),
//                                       // const PropertyCard(),
//                                       Visibility(
//                                         visible:
//                                             state.isResturant?.isRestaurant ==
//                                                 false,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             if (context
//                                                 .read<UserCubit>()
//                                                 .isLoggedIn) {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         BlocProvider<
//                                                             CreateRestaurantCubit>(
//                                                       create: (context) =>
//                                                           serviceLocator(),
//                                                       child:
//                                                           const CreateRestaurantForm(),
//                                                     ),
//                                                   ));
//                                               // context
//                                               //     .push(Routes.CREATERESTURANT);
//                                             } else {
//                                               context.push(Routes.REGISTER);
//                                             }
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5.0),
//                                             child: Text(
//                                               LocaleKeys
//                                                   .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
//                                                   .tr(),
//                                               style: Styles.mediumText(
//                                                 color: Colors.red,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const Sizer(),
//                                       Visibility(
//                                           visible: (state.isResturant
//                                                       ?.isRestaurant ??
//                                                   false) &&
//                                               (state.isResturant?.approved ??
//                                                   false),
//                                           child:
//                                               const ResturantDashboardButton()),
//                                       const Sizer(),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 if (context
//                                                     .read<UserCubit>()
//                                                     .isLoggedIn) {
//                                                   context
//                                                       .push(Routes.SEARCHMEALS);
//                                                 } else {
//                                                   context.push(Routes.REGISTER);
//                                                 }
//                                               },
//                                               child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 10.w),
//                                                   height: 50.h,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     border: Border.all(
//                                                         width: .5,
//                                                         color: Colors.grey),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(LocaleKeys.search
//                                                           .tr()),
//                                                       const Icon(Icons.search,
//                                                           color: Colors.grey),
//                                                     ],
//                                                   )),
//                                             ),
//                                           ),
//                                           Sizer(),
//                                           Expanded(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 if (context
//                                                     .read<UserCubit>()
//                                                     .isLoggedIn) {
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             TripRequestsScreen(),
//                                                       ));
//                                                 } else {
//                                                   context.push(Routes.REGISTER);
//                                                 }
//                                               },
//                                               child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 10.w),
//                                                   height: 50.h,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     border: Border.all(
//                                                         width: .5,
//                                                         color: Colors.grey),
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(LocaleKeys
//                                                         .expiredRequests
//                                                         .tr()),
//                                                   )),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const Sizer(),
//                                       if (state.mealCategories?.isNotEmpty ??
//                                           false)
//                                         const MealCategories(),
//                                       if (state.loadingSubCategories) ...[
//                                         Shimmer.fromColors(
//                                             baseColor: Colors.grey[100]!,
//                                             highlightColor: Colors.white,
//                                             child: Row(
//                                               children: List.generate(
//                                                 2,
//                                                 (index) => Container(
//                                                   margin: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 10),
//                                                   height: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.2,
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.2,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10)),
//                                                 ),
//                                               ),
//                                             ))
//                                       ],
//                                       // if ((state.subCategories?.isNotEmpty ??
//                                       //         false) &&
//                                       //     state.isSuccess) ...[
//                                       //   Label(
//                                       //     text: LocaleKeys.restaurantsForSelectedMeal
//                                       //         .tr(),
//                                       //     style: Styles.headerText(),
//                                       //   ),
//                                       //   const Sizer(),
//                                       //   _buildSubCatigoriesRestaurants(),
//                                       // ],
//                                       // const Sizer(),
//                                       const Sizer(),
//                                       if ((state.allRestaurant?.isNotEmpty ??
//                                           false)) ...[
//                                         Label(
//                                             text:
//                                                 LocaleKeys.allRestaurants.tr(),
//                                             style: Styles.headerText()),
//                                         const Sizer(),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                                 SliverToBoxAdapter(
//                                   child: _buildAllRestaurants(),
//                                 ),
//                               ],
//                             ),
//
//                             /// numOfRestaurants
//                             // if (state.numOfRestaurants != null)
//                             //   Positioned(
//                             //     bottom: 10,
//                             //     right: 10,
//                             //     child: FloatingActionButton(
//                             //       tooltip: LocaleKeys.restaurants.tr(),
//                             //       backgroundColor: AppColors.PRIMARY_COLOR,
//                             //       onPressed: () {},
//                             //       child: Text(
//                             //         "${state.numOfRestaurants}",
//                             //         style: Styles.mediumText(
//                             //             color: Colors.white,
//                             //             fontWeight: FontWeight.bold),
//                             //       ),
//                             //     ),
//                             //   )
//                           ],
//                         );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubCatigoriesRestaurants() {
//     return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
//         builder: (context, state) {
//       return SizedBox(
//           height: MediaQuery.of(context).size.width,
//           child: ListView.separated(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) => SubCategoriesRestaurantCard(
//                   mealId: '', item: state.subCategories?[index]),
//               separatorBuilder: (context, index) => const Sizer(),
//               itemCount: state.subCategories?.length ?? 0));
//     });
//   }
//
//   Widget _buildAllRestaurants() {
//     return BlocConsumer<RestaurantsCubit, RestaurantsListState>(
//       builder: (context, state) {
//         return GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             // GridView won't scroll independently
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 1,
//               mainAxisSpacing: 8,
//               crossAxisSpacing: 8,
//               childAspectRatio: 0.7,
//             ),
//             itemBuilder: (context, index) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SubCategoriesRestaurantCard(
//                     item: state.allRestaurant![index],
//                     mealId: '',
//                   ),
//                 ),
//             itemCount: state.allRestaurant?.length ?? 0);
//       },
//       listener: (BuildContext context, RestaurantsListState state) {},
//     );
//   }
// }
//
// class NoAuthRestaurantCategory {
//   final bool status;
//   final CategoryData data;
//
//   NoAuthRestaurantCategory({
//     required this.status,
//     required this.data,
//   });
//
//   // Factory constructor to create an instance from JSON
//   factory NoAuthRestaurantCategory.fromJson(Map<String, dynamic> json) {
//     return NoAuthRestaurantCategory(
//       status: json['status'],
//       data: CategoryData.fromJson(json['data']),
//     );
//   }
//
//   // Method to convert back to JSON if needed
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': data.toJson(),
//     };
//   }
// }
//
// class CategoryData {
//   final String id;
//   final String banner;
//   final String cover;
//   final int index;
//   final String createdAt;
//   final String updatedAt;
//   final String nameAr;
//   final String nameEn;
//   final String nameCode;
//   final bool isHidden;
//   final bool enableInstallmentAndAuction;
//   final int numberOfAds;
//
//   CategoryData({
//     required this.id,
//     required this.banner,
//     required this.cover,
//     required this.index,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.nameAr,
//     required this.nameEn,
//     required this.nameCode,
//     required this.isHidden,
//     required this.enableInstallmentAndAuction,
//     required this.numberOfAds,
//   });
//
//   // Factory constructor to create an instance from JSON
//   factory CategoryData.fromJson(Map<String, dynamic> json) {
//     return CategoryData(
//       id: json['_id'],
//       banner: json['banner'],
//       cover: json['cover'],
//       index: json['index'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       nameAr: json['nameAr'],
//       nameEn: json['nameEn'],
//       nameCode: json['nameCode'],
//       isHidden: json['isHidden'],
//       enableInstallmentAndAuction: json['EnableInstallmentAndAuction'],
//       numberOfAds: json['numberOfAds'],
//     );
//   }
//
//   // Method to convert back to JSON if needed
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'banner': banner,
//       'cover': cover,
//       'index': index,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'nameAr': nameAr,
//       'nameEn': nameEn,
//       'nameCode': nameCode,
//       'isHidden': isHidden,
//       'EnableInstallmentAndAuction': enableInstallmentAndAuction,
//       'numberOfAds': numberOfAds,
//     };
//   }
// }

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/restaurants_list_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests

class RestaurantsListsView extends StatefulWidget {
  const RestaurantsListsView({super.key});

  @override
  State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
}

class _RestaurantsListsViewState extends State<RestaurantsListsView> {
  NoAuthRestaurantCategory? restaurantCategory;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://49dev.com/api/v1/restaurants/mainCategory/62c8b57e9332225799fe3308');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          restaurantCategory = NoAuthRestaurantCategory.fromJson(data);
        });
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantsCubit>().state;
    return Scaffold(
      body: BlocProvider<RestaurantsCubit>(
        create: (_) => RestaurantsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData(),
        child: SharedScaffold(
          mainCategoryId: 1,
          body: RefreshIndicator(
            onRefresh: () async {
              if (context.read<UserCubit>().isLoggedIn) {
                setState(() {
                  context.read<RestaurantsCubit>().loadData();
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                builder: (context, snapshot) {
                  if (!context.watch<UserCubit>().isLoggedIn) {
                    return _buildNotLoggedInView(context);
                  }
                  if (state.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return _buildLoggedInView(snapshot.data!);
                },
                stream: context.watch<RestaurantsCubit>().stream,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    if (restaurantCategory == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                restaurantCategory!.data.banner,
                width: double.infinity,
                height: 100.h,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) =>
                    _buildShimmerPlaceholder(),
              ),
              PositionedDirectional(
                start: 8,
                child: Label(
                  text:
                      '${restaurantCategory!.data.numberOfAds} ${LocaleKeys.ads.tr()}',
                  style: Styles.mediumText(
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Label(
                  text: context.isArabic ? 'اكله' : 'Meal',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45.sp,
                  ),
                ),
              ),
              PositionedDirectional(
                end: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => context.push(Routes.REGISTER),
                    child: Text(
                      LocaleKeys.register.tr(),
                      style: Styles.mediumText(
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: Colors.black,
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push(Routes.REGISTER),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                LocaleKeys
                    .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
                    .tr(),
                style: Styles.mediumText(color: Colors.red),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildShimmerPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInView(RestaurantsListState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const MealBanner(),
              if (!(state.isResturant?.isRestaurant ?? false))
                _buildRegisterRestaurantPrompt(),
              const Sizer(),
              if ((state.isResturant?.isRestaurant ?? false) &&
                  (state.isResturant?.approved ?? false))
                const ResturantDashboardButton(),
              const Sizer(),
              _buildSearchAndExpiredRequests(),
              const Sizer(),
              if (state.mealCategories?.isNotEmpty ?? false) MealCategories(),
              if (state.loadingSubCategories)
                _buildLoadingSubCategoriesPlaceholder(),
              const Sizer(),
              if ((state.allRestaurant?.isNotEmpty ?? false)) ...[
                Label(
                  text: LocaleKeys.allRestaurants.tr(),
                  style: Styles.headerText(),
                ),
                const Sizer(),
              ],
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: _buildAllRestaurants(state),
        ),
      ],
    );
  }

  Widget _buildRegisterRestaurantPrompt() {
    return GestureDetector(
      onTap: () => context.push(Routes.CREATERESTURANT),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(
          LocaleKeys
              .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
              .tr(),
          style: Styles.mediumText(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSearchAndExpiredRequests() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => context.push(Routes.SEARCHMEALS),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: .5, color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.search.tr()),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        const Sizer(),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: serviceLocator<RestaurantsCubit>()
                        ..getExpiredOrders(),
                      child: const RestaurantExpiredRequestsScreen(),
                    ),
                  ));
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: .5, color: Colors.grey),
              ),
              child: Center(
                child: Text(LocaleKeys.expiredRequests.tr()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSubCategoriesPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: Row(
        children: List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllRestaurants(state) {
    return Builder(
      builder: (context) {
        final restaurants = state.allRestaurant ?? [];
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.001,
          ),
          itemCount: restaurants.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubCategoriesRestaurantCard(
              item: restaurants[index],
              mealId: '',
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoAuthRestaurantCategory {
  final bool status;
  final CategoryData data;

  NoAuthRestaurantCategory({
    required this.status,
    required this.data,
  });

  factory NoAuthRestaurantCategory.fromJson(Map<String, dynamic> json) {
    return NoAuthRestaurantCategory(
      status: json['status'],
      data: CategoryData.fromJson(json['data']),
    );
  }
}

class CategoryData {
  final String id;
  final String banner;
  final String cover;
  final int index;
  final String createdAt;
  final String updatedAt;
  final String nameAr;
  final String nameEn;
  final String nameCode;
  final bool isHidden;
  final bool enableInstallmentAndAuction;
  final int numberOfAds;

  CategoryData({
    required this.id,
    required this.banner,
    required this.cover,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
    required this.nameAr,
    required this.nameEn,
    required this.nameCode,
    required this.isHidden,
    required this.enableInstallmentAndAuction,
    required this.numberOfAds,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'],
      banner: json['banner'],
      cover: json['cover'],
      index: json['index'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      nameCode: json['nameCode'],
      isHidden: json['isHidden'],
      enableInstallmentAndAuction: json['EnableInstallmentAndAuction'],
      numberOfAds: json['numberOfAds'],
    );
  }
}
