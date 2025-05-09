import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/value_and_title_header_profile_instagram.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';

class HeaderProfileInstagram extends StatelessWidget {
  const HeaderProfileInstagram({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProfile =
        context.read<ProfileInstagramCubit>().state.profileData!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Stack(
            children: [
              ImageFromInternet(
                image: dataProfile.profilePictureUrl,
                isCircle: true,
                height: 86,
                width: 86,
                fit: BoxFit.cover,
              ),
              PositionedDirectional(
                bottom: 0,
                end: 5,
                child: InkWell(
                  onTap: () async {
                    context.read<UserCubit>().isLoggedIn
                        ? await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
                            ),
                          )
                        : pleaseLoginDialog(context);
                    // context.push(Routes.LOGIN);

                    BlocProvider.of<StoryCubit>(context)
                      ..fetchStories()
                      ..getMutedStories();
                  },
                  child: Container(
                    width: 29,
                    height: 29,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      radius: 18,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(
            flex: 2,
          ),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.postsCount),
            title: LocaleKeys.post.localize,
          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.friendsCount),
            title: LocaleKeys.friend.localize,
          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.followersCount),
            title: LocaleKeys.follower.localize,
          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.followingCount),
            title: LocaleKeys.following.localize,
          ),
        ],
      ),
    );
  }
}
