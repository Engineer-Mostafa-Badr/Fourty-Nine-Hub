import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';


class CreateRestaurantSubmitButton extends StatelessWidget {
  const CreateRestaurantSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: () async {
              var res =
                  await context.read<CreateRestaurantCubit>().submit(context);
              // var res = await context
              //     .read<CreateRestaurantCubit>()
              //     .updateRestaurant('66ff110be6f198a009c8017e');
              if (res == 'success') {
                Navigator.pop(context);
              }
            },
            color: AppColors.getReversedTextColor(context),
            label: context.isArabic ? 'ارسال' : 'Submit' ,
            backColor: AppColors.getRedColor(context),
            //textStyle: ,
          ),
        ),
      ],
    );
  }
}
