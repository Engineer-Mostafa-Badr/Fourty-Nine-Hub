import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/meal_cubit/restaurants_list_cubit.dart';
import '../widgets/restaurant_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests

class RestaurantsListsView extends StatefulWidget {
  const RestaurantsListsView({super.key});

  @override
  State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
}

class _RestaurantsListsViewState extends State<RestaurantsListsView> {
  var bannerImageWhenNotLoggedIn = '';

// Define a function to fetch the data
  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://49dev.com/api/v1/restaurants/mainCategory/62c8b57e9332225799fe3308');

    // Perform the GET request
    final response = await http.get(url);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON data
      final data = jsonDecode(response.body);
      print(data); // Use the data as needed
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => serviceLocator<RestaurantsListCubit>(),
        child: SharedScaffold(
          mainCategoryId: 1,
          body: RefreshIndicator(
            onRefresh: () async =>
                serviceLocator<RestaurantsListCubit>().loadData(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<RestaurantsListCubit, RestaurantsListState>(
                listener: (BuildContext context, RestaurantsListState state) {  },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return context.watch<RestaurantsListCubit>().user == null
                      ? Builder(
                        builder: (context) {
                          fetchData();
                          return Center(
                              child: Label(
                              text: LocaleKeys.needToLogin.tr(),
                            ));
                        }
                      )
                      : Stack(
                          children: [
                            CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          width: double.infinity,
                                          height: 150.h,
                                          child: const MealBanner()),
                                      // const PropertyCard(),
                                      Visibility(
                                        visible:
                                            state.isResturant?.isRestaurant ==
                                                false,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (context
                                                .read<UserCubit>()
                                                .isLoggedIn) {
                                              context
                                                  .push(Routes.CREATERESTURANT);
                                            } else {
                                              context.push(Routes.REGISTER);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(
                                              LocaleKeys
                                                  .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
                                                  .tr(),
                                              style: Styles.mediumText(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Sizer(),
                                      Visibility(
                                          visible: (state.isResturant
                                                      ?.isRestaurant ??
                                                  false) &&
                                              (state.isResturant?.approved ??
                                                  false),
                                          child:
                                              const ResturantDashboardButton()),
                                      const Sizer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (context
                                              .read<UserCubit>()
                                              .isLoggedIn) {
                                            context.push(Routes.SEARCHMEALS);
                                          } else {
                                            context.push(Routes.REGISTER);
                                          }
                                        },
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            height: 36.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: .5,
                                                  color: Colors.grey),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(LocaleKeys.search.tr()),
                                                const Icon(Icons.search,
                                                    color: Colors.grey),
                                              ],
                                            )),
                                      ),
                                      const Sizer(),
                                      if (state.mealCategories?.isNotEmpty ??
                                          false)
                                        const MealCategories(),
                                      if (state.loadingSubCategories) ...[
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey[100]!,
                                            highlightColor: Colors.white,
                                            child: Row(
                                              children: List.generate(
                                                2,
                                                (index) => Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ))
                                      ],
                                      // if ((state.subCategories?.isNotEmpty ??
                                      //         false) &&
                                      //     state.isSuccess) ...[
                                      //   Label(
                                      //     text: LocaleKeys.restaurantsForSelectedMeal
                                      //         .tr(),
                                      //     style: Styles.headerText(),
                                      //   ),
                                      //   const Sizer(),
                                      //   _buildSubCatigoriesRestaurants(),
                                      // ],
                                      // const Sizer(),
                                      const Sizer(),
                                      if ((state.allRestaurant?.isNotEmpty ??
                                          false)) ...[
                                        Label(
                                            text:
                                                LocaleKeys.allRestaurants.tr(),
                                            style: Styles.headerText()),
                                        const Sizer(),
                                      ],
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: _buildAllRestaurants(),
                                ),
                              ],
                            ),

                            /// numOfRestaurants
                            // if (state.numOfRestaurants != null)
                            //   Positioned(
                            //     bottom: 10,
                            //     right: 10,
                            //     child: FloatingActionButton(
                            //       tooltip: LocaleKeys.restaurants.tr(),
                            //       backgroundColor: AppColors.PRIMARY_COLOR,
                            //       onPressed: () {},
                            //       child: Text(
                            //         "${state.numOfRestaurants}",
                            //         style: Styles.mediumText(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   )
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCatigoriesRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => SubCatigoriesRestaurantCard(
                  item: state.subCategories?[index]),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.subCategories?.length ?? 0));
    });
  }

  Widget _buildAllRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // GridView won't scroll independently
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SubCatigoriesRestaurantCard(
                    item: state.allRestaurant![index]),
              ),
          itemCount: state.allRestaurant?.length ?? 0);
    });
  }
}
