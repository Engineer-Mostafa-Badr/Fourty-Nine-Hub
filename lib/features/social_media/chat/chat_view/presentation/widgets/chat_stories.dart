// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
// // import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
// // import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/res/style/const.dart';
// // import 'package:fourtyninehub/res/style/styles.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// //
// // import '../../../../stories/presentation/cubit/stories_cubit.dart';
// // import '../../../../stories/presentation/pages/more_stories.dart';
// // import '../../../../tinder/presentation/pages/user_profile.dart';
// //
// // class ChatStories extends StatelessWidget {
// //   const ChatStories({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: kToolbarHeight * 2,
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).scaffoldBackgroundColor,
// //       ),
// //       child: ListView(
// //         shrinkWrap: true,
// //         scrollDirection: Axis.horizontal,
// //         children: [
// //           _createMyStory(context),
// //           const Sizer(),
// //           BlocBuilder<StoryCubit, StoryState>(
// //             builder: (context, state) {
// //               return ListView.separated(
// //                 shrinkWrap: true,
// //                 scrollDirection: Axis.horizontal,
// //                 itemBuilder: (context, index) {
// //                   return _buildStoryItem(context, state, index);
// //                 },
// //                 separatorBuilder: (context, index) => const Sizer(),
// //                 itemCount: state.stories.length,
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _createMyStory(context) {
// //     return GestureDetector(
// //       onTap: () async {
// //         await Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => const CameraScreen(),
// //           ),
// //         );
// //
// //         await BlocProvider.of<StoryCubit>(context).fetchStories();
// //       },
// //       child: FittedBox(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             CircleAvatar(
// //               radius: 20,
// //               child: Stack(
// //                 children: [
// //                   Positioned.fill(
// //                     child: CircleAvatar(
// //                       backgroundColor: AppColors.PRIMARY_COLOR,
// //                       backgroundImage: NetworkImage(
// //                         serviceLocator<UserCubit>().state.data != null
// //                             ? serviceLocator<UserCubit>()
// //                                 .state
// //                                 .data!
// //                                 .profilePicture!
// //                             : UIConst.profilePlaceHolder,
// //                       ),
// //                       onBackgroundImageError: (exception, stackTrace) =>
// //                           const NetworkImage(
// //                         UIConst.profilePlaceHolder,
// //                       ),
// //                     ),
// //                   ),
// //                   const Positioned(
// //                     bottom: 0,
// //                     right: 0,
// //                     child: CircleAvatar(
// //                       backgroundColor: AppColors.PRIMARY_COLOR,
// //                       radius: 10,
// //                       child: Icon(
// //                         Icons.add,
// //                         size: 15,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //             Label(
// //               text: 'Add Story',
// //               style: Styles.smallText(fontWeight: FontWeight.w600),
// //               textAlign: TextAlign.center,
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStoryItem(context, StoryState state, index) {
// //     return GestureDetector(
// //       onTap: () async {
// //         await Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => StoryViewScreen(
// //               stories: state.stories,
// //               initialUserIndex: index,
// //             ),
// //           ),
// //         );
// //         // await BlocProvider.of<StoryCubit>(context).fetchStories();
// //       },
// //       child: FittedBox(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             CircleAvatar(
// //               radius: 25,
// //               backgroundColor: AppColors.SECONDARY_COLOR,
// //               child: CircleAvatar(
// //                 radius: 23,
// //                 backgroundColor: Colors.black87,
// //                 backgroundImage: NetworkImage(
// //                     state.stories[index].user!.profilePictureUrl != null &&
// //                             state.stories[index].user!.profilePictureUrl!
// //                                 .isNotEmpty
// //                         ? state.stories[index].user!.profilePictureUrl!
// //                         : UIConst.profilePlaceHolder),
// //                 onBackgroundImageError: (exception, stackTrace) =>
// //                     const NetworkImage(
// //                   UIConst.profilePlaceHolder,
// //                 ),
// //               ),
// //             ),
// //             Label(
// //               text: capitalizeAndSplit2Only(
// //                   "${state.stories[index].user!.firstName}\n${state.stories[index].user!.lastName}"),
// //               style: Styles.mediumText(fontWeight: FontWeight.w600),
// //               textAlign: TextAlign.center,
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
// import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:story_view/controller/story_controller.dart';
// import 'package:story_view/widgets/story_view.dart';
//
// import '../../../../stories/presentation/pages/more_stories.dart';
// import '../../../../tinder/data/shared/shared.dart';
// import '../../../../tinder/presentation/pages/user_profile.dart';
//
// class ChatStories extends StatelessWidget {
//   const ChatStories({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.15, // Responsive height
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               width: 4,
//             ),
//             _createMyStory(context),
//             const SizedBox(
//               width: 4,
//             ),
//             BlocBuilder<StoryCubit, StoryState>(
//               builder: (context, state) {
//                 if (state.users.isEmpty) {
//                   // return  Center(
//                   //   child: Text(
//                   //     'No stories available',
//                   //     textScaler: TextScaler.noScaling,
//                   //     style: TextStyle(fontSize: 40.sp),
//                   //   ),
//                   // );
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                     child: Shimmer.fromColors(
//                       baseColor: Colors.grey.withOpacity(0.1),
//                       highlightColor: Colors.grey.withOpacity(0.5),
//                       child: CircleAvatar(
//                         radius: MediaQuery.of(context).size.width *
//                             0.09, // Responsive radius
//                       ),
//                     ),
//                   );
//                 }
//                 return ListView.separated(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                       child: _buildStoryItem(context, state, index),
//                     );
//                   },
//                   separatorBuilder: (context, index) => const Sizer(
//                     width: 8,
//                   ),
//                   itemCount: state.users.length,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _createMyStory(BuildContext context) {
//     return FittedBox(
//       child: GestureDetector(
//         onTap: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CameraScreen(),
//             ),
//           );
//           await BlocProvider.of<StoryCubit>(context).fetchStories();
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius:
//                   MediaQuery.of(context).size.width * 0.09, // Responsive radius
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
//                       onBackgroundImageError: (_, __) => Image.asset(
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
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 2,
//             ),
//             FittedBox(
//               child: Text(
//                 'Add Story\n ',
//                 textScaler: TextScaler.noScaling,
//                 style: TextStyle(fontWeight: FontWeight.normal),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
//     final userController = StoryController();
//
//     return InkWell(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => StoryViewScreen(
//               stories: state.users,
//               initialUserIndex: index,
//             ),
//           ),
//         );
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius:
//                 MediaQuery.of(context).size.width * 0.09, // Responsive radius
//             backgroundColor: AppColors.SECONDARY_COLOR,
//             child: ClipOval(
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               child: SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: IgnorePointer(
//                   ignoring: true,
//                   child: StoryView(
//                     indicatorColor: Colors.transparent,
//                     indicatorForegroundColor: Colors.transparent,
//                     storyItems: [
//                       state.users[index].userStories!.first.type != 'video'
//                           ? createStoryItem(
//                               context,
//                               state.users[index].userStories!.first,
//                               userController,
//                               textStyle: const TextStyle(fontSize: 12))
//                           : StoryItem.pageImage(
//                               loadingWidget: const CupertinoActivityIndicator(
//                                 color: Colors.white,
//                               ),
//                               url: state.users[index].user!.profilePictureUrl!,
//                               errorWidget: Image.network(
//                                 UIConst.profilePlaceHolder,
//                                 fit: BoxFit.fitHeight,
//                               ),
//                               imageFit: BoxFit.cover,
//                               // Ensure it fits circularly
//                               controller: userController,
//                             ),
//                     ],
//                     controller: userController,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 2),
//           // Add some space between the avatar and label
//           Flexible(
//             child: FittedBox(
//               child: Text(
//                 capitalizeAndSplit2Only(
//                   "${state.users[index].user!.firstName}\n${state.users[index].user!.lastName}",
//                 ),
//                 textScaler: TextScaler.noScaling,
//                 style: const TextStyle(fontWeight: FontWeight.normal),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// // Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
// //   final userController = StoryController();
// //
// //   return GestureDetector(
// //     onTap: () async {
// //       await Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => StoryViewScreen(
// //             stories: state.users,
// //             initialUserIndex: index,
// //           ),
// //         ),
// //       );
// //     },
// //     child: Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         CircleAvatar(
// //           radius:
// //               MediaQuery.of(context).size.width * 0.09, // Responsive radius
// //           backgroundColor: AppColors.SECONDARY_COLOR,
// //
// //           child: StoryView(storyItems: [
// //             state.users[index].userStories!.first.type != 'video'
// //                 ? createStoryItem(context,
// //                     state.users[index].userStories!.first, userController)
// //                 : StoryItem.pageImage(
// //                     loadingWidget: const CupertinoActivityIndicator(
// //                       color: Colors.white,
// //                     ),
// //                     url: state.users[index].user!.profilePictureUrl!,
// //                     errorWidget: Image.network(
// //                       UIConst.profilePlaceHolder,
// //                       fit: BoxFit.fitHeight,
// //                     ),
// //                     imageFit: BoxFit.fitHeight,
// //                     controller: userController,
// //                   )
// //           ], controller: userController),
// //           // CircleAvatar(
// //           //   radius: MediaQuery.of(context).size.width * 0.085,
// //           //   backgroundColor: Colors.black87,
// //           //   backgroundImage: NetworkImage(
// //           //     state.users[index].user!.profilePictureUrl != null &&
// //           //             state.users[index].user!.profilePictureUrl!.isNotEmpty
// //           //         ? state.users[index].user!.profilePictureUrl!
// //           //         : UIConst.profilePlaceHolder,
// //           //   ),
// //           //   onBackgroundImageError: (_, __) => Image.asset(
// //           //     UIConst.profilePlaceHolder,
// //           //   ),
// //           // ),
// //         ),
// //         Label(
// //           text: capitalizeAndSplit2Only(
// //             "${state.users[index].user!.firstName}\n${state.users[index].user!.lastName}",
// //           ),
// //           style: Styles.mediumText(fontWeight: FontWeight.w600),
// //           textAlign: TextAlign.center,
// //         ),
// //       ],
// //     ),
// //   );
// // }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/muted_stories.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // For localization keys

import '../../../../stories/presentation/pages/more_stories.dart';
import '../../../../tinder/data/shared/shared.dart';

class ChatStories extends StatelessWidget {
  const ChatStories({super.key});

  @override
  Widget build(BuildContext context) {
    // if(context.read<UserCubit>().isLoggedIn){
    //   return Container();
    // }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        height: 120, // Responsive height
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 8,
              ),
              SizedBox(height: 120, child: _createMyStory(context)),
              const SizedBox(
                width: 6,
              ),
              BlocBuilder<StoryCubit, StoryState>(
                builder: (context, state) {
                  if (state.users.isEmpty ?? false) {
                    // return Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    //   child: Shimmer.fromColors(
                    //     baseColor: Colors.grey.withOpacity(0.1),
                    //     highlightColor: Colors.grey.withOpacity(0.5),
                    //     child: CircleAvatar(
                    //       radius: MediaQuery.of(context).size.height *
                    //           0.03, // Responsive radius
                    //     ),
                    //   ),
                    // );
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
              const Sizer(
                width: 12,
              ),
              BlocConsumer<StoryCubit, StoryState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state.mutedStoriesResponse != null &&
                      state.mutedStoriesResponse!.data.stories.isNotEmpty) {
                    return _mutedStories(context);
                  }
                  return const SizedBox(
                    height: 0,
                    width: 0,
                  );
                },
              ),
              const Sizer(
                width: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createMyStory(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () async {
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraScreen(),
                  ),
                )
              : context.push(Routes.LOGIN);

          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width *
                        0.1, // Responsive radius
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CircleAvatar(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            backgroundImage: NetworkImage(
                              serviceLocator<UserCubit>().state.data != null &&
                                      context.isUserLoggedIn
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
                        Positioned(
                          bottom: -8,
                          right: -12,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: CircleAvatar(
                              backgroundColor: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                              radius: 18,
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: context.isDarkMode
                                    ? const Color(0xff0D0D0D)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            FittedBox(
              child: Text(
                context.isArabic ? "قصتي" : "My Story", // Localized text
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mutedStories(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () async {
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: serviceLocator<StoryCubit>(),
                      child: const MutedStories(),
                    ),
                  ),
                )
              : context.push(Routes.LOGIN);

          context.read<StoryCubit>()
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius:
                  MediaQuery.of(context).size.width * 0.08, // Responsive radius
              backgroundColor: Colors.black12,

              child: Icon(
                Icons.notifications_off_outlined,
                color: context.isDarkMode
                    ? AppColors.LIGHT_COLOR
                    : Colors.black.withOpacity(0.68),
              ),
              // child: Icon(icon)
            ),
            const SizedBox(
              height: 2,
            ),
            FittedBox(
              child: Text(
                LocaleKeys.muted.localize,
                style: Styles.headerText(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : Colors.black.withOpacity(0.68),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
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
              : context.push(Routes.LOGIN);

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

class ProfileWithStoriesBorder extends StatelessWidget {
  final String profilePictureUrl;
  final int storiesCount;

  const ProfileWithStoriesBorder({
    super.key,
    required this.profilePictureUrl,
    required this.storiesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: StoriesBorderPainter(storiesCount: storiesCount),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipOval(
            child: Image.network(
              profilePictureUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  UIConst.profilePlaceHolder,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class StoriesBorderPainter extends CustomPainter {
//   final int storiesCount;
//
//   StoriesBorderPainter({required this.storiesCount});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (storiesCount <= 0) return;
//
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8.0
//       ..color = Colors.red;
//
//     final double radius = size.width / 2;
//     final Offset center = Offset(size.width / 2, size.height / 2);
//
//     if (storiesCount == 1) {
//       // Draw a complete circle for a single story
//       canvas.drawCircle(center, radius, paint);
//     } else {
//       // Rotate the starting point by π/2 to align cuts at the top and bottom
//       final double angle = 2 * 3.141592653589793 / storiesCount;
//       const double rotationOffset = 3.141592653589793 / 2; // π/2 radians
//
//       for (int i = 0; i < storiesCount; i++) {
//         final double startAngle = (i * angle) - rotationOffset;
//         canvas.drawArc(
//           Rect.fromCircle(center: center, radius: radius),
//           startAngle,
//           angle - 0.1, // Add a small gap for better separation
//           false,
//           paint,
//         );
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

class StoriesBorderPainter extends CustomPainter {
  final int storiesCount;

  StoriesBorderPainter({required this.storiesCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (storiesCount <= 0) return;

    final double strokeWidth = 3.0;
    final double radius = (size.width / 2) + 4;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    const Gradient gradient = SweepGradient(
      colors: [
        Color(0xFFFF3308),
        Color(0xFF0B1035),
      ],
      stops: [0.0, 1.0],
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round;

    if (storiesCount == 1) {
      canvas.drawCircle(center, radius, paint);
    } else if (storiesCount == 2) {
      final double dashAngle = (pi * 0.9);
      final double gapAngle = (pi * 0.1);

      final double startAngle1 = -pi / 2 + (gapAngle / 2);
      final double startAngle2 = pi / 2 + (gapAngle / 2);

      canvas.drawArc(rect, startAngle1, dashAngle, false, paint);
      canvas.drawArc(rect, startAngle2, dashAngle, false, paint);
    } else {
      final double totalAngle = 2 * pi;
      final double segmentAngle = totalAngle / storiesCount;
      final double dashAngle = segmentAngle * 0.8;
      final double gapAngle = segmentAngle * 0.2;

      for (int i = 0; i < storiesCount; i++) {
        final double startAngle = (i * segmentAngle) - (pi / 2);
        canvas.drawArc(rect, startAngle, dashAngle, false, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
