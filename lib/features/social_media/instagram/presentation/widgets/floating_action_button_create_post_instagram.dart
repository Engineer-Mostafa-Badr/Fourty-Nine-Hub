import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
              context.read<CreatePostInstagramCubit>().postTypes.length,
              (index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: InkWell(
                    onTap: () async {
                      if (index == 1) {
                        context.read<UserCubit>().isLoggedIn
                            ? await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen(),
                                ),
                              )
                            : context.push(Routes.LOGIN);
                        if (!context.mounted) return;
                        BlocProvider.of<StoryCubit>(context)
                          ..fetchStories()
                          ..getMutedStories();
                      } else {
                        context
                            .read<CreatePostInstagramCubit>()
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
                          text: context
                              .read<CreatePostInstagramCubit>()
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
