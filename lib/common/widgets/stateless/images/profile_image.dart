import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';

class ProfileImage extends StatelessWidget {
  final String? imageURL;
  final double size;
  final Color borderColor;
  final bool withBorder;
  final bool? fromProfile;
  final int accountId;
  final String userId;

  const ProfileImage(
      {super.key,
      required this.accountId,
      required this.userId,
      this.size = 40,
      this.withBorder = false,
      this.imageURL,
      this.borderColor = AppColors.SECONDARY_COLOR,
      this.fromProfile = false});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
        if (fromProfile == false && userId.isNotEmpty) {
          if (context.isUserLoggedIn) {
            context.read<UserCubit>().updateProfileView(
                  isProfile: false,
                  userId: userId,
                );
          }
          context.push(Routes.OTHERSACCOUNT, extra: userId);
        }
      },
      child: ImageFromInternet(
          image: imageURL ?? '',
          isCircle: true,
          defaultLogo: false,
          width: 50,
          height: 50,
          // firstChar: user.firstName[0].toUpperCase(),
          charPadding: 0),
    );
  }
}
