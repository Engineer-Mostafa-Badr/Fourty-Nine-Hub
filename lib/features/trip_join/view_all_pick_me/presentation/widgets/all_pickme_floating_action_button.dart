import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AllPickMeFloatingActionButton extends StatelessWidget {
  const AllPickMeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      bottom: 10,
      end: 10,
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FloatingActionButton(
        onPressed: () {
          context.read<UserCubit>().isLoggedIn
              ? context.push(Routes.AddNewPickMe)
              : context.push(Routes.LOGIN);
        },
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
