import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          color: AppColors.YELLOW_COLOR,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.healthBanner),
          )),
      child: Stack(
        children: [
          /// image
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Sizer(),
                Text(
                  Labels.meals,
                  style: Styles.headerText(color: AppColors.DARK_BLUE_COLOR),
                ),
                InkWell(
                  onTap: () {
                    if (context.read<UserCubit>().isLoggedIn) {
                      context.push(Routes.CREATEDOCTOR);
                    } else {
                      context.push(Routes.REGISTER);
                    }
                  },
                  child: Text(Labels.register,
                      style:
                          Styles.mediumText(color: AppColors.DARK_BLUE_COLOR)),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_border,
            color: AppColors.SECONDARY_COLOR,
          ),
        ],
      ),
    );
  }
}
