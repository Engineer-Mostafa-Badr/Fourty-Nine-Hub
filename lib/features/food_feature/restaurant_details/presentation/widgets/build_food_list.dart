import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/item_card.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

class BuildFoodList extends StatelessWidget {
  const BuildFoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return state.meals?.isNotEmpty ?? false
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.meals?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  RestaurantMenu? meal = state.meals?[index];
                  return ItemCard(meal: meal);
                },
              ),
            )
          : SizedBox();
    });
  }
}
