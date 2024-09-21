// // // // import 'package:easy_localization/easy_localization.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/widgets.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// // // // import 'package:fourtyninehub/res/style/const.dart';
// // // // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // // // import 'package:story_view/controller/story_controller.dart';
// // // // import 'package:story_view/widgets/story_view.dart';
// // // //
// // // // import '../../data/models/friends_stories_model.dart';
// // // // import '../../data/repositories/StoriesRpo.dart';
// // // // import '../cubit/stories_cubit.dart';
// // // //
// // // // StoryItem createStoryItem(Story storyData, StoryController controller) {
// // // //   switch (storyData.type) {
// // // //     case 'text':
// // // //       return StoryItem.text(
// // // //         title: storyData.content!,
// // // //         backgroundColor: Colors.deepOrange,
// // // //       );
// // // //     case 'image':
// // // //       return StoryItem.pageImage(
// // // //         url: storyData.content!,
// // // //         caption: storyData.caption != null && storyData.caption != 'null'
// // // //             ? Text(
// // // //                 storyData.caption!,
// // // //                 style: const TextStyle(color: Colors.white),
// // // //                 textAlign: TextAlign.center,
// // // //               )
// // // //             : null,
// // // //         controller: controller,
// // // //       );
// // // //     case 'video':
// // // //       return StoryItem.pageVideo(
// // // //         storyData.content!,
// // // //         caption: storyData.caption != null && storyData.caption != 'null'
// // // //             ? Text(
// // // //                 storyData.caption!,
// // // //                 style: const TextStyle(color: Colors.white),
// // // //                 textAlign: TextAlign.center,
// // // //               )
// // // //             : null,
// // // //         controller: controller,
// // // //       );
// // // //     default:
// // // //       return StoryItem.text(
// // // //         title: "Unknown story type",
// // // //         backgroundColor: Colors.red,
// // // //       );
// // // //   }
// // // // }
// // // //
// // // // class MoreStories extends StatefulWidget {
// // // //   const MoreStories({super.key});
// // // //
// // // //   @override
// // // //   MoreStoriesState createState() => MoreStoriesState();
// // // // }
// // // //
// // // // class MoreStoriesState extends State<MoreStories> {
// // // //   late StoryCubit _storyCubit;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     // _storyCubit = StoryCubit(StoryRepository());
// // // //     _storyCubit = serviceLocator<StoryCubit>();
// // // //     _storyCubit.fetchStories();
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   void _navigateToNextUser(int currentIndex) {
// // // //     if (currentIndex < _storyCubit.state.stories.length - 1) {
// // // //       // Navigate to the next user's stories
// // // //       Navigator.of(context).pushReplacement(
// // // //         MaterialPageRoute(
// // // //           builder: (context) => BlocProvider.value(
// // // //             value: serviceLocator<StoryCubit>(),
// // // //             child: MoreStoriesUserView(
// // // //               userIndex: currentIndex + 1,
// // // //               storyCubit: _storyCubit,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       );
// // // //     } else {
// // // //       Navigator.pop(context); // Close the story view after the last story
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       extendBodyBehindAppBar: true,
// // // //       body: BlocBuilder<StoryCubit, StoryState>(
// // // //         bloc: _storyCubit,
// // // //         builder: (context, state) {
// // // //           if (state.isLoading && state.stories.isEmpty) {
// // // //             return const Center(child: CircularProgressIndicator());
// // // //           } else if (state.stories.isNotEmpty) {
// // // //             return PageView.builder(
// // // //               itemCount: state.stories.length,
// // // //               itemBuilder: (context, userIndex) {
// // // //                 final userStory = state.stories[userIndex];
// // // //                 final userController = StoryController();
// // // //
// // // //                 return Stack(
// // // //                   key: UniqueKey(),
// // // //                   children: [
// // // //                     StoryView(
// // // //                       storyItems: userStory.stories
// // // //                               ?.map((story) =>
// // // //                                   createStoryItem(story, userController))
// // // //                               .toList() ??
// // // //                           [],
// // // //                       onStoryShow: (storyItem, storyIndex) {
// // // //                         print(
// // // //                             'onStoryShow --------------------------------------------');
// // // //                         final createdAt =
// // // //                             userStory.stories![storyIndex].createdAt;
// // // //                         context
// // // //                             .read<StoryCubit>()
// // // //                             .updateCurrentStoryCreatedAt(createdAt!);
// // // //
// // // //                         if (userIndex == state.stories.length - 1 &&
// // // //                             storyIndex == userStory.stories!.length - 1 &&
// // // //                             !state.hasReachedMax) {
// // // //                           _storyCubit.fetchStories(loadMore: true);
// // // //                         }
// // // //                       },
// // // //                       onComplete: () {
// // // //                         print(
// // // //                             'onComplete --------------------------------------------');
// // // //
// // // //                         _navigateToNextUser(userIndex);
// // // //                       },
// // // //                       progressPosition: ProgressPosition.top,
// // // //                       repeat: false,
// // // //                       controller: userController,
// // // //                     ),
// // // //                     Positioned(
// // // //                       top: kToolbarHeight,
// // // //                       left: 0,
// // // //                       right: 0,
// // // //                       child: Padding(
// // // //                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
// // // //                         child: Row(
// // // //                           crossAxisAlignment: CrossAxisAlignment.center,
// // // //                           children: [
// // // //                             IconButton(
// // // //                               onPressed: () {
// // // //                                 if (Navigator.canPop(context)) {
// // // //                                   Navigator.pop(context);
// // // //                                 }
// // // //                               },
// // // //                               icon: const Icon(
// // // //                                 Icons.arrow_back_ios,
// // // //                                 color: Colors.white,
// // // //                                 shadows: <Shadow>[
// // // //                                   Shadow(
// // // //                                     color: Colors.black,
// // // //                                     offset: Offset(2, 2),
// // // //                                     blurRadius: 9,
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                             CircleAvatar(
// // // //                               minRadius: 25,
// // // //                               onBackgroundImageError: (exception, stackTrace) =>
// // // //                                   const NetworkImage(
// // // //                                 UIConst.profilePlaceHolder,
// // // //                               ),
// // // //                               backgroundImage: NetworkImage(
// // // //                                 userStory.user?.profilePictureUrl ?? '',
// // // //                               ),
// // // //                             ),
// // // //                             const SizedBox(
// // // //                               width: 8,
// // // //                             ),
// // // //                             Column(
// // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 Text(
// // // //                                   capitalizeAndSplit2Only(
// // // //                                       '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
// // // //                                   style: const TextStyle(
// // // //                                     fontSize: 18,
// // // //                                     color: Colors.white,
// // // //                                   ),
// // // //                                 ),
// // // //                                 const SizedBox(
// // // //                                   height: 4,
// // // //                                 ),
// // // //                                 BlocConsumer<StoryCubit, StoryState>(
// // // //                                   listener: (context, state) {
// // // //                                     // TODO: implement listener
// // // //                                   },
// // // //                                   builder: (context, state) {
// // // //                                     if (state.currentStoryCreatedAt != null) {
// // // //                                       return Text(
// // // //                                         'Last Seen: ${DateFormat('hh:mm a').format(state.currentStoryCreatedAt!)}',
// // // //                                         style: const TextStyle(
// // // //                                           fontSize: 12,
// // // //                                           color: Colors.white70,
// // // //                                         ),
// // // //                                       );
// // // //                                     }
// // // //                                     return const Sizer();
// // // //                                   },
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                             const Spacer(),
// // // //                             IconButton(
// // // //                               onPressed: () {},
// // // //                               icon: const Icon(
// // // //                                 Icons.more_vert,
// // // //                                 color: Colors.white,
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 );
// // // //               },
// // // //             );
// // // //           } else if (state is StoryError) {
// // // //             return Center(
// // // //               child: Text("Failed to load stories: ${state.error}"),
// // // //             );
// // // //           }
// // // //           return Container();
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // // // @override
// // // // // Widget build(BuildContext context) {
// // // // //   return Scaffold(
// // // // //     extendBodyBehindAppBar: true,
// // // // //     body: BlocBuilder<StoryCubit, StoryState>(
// // // // //       bloc: _storyCubit,
// // // // //       builder: (context, state) {
// // // // //         if (state.isLoading && state.stories.isEmpty) {
// // // // //           return const Center(child: CircularProgressIndicator());
// // // // //         } else if (state.stories.isNotEmpty) {
// // // // //           return PageView.builder(
// // // // //             itemCount: state.stories.length,
// // // // //             itemBuilder: (context, userIndex) {
// // // // //               final userStory = state.stories[userIndex];
// // // // //               final userController = StoryController();
// // // // //
// // // // //               return Container(
// // // // //                 color: Colors.black,
// // // // //                 height: double.infinity,
// // // // //                 child: Column(
// // // // //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // //                   children: [
// // // // //                     Padding(
// // // // //                       padding: const EdgeInsets.only(top: 25,bottom: 4),
// // // // //                       child: Row(
// // // // //                         crossAxisAlignment: CrossAxisAlignment.center,
// // // // //                         children: [
// // // // //                           IconButton(
// // // // //                             onPressed: () {
// // // // //                               if (Navigator.canPop(context)) {
// // // // //                                 Navigator.pop(context);
// // // // //                               }
// // // // //                             },
// // // // //                             icon: const Icon(
// // // // //                               Icons.arrow_back_ios,
// // // // //                               color: Colors.white,
// // // // //                               shadows: <Shadow>[
// // // // //                                 Shadow(
// // // // //                                   color: Colors.black,
// // // // //                                   offset: Offset(2, 2),
// // // // //                                   blurRadius: 9,
// // // // //                                 ),
// // // // //                               ],
// // // // //                             ),
// // // // //                           ),
// // // // //                           CircleAvatar(
// // // // //                             minRadius: 25,
// // // // //                             onBackgroundImageError:
// // // // //                                 (exception, stackTrace) =>
// // // // //                                     const NetworkImage(
// // // // //                               UIConst.profilePlaceHolder,
// // // // //                             ),
// // // // //                             backgroundImage: NetworkImage(
// // // // //                               userStory.user?.profilePictureUrl ?? '',
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(
// // // // //                             width: 8,
// // // // //                           ),
// // // // //                           Column(
// // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                             children: [
// // // // //                               Text(
// // // // //                                 capitalizeAndSplit2Only('${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
// // // // //                                 style: const TextStyle(
// // // // //                                   fontSize: 18,
// // // // //                                   color: Colors.white,
// // // // //                                 ),
// // // // //                               ),
// // // // //                               const SizedBox(height: 4,),
// // // // //                               const Text(
// // // // //                                 'Last Seen: 8 minute ago',
// // // // //                                 style: TextStyle(
// // // // //                                   fontSize: 12,
// // // // //                                   color: Colors.white70,
// // // // //                                 ),
// // // // //                               )
// // // // //                             ],
// // // // //                           ),
// // // // //                           const Spacer(),
// // // // //                           IconButton(onPressed: () {
// // // // //
// // // // //                           }, icon: const Icon(Icons.more_vert,color: Colors.white,))
// // // // //
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                     Expanded(
// // // // //                       child: StoryView(
// // // // //                         storyItems: userStory.stories
// // // // //                                 ?.map((story) =>
// // // // //                                     createStoryItem(story, userController))
// // // // //                                 .toList() ??
// // // // //                             [],
// // // // //                         onStoryShow: (storyItem, storyIndex) {
// // // // //                           print(
// // // // //                               'onStoryShow --------------------------------------------');
// // // // //
// // // // //                           // if (userIndex == state.stories.length -1 &&
// // // // //                           //     storyIndex == userStory.stories!.length-1 &&
// // // // //                           //     !state.hasReachedMax) {
// // // // //                           //   _storyCubit.fetchStories(loadMore: true);
// // // // //                           // }
// // // // //                         },
// // // // //                         onComplete: () {
// // // // //                           print(
// // // // //                               'onComplete --------------------------------------------');
// // // // //
// // // // //                           // _navigateToNextUser(userIndex);
// // // // //                         },
// // // // //                         progressPosition: ProgressPosition.top,
// // // // //                         repeat: false,
// // // // //                         controller: userController,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               );
// // // // //             },
// // // // //           );
// // // // //         } else if (state is StoryError) {
// // // // //           return Center(
// // // // //             child: Text("Failed to load stories: ${state.error}"),
// // // // //           );
// // // // //         }
// // // // //         return Container();
// // // // //       },
// // // // //     ),
// // // // //   );
// // // // // }
// // // // }
// // // //
// // // // class MoreStoriesUserView extends StatefulWidget {
// // // //   final int userIndex;
// // // //   final StoryCubit storyCubit;
// // // //
// // // //   const MoreStoriesUserView(
// // // //       {super.key, required this.userIndex, required this.storyCubit});
// // // //
// // // //   @override
// // // //   State<MoreStoriesUserView> createState() => _MoreStoriesUserViewState();
// // // // }
// // // //
// // // // class _MoreStoriesUserViewState extends State<MoreStoriesUserView> {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final userStory = widget.storyCubit.state.stories[widget.userIndex];
// // // //     final userController = StoryController();
// // // //
// // // //     return Scaffold(
// // // //       extendBodyBehindAppBar: true,
// // // //       body: Container(
// // // //         color: Colors.black,
// // // //         height: double.infinity,
// // // //         child: Stack(
// // // //           children: [
// // // //             StoryView(
// // // //               storyItems: userStory.stories
// // // //                       ?.map((story) => createStoryItem(story, userController))
// // // //                       .toList() ??
// // // //                   [],
// // // //               onStoryShow: (storyItem, index) {
// // // //                 final createdAt = userStory.stories![index].createdAt;
// // // //                 context
// // // //                     .read<StoryCubit>()
// // // //                     .updateCurrentStoryCreatedAt(createdAt!);
// // // //               },
// // // //               onComplete: () {
// // // //                 if (widget.userIndex <
// // // //                     widget.storyCubit.state.stories.length - 1) {
// // // //                   Navigator.of(context).pushReplacement(
// // // //                     MaterialPageRoute(
// // // //                       builder: (context) => BlocProvider.value(
// // // //                         value: serviceLocator<StoryCubit>(),
// // // //                         child: MoreStoriesUserView(
// // // //                           userIndex: widget.userIndex + 1,
// // // //                           storyCubit: widget.storyCubit,
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   );
// // // //                 } else {
// // // //                   Navigator.pop(context); // Close after the last story
// // // //                 }
// // // //               },
// // // //               progressPosition: ProgressPosition.top,
// // // //               repeat: false,
// // // //               controller: userController,
// // // //             ),
// // // //             Positioned(
// // // //               top: kToolbarHeight,
// // // //               left: 0,
// // // //               right: 0,
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
// // // //                 child: Row(
// // // //                   crossAxisAlignment: CrossAxisAlignment.center,
// // // //                   children: [
// // // //                     IconButton(
// // // //                       onPressed: () {
// // // //                         if (Navigator.canPop(context)) {
// // // //                           Navigator.pop(context);
// // // //                         }
// // // //                       },
// // // //                       icon: const Icon(
// // // //                         Icons.arrow_back_ios,
// // // //                         color: Colors.white,
// // // //                         shadows: <Shadow>[
// // // //                           Shadow(
// // // //                             color: Colors.black,
// // // //                             offset: Offset(2, 2),
// // // //                             blurRadius: 9,
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                     CircleAvatar(
// // // //                       minRadius: 25,
// // // //                       onBackgroundImageError: (exception, stackTrace) =>
// // // //                           const NetworkImage(
// // // //                         UIConst.profilePlaceHolder,
// // // //                       ),
// // // //                       backgroundImage: NetworkImage(
// // // //                         userStory.user?.profilePictureUrl ?? '',
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(
// // // //                       width: 8,
// // // //                     ),
// // // //                     Column(
// // // //                       mainAxisAlignment: MainAxisAlignment.center,
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text(
// // // //                           capitalizeAndSplit2Only(
// // // //                               '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
// // // //                           style: const TextStyle(
// // // //                             fontSize: 18,
// // // //                             color: Colors.white,
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(
// // // //                           height: 4,
// // // //                         ),
// // // //                         BlocConsumer<StoryCubit, StoryState>(
// // // //                           listener: (context, state) {
// // // //                             // TODO: implement listener
// // // //                           },
// // // //                           builder: (context, state) {
// // // //                             if (state.currentStoryCreatedAt != null) {
// // // //                               return Text(
// // // //                                 'Last Seen: ${DateFormat('hh:mm a').format(state.currentStoryCreatedAt!)}',
// // // //                                 style: const TextStyle(
// // // //                                   fontSize: 12,
// // // //                                   color: Colors.white70,
// // // //                                 ),
// // // //                               );
// // // //                             }
// // // //                             return const Sizer();
// // // //                           },
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                     const Spacer(),
// // // //                     IconButton(
// // // //                       onPressed: () {},
// // // //                       icon: const Icon(
// // // //                         Icons.more_vert,
// // // //                         color: Colors.white,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'package:easy_localization/easy_localization.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // // import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
// // // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // // import 'package:story_view/controller/story_controller.dart';
// // // import 'package:story_view/story_view.dart';
// // // import 'package:story_view/widgets/story_view.dart';
// // //
// // // import '../../../../../res/style/const.dart';
// // // import '../../../tinder/presentation/pages/user_profile.dart';
// // // import '../cubit/stories_cubit.dart';
// // //
// // // class StoryViewScreen extends StatefulWidget {
// // //   final int initialUserIndex;
// // //
// // //   const StoryViewScreen({
// // //     super.key,
// // //     this.initialUserIndex = 0,
// // //   });
// // //
// // //   @override
// // //   _StoryViewScreenState createState() => _StoryViewScreenState();
// // // }
// // //
// // // class _StoryViewScreenState extends State<StoryViewScreen> {
// // //   late PageController _pageController;
// // //   late int _currentUserIndex;
// // //   late List<UserStories> stories;
// // //
// // //   late StoryCubit _storyCubit;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _storyCubit = serviceLocator<StoryCubit>();
// // //     _initializeStories();
// // //     _currentUserIndex = widget.initialUserIndex;
// // //     _pageController = PageController(initialPage: _currentUserIndex);
// // //   }
// // //
// // //   Future<void> _initializeStories() async {
// // //     try {
// // //       await _storyCubit.fetchStories();
// // //       setState(() {
// // //         stories = _storyCubit.state.stories;
// // //       });
// // //       print('Fetched ${stories.length} stories');
// // //     } catch (e) {
// // //       print('Error fetching stories: $e');
// // //       // Handle error (e.g., show error message to user)
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _pageController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   void _navigateToNextUser() {
// // //     if (_currentUserIndex < stories.length - 1) {
// // //       _pageController.nextPage(
// // //         duration: const Duration(milliseconds: 300),
// // //         curve: Curves.easeInOut,
// // //       );
// // //     } else {
// // //       Navigator.of(context).pop();
// // //     }
// // //   }
// // //
// // //   void _navigateToPreviousUser() {
// // //     if (_currentUserIndex > 0) {
// // //       _pageController.previousPage(
// // //         duration: const Duration(milliseconds: 300),
// // //         curve: Curves.easeInOut,
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       extendBodyBehindAppBar: true,
// // //       body: stories.isNotEmpty
// // //           ? PageView.builder(
// // //               controller: _pageController,
// // //               itemCount: stories.length,
// // //               onPageChanged: (index) {
// // //                 setState(() {
// // //                   _currentUserIndex = index;
// // //                 });
// // //               },
// // //               itemBuilder: (context, index) {
// // //                 return UserStoryView(
// // //                   userStory: stories[index],
// // //                   onComplete: _navigateToNextUser,
// // //                   onPrevious: _navigateToPreviousUser,
// // //                 );
// // //               },
// // //             )
// // //           : const Sizer(),
// // //     );
// // //   }
// // // }
// // //
// // // class UserStoryView extends StatefulWidget {
// // //   final UserStories userStory;
// // //   final VoidCallback onComplete;
// // //   final VoidCallback onPrevious;
// // //
// // //   const UserStoryView({
// // //     super.key,
// // //     required this.userStory,
// // //     required this.onComplete,
// // //     required this.onPrevious,
// // //   });
// // //
// // //   @override
// // //   _UserStoryViewState createState() => _UserStoryViewState();
// // // }
// // //
// // // class _UserStoryViewState extends State<UserStoryView> {
// // //   late StoryController _storyController;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _storyController = StoryController();
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _storyController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Stack(
// // //       children: [
// // //         StoryView(
// // //           storyItems: widget.userStory.stories
// // //                   ?.map((story) => createStoryItem(story, _storyController))
// // //                   .toList() ??
// // //               [],
// // //           controller: _storyController,
// // //           onComplete: widget.onComplete,
// // //           onVerticalSwipeComplete: (direction) {
// // //             if (direction == Direction.down) {
// // //               Navigator.of(context).pop();
// // //             }
// // //           },
// // //           progressPosition: ProgressPosition.top,
// // //         ),
// // //         _buildUserInfoBar(),
// // //         _buildNavigationOverlay(),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildUserInfoBar() {
// // //     return Positioned(
// // //       top: kToolbarHeight,
// // //       left: 0,
// // //       right: 0,
// // //       child: BlocProvider(
// // //         create: (context) => context.read<StoryCubit>(),
// // //         child: UserInfoBar(userStory: widget.userStory),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildNavigationOverlay() {
// // //     return GestureDetector(
// // //       onTapDown: (details) {
// // //         final screenWidth = MediaQuery.of(context).size.width;
// // //         if (details.globalPosition.dx < screenWidth / 2) {
// // //           _storyController.previous();
// // //         } else {
// // //           _storyController.next();
// // //         }
// // //       },
// // //       child: Container(
// // //         color: Colors.transparent,
// // //         child: Row(
// // //           children: [
// // //             Expanded(
// // //               child: GestureDetector(
// // //                 onTap: widget.onPrevious,
// // //                 child: Container(color: Colors.transparent),
// // //               ),
// // //             ),
// // //             Expanded(
// // //               child: GestureDetector(
// // //                 onTap: widget.onComplete,
// // //                 child: Container(color: Colors.transparent),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class UserInfoBar extends StatelessWidget {
// // //   final UserStories userStory;
// // //
// // //   const UserInfoBar({super.key, required this.userStory});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           _buildBackButton(context),
// // //           _buildUserAvatar(),
// // //           const SizedBox(width: 8),
// // //           _buildUserInfo(context),
// // //           const Spacer(),
// // //           _buildMoreOptionsButton(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildBackButton(BuildContext context) {
// // //     return IconButton(
// // //       onPressed: () => Navigator.of(context).pop(),
// // //       icon: const Icon(
// // //         Icons.arrow_back_ios,
// // //         color: Colors.white,
// // //         shadows: [
// // //           Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 9)
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildUserAvatar() {
// // //     return CircleAvatar(
// // //       minRadius: 25,
// // //       backgroundImage: NetworkImage(userStory.user?.profilePictureUrl ?? ''),
// // //       onBackgroundImageError: (_, __) =>
// // //           const NetworkImage(UIConst.profilePlaceHolder),
// // //     );
// // //   }
// // //
// // //   Widget _buildUserInfo(BuildContext context) {
// // //     return Column(
// // //       mainAxisAlignment: MainAxisAlignment.center,
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Text(
// // //           capitalizeAndSplit2Only(
// // //               '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
// // //           style: const TextStyle(fontSize: 18, color: Colors.white),
// // //         ),
// // //         const SizedBox(height: 4),
// // //         // BlocBuilder<StoryCubit, StoryState>(
// // //         //   builder: (context, state) {
// // //         //     if (state.currentStoryCreatedAt != null) {
// // //         //       return Text(
// // //         //         'Last Seen: ${DateFormat('hh:mm a').format(
// // //         //             state.currentStoryCreatedAt!)}',
// // //         //         style: const TextStyle(fontSize: 12, color: Colors.white70),
// // //         //       );
// // //         //     }
// // //         //     return const SizedBox.shrink();
// // //         //   },
// // //         // ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildMoreOptionsButton() {
// // //     return IconButton(
// // //       onPressed: () {
// // //         // Implement more options functionality
// // //       },
// // //       icon: const Icon(Icons.more_vert, color: Colors.white),
// // //     );
// // //   }
// // // }
// // //
// // // StoryItem createStoryItem(Story storyData, StoryController controller) {
// // //   switch (storyData.type) {
// // //     case 'text':
// // //       return StoryItem.text(
// // //         title: storyData.content!,
// // //         backgroundColor: Colors.deepOrange,
// // //       );
// // //     case 'image':
// // //       return StoryItem.pageImage(
// // //         url: storyData.content!,
// // //         caption: storyData.caption != null && storyData.caption != 'null'
// // //             ? Text(
// // //                 storyData.caption!,
// // //                 style: const TextStyle(color: Colors.white),
// // //                 textAlign: TextAlign.center,
// // //               )
// // //             : null,
// // //         controller: controller,
// // //       );
// // //     case 'video':
// // //       return StoryItem.pageVideo(
// // //         storyData.content!,
// // //         caption: storyData.caption != null && storyData.caption != 'null'
// // //             ? Text(
// // //                 storyData.caption!,
// // //                 style: const TextStyle(color: Colors.white),
// // //                 textAlign: TextAlign.center,
// // //               )
// // //             : null,
// // //         controller: controller,
// // //       );
// // //     default:
// // //       return StoryItem.text(
// // //         title: "Unknown story type",
// // //         backgroundColor: Colors.red,
// // //       );
// // //   }
// // // }
// //
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import 'package:story_view/controller/story_controller.dart';
// // import 'package:story_view/story_view.dart';
// // import 'package:story_view/widgets/story_view.dart';
// //
// // import '../../../../../res/style/const.dart';
// // import '../../../tinder/presentation/pages/user_profile.dart';
// // import '../cubit/stories_cubit.dart';
// //
// // class StoryViewScreen extends StatefulWidget {
// //   final int initialUserIndex;
// //
// //   const StoryViewScreen({super.key, this.initialUserIndex = 0});
// //
// //   @override
// //   _StoryViewScreenState createState() => _StoryViewScreenState();
// // }
// //
// // class _StoryViewScreenState extends State<StoryViewScreen> {
// //   late final PageController _pageController;
// //   late final StoryCubit _storyCubit;
// //   late List<UserStories> stories = [];
// //   int _currentUserIndex = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _storyCubit = serviceLocator<StoryCubit>();
// //     _initializeStories();
// //     _currentUserIndex = widget.initialUserIndex;
// //     _pageController = PageController(initialPage: _currentUserIndex);
// //   }
// //
// //   Future<void> _initializeStories() async {
// //     try {
// //       await _storyCubit.fetchStories();
// //       setState(() {
// //         stories = _storyCubit.state.stories;
// //       });
// //       debugPrint('Fetched ${stories.length} stories');
// //     } catch (error) {
// //       debugPrint('Error fetching stories: $error');
// //       _showErrorSnackBar();
// //     }
// //   }
// //
// //   void _showErrorSnackBar() {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(tr('error_fetching_stories'))),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _navigateToNextUser() {
// //     if (_currentUserIndex < stories.length - 1) {
// //       _pageController.nextPage(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //       );
// //     } else {
// //       Navigator.of(context).pop();
// //     }
// //   }
// //
// //   void _navigateToPreviousUser() {
// //     if (_currentUserIndex > 0) {
// //       _pageController.previousPage(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //       body: stories.isNotEmpty
// //           ? PageView.builder(
// //               controller: _pageController,
// //               itemCount: stories.length,
// //               onPageChanged: (index) {
// //                 setState(() {
// //                   _currentUserIndex = index;
// //                 });
// //               },
// //               itemBuilder: (context, index) {
// //                 return UserStoryView(
// //                   userStory: stories[index],
// //                   onComplete: _navigateToNextUser,
// //                   onPrevious: _navigateToPreviousUser,
// //                 );
// //               },
// //             )
// //           : const Sizer(),
// //     );
// //   }
// // }
// //
// // class UserStoryView extends StatefulWidget {
// //   final UserStories userStory;
// //   final VoidCallback onComplete;
// //   final VoidCallback onPrevious;
// //
// //   const UserStoryView({
// //     super.key,
// //     required this.userStory,
// //     required this.onComplete,
// //     required this.onPrevious,
// //   });
// //
// //   @override
// //   _UserStoryViewState createState() => _UserStoryViewState();
// // }
// //
// // class _UserStoryViewState extends State<UserStoryView> {
// //   late final StoryController _storyController;
// //   late DateTime _currentStoryCreatedAt;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _storyController = StoryController();
// //     _currentStoryCreatedAt = widget.userStory.stories!.first.createdAt!;
// //   }
// //
// //   @override
// //   void dispose() {
// //     _storyController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         StoryView(
// //           storyItems: widget.userStory.stories
// //                   ?.map((story) => createStoryItem(story, _storyController))
// //                   .toList() ??
// //               [],
// //           onStoryShow: (storyItem, index) {
// //             print('onStoryShow --------------------------------------------');
// //             // final createdAt = widget.userStory.stories![index].createdAt;
// //             //
// //             // serviceLocator<StoryCubit>()
// //             //     .updateCurrentStoryCreatedAt(createdAt!);
// //             // setState(() {
// //             _currentStoryCreatedAt =
// //                 widget.userStory.stories![index].createdAt!;
// //             // });
// //           },
// //           controller: _storyController,
// //           onComplete: widget.onComplete,
// //           onVerticalSwipeComplete: (direction) {
// //             if (direction == Direction.down) {
// //               Navigator.of(context).pop();
// //             }
// //           },
// //           progressPosition: ProgressPosition.top,
// //         ),
// //         _buildUserInfoBar(),
// //         _buildNavigationOverlay(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildUserInfoBar() {
// //     return Positioned(
// //       top: kToolbarHeight,
// //       left: 0,
// //       right: 0,
// //       child: BlocProvider(
// //         create: (context) => context.read<StoryCubit>(),
// //         child: UserInfoBar(
// //           userStory: widget.userStory,
// //           createdAt: _currentStoryCreatedAt,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildNavigationOverlay() {
// //     return GestureDetector(
// //       onTapDown: (details) {
// //         final screenWidth = MediaQuery.of(context).size.width;
// //         if (details.globalPosition.dx < screenWidth / 2) {
// //           _storyController.previous();
// //         } else {
// //           _storyController.next();
// //         }
// //       },
// //       onHorizontalDragEnd: (details) {
// //         if (details.primaryVelocity != null) {
// //           if (details.primaryVelocity! < 0) {
// //             widget.onComplete(); // Swipe left to go to the next user
// //           } else if (details.primaryVelocity! > 0) {
// //             widget.onPrevious(); // Swipe right to go to the previous user
// //           }
// //         }
// //       },
// //       child: Container(
// //         color: Colors.transparent,
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: GestureDetector(
// //                 onTap: _storyController.previous,
// //                 child: Container(color: Colors.transparent),
// //               ),
// //             ),
// //             Expanded(
// //               child: GestureDetector(
// //                 onTap: _storyController.next,
// //                 child: Container(color: Colors.transparent),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class UserInfoBar extends StatelessWidget {
// //   final UserStories userStory;
// //
// //   final DateTime createdAt;
// //
// //   const UserInfoBar(
// //       {super.key, required this.userStory, required this.createdAt});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     print(
// //         "$createdAt-----------------------------------------------------------");
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           _buildBackButton(context),
// //           _buildUserAvatar(),
// //           const SizedBox(width: 8),
// //           _buildUserInfo(),
// //           const Spacer(),
// //           _buildMoreOptionsButton(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBackButton(BuildContext context) {
// //     return IconButton(
// //       onPressed: () => Navigator.of(context).pop(),
// //       icon: const Icon(
// //         Icons.arrow_back_ios,
// //         color: Colors.white,
// //         shadows: [
// //           Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 9),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserAvatar() {
// //     return CircleAvatar(
// //       minRadius: 25,
// //       backgroundImage: NetworkImage(userStory.user?.profilePictureUrl ?? ''),
// //       onBackgroundImageError: (_, __) =>
// //           const NetworkImage(UIConst.profilePlaceHolder),
// //     );
// //   }
// //
// //   Widget _buildUserInfo() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           capitalizeAndSplit2Only(
// //               '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
// //           style: const TextStyle(fontSize: 18, color: Colors.white),
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           serviceLocator<StoryCubit>().state.currentStoryCreatedAt.toString(),
// //           style: const TextStyle(fontSize: 18, color: Colors.white),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildMoreOptionsButton() {
// //     return IconButton(
// //       onPressed: () {
// //         // Implement more options functionality
// //       },
// //       icon: const Icon(Icons.more_vert, color: Colors.white),
// //     );
// //   }
// // }
// //
// // StoryItem createStoryItem(Story storyData, StoryController controller) {
// //   switch (storyData.type) {
// //     case 'text':
// //       return StoryItem.text(
// //         title: storyData.content!,
// //         backgroundColor: Colors.deepOrange,
// //       );
// //     case 'image':
// //       return StoryItem.pageImage(
// //         url: storyData.content!,
// //         caption: storyData.caption != null && storyData.caption != 'null'
// //             ? Text(
// //                 storyData.caption!,
// //                 style: const TextStyle(color: Colors.white),
// //                 textAlign: TextAlign.center,
// //               )
// //             : null,
// //         controller: controller,
// //       );
// //     case 'video':
// //       return StoryItem.pageVideo(
// //         storyData.content!,
// //         caption: storyData.caption != null && storyData.caption != 'null'
// //             ? Text(
// //                 storyData.caption!,
// //                 style: const TextStyle(color: Colors.white),
// //                 textAlign: TextAlign.center,
// //               )
// //             : null,
// //         controller: controller,
// //       );
// //     default:
// //       return StoryItem.text(
// //         title: "Unknown story type",
// //         backgroundColor: Colors.red,
// //       );
// //   }
// // }
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:story_view/controller/story_controller.dart';
// import 'package:story_view/story_view.dart';
// import 'package:story_view/widgets/story_view.dart';
//
// import '../../../../../res/style/const.dart';
// import '../../../tinder/presentation/pages/user_profile.dart';
// import '../cubit/stories_cubit.dart';
//
// class StoryViewScreen extends StatefulWidget {
//   final int initialUserIndex;
//
//   const StoryViewScreen({super.key, this.initialUserIndex = 0});
//
//   @override
//   _StoryViewScreenState createState() => _StoryViewScreenState();
// }
//
// class _StoryViewScreenState extends State<StoryViewScreen> {
//   late final PageController _pageController;
//   late final StoryCubit _storyCubit;
//   late List<UserStories> stories = [];
//   int _currentUserIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _storyCubit = serviceLocator<StoryCubit>();
//     _initializeStories();
//     _currentUserIndex = widget.initialUserIndex;
//     _pageController = PageController(initialPage: _currentUserIndex);
//   }
//
//   Future<void> _initializeStories() async {
//     try {
//       await _storyCubit.fetchStories();
//       setState(() {
//         stories = _storyCubit.state.stories;
//       });
//       debugPrint('Fetched ${stories.length} stories');
//     } catch (error) {
//       debugPrint('Error fetching stories: $error');
//       _showErrorSnackBar();
//     }
//   }
//
//   void _showErrorSnackBar() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(tr('error_fetching_stories'))),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _navigateToNextUser() {
//     if (_currentUserIndex < stories.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       Navigator.of(context).pop();
//     }
//   }
//
//   void _navigateToPreviousUser() {
//     if (_currentUserIndex > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: stories.isNotEmpty
//           ? PageView.builder(
//               controller: _pageController,
//               itemCount: stories.length,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentUserIndex = index;
//                 });
//               },
//               itemBuilder: (context, index) {
//                 return UserStoryView(
//                   userStory: stories[index],
//                   onComplete: _navigateToNextUser,
//                   onPrevious: _navigateToPreviousUser,
//                 );
//               },
//             )
//           : const Sizer(),
//     );
//   }
// }
//
// class UserStoryView extends StatefulWidget {
//   final UserStories userStory;
//   final VoidCallback onComplete;
//   final VoidCallback onPrevious;
//
//   const UserStoryView({
//     super.key,
//     required this.userStory,
//     required this.onComplete,
//     required this.onPrevious,
//   });
//
//   @override
//   _UserStoryViewState createState() => _UserStoryViewState();
// }
//
// class _UserStoryViewState extends State<UserStoryView> {
//   late final StoryController _storyController;
//   late final ValueNotifier<DateTime> _currentStoryCreatedAtNotifier;
//
//   @override
//   void initState() {
//     super.initState();
//     _storyController = StoryController();
//     _currentStoryCreatedAtNotifier =
//         ValueNotifier<DateTime>(widget.userStory.stories!.first.createdAt!);
//   }
//
//   @override
//   void dispose() {
//     _storyController.dispose();
//     _currentStoryCreatedAtNotifier.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         StoryView(
//           storyItems: widget.userStory.stories
//                   ?.map((story) => createStoryItem(story, _storyController))
//                   .toList() ??
//               [],
//           onStoryShow: (storyItem, index) {
//             _currentStoryCreatedAtNotifier.value =
//                 widget.userStory.stories![index].createdAt!;
//           },
//           controller: _storyController,
//           onComplete: widget.onComplete,
//           onVerticalSwipeComplete: (direction) {
//             if (direction == Direction.down) {
//               Navigator.of(context).pop();
//             }
//           },
//           progressPosition: ProgressPosition.top,
//         ),
//         _buildUserInfoBar(),
//         _buildNavigationOverlay(),
//       ],
//     );
//   }
//
//   Widget _buildUserInfoBar() {
//     return Positioned(
//       top: kToolbarHeight,
//       left: 0,
//       right: 0,
//       child: BlocProvider(
//         create: (context) => context.read<StoryCubit>(),
//         child: ValueListenableBuilder<DateTime>(
//           valueListenable: _currentStoryCreatedAtNotifier,
//           builder: (context, createdAt, child) {
//             return UserInfoBar(
//               userStory: widget.userStory,
//               createdAt: createdAt,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavigationOverlay() {
//     return GestureDetector(
//       onTapDown: (details) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         if (details.globalPosition.dx < screenWidth / 2) {
//           _storyController.previous();
//         } else {
//           _storyController.next();
//         }
//       },
//       onHorizontalDragEnd: (details) {
//         if (details.primaryVelocity != null) {
//           if (details.primaryVelocity! < 0) {
//             widget.onComplete(); // Swipe left to go to the next user
//           } else if (details.primaryVelocity! > 0) {
//             widget.onPrevious(); // Swipe right to go to the previous user
//           }
//         }
//       },
//       child: Container(
//         color: Colors.transparent,
//         child: Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: _storyController.previous,
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: _storyController.next,
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class UserInfoBar extends StatelessWidget {
//   final UserStories userStory;
//   final DateTime createdAt;
//
//   const UserInfoBar({
//     super.key,
//     required this.userStory,
//     required this.createdAt,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _buildBackButton(context),
//           _buildUserAvatar(),
//           const SizedBox(width: 8),
//           _buildUserInfo(),
//           const Spacer(),
//           _buildMoreOptionsButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackButton(BuildContext context) {
//     return IconButton(
//       onPressed: () => Navigator.of(context).pop(),
//       icon: const Icon(
//         Icons.arrow_back_ios,
//         color: Colors.white,
//         shadows: [
//           Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 9),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserAvatar() {
//     return CircleAvatar(
//       minRadius: 25,
//       backgroundImage: NetworkImage(userStory.user?.profilePictureUrl ?? ''),
//       onBackgroundImageError: (_, __) =>
//           const NetworkImage(UIConst.profilePlaceHolder),
//     );
//   }
//
//   Widget _buildUserInfo() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           capitalizeAndSplit2Only(
//               '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
//           style: const TextStyle(fontSize: 18, color: Colors.white),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           DateFormat('hh:mm a').format(createdAt),
//           style: const TextStyle(fontSize: 12, color: Colors.white70),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMoreOptionsButton() {
//     return IconButton(
//       onPressed: () {
//         // Implement more options functionality
//       },
//       icon: const Icon(Icons.more_vert, color: Colors.white),
//     );
//   }
// }
//
// StoryItem createStoryItem(Story storyData, StoryController controller) {
//   switch (storyData.type) {
//     case 'text':
//       return StoryItem.text(
//         title: storyData.content!,
//         backgroundColor: Colors.deepOrange,
//       );
//     case 'image':
//       return StoryItem.pageImage(
//         url: storyData.content!,
//         caption: storyData.caption != null && storyData.caption != 'null'
//             ? Text(
//                 storyData.caption!,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               )
//             : null,
//         controller: controller,
//       );
//     case 'video':
//       return StoryItem.pageVideo(
//         storyData.content!,
//         caption: storyData.caption != null && storyData.caption != 'null'
//             ? Text(
//                 storyData.caption!,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               )
//             : null,
//         controller: controller,
//       );
//     default:
//       return StoryItem.text(
//         title: "Unknown story type",
//         backgroundColor: Colors.red,
//       );
//   }
// }

// import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
// import 'package:story_view/story_view.dart';

import '../../../../../res/style/const.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import '../cubit/stories_cubit.dart';

class StoryViewScreen extends StatefulWidget {
  final int initialUserIndex;
  final List<UserStories> stories;

  const StoryViewScreen(
      {super.key, this.initialUserIndex = 0, required this.stories});

  @override
  StoryViewScreenState createState() => StoryViewScreenState();
}

class StoryViewScreenState extends State<StoryViewScreen> {
  late final PageController _pageController;
  // late final StoryCubit _storyCubit;
  // late List<UserStories> stories = [];
  int _currentUserIndex = 0;

  @override
  void initState() {
    super.initState();
    // _storyCubit = serviceLocator<StoryCubit>();
    _pageController = PageController(initialPage: widget.initialUserIndex);
    _currentUserIndex = widget.initialUserIndex;
    _initializeStories();
  }

  Future<void> _initializeStories() async {
    // try {
    //   // await _storyCubit.fetchStories();
    //   setState(() {
    //     // stories = _storyCubit.state.stories;
    //   });
    //   debugPrint('Fetched ${stories.length} stories');
    // } catch (error) {
    //   debugPrint('Error fetching stories: $error');
    //   _showErrorSnackBar();
    // }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('error_fetching_stories'))),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextUser() {
    if (_currentUserIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _navigateToPreviousUser() {
    if (_currentUserIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: widget.stories.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentUserIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return UserStoryView(
                  userStory: widget.stories[index],
                  onComplete: _navigateToNextUser,
                  onPrevious: _navigateToPreviousUser,
                );
              },
            )
          : const Sizer(),
    );
  }
}

class UserStoryView extends StatefulWidget {
  final UserStories userStory;
  final VoidCallback onComplete;
  final VoidCallback onPrevious;

  const UserStoryView({
    super.key,
    required this.userStory,
    required this.onComplete,
    required this.onPrevious,
  });

  @override
  UserStoryViewState createState() => UserStoryViewState();
}

class UserStoryViewState extends State<UserStoryView> {
  // late final StoryController _storyController;
  late final ValueNotifier<DateTime> _currentStoryCreatedAtNotifier;

  @override
  void initState() {
    super.initState();
    // _storyController = StoryController();
    _currentStoryCreatedAtNotifier =
        ValueNotifier<DateTime>(widget.userStory.stories!.first.createdAt!);
  }

  @override
  void dispose() {
    // _storyController.dispose();
    _currentStoryCreatedAtNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // _buildStoryView(),
        _buildUserInfoBar(),
        _buildNavigationOverlay(),
      ],
    );
  }

  // Widget _buildStoryView() {
  //   return StoryView(
  //     storyItems: widget.userStory.stories
  //             ?.map((story) => createStoryItem(story, _storyController))
  //             .toList() ??
  //         [],
  //     onStoryShow: (storyItem, index) {
  //       _currentStoryCreatedAtNotifier.value =
  //           widget.userStory.stories![index].createdAt!;
  //     },
  //     controller: _storyController,
  //     onComplete: widget.onComplete,
  //     onVerticalSwipeComplete: (direction) {
  //       if (direction == Direction.down) {
  //         Navigator.of(context).pop();
  //       }
  //     },
  //     progressPosition: ProgressPosition.top,
  //   );
  // }

  Widget _buildUserInfoBar() {
    return Positioned(
      top: kToolbarHeight,
      left: 0,
      right: 0,
      child: BlocProvider(
        create: (context) => context.read<StoryCubit>(),
        child: ValueListenableBuilder<DateTime>(
          valueListenable: _currentStoryCreatedAtNotifier,
          builder: (context, createdAt, child) {
            return UserInfoBar(
              userStory: widget.userStory,
              createdAt: createdAt,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    return GestureDetector(
      // onTapDown: (details) {
      //   final screenWidth = MediaQuery.of(context).size.width;
      //   if (details.globalPosition.dx < screenWidth / 2) {
      //     _storyController.previous();
      //   } else {
      //     _storyController.next();
      //   }
      // },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            widget.onComplete(); // Swipe left to go to the next user
          } else if (details.primaryVelocity! > 0) {
            widget.onPrevious(); // Swipe right to go to the previous user
          }
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < -300) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                // onTap: _storyController.previous,
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                // onTap: _storyController.next,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoBar extends StatelessWidget {
  final UserStories userStory;
  final DateTime createdAt;

  const UserInfoBar({
    super.key,
    required this.userStory,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(context),
          _buildUserAvatar(),
          const SizedBox(width: 8),
          _buildUserInfo(),
          const Spacer(),
          _buildMoreOptionsButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        shadows: [
          Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 9),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      minRadius: 25,
      backgroundImage: NetworkImage(userStory.user?.profilePictureUrl ?? ''),
      onBackgroundImageError: (_, __) =>
          const NetworkImage(UIConst.profilePlaceHolder),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeAndSplit2Only(
              '${userStory.user?.firstName ?? ''} ${userStory.user?.lastName ?? ''}'),
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('hh:mm a').format(createdAt),
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton() {
    return IconButton(
      onPressed: () {
        // Implement more options functionality
      },
      icon: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}

// StoryItem createStoryItem(Story storyData, StoryController controller) {
//   switch (storyData.type) {
//     case 'text':
//       return StoryItem.text(
//         title: storyData.content!,
//         backgroundColor: Colors.deepOrange,
//       );
//     case 'image':
//       return StoryItem.pageImage(
//         url: storyData.content!,
//         caption: storyData.caption != null && storyData.caption != 'null'
//             ? Text(
//                 storyData.caption!,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               )
//             : null,
//         controller: controller,
//       );
//     case 'video':
//       return StoryItem.pageVideo(
//         storyData.content!,
//         caption: storyData.caption != null && storyData.caption != 'null'
//             ? Text(
//                 storyData.caption!,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               )
//             : null,
//         controller: controller,
//       );
//     default:
//       return StoryItem.text(
//         title: "Unknown story type",
//         backgroundColor: Colors.red,
//       );
//   }
// }
