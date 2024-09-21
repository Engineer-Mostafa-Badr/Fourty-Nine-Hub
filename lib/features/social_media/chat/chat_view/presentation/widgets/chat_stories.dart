import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../../stories/presentation/pages/more_stories.dart';
import '../../../../tinder/presentation/pages/user_profile.dart';

class ChatStories extends StatelessWidget {
  const ChatStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 1.5,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _createMyStory(context),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 1.5,
            child: BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _buildStoryItem(context, state, index);
                  },
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.stories.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMyStory(context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      ),
      child: SizedBox(
        height: kToolbarHeight * 1.5,
        width: kToolbarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      child: Label(
                          text: 'FS',
                          style: Styles.headerText(color: Colors.white)),
                    ),
                  ),
                  const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ))
                ],
              ),
            ),
            Label(
                text: 'My Story',
                style: Styles.mediumText(fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(context, StoryState state, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryViewScreen(
                stories: state.stories,
                initialUserIndex: index,
              ),
            ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.SECONDARY_COLOR,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  state.stories[index].user!.profilePictureUrl ??
                      UIConst.profilePlaceHolder),
            ),
          ),
          Label(
              text: capitalizeAndSplit2Only(
                  "${state.stories[index].user!.firstName} ${state.stories[index].user!.lastName}"),
              style: Styles.mediumText(fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
