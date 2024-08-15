import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<UserCubit>();
    return ListView(
      shrinkWrap: true,
      children: [
        Label(
          text: 'Logout',
          style: Styles.headerText(),
        ),
        Label(
          text: 'Are you sure you want to logout?',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        Row(
          children: [
            Expanded(
                child: AppButton(
              label: 'No',
              onPressed: () => context.pop(),
              backColor: AppColors.DARK_GRAY_COLOR,
            )),
            const Sizer(),
            Expanded(
              child: AppButton(
                label: 'Logout',
                onPressed: () {
                  controller.logout();
                  context.pop();
                  context.pop();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
