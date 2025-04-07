import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/create_post_instagram_screen.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CreatePostInstagramView extends StatelessWidget {
  const CreatePostInstagramView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              serviceLocator<CreatePostInstagramCubit>()..loadImages(context),
          child: const CreatePostInstagramScreen(),
        ),
      ),
    );
  }
}
