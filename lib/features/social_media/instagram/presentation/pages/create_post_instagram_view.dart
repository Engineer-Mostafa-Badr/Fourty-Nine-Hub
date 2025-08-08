import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../widgets/create_post_instagram_view_body.dart';
import '../../../../../service_locator/service_locator.dart';

class CreatePostInstagramView extends StatelessWidget {
  const CreatePostInstagramView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CreatePostInstagramCubit>()..loadImages(context),
      child: const CustomScaffold(
        body: SafeArea(
          child: CreatePostInstagramViewBody(),
        ),
      ),
    );
  }
}
