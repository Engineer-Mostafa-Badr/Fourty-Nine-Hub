import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  const ProfileImage(
      {super.key,
      required this.accountId,
      this.size = 15,
      this.withBorder = false,
      this.imageURL,
      this.borderColor = AppColors.SECONDARY_COLOR, this.fromProfile=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(fromProfile==false){
          context.push(Routes.OTHERSACCOUNT);
        }
      },
      child: CircleAvatar(
        radius: withBorder ? size + 2 : size,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(imageURL?? UIConst.profilePlaceHolder),
        ),
      ),
    );
  }
}
