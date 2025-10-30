import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../cubit/create_restaurant_cubit.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class CreateRestaurantNameField extends StatefulWidget {
  const CreateRestaurantNameField({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  State<CreateRestaurantNameField> createState() => _CreateRestaurantNameFieldState();
}

class _CreateRestaurantNameFieldState extends State<CreateRestaurantNameField> {
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
            focusNode: widget.focusNode,
            style: Styles.mediumText(),
            controller: restaurantLoginCubit.name,
            decoration: InputDecoration(
              fillColor:  AppColors.getFillColor(context),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(10),
              hintText: LocaleKeys.restaurantName.localize,
              hintStyle: Styles.mediumText(),
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
  const CreateRestaurantNumberField({super.key, required this.restaurantNumber});
  final String restaurantNumber ;
  @override
  Widget build(BuildContext context) {
    final restaurantLoginCubit = context.read<CreateRestaurantCubit>();
    restaurantLoginCubit.phoneController.text = restaurantNumber; // Set value
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
               style: Styles.mediumText(),
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
              fillColor:  AppColors.getFillColor(context),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: state is ValidationState && (state.isName ?? true)
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              filled: true,
              contentPadding:

                  const EdgeInsets.all(10), // Padding inside the text field
              hintText: LocaleKeys.restaurantNumber.tr(),
                hintStyle: Styles.mediumText(), // Hint text
              // contentPadding: const EdgeInsets.all(10), // Padding inside the text field
              // hintText:context.isArabic?'رقم المطعم':'Restaurant Number' ,
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
