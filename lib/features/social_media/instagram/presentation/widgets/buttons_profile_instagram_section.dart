import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
                backColor: Colors.white,
                radius: 7,
                border: Border.all(
                  color: Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {
                  context.push(Routes.EDITPROFILE);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: LocaleKeys.shareProfile.localize,
                backColor: Colors.white,
                radius: 7,
                border: Border.all(
                  color: Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {},
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
                backColor: Colors.white,
                radius: 7,
                border: Border.all(
                  color: Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: LocaleKeys.message.localize,
                backColor: Colors.white,
                radius: 7,
                border: Border.all(
                  color: Colors.black,
                ),
                style: Styles.mediumText(
                  fontSize: 32,
                  height: 1.22,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
    }
  }
}
