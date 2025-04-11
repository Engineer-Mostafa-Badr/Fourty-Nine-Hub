import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/button_label_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/content_text_field_create_second_post.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/show_images_create_post_second.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/tag_user_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CreatePostSecondPageInstagramViewBody extends StatelessWidget {
  const CreatePostSecondPageInstagramViewBody({
    super.key,
    // required this.selectedImages,
  });

  // final List<Future<File?>> selectedImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShowImagesCreatePostSecond(
                    // selectedImages: selectedImages,
                    ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ContentTextFieldCreateSecondPost(),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ButtonLabelCreatePostInstagram(
                icon: Icons.person_outline_rounded,
                title: LocaleKeys.tagPeople.localize,
                iconAction: Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => serviceLocator<TagUsersCubit>(),
                        child: const TagUserView(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ButtonLabelCreatePostInstagram(
                icon: Icons.location_pin,
                title: 'Add Location',
                iconAction: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
              const SizedBox(
                height: 16,
              ),
              // ButtonLabelCreatePostInstagram(
              //   icon: Icons.music_note_outlined,
              //   title: 'Add Music',
              //   iconAction: Icons.arrow_back_ios_new,
              //   onPressed: () {},
              // ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: AppButton(
            label: LocaleKeys.publish.localize,
            backColor: AppColors.PRIMARY_COLOR,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
