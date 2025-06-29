import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../../features/social_media/stories/presentation/cubit/stories_cubit.dart';
import '../../../../features/social_media/stories/presentation/pages/more_stories.dart';
import '../../../../features/social_media/tinder/data/shared/shared.dart';
import '../../../../service_locator/service_locator.dart';
import '../../dialogs/please_login_dialog.dart';
import '../../dynamic/sizer.dart';

class ProfileImageWithStories extends StatelessWidget {
  const ProfileImageWithStories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<StoryCubit>()
        ..fetchStories()
        ..getMutedStories(),
  child: BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        if (state.users.isEmpty ?? false) {
          return const SizedBox();
        }
        return ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildStoryItem(context, state, index),
            );
          },
          separatorBuilder: (context, index) => const Sizer(
            width: 8,
          ),
          itemCount: state.users.length ?? 0,
        );
      },
    ),
);
  }
  Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
    final userController = StoryController();

    return FittedBox(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator<StoryCubit>(),
                child: StoryViewScreen(
                  stories: state.users ?? [],
                  initialUserIndex: index,
                ),
              ),
            ),
          )
              : pleaseLoginDialog(context);
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileWithStoriesBorder(
              profilePictureUrl:
              state.users[index].user?.profilePictureUrl ?? '',
              storiesCount: state.users[index].stories?.length ?? 0,
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Text(
                capitalizeAndSplit2Only(
                  state.users[index].user?.firstName?.split(' ').first ?? '',
                ),
                textScaler: TextScaler.noScaling,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
