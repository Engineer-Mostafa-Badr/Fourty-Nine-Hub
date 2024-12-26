import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
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
      this.size = 15,
      this.withBorder = false,
      this.imageURL,
      this.borderColor = AppColors.SECONDARY_COLOR,
      this.fromProfile = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
