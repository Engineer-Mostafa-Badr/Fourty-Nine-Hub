import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
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
                      : Colors.grey,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color:
                      Colors.red,
                ),
              ),
              filled: false,
              contentPadding:
                  const EdgeInsets.all(10),
              hintText:context.isArabic?'اسم المطعم':'Restaurant Name' ,
            ),
          ),
          Visibility(
            visible: state is ValidationState && (state.isName ?? false),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                LocaleKeys.youHaveToFillRestaurantName.localize,
                style: const TextStyle(color: Colors.red),
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
            onChanged: (value) =>
                restaurantLoginCubit.saveNumberTextEditingController(),
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
                  color:
                      Colors.red, // Keep red border when focused with an error
                ),
              ),
              filled: false,
              contentPadding:
                  const EdgeInsets.all(10), // Padding inside the text field
              hintText: LocaleKeys.restaurantNumber.tr(), // Hint text
              contentPadding: const EdgeInsets.all(10), // Padding inside the text field
              hintText:context.isArabic?'رقم المطعم':'Restaurant Number' ,
            ),
            keyboardType: TextInputType.phone,
          ),
          Visibility(
            visible: state is ValidationState && (state.isNumber ?? false),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                LocaleKeys.youHaveToFillRestaurantPhoneNumber.localize,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }
}
