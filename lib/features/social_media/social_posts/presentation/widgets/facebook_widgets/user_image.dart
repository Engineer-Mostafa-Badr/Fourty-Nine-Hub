import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return InkWell(
      onTap: () {
      ManageVibration.vibrate();
        if (fromProfile == false && context.read<UserCubit>().isLoggedIn) {
          context.push(Routes.OTHERSACCOUNT, extra: userId);
        }
      },
      child: CircleAvatar(
        radius: withBorder ? size + 2 : size,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
              imageURL ?? UIConst.profilePlaceHolder),
        ),
      ),
    );
  }
}