import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
              const Sizer(height: 20,),
              Text(
                '${9999.toShortScale} ${Labels.ads}',
                style: Styles.mediumText(),
              )
            ],
          ),
          Text(
            Labels.health,
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
                style: Styles.mediumText(color: AppColors.DARK_BLUE_COLOR)),
          ),
        ],
      ),
    );
  }
}
