import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/item_card.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

class BuildFoodList extends StatelessWidget {
  final String restaurantId;

  const BuildFoodList({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      builder: (context, state) {

        final meals = state.meals;
        if (meals == null || meals.isEmpty) {
          return const SizedBox(); // Return an empty widget if meals are null or empty
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            shrinkWrap: true,

            itemCount: meals.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              final meal = meals[index];

              return ItemCard(
                meal: meal,
                restaurantId: restaurantId,

              );
            },
          ),
        );
      },
    );
  }
}
