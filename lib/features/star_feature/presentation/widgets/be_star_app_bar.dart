import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/all_winner_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class BeStarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BeStarAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.tube.localize,
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              _navigateToWinners(context);
            },
            child: Row(
              children: [
                Text(
                  LocaleKeys.winners.localize,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(Assets.winners),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToWinners(BuildContext context) {
    ManageVibration.vibrate();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<StarCubit>(),
          child: const AllWinnerView(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}