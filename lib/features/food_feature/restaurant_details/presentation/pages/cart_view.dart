import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../widgets/cart_item_card.dart';

class FoodCartView extends StatelessWidget {
  const FoodCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: const BackAppBar(
          label: 'Cart',
        ),
        bottomNavigationBar:
            AppButton(margin: 10, label: 'Place Order', onPressed: () => context.push(Routes.REQUESTSHISTORY)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              _buildCartItems(context: context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCartItems({
    required BuildContext context
  }) {
    final controller = context.read<RestaurantDetailsCubit>();
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => CartItemCard(
                onEdit: (v) {},
                onRemove: () =>controller.removeFromCart(index: index),
                meal: state.selectedMeals![index],
              ),
          separatorBuilder: (context, state) => const SizedBox(),
          itemCount: state.selectedMeals?.length ?? 0);
    });
  }
}
