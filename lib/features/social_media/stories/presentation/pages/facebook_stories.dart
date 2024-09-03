
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/stories_cubit.dart';
import 'more_stories.dart';
import 'create_story_screen.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2.5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          const Sizer(),
          _buildYourStory(context),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _buildOthersStories(context, state, index),
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.stories.length);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOthersStories(context, StoryState state, index) {
    final userController = StoryController();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewScreen(
              stories: state.stories,
              initialUserIndex: index,
            ),
          ),
        ),
        child: Container(
          height: kToolbarHeight * 2.5,
          width: kToolbarHeight * 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: StoryView(storyItems: [
                  createStoryItem(
                      state.stories[index].stories!.first, userController)
                ], controller: userController),
              ),
              Positioned.fill(
                  child: Container(
                color: Colors.black.withOpacity(.1),
              )),
              Positioned.fill(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      radius: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          state.stories[index].user!.profilePictureUrl ??
                              UIConst.profilePlaceHolder,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Label(
                          text: capitalizeAndSplit2Only(
                              "${state.stories[index].user!.firstName} ${state.stories[index].user!.lastName}"),
                          textAlign: TextAlign.end,
                          style: Styles.smallText(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourStory(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        ),
        // onTap: () => serviceLocator<StoryCubit>().pickAndUploadStory(description: "romman"),
        child: Container(
          height: kToolbarHeight * 2,
          width: kToolbarHeight * 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Column(
                children: [
                  Expanded(child: Image.network(UIConst.profilePlaceHolder)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(text: 'Create Story', style: Styles.smallText())
                      ],
                    ),
                  ))
                ],
              )),
              const Positioned.fill(
                  child: Center(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
