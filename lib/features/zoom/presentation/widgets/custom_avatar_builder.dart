import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../../social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

Widget customAvatarBuilder(
  BuildContext context,
  Size size,
  ZegoUIKitUser? user,
  Map<String, dynamic> extraInfo,
) {
  return CachedNetworkImage(
    imageUrl: context.read<UserCubit>().state.data!.profilePicture ??
        'https://th.bing.com/th/id/R.195a84f441cfe772357436029a60a5e3?rik=G0PzgIkK4tjAyA&pid=ImgRaw&r=0',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) {
      ZegoLoggerService.logInfo(
        '$user avatar url is invalid',
        tag: 'live audio',
        subTag: 'live page',
      );
      return ZegoAvatar(
        user: user,
        avatarSize: size,
        showSoundLevel: false,
      );
    },
  );
}
