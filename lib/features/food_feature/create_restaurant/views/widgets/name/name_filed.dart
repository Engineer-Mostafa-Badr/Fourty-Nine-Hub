import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';

class CreateRestaurantNameField extends StatelessWidget {
  const CreateRestaurantNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantLoginCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (value) =>
                restaurantLoginCubit.saveTextEditingController(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return null;
            },
            controller: restaurantLoginCubit.name,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: state is ValidationState && (state.isName ?? true)
                        ? Colors.red
                        : Colors.grey),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: state is ValidationState && (state.isName ?? true)
                        ? Colors.red
                        : Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: state is ValidationState && (state.isName ?? true)
                        ? Colors.red
                        : Colors.grey),
              ),
              filled: false,
              contentPadding: EdgeInsets.all(10),
              hintText: LocaleKeys.restaurantName.tr(),
            ),
          ),
          Visibility(
            visible: state is ValidationState && (state.isName ?? false),
            child: const Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                "You have to fill Restaurant Name!",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }
}
