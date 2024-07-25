import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      decoration: BoxDecoration(
          color: AppColors.YELLOW_COLOR,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.healthBanner),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Icon(
                Icons.favorite_border,
                color: AppColors.SECONDARY_COLOR,
              ),
              Text(
                '99 ads',
                style: Styles.mediumText(),
              )
            ],
          ),
          Text(
            'Health',
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
            child: Text('Register',
                style: Styles.mediumText(color: AppColors.DARK_BLUE_COLOR)),
          ),
        ],
      ),
    );
  }
}
