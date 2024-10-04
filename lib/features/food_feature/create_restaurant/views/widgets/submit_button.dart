import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';

import '../../../../../res/style/styles.dart';

class CreateRestaurantSubmitButton extends StatelessWidget {
  const CreateRestaurantSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedAppButton(
            onPressed: () async {
              var res = await context.read<CreateRestaurantCubit>().submit();
              if (res == 'success') {
                Navigator.pop(context);
              }
            },
            label: LocaleKeys.submit.tr(),
            textStyle: Styles.headerText(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
