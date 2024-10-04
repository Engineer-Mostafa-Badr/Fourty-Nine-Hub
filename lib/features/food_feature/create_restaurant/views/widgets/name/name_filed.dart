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
            onChanged: (value) => restaurantLoginCubit.saveTextEditingController(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return null;
            },
            controller: restaurantLoginCubit.name,
            decoration: InputDecoration(
              // Border when the field is not focused
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.grey, // Use grey as the default border color
                ),
              ),
              // Border when the field is focused
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.grey, // Grey border when focused
                ),
              ),
              // Default border (same as enabledBorder)
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              // Error border when validation fails
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red, // Red border when there's an error
                ),
              ),
              // Error border when focused and invalid
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red, // Keep red border when focused with an error
                ),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(10), // Padding inside the text field
              hintText: LocaleKeys.restaurantName.tr(), // Hint text
            ),
          )
,
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
class CreateRestaurantNumberField extends StatelessWidget {
   const CreateRestaurantNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantLoginCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (value) => restaurantLoginCubit.saveNumberTextEditingController(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return null;
            },
            controller: restaurantLoginCubit.phoneController,
            decoration: InputDecoration(
              // Border when the field is not focused
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.grey, // Use grey as the default border color
                ),
              ),
              // Border when the field is focused
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.grey, // Grey border when focused
                ),
              ),
              // Default border (same as enabledBorder)
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isNumber ?? true)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              // Error border when validation fails
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red, // Red border when there's an error
                ),
              ),
              // Error border when focused and invalid
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red, // Keep red border when focused with an error
                ),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(10), // Padding inside the text field
              hintText: LocaleKeys.restaurantNumber.tr(), // Hint text
            ),
            keyboardType: TextInputType.phone,
          )
,
          Visibility(
            visible: state is ValidationState && (state.isNumber ?? false),
            child: const Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                "You have to fill Restaurant Phone Number!",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }
}
