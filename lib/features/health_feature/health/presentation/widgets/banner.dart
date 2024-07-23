import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/cubit/health_cubit.dart';
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
          const Icon(
            Icons.favorite_border,
            color: AppColors.SECONDARY_COLOR,
          ),
          Text(
            'Health',
            style: Styles.headerText(color: AppColors.DARK_BLUE_COLOR),
          ),
          InkWell(
            onTap: () => context.push(Routes.DOCTORLOGIN,extra: context.read<HealthCubit>().state.subCategories),
            child: Text('Register',
                style: Styles.mediumText(color: AppColors.DARK_BLUE_COLOR)),
          ),
        ],
      ),
    );
  }
}
