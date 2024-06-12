import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
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
              return ListView(
                children: [
                  if (state.categories?.isNotEmpty ?? false)
                    _buildOffersWidget(),
                  if (state.trendingRestaurants?.isNotEmpty ?? false)
                    Label(
                        text: 'Restaurants you know',
                        style: Styles.headerText()),
                  if (state.trendingRestaurants?.isNotEmpty ?? false)
                    const Sizer(),
                  if (state.trendingRestaurants?.isNotEmpty ?? false)
                    _buildHorizontalRestaurants(),
                  const Sizer(),
                  if (state.nearByRestaurants?.isNotEmpty ?? false)
                    Label(text: 'All Restaurants', style: Styles.headerText()),
                  if (state.nearByRestaurants?.isNotEmpty ?? false)
                    const Sizer(),
                  if (state.nearByRestaurants?.isNotEmpty ?? false)
                    _buildVerticalRestaurants()
                ],
              );
            },
          )),
    ));
  }

  Widget _buildOffersWidget() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return SizedBox(
          height: kToolbarHeight * 2,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FoodOfferCard(
                    item: state.categories![index] ,
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.categories?.length ?? 0));
    });
  }

  Widget _buildHorizontalRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return SizedBox(
          height: kToolbarHeight * 3,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>  RestaurantCard(item:state.trendingRestaurants![index]),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.trendingRestaurants?.length ?? 0));
    });
  }

  Widget _buildVerticalRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>  RestaurantCard(
                isVert: false,
                item: state.nearByRestaurants![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.nearByRestaurants?.length ?? 0);
    });
  }
}
