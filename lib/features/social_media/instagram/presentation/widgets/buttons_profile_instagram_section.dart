import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';

class ButtonsProfileInstagramSection extends StatelessWidget {
  const ButtonsProfileInstagramSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<ProfileInstagramCubit>().state.profileData!.username ==
        UserCubit.to.state.data?.username) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: LocaleKeys.editProfile.localize,
                backColor:
                    context.isDarkMode ? Colors.transparent : Colors.white,
                radius: 7,
                border: Border.all(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {
                  ManageVibration.vibrate();
                  context.pushNamed(Routes.EDITPROFILE);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: LocaleKeys.shareProfile.localize,
                backColor:
                    context.isDarkMode ? Colors.transparent : Colors.white,
                radius: 7,
                border: Border.all(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {
                  ManageVibration.vibrate();
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: LocaleKeys.friend.localize,
                backColor:
                    context.isDarkMode ? Colors.transparent : Colors.white,
                radius: 7,
                border: Border.all(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {
                  ManageVibration.vibrate();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: LocaleKeys.message.localize,
                backColor:
                    context.isDarkMode ? Colors.transparent : Colors.white,
                radius: 7,
                border: Border.all(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {
                  ManageVibration.vibrate();
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
