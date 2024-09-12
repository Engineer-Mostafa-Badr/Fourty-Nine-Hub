// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
// import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
// import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// import '../../../../stories/presentation/cubit/stories_cubit.dart';
// import '../../../../stories/presentation/pages/more_stories.dart';
// import '../../../../tinder/presentation/pages/user_profile.dart';
//
// class ChatStories extends StatelessWidget {
//   const ChatStories({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: kToolbarHeight * 2,
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//       ),
//       child: ListView(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         children: [
//           _createMyStory(context),
//           const Sizer(),
//           BlocBuilder<StoryCubit, StoryState>(
//             builder: (context, state) {
//               return ListView.separated(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return _buildStoryItem(context, state, index);
//                 },
//                 separatorBuilder: (context, index) => const Sizer(),
//                 itemCount: state.stories.length,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _createMyStory(context) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const CameraScreen(),
//           ),
//         );
//
//         await BlocProvider.of<StoryCubit>(context).fetchStories();
//       },
//       child: FittedBox(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 20,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.PRIMARY_COLOR,
//                       backgroundImage: NetworkImage(
//                         serviceLocator<UserCubit>().state.data != null
//                             ? serviceLocator<UserCubit>()
//                                 .state
//                                 .data!
//                                 .profilePicture!
//                             : UIConst.profilePlaceHolder,
//                       ),
//                       onBackgroundImageError: (exception, stackTrace) =>
//                           const NetworkImage(
//                         UIConst.profilePlaceHolder,
//                       ),
//                     ),
//                   ),
//                   const Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.PRIMARY_COLOR,
//                       radius: 10,
//                       child: Icon(
//                         Icons.add,
//                         size: 15,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Label(
//               text: 'Add Story',
//               style: Styles.smallText(fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryItem(context, StoryState state, index) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => StoryViewScreen(
//               stories: state.stories,
//               initialUserIndex: index,
//             ),
//           ),
//         );
//         // await BlocProvider.of<StoryCubit>(context).fetchStories();
//       },
//       child: FittedBox(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: AppColors.SECONDARY_COLOR,
//               child: CircleAvatar(
//                 radius: 23,
//                 backgroundColor: Colors.black87,
//                 backgroundImage: NetworkImage(
//                     state.stories[index].user!.profilePictureUrl != null &&
//                             state.stories[index].user!.profilePictureUrl!
//                                 .isNotEmpty
//                         ? state.stories[index].user!.profilePictureUrl!
//                         : UIConst.profilePlaceHolder),
//                 onBackgroundImageError: (exception, stackTrace) =>
//                     const NetworkImage(
//                   UIConst.profilePlaceHolder,
//                 ),
//               ),
//             ),
//             Label(
//               text: capitalizeAndSplit2Only(
//                   "${state.stories[index].user!.firstName}\n${state.stories[index].user!.lastName}"),
//               style: Styles.mediumText(fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../../stories/presentation/pages/more_stories.dart';
import '../../../../tinder/presentation/pages/user_profile.dart';

class ChatStories extends StatelessWidget {
  const ChatStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _createMyStory(context),
            Sizer(width: 8,),
            BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                if (state.users.isEmpty) {
                  return const Center(
                    child: Text('No stories available'),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _buildStoryItem(context, state, index);
                  },
                  separatorBuilder: (context, index) => Sizer(width: 8,),
                  itemCount: state.users.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createMyStory(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        );
        await BlocProvider.of<StoryCubit>(context).fetchStories();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius:
                MediaQuery.of(context).size.width * 0.09, // Responsive radius
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    backgroundImage: NetworkImage(
                      serviceLocator<UserCubit>().state.data != null
                          ? serviceLocator<UserCubit>()
                              .state
                              .data!
                              .profilePicture!
                          : UIConst.profilePlaceHolder,
                    ),
                    onBackgroundImageError: (_, __) => Image.asset(
                      UIConst.profilePlaceHolder,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    radius: 10,
                    child: Icon(
                      Icons.add,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Label(
            text: 'Add Story\n ',
            style: Styles.mediumText(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
    final userController = StoryController();

    return InkWell(
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
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius:
                MediaQuery.of(context).size.width * 0.09, // Responsive radius
            backgroundColor: AppColors.SECONDARY_COLOR,
            child: ClipOval(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: IgnorePointer(
                  ignoring: true,
                  child: StoryView(
                    indicatorColor: Colors.transparent,
                    indicatorForegroundColor: Colors.transparent,
                    storyItems: [
                      state.users[index].userStories!.first.type != 'video'
                          ? createStoryItem(
                              context,
                              state.users[index].userStories!.first,
                              userController,
                              textStyle: const TextStyle(fontSize: 12))
                          : StoryItem.pageImage(
                              loadingWidget: const CupertinoActivityIndicator(
                                color: Colors.white,
                              ),
                              url: state.users[index].user!.profilePictureUrl!,
                              errorWidget: Image.network(
                                UIConst.profilePlaceHolder,
                                fit: BoxFit.fitHeight,
                              ),
                              imageFit: BoxFit.cover,
                              // Ensure it fits circularly
                              controller: userController,
                            ),
                    ],
                    controller: userController,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Add some space between the avatar and label
          Label(
            text: capitalizeAndSplit2Only(
              "${state.users[index].user!.firstName}\n${state.users[index].user!.lastName}",
            ),
            style: Styles.mediumText(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

// Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
//   final userController = StoryController();
//
//   return GestureDetector(
//     onTap: () async {
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => StoryViewScreen(
//             stories: state.users,
//             initialUserIndex: index,
//           ),
//         ),
//       );
//     },
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           radius:
//               MediaQuery.of(context).size.width * 0.09, // Responsive radius
//           backgroundColor: AppColors.SECONDARY_COLOR,
//
//           child: StoryView(storyItems: [
//             state.users[index].userStories!.first.type != 'video'
//                 ? createStoryItem(context,
//                     state.users[index].userStories!.first, userController)
//                 : StoryItem.pageImage(
//                     loadingWidget: const CupertinoActivityIndicator(
//                       color: Colors.white,
//                     ),
//                     url: state.users[index].user!.profilePictureUrl!,
//                     errorWidget: Image.network(
//                       UIConst.profilePlaceHolder,
//                       fit: BoxFit.fitHeight,
//                     ),
//                     imageFit: BoxFit.fitHeight,
//                     controller: userController,
//                   )
//           ], controller: userController),
//           // CircleAvatar(
//           //   radius: MediaQuery.of(context).size.width * 0.085,
//           //   backgroundColor: Colors.black87,
//           //   backgroundImage: NetworkImage(
//           //     state.users[index].user!.profilePictureUrl != null &&
//           //             state.users[index].user!.profilePictureUrl!.isNotEmpty
//           //         ? state.users[index].user!.profilePictureUrl!
//           //         : UIConst.profilePlaceHolder,
//           //   ),
//           //   onBackgroundImageError: (_, __) => Image.asset(
//           //     UIConst.profilePlaceHolder,
//           //   ),
//           // ),
//         ),
//         Label(
//           text: capitalizeAndSplit2Only(
//             "${state.users[index].user!.firstName}\n${state.users[index].user!.lastName}",
//           ),
//           style: Styles.mediumText(fontWeight: FontWeight.w600),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//   );
// }
}
