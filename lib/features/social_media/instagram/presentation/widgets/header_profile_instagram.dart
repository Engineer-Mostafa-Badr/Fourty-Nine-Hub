import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'value_and_title_header_profile_instagram.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../stories/presentation/pages/create_story_screen.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
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
            dataProfile: dataProfile,
            index: -1,
          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.friendsCount),
            title: LocaleKeys.friend.localize,
            dataProfile: dataProfile,
            index: 0,

          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.followersCount),
            title: LocaleKeys.follower.localize,
            dataProfile: dataProfile,
            index: 1,
          ),
          const Spacer(),
          ValueAndTitleHeaderProfileInstagram(
            value: FormatNumbers().formatNumber(dataProfile.viewsCount),
            title: LocaleKeys.views.localize,
            dataProfile: dataProfile,
            index: -1,
          ),
        ],
      ),
    );
  }
}