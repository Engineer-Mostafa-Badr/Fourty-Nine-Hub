import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../cubit/create_restaurant_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../helpers/manage_vibration.dart';


class CreateRestaurantSubmitButton extends StatelessWidget {
  const CreateRestaurantSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: () async {
      ManageVibration.vibrate();
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