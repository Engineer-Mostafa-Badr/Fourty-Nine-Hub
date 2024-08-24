import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/restaurant_shared_data.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/restaurant_card.dart';

class RestaurantsListsView extends StatelessWidget {
  const RestaurantsListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedScaffold(
        mainCategoryId: 1,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Stack(
                children: [
                  ListView(
                    children: [
                      const MealBanner(),
                      const Sizer(),
                      const ResturantDashboardButton(),
                      const Sizer(),
                      GestureDetector(
                        onTap: () {
                          if (context.read<UserCubit>().isLoggedIn) {
                            context.push(Routes.SEARCHMEALS);
                          } else {
                            context.push(Routes.REGISTER);
                          }
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 36,
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
                            )),
                      ),
                      const Sizer(),
                      if (state.mealCategories?.isNotEmpty ?? false)
                        const MealCategories(),
                      if (state.loadingSubCategories) ...[
                        Shimmer.fromColors(
                            baseColor: Colors.grey[100]!,
                            highlightColor: Colors.white,
                            child: Row(
                              children: List.generate(
                                2,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ))
                      ],
                      if ((state.subCategories?.isNotEmpty ?? false) &&
                          state.isSuccess) ...[
                        Label(
                          text: Labels.restaurantsForSelectedMeal,
                          style: Styles.headerText(),
                        ),
                        const Sizer(),
                        _buildSubCatigoriesRestaurants(),
                      ],
                      const Sizer(),
                      const Sizer(),
                      if ((state.allRestaurant?.isNotEmpty ?? false)) ...[
                        Label(
                            text: 'All Restaurants',
                            style: Styles.headerText()),
                        const Sizer(),
                        _buildAllRestaurants(),
                      ],
                    ],
                  ),

                  /// numOfRestaurants
                  if (state.numOfRestaurants != null)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        tooltip: Labels.resturants,
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        onPressed: () {},
                        child: Text(
                          "${state.numOfRestaurants}",
                          style: Styles.mediumText(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubCatigoriesRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return SizedBox(
          height: kToolbarHeight * 3.15,
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
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => RestaurantCard(
                isVert: false,
                item: state.allRestaurant![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.allRestaurant?.length ?? 0);
    });
  }
}
