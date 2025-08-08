
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'button_label_create_post_instagram.dart';
import 'caption_text_field_create_second_post.dart';
import 'show_images_create_post_second.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_posts/presentation/pages/Social_home.dart';
import '../../../../../helpers/manage_vibration.dart';

class CreatePostSecondPageInstagramViewBody extends StatefulWidget {
  const CreatePostSecondPageInstagramViewBody({
    super.key,
  });

  @override
  State<CreatePostSecondPageInstagramViewBody> createState() =>
      _CreatePostSecondPageInstagramViewBodyState();
}

class _CreatePostSecondPageInstagramViewBodyState
    extends State<CreatePostSecondPageInstagramViewBody> {
  late final TextEditingController captionController;

  @override
  void initState() {
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child:
              BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
            buildWhen: (previous, current) =>
                previous.usersTag != current.usersTag ||
                previous.location != current.location,
            builder: (context, state) {
              return Column(
                children: [

                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 24.0),
                    child: ShowImagesCreatePostSecond(
                        // selectedImages: selectedImages,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CaptionTextFieldCreateSecondPost(
                      captionController: captionController,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ButtonLabelCreatePostInstagram(
                    svgIcon: state.usersTag.isNotEmpty
                        ? (context.isDarkMode
                            ? Assets.instagramTagPeopleRedIconDark
                            : Assets.instagramTagPeopleRedIcon)
                        : (context.isDarkMode
                            ? Assets.instagramTagPeopleIconDark
                            : Assets.instagramTagPeopleIcon),
                    title: LocaleKeys.tagPeople.localize,
                    labelColor: state.usersTag.isNotEmpty
                        ? (context.isDarkMode
                            ? const Color(0xffFF4622)
                            : const Color(0xffFF3308))
                        : (context.isDarkMode ? Colors.white : AppColors.black),
                    iconAction: state.usersTag.isNotEmpty
                        ? Icons.close_rounded
                        : Icons.arrow_forward_ios_rounded,
                    onPressed: () {
      ManageVibration.vibrate();
                      context.pushNamed(
                        Routes.TAGUSER,
                        extra: context.read<CreatePostInstagramCubit>(),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BlocProvider(
                      //       create: (context) => serviceLocator<TagUsersCubit>(),
                      //       child: TagUserView(
                      //         image: context
                      //             .read<CreatePostInstagramCubit>()
                      //             .state
                      //             .images
                      //             .first,
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ButtonLabelCreatePostInstagram(
                    svgIcon: state.location == null
                        ? (context.isDarkMode
                            ? Assets.instagramLocationIconDark
                            : Assets.instagramLocationIcon)
                        : (context.isDarkMode
                            ? Assets.instagramLocationRedIconDark
                            : Assets.instagramLocationRedIcon),
                    title: state.location == null
                        ? LocaleKeys.addLocation.localize
                        : state.location!.name,
                    labelColor: state.location == null
                        ? (context.isDarkMode ? Colors.white : AppColors.black)
                        : (context.isDarkMode
                            ? const Color(0xffFF4622)
                            : const Color(0xffFF3308)),
                    iconAction: state.location == null
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.close_rounded,
                    onPressed: () {
      ManageVibration.vibrate();
                      context.pushNamed(
                        Routes.INSTAGRAMADDLOCATION,
                        extra: context.read<CreatePostInstagramCubit>(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ButtonLabelCreatePostInstagram(
                    svgIcon: context.isDarkMode
                        ? Assets.instagramMusicIconDark
                        : Assets.instagramMusicIcon,
                    title: LocaleKeys.addMusic.localize,
                    labelColor:
                        context.isDarkMode ? Colors.white : Colors.black,
                    iconAction: Icons.arrow_forward_ios_rounded,
                    onPressed: () {
      ManageVibration.vibrate();
                      context.pushNamed(
                        Routes.INSTAGRAMADDMUSIC,
                        extra: context.read<CreatePostInstagramCubit>(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: AppButton(
            label: LocaleKeys.share.localize,
            height: 51,
            radius: 8,
            style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode
                    ? const Color(0xff0D0D0D)
                    : Colors.white),
            backColor: context.isDarkMode ? Colors.white : AppColors.c0B1035,
            onPressed: () {
      ManageVibration.vibrate();
              if (captionController.text.isEmpty) {
                showErrorMessage(
                    context, LocaleKeys.captionMustBeAdded.localize);
                return;
              } else {
                context.read<CreatePostInstagramCubit>().createPost(
                      caption: captionController.text,
                    );
                context.go(Routes.SOCIAL,extra: SocialParams(userId: UserCubit.to.state.data?.id ?? '', index: 1));
              }
            },
          ),
        ),
      ],
    );
  }
}