import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/name/first_name_text_form_field.dart';

class CreateRestaurantNameField extends StatelessWidget {
  const CreateRestaurantNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantLoginCubit = context.read<CreateRestaurantCubit>();
    return RestaurantNameTextFormField(
      currentController: restaurantLoginCubit.name,
    );
  }
}
