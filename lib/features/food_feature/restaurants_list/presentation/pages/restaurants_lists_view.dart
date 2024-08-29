import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/offer_card.dart';
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
              final user = context.read<UserCubit>();

              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return user.state.data == null
                  ? const Center(
                      child: Text(Labels.shouldLoginFirst),
                    )
                  : Stack(
                      children: [
                        ListView(
                          children: [
                            const MealBanner(),
                            const Sizer(),
                            const ResturantDashboardButton(),
                            const Sizer(),
                            if (state.mealCategories?.isNotEmpty ?? false)
                              const MealCategories(),
                            if (state.subCategories?.isNotEmpty ?? false) ...[
                              Label(
                                text: Labels.restaurantsForSelectedMeal,
                                style: Styles.headerText(),
                              ),
                              const Sizer(),
                              _buildHorizontalRestaurants(),
                            ],
                            const Sizer(),
                            const Sizer(),
                            if (state.allRestaurant?.isNotEmpty ?? false) ...[
                              Label(
                                  text: 'All Restaurants',
                                  style: Styles.headerText()),
                              const Sizer(),
                              _buildVerticalRestaurants(),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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

  Widget _buildOffersWidget() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      final controller = context.read<RestaurantsListCubit>();
      return SizedBox(
          height: kToolbarHeight * 2,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FoodOfferCard(
                    item: state.categories![index],
                    onTap: (String id) =>
                        controller.getSubCategoryRestaurants(id: id),
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.categories?.length ?? 0));
    });
  }

  Widget _buildHorizontalRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      if (state.isLoading && state.allRestaurant == null) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.white24,
          child: Column(
            children: List.generate(
                3,
                (index) => Container(
                      height: 150,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                    )),
          ),
        );
      } else {
        return SizedBox(
            height: kToolbarHeight * 3.15,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    RestaurantCard(item: state.allRestaurant![index]),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: state.subCategories?.length ?? 0));
      }
    });
  }

  Widget _buildVerticalRestaurants() {
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
          itemCount: state.nearByRestaurants?.length ?? 0);
    });
  }
}
