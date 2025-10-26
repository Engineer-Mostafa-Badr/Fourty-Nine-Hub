import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/cuisine_restaurants/presentation/cubit/cuisine_restaurants_cubit.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../restaurants_list/presentation/widgets/restaurant_card.dart';

class CuisineRestaurantsView extends StatelessWidget {
  const CuisineRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CuisineRestaurantsCubit, CuisineRestaurantsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: BackAppBar(
                label: 'Cuisine Restaurants',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => const RestaurantCard(
                        isVert: false,
                        // item:,// state.cusineRestaurants![index],
                      ),
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.cusineRestaurants?.length ?? 0),
            ),
          );
        });
  }
}
