import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../restaurants_list/presentation/widgets/restaurant_card.dart';
import '../cubit/cusine_restaurants_cubit.dart';

class CusineRestaurantsView extends StatelessWidget {
  const CusineRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CusineRestaurantsCubit, CusineRestaurantsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: const BackAppBar(
              label: 'Cusine Restaurants',
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => RestaurantCard(
                        isVert: false,
                        // item:,// state.cusineRestaurants![index],
                      ),
                  separatorBuilder: (context, index) => Sizer(),
                  itemCount: state.cusineRestaurants?.length ?? 0),
            ),
          );
        });
  }
}
