import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../helpers/manage_vibration.dart';

class UserProfileImage extends StatelessWidget {
  final String? imageURL;
  final String userId;
  final double size;
  final Color borderColor;
  final bool withBorder;
  final bool? fromProfile;
  final int accountId;

  const UserProfileImage(
      {super.key,
      required this.accountId,
      this.size = 15,
      this.withBorder = false,
      this.imageURL,
      this.borderColor = AppColors.SECONDARY_COLOR,
      this.fromProfile = false,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
        if (fromProfile == false && context.read<UserCubit>().isLoggedIn) {
          context.pushNamed(Routes.OTHERSACCOUNT, extra: userId);
        }
      },
      child: ImageFromInternet(
          image: imageURL ?? '',
          isCircle: true,
          defaultLogo: false,
          width: 40,
          height: 40,
          firstChar: UserCubit.to.state.data?.firstName[0].toUpperCase(),
          charPadding: 0),
    );
  }
}
