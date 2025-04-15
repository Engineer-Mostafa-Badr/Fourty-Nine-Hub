import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/button_label_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/caption_text_field_create_second_post.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/show_images_create_post_second.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/tag_user_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                svgIcon: Assets.instagramTagPeopleIcon,
                title: LocaleKeys.tagPeople.localize,
                iconAction: Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  context.pushNamed(
                    Routes.TAGUSER,
                    extra: context
                        .read<CreatePostInstagramCubit>()
                        .state
                        .selectedImages,
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
                svgIcon: Assets.instagramLocationIcon,
                title: LocaleKeys.addLocation.localize,
                iconAction: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonLabelCreatePostInstagram(
                svgIcon: Assets.instagramMusicIcon,
                title: LocaleKeys.addMusic.localize,
                iconAction: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: AppButton(
            label: LocaleKeys.share.localize,
            height: 51,
            radius: 8,
            style: Styles.headerText(
                fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
            backColor: AppColors.c0B1035,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
