import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/states/basic_state.dart';
import '../../domain/entities/cart_entity.dart';
import '../cubit/food_cart_cubit.dart';

class FoodCartView extends StatelessWidget {
  const FoodCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCartCubit, BasicState<CartEntity>>(
        builder: (context, state) {
      final controller = context.read<FoodCartCubit>();
      return Scaffold(
        appBar: const BackAppBar(
          label: 'Cart',
        ),
        bottomNavigationBar: AppButton(
            margin: 10,
            label: 'Place Order',
            onPressed: () => controller.placeOrder(context)),
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
  
  Widget _buildCartItems({required BuildContext context}) {
    // final controller = context.read<FoodCartCubit>();
    return BlocBuilder<FoodCartCubit, BasicState<CartEntity>>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Text('label'),
          separatorBuilder: (context, state) => const SizedBox(),
          itemCount: state.data?.allItems.length ?? 0);
    });
  }
}
