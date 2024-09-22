import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
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
          const Sizer(
            width: 8,
          ),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                return state.users.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _buildOthersStories(context, state, index),
                        separatorBuilder: (context, index) => const Sizer(
                              width: 8,
                            ),
                        itemCount: state.users.length)
                    : const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.black,
                        ),
                      );
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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryViewScreen(
                stories: state.users,
                initialUserIndex: index,
              ),
            ),
          );
          // await BlocProvider.of<StoryCubit>(context).fetchStories();
        },
        child: Container(
          height: kToolbarHeight * 2.5,
          width: kToolbarHeight * 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: state.users.isNotEmpty &&
                  state.users[index].userStories!.isNotEmpty
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: StoryView(
                          indicatorColor: Colors.transparent,
                          indicatorForegroundColor: Colors.transparent,
                          storyItems: [
                            state.users[index].userStories!.first.type !=
                                    'video'
                                ? createStoryItem(
                                    context,
                                    state.users[index].userStories!.first,
                                    userController)
                                : StoryItem.pageImage(
                                    loadingWidget:
                                        const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                    url: state
                                        .users[index].user!.profilePictureUrl!,
                                    errorWidget: Image.network(
                                      UIConst.profilePlaceHolder,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    imageFit: BoxFit.fitHeight,
                                    controller: userController,
                                  )
                          ],
                          controller: userController),
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
                            backgroundColor: AppColors.SECONDARY_COLOR,
                            radius: 16,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(state.users[index]
                                              .user!.profilePictureUrl !=
                                          null &&
                                      state.users[index].user!
                                          .profilePictureUrl!.isNotEmpty
                                  ? state.users[index].user!.profilePictureUrl!
                                  : UIConst.profilePlaceHolder),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const NetworkImage(
                                UIConst.profilePlaceHolder,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: FittedBox(
                              child: Label(
                                  text: capitalizeAndSplit2Only(
                                      "${state.users[index].user!.firstName}\n${state.users[index].user!.lastName}"),
                                  textAlign: TextAlign.start,
                                  style: Styles.mediumText(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      const Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 8.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                )
              : const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildYourStory(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CameraScreen(),
            ),
          );

          await BlocProvider.of<StoryCubit>(context).fetchStories();
        },
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
                  Expanded(
                    child: Image.network(
                      serviceLocator<UserCubit>().state.data != null &&
                              serviceLocator<UserCubit>()
                                      .state
                                      .data!
                                      .profilePicture !=
                                  null
                          ? serviceLocator<UserCubit>()
                              .state
                              .data!
                              .profilePicture!
                          : UIConst.profilePlaceHolder,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(UIConst.imagePlaceHolder),
                    ),
                  ),
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
