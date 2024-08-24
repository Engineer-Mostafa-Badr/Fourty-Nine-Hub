import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';

class CreateRestaurantSubmitButton extends StatelessWidget {
  const CreateRestaurantSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedAppButton(
            onPressed: () {
              context.read<CreateRestaurantCubit>().submit();
            },
            fontSize: 18,
            label: LocaleKeys.submit.tr(),
          ),
        ),
      ],
    );
  }
}
