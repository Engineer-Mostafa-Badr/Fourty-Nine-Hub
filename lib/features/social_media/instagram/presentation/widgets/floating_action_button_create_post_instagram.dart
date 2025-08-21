import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../stories/presentation/pages/create_story_screen.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../reels/presentation/pages/recording/recording_shared.dart';
import '../../../../../helpers/manage_vibration.dart';

class FloatingActionButtonCreatePostInstagram extends StatelessWidget {
  const FloatingActionButtonCreatePostInstagram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsetsDirectional.only(
          top: 15,
          bottom: 15,
          start: 18,
          // end: 15,
        ),
        decoration: ShapeDecoration(
          color: context.isDarkMode ? Colors.white : AppColors.c0B1035,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 16,
              width: 18,
              child: SvgPicture.asset(
                context.isDarkMode
                    ? Assets.imageWhiteIconDark
                    : Assets.imageWhiteIcon,
              ),
            ),
            const SizedBox(
              width: 17,
            ),
            ...List.generate(
              serviceLocator<CreatePostInstagramCubit>().postTypes.length,
              (index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: InkWell(
                    onTap: () async {
      ManageVibration.vibrate();
                      if (index == 1) {
                        context.read<UserCubit>().isLoggedIn
                            ? await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen(),
                                ),
                              )
                            : pleaseLoginDialog(context);
                        // context.push(Routes.LOGIN);
                        if (!context.mounted) return;
                        BlocProvider.of<StoryCubit>(context)
                          ..fetchStories()
                          ..getMutedStories();
                      } else if (index == 2) {
                        context.read<UserCubit>().isLoggedIn
                            // ?context.go(Paths.REELS)
                            // ? await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => BlocProvider(
                            //         create: (context) =>
                            //             serviceLocator<SocialPostsCubit>(),
                            //         child: const ReelView(),
                            //       ),
                            //     ),
                            //   )
                            ? await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReelsRecordingScreen(
                                          voiceMediaId:'',
                                          voiceSignedUrl: '',
                                      ),
                                ),
                              )
                            : pleaseLoginDialog(context);
                        // context.push(Paths.REELS);
                      } else {
                        serviceLocator<CreatePostInstagramCubit>()
                            .changePostType(index);
                      }
                    },
                    child: BlocBuilder<CreatePostInstagramCubit,
                        CreatePostInstagramState>(
                      buildWhen: (previous, current) =>
                          previous.postTypeSelectedIndex !=
                          current.postTypeSelectedIndex,
                      builder: (context, state) {
                        return Label(
                          text: serviceLocator<CreatePostInstagramCubit>()
                              .postTypes[index]
                              .title,
                          style: Styles.mediumText(
                            color: context.isDarkMode
                                ? const Color(0xff0D0D0D)
                                : Colors.white,
                            fontWeight: state.postTypeSelectedIndex == index
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}