import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/create_post_second_page_instagram_view_body.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CreatePostSecondPageInstagramView extends StatelessWidget {
  const CreatePostSecondPageInstagramView({
    super.key,
    // required this.selectedImages,
  });
  // final List<Future<File?>> selectedImages;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.newPost.localize,
      ),
      body: BlocProvider(
        create: (context) => serviceLocator<CreatePostInstagramCubit>(),
        child: const CreatePostSecondPageInstagramViewBody(
            // selectedImages: selectedImages,
            ),
      ),
    );
  }
}
