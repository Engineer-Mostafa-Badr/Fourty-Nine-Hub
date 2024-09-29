import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../cubit/meal_cubit/restaurants_meal_list_cubit.dart';

class RestaurantForSelectedMeal extends StatefulWidget {
  final mealId;

  RestaurantForSelectedMeal({super.key, required this.mealId});

  @override
  State<RestaurantForSelectedMeal> createState() =>
      _RestaurantForSelectedMealState();
}

class _RestaurantForSelectedMealState extends State<RestaurantForSelectedMeal> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.mealId + "5555555555555555555555555555555555555555");
    // serviceLocator<RestaurantsListCubit>()
    //     .getSubCategoryRestaurants(id: widget.mealId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<RestaurantsListCubit>()
    //   ..getSubCategoryRestaurants(id: widget.mealId);

    return SharedScaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<RestaurantsMealListCubit, RestaurantsMealListState>(
            builder: (context, state) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubCatigoriesRestaurantCard(
                            item: state.subCategories?[index]),
                      ),
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.subCategories?.length ?? 0));
        }),
      ),
      mainCategoryId: 1,
    );
  }
}
