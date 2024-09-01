import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({super.key});

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<UserCubit>();
    return ListView(
      shrinkWrap: true,
      children: [
        Label(
          text: LocaleKeys.logout.localize,
          style: Styles.headerText(),
        ),
        Label(
          text: LocaleKeys.sureLogout.localize,
          style: Styles.mediumText(),
        ),
        const Sizer(),
        Row(
          children: [
            Expanded(
                child: AppButton(
              height: 50.zH,
              label: LocaleKeys.no.localize,
              color: AppColors.AUTH_CONTAINER_COLOR,
              onPressed: () => context.pop(),
              backColor: AppColors.DARK_GRAY_COLOR,
            )),
            const Sizer(),
            Expanded(
              child: AppButton(
                height: 50.zH,
                label: LocaleKeys.logout.localize,
                color: AppColors.AUTH_CONTAINER_COLOR,
                onPressed: () {
                  controller.logout();
                  context.pop();
                  context.pop();
                  setState(() {});
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
