import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/face_book_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../stories/presentation/cubit/stories_cubit.dart';

class FacebookBody extends StatelessWidget {
  const FacebookBody({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocialPostsCubit>(
          create: (_) => serviceLocator()..loadData(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<StoryCubit>()
            ..fetchStories()
            ..getMutedStories(),
          // create: (context) => serviceLocator<StoryCubit>(),
        ),
      ],
      child: FaceBookView(),
    );
  }
}