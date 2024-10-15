// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// //
// // class ReelView extends StatelessWidget {
// //   const ReelView({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //       extendBody: true,
// //       body: MultiBlocProvider(
// //         providers: [
// //           BlocProvider(
// //             create: (context) => serviceLocator<ReelsCubit>(),
// //           ),
// //           BlocProvider(
// //             create: (context) => serviceLocator<UserCubit>(),
// //           ),
// //         ],
// //         child: const ReelsScreen(),
// //       ),
// //     );
// //   }
// // }
// //
// // void showSnackBarAfterBuild(
// //   BuildContext context, {
// //   required String message,
// //   String? actionLabel,
// //   VoidCallback? onActionPressed,
// //   IconData? icon,
// //   Color backgroundColor = Colors.black,
// //   Color textColor = Colors.red,
// //   Color actionTextColor = Colors.blue,
// //   Duration duration = const Duration(seconds: 1),
// // }) {
// //   final snackBar = SnackBar(
// //     content: Row(
// //       children: [
// //         Expanded(
// //           child: Text(
// //             message,
// //             textScaler: TextScaler.noScaling,
// //             style: TextStyle(
// //               color: textColor,
// //               fontSize: 30.sp,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),
// //         ),
// //         if (icon != null)
// //           Icon(
// //             icon,
// //             color: Colors.green,
// //             size: 50.h,
// //           ),
// //       ],
// //     ),
// //     backgroundColor: backgroundColor,
// //     duration: duration,
// //     action: actionLabel != null
// //         ? SnackBarAction(
// //             label: actionLabel,
// //             onPressed: onActionPressed ?? () {},
// //             textColor: actionTextColor,
// //           )
// //         : null,
// //     behavior: SnackBarBehavior.floating,
// //     shape: RoundedRectangleBorder(
// //       borderRadius: BorderRadius.circular(10),
// //     ),
// //     margin: const EdgeInsets.all(16),
// //     elevation: 10,
// //   );
// //   SchedulerBinding.instance.addPostFrameCallback((_) {
// //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //   });
// // }
// //
// // class ReelsScreen extends StatefulWidget {
// //   const ReelsScreen({super.key});
// //
// //   @override
// //   ReelsScreenState createState() => ReelsScreenState();
// // }
// //
// // class ReelsScreenState extends State<ReelsScreen>
// //     with AutomaticKeepAliveClientMixin {
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchInitialReels();
// //   }
// //
// //   void _fetchInitialReels() {
// //     if (mounted) {
// //       context.read<ReelsCubit>().fetchReels();
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return BlocBuilder<ReelsCubit, ReelsState>(
// //       builder: (context, state) {
// //         return Stack(
// //           children: [
// //             Positioned.fill(
// //               child: PageView.builder(
// //                 physics: const BouncingScrollPhysics(),
// //                 controller: _pageController,
// //                 scrollDirection: Axis.vertical,
// //                 itemCount: state.globalReels.length +
// //                     (state.globalReelsHasReachedMax ? 0 : 1),
// //                 onPageChanged: _handlePageChange,
// //                 itemBuilder: (context, index) {
// //                   if (index >= state.globalReels.length) {
// //                     return const Center(
// //                       child: CupertinoActivityIndicator(radius: 25),
// //                     );
// //                   }
// //                   return VideoWidget(
// //                     url: state.globalReels[index].videoMedia,
// //                   );
// //                   // return UnifiedReelItem(
// //                   //   reel: state.globalReels[index],
// //                   //   isVisible: _currentPage == index,
// //                   //   itemType: ReelItemType.main,
// //                   // );
// //                 },
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _handlePageChange(int index) {
// //     setState(() => _currentPage = index);
// //     final reelsCubit = context.read<ReelsCubit>();
// //     if (index == reelsCubit.state.globalReels.length - 1 && mounted) {
// //       reelsCubit.fetchReels();
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // class RoundedButtonWithImage extends StatelessWidget {
// //   final String imagePath;
// //   final VoidCallback onPressed;
// //
// //   const RoundedButtonWithImage({
// //     super.key,
// //     required this.imagePath,
// //     required this.onPressed,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 100,
// //       height: 50,
// //       child: FittedBox(
// //         child: ElevatedButton.icon(
// //           onPressed: onPressed,
// //           style: ButtonStyle(
// //             backgroundColor: MaterialStatePropertyAll<Color>(
// //               Colors.blueGrey.withOpacity(0.2),
// //             ),
// //           ),
// //           icon: const Icon(
// //             FontAwesomeIcons.music,
// //             color: Colors.white,
// //           ),
// //           label: const Text(
// //             'Audio',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class VideoWidget extends StatefulWidget {
// //   final String url;
// //
// //   const VideoWidget({required this.url});
// //
// //   @override
// //   _VideoWidgetState createState() => _VideoWidgetState();
// // }
// //
// // class _VideoWidgetState extends State<VideoWidget> {
// //   late VideoPlayerController videoPlayerController;
// //
// //   late Future<void> _initializeVideoPlayerFuture;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     videoPlayerController =
// //         new VideoPlayerController.networkUrl(Uri.parse(widget.url));
// //
// //     _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
// //       //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
// //       setState(() {});
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     videoPlayerController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       future: _initializeVideoPlayerFuture,
// //       builder: (context, snapshot) {
// //         return (snapshot.connectionState == ConnectionState.done)
// //             ? SizedBox(
// //                 height: double.infinity,
// //                 child: Chewie(
// //                   key: new PageStorageKey(widget.url),
// //                   controller: ChewieController(
// //                     videoPlayerController: videoPlayerController,
// //                     autoInitialize: true,
// //                     looping: true,
// //                     showOptions: false,
// //                     allowFullScreen: false,
// //                     aspectRatio: 4/2,
// //                     errorBuilder: (context, errorMessage) {
// //                       return Center(
// //                         child: Text(
// //                           errorMessage,
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               )
// //             : SizedBox(
// //                 height: 200,
// //                 child: Center(
// //                   child: (snapshot.connectionState != ConnectionState.none)
// //                       ? CircularProgressIndicator()
// //                       : SizedBox(),
// //                 ),
// //               );
// //       },
// //     );
// //   }
// // }
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart'; // Import the visibility_detector package
//
// class ReelView extends StatelessWidget {
//   const ReelView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => serviceLocator<ReelsCubit>(),
//           ),
//           BlocProvider(
//             create: (context) => serviceLocator<UserCubit>(),
//           ),
//         ],
//         child: const ReelsScreen(),
//       ),
//     );
//   }
// }
//
// void showSnackBarAfterBuild(BuildContext context, {
//   required String message,
//   String? actionLabel,
//   VoidCallback? onActionPressed,
//   IconData? icon,
//   Color backgroundColor = Colors.black,
//   Color textColor = Colors.red,
//   Color actionTextColor = Colors.blue,
//   Duration duration = const Duration(seconds: 1),
// }) {
//   final snackBar = SnackBar(
//     content: Row(
//       children: [
//         Expanded(
//           child: Text(
//             message,
//             textScaler: TextScaler.noScaling,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 30.sp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         if (icon != null)
//           Icon(
//             icon,
//             color: Colors.green,
//             size: 50.h,
//           ),
//       ],
//     ),
//     backgroundColor: backgroundColor,
//     duration: duration,
//     action: actionLabel != null
//         ? SnackBarAction(
//       label: actionLabel,
//       onPressed: onActionPressed ?? () {},
//       textColor: actionTextColor,
//     )
//         : null,
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     margin: const EdgeInsets.all(16),
//     elevation: 10,
//   );
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   });
// }
//
// class ReelsScreen extends StatefulWidget {
//   const ReelsScreen({super.key});
//
//   @override
//   ReelsScreenState createState() => ReelsScreenState();
// }
//
// class ReelsScreenState extends State<ReelsScreen>
//     with AutomaticKeepAliveClientMixin {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialReels();
//   }
//
//   void _fetchInitialReels() {
//     if (mounted) {
//       context.read<ReelsCubit>().fetchReels();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return BlocBuilder<ReelsCubit, ReelsState>(
//       builder: (context, state) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: PageView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 controller: _pageController,
//                 scrollDirection: Axis.vertical,
//                 itemCount: state.globalReels.length +
//                     (state.globalReelsHasReachedMax ? 0 : 1),
//                 onPageChanged: _handlePageChange,
//                 itemBuilder: (context, index) {
//                   if (index >= state.globalReels.length) {
//                     return const Center(
//                       child: CupertinoActivityIndicator(radius: 25),
//                     );
//                   }
//                   return VideoWidget(
//                     url: state.globalReels[index].videoMedia,
//                   );
//                   // return UnifiedReelItem(
//                   //   reel: state.globalReels[index],
//                   //   isVisible: _currentPage == index,
//                   //   itemType: ReelItemType.main,
//                   // );
//                 },
//               ),
//             ),
//             Positioned(
//               top: 100,
//               bottom: 100,
//               right: 0,
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.push(Routes.Tinder);
//                 },
//                 child: Text('sfbdfbdb'),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handlePageChange(int index) {
//     setState(() => _currentPage = index);
//     final reelsCubit = context.read<ReelsCubit>();
//     if (index == reelsCubit.state.globalReels.length - 1 && mounted) {
//       reelsCubit.fetchReels();
//     }
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
// class RoundedButtonWithImage extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onPressed;
//
//   const RoundedButtonWithImage({
//     super.key,
//     required this.imagePath,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 100,
//       height: 50,
//       child: FittedBox(
//         child: ElevatedButton.icon(
//           onPressed: onPressed,
//           style: ButtonStyle(
//             backgroundColor: MaterialStatePropertyAll<Color>(
//               Colors.blueGrey.withOpacity(0.2),
//             ),
//           ),
//           icon: const Icon(
//             FontAwesomeIcons.music,
//             color: Colors.white,
//           ),
//           label: const Text(
//             'Audio',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VideoWidget extends StatefulWidget {
//   final String url;
//
//   const VideoWidget({required this.url});
//
//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }
//
// class _VideoWidgetState extends State<VideoWidget> {
//   late VideoPlayerController videoPlayerController;
//
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isVisible = false; // Track visibility state
//
//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.url));
//
//     _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
//       // Ensure the first frame is shown after the video is initialized
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key(widget.url), // Unique key for each video widget
//       onVisibilityChanged: (visibilityInfo) {
//         var visiblePercentage = visibilityInfo.visibleFraction * 100;
//
//         // Play video when more than 50% is visible
//         if (visiblePercentage > 50 && !_isVisible) {
//           setState(() {
//             _isVisible = true;
//           });
//           videoPlayerController.play();
//         } else if (visiblePercentage <= 50 && _isVisible) {
//           setState(() {
//             _isVisible = false;
//           });
//           videoPlayerController.pause();
//         }
//       },
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           return (snapshot.connectionState == ConnectionState.done)
//               ? Container(
//             height: double.infinity,
//             color: Colors.black,
//             child: Stack(
//               children: [
//                 Chewie(
//                   key: PageStorageKey(widget.url),
//                   controller: ChewieController(
//                     videoPlayerController: videoPlayerController,
//                     autoInitialize: true,
//                     looping: true,
//                     showOptions: false,
//                     allowFullScreen: false,
//                     aspectRatio: 2 / 4,
//                     errorBuilder: (context, errorMessage) {
//                       return Center(
//                         child: Text(
//                           errorMessage,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   top: 100,
//                   bottom: 100,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       context.push(Routes.Tinder);
//                     },
//                     child: Text('data'),
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : SizedBox(
//             height: 200,
//             child: Center(
//               child: (snapshot.connectionState != ConnectionState.none)
//                   ? CircularProgressIndicator()
//                   : SizedBox(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/profile_buttom_sheet.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../res/style/styles.dart';

// Entry point of the reels view
class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => serviceLocator<ReelsCubit>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<UserCubit>(),
          ),
        ],
        child: const ReelsScreen(),
      ),
    );
  }
}

// Utility function to show snack bar after build
void showSnackBarAfterBuild({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  IconData? icon,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.red,
  Color actionTextColor = Colors.blue,
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (icon != null)
          Icon(
            icon,
            color: Colors.green,
            size: 50.h,
          ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
            textColor: actionTextColor,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
    elevation: 10,
  );
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchInitialReels();
  }

  // Fetch the initial set of reels
  void _fetchInitialReels() {
    if (mounted) {
      context.read<ReelsCubit>().fetchReels();
    }
  }

  // Handles the page change to update the current page and fetch more reels if necessary
  void _handlePageChange(int index) {
    setState(() {
      _currentPage = index;
    });
    final reelsCubit = context.read<ReelsCubit>();
    if (index == reelsCubit.state.globalReels.length - 1 && mounted) {
      reelsCubit.fetchReels();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Required to keep the widget alive between page changes
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.globalReels.length +
                    (state.globalReelsHasReachedMax ? 0 : 1),
                onPageChanged: _handlePageChange,
                itemBuilder: (context, index) {
                  if (index >= state.globalReels.length) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        radius: 25,
                        color: Colors.red,
                      ),
                    );
                  }
                  return UnifiedReelItem(
                    reel: state.globalReels[index],
                    isVisible: _currentPage == index,
                    itemType: ReelItemType.main,
                  );
                },
              ),
            ),
            Positioned(
                top: kToolbarHeight * 0.5,
                right: 4,
                left: 4,
                child: AdvancedTikTokTabBar()
                // ElevatedButton(
                //   onPressed: () {
                //     videoPlayerController
                //         .pause(); // Pause video on navigation
                //     context.push(Routes.Tinder);
                //   },
                //   child: const Text('Navigate'),
                // ),
                ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class RoundedButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: FittedBox(
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(
              Colors.blueGrey.withOpacity(0.2),
            ),
          ),
          icon: const Icon(
            FontAwesomeIcons.music,
            color: Colors.white,
          ),
          label: const Text(
            'Audio',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class UnifiedReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;
  final ReelItemType itemType;

  const UnifiedReelItem({
    super.key,
    required this.reel,
    required this.isVisible,
    this.itemType = ReelItemType.main,
  });

  @override
  State<UnifiedReelItem> createState() => _UnifiedReelItemState();
}

enum ReelItemType { main, instagram, spotlight }

class _UnifiedReelItemState extends State<UnifiedReelItem>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false; // Track visibility state

  // ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  late final AnimationController _rotationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Start observing lifecycle changes

    _initializeRotationController();
    _initializePlayer();
  }

  /// Initializes the rotation controller for any rotating UI elements.
  void _initializeRotationController() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant UnifiedReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _playVideo() : _pauseVideo();
    }
  }

  // Implement didChangeAppLifecycleState for handling lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseVideo();
    } else if (state == AppLifecycleState.resumed && widget.isVisible) {
      _playVideo();
    }
  }

  /// Initializes the video player and Chewie controller.
  // Future<void> _initializePlayer() async {
  //   _videoPlayerController =
  //       VideoPlayerController.network(widget.reel.videoMedia);
  //   try {
  //     await _videoPlayerController.initialize();
  //     _setupChewieController();
  //     if (mounted) {
  //       setState(() {
  //         _isInitialized = true;
  //         _isPlaying = widget.isVisible;
  //       });
  //     }
  //     if (widget.isVisible) {
  //       _playVideo();
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       setState(() {
  //         _isInitialized = false;
  //       });
  //       _showError('Failed to load video');
  //     }
  //   }
  // }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      _initializeVideoPlayerFuture =
          _videoPlayerController.initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after initialization
      });
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = widget.isVisible;
        });
      }
      // Add listener for video progress
      _videoPlayerController.addListener(_onVideoProgress);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
        _showError('Failed to load video');
      }
    }
  }

  /// Sets up the Chewie controller after the video player is initialized.
  // void _setupChewieController() {
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     autoPlay: true,
  //     looping: true,
  //     showControls: true,
  //     hideControlsTimer: const Duration(milliseconds: 500),
  //     aspectRatio: _videoPlayerController.value.aspectRatio,
  //   );
  // }

  /// Displays an error message using a SnackBar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Starts video playback.
  void _playVideo() {
    if (_isInitialized && !_isPlaying) {
      _videoPlayerController.play();
      // _chewieController?.play();
      setState(() {
        _isPlaying = true;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  /// Pauses video playback.
  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _videoPlayerController.pause();

      // _chewieController?.pause();
      setState(() {
        _isPlaying = false;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  /// Toggles between play and pause states.
  void _togglePlayPause() {
    _isPlaying ? _pauseVideo() : _playVideo();
  }

  /// Hides the play/pause icon after a short delay.
  void _hidePlayPauseIconAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildVideoContent(),
        if (_showPlayPauseIcon) _buildPlayPauseIcon(),
        _buildOverlay(),
        if (!_isInitialized)
          const Center(
            child: CupertinoActivityIndicator(
              radius: 25,
              color: Colors.blue,
            ),
          ),
        // if (widget.itemType == ReelItemType.main)
        // Positioned(
        //   top: 4,
        //   child: _buildAppBar(context),
        // ),
      ],
    );
  }

/*
  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button Row
          Row(
            children: [
              _buildGradientIconButton(
                iconData: Icons.arrow_back,
                onPressed: () => context.pop(),
              ),
              const Spacer(),
            ],
          ),
          const Sizer(),
          // Buttons Row
          FittedBox(
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Live Button
                _buildGradientSvgButton(
                  assetName: 'assets/images/live_icon.svg',
                  onPressed: () {
                    _pauseVideo();
                    context.push(Routes.LIVE);
                  },
                ),
                const Sizer(),
                // Spotlight Button
                _buildGradientTextButton(
                  text: 'Spotlight',
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.SPOTLIGHT);
                  },
                ),
                const Sizer(),
                // Snap Button
                _buildGradientTextButton(
                  text: 'Snap',
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.SNAP);
                  },
                ),
                const Sizer(),
                // Reels Button
                _buildGradientTextButton(
                  text: 'Reels',
                  onPressed: () async {
                    _pauseVideo();

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReelsRecordingScreen(),
                      ),
                    );
                  },
                ),
                const Sizer(),
                // Search Button
                _buildGradientIconButton(
                  iconData: FontAwesomeIcons.magnifyingGlass,
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.Tinder);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method for gradient icon buttons
  Widget _buildGradientIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: FittedBox(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient SVG buttons
  Widget _buildGradientSvgButton(
      {required String assetName, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: SvgPicture.asset(
          assetName,
          fit: BoxFit.fitHeight,
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient text buttons
  Widget _buildGradientTextButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Styles.mediumText(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// Button decoration with gradient and rounded corners
  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.white10,
          Colors.black12,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
*/

  /// Handles vertical drag events for the spotlight item type.
  void _handleVerticalDrag(DragEndDetails details) async {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _pauseVideo();
      await ProfileBottomSheet.show(context, widget.reel);
      _playVideo();
    }
  }

  /// Builds the video content or displays a placeholder if not initialized.
  Widget _buildVideoContent() {
    return VisibilityDetector(
      key: Key(widget.reel.videoMedia), // Unique key for each video widget

      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;

        // Play video when more than 50% is visible
        if (visiblePercentage > 50 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          _videoPlayerController.play();
        } else if (visiblePercentage <= 50 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
          _videoPlayerController.pause();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: _togglePlayPause,
              onVerticalDragEnd: widget.itemType == ReelItemType.spotlight
                  ? _handleVerticalDrag
                  : null,
              child: DoubleTapHeart(
                onDoubleTap: () async {
                  await serviceLocator<ReelsCubit>()
                      .likeReel(widget.reel.id)
                      .then((val) async {
                    if (val == "Reel liked successfully") {
                      setState(() {
                        widget.reel.likeCount++;
                      });
                    } else if (val == "Reel unlike successfully") {
                      if (widget.reel.likeCount > 0) {
                        setState(() {
                          widget.reel.likeCount--;
                        });
                      }
                    }
                    if (val == "Reel unlike successfully") {
                      await serviceLocator<ReelsCubit>()
                          .likeReel(widget.reel.id)
                          .then((value) {
                        if (value == "Reel liked successfully") {
                          setState(() {
                            widget.reel.likeCount++;
                          });
                        } else if (value == "Reel unlike successfully") {
                          if (widget.reel.likeCount > 0) {
                            setState(() {
                              widget.reel.likeCount--;
                            });
                          }
                        }
                      });
                    }
                  });
                },
                iconSize: 200,
                animationDuration: Duration(seconds: 1),
                heartIcon: Icons.favorite,
                iconColor: Colors.pink,
                child: Container(
                  height: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Chewie(
                        key: PageStorageKey(widget.reel.videoMedia),
                        controller: ChewieController(
                          videoPlayerController: _videoPlayerController,
                          autoInitialize: true,
                          looping: true,
                          showOptions: false,
                          allowFullScreen: false,
                          showControls: false,
                          aspectRatio: 2 / 4,
                          errorBuilder: (context, errorMessage) {
                            return Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 10,
                        right: 10,
                        child: CustomProgressBar(
                          videoPlayerController: _videoPlayerController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds the play/pause icon with an animation.
  Widget _buildPlayPauseIcon() {
    return AnimatedOpacity(
      opacity: _showPlayPauseIcon ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  /// Builds the overlay that contains additional UI elements like reel info.
  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.itemType != ReelItemType.instagram)
          Expanded(
            child: GestureDetector(
              onTap: _togglePlayPause,
              behavior: HitTestBehavior.opaque,
            ),
          ),
        ReelInfo(
          reel: widget.reel,
          itemType: widget.itemType,
          rotationController: _rotationController,
        ),
      ],
    );
  }

  void _onVideoProgress() {
    if (_videoPlayerController.value.isInitialized) {
      final position = _videoPlayerController.value.position;
      final duration = _videoPlayerController.value.duration;

      // Check if the video has reached 60% of its duration
      if (position.inSeconds > 0.6 * duration.inSeconds) {
        // Dispatch the createReelView event once
        serviceLocator<ReelsCubit>()
            .createReelView(widget.reel.id, duration.inSeconds);

        // Remove the listener after the event is dispatched to prevent repeated calls
        _videoPlayerController.removeListener(_onVideoProgress);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoProgress);
    _videoPlayerController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class DoubleTapHeart extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDoubleTap;
  final IconData heartIcon;
  final double iconSize;
  final Color iconColor;
  final Duration animationDuration;

  const DoubleTapHeart({
    Key? key,
    required this.child,
    this.onDoubleTap,
    this.heartIcon = Icons.favorite,
    this.iconSize = 80.0,
    this.iconColor = Colors.redAccent,
    this.animationDuration = const Duration(milliseconds: 700),
  }) : super(key: key);

  @override
  _DoubleTapHeartState createState() => _DoubleTapHeartState();
}

class _DoubleTapHeartState extends State<DoubleTapHeart>
    with SingleTickerProviderStateMixin {
  Offset _tapPosition = Offset.zero;
  List<_AnimatedHeartOverlay> _heartOverlays = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (TapDownDetails details) {
        final renderBox = context.findRenderObject() as RenderBox;
        _tapPosition = renderBox.globalToLocal(details.globalPosition);
      },
      onDoubleTap: () {
        _showHeart();
        if (widget.onDoubleTap != null) {
          widget.onDoubleTap!();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          widget.child,
          ..._heartOverlays,
        ],
      ),
    );
  }

  void _showHeart() {
    final overlay = _AnimatedHeartOverlay(
      key: UniqueKey(),
      position: _tapPosition,
      icon: widget.heartIcon,
      size: widget.iconSize,
      color: widget.iconColor,
      duration: widget.animationDuration,
      onAnimationComplete: _removeOverlay,
    );

    setState(() {
      _heartOverlays.add(overlay);
    });
  }

  void _removeOverlay(_AnimatedHeartOverlay overlay) {
    setState(() {
      _heartOverlays.remove(overlay);
    });
  }
}

class _AnimatedHeartOverlay extends StatefulWidget {
  final Offset position;
  final IconData icon;
  final double size;
  final Color color;
  final Duration duration;
  final Function(_AnimatedHeartOverlay) onAnimationComplete;

  const _AnimatedHeartOverlay({
    Key? key,
    required this.position,
    required this.icon,
    required this.size,
    required this.color,
    required this.duration,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  __AnimatedHeartOverlayState createState() => __AnimatedHeartOverlayState();
}

class __AnimatedHeartOverlayState extends State<_AnimatedHeartOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onAnimationComplete(widget);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({required this.url});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false; // Track visibility state

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {}); // Ensure the first frame is shown after initialization
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url), // Unique key for each video widget
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;

        // Play video when more than 50% is visible
        if (visiblePercentage > 50 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          videoPlayerController.play();
        } else if (visiblePercentage <= 50 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
          videoPlayerController.pause();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  Chewie(
                    key: PageStorageKey(widget.url),
                    controller: ChewieController(
                      videoPlayerController: videoPlayerController,
                      autoInitialize: true,
                      looping: true,
                      showOptions: false,
                      allowFullScreen: false,
                      aspectRatio: 2 / 4,
                      errorBuilder: (context, errorMessage) {
                        return Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      customControls: CustomChewieControls(
                        chewieController: ChewieController(
                          videoPlayerController: videoPlayerController,
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     top: 50, right: 0, left: 0, child: AdvancedTikTokTabBar()
                  //     // ElevatedButton(
                  //     //   onPressed: () {
                  //     //     videoPlayerController
                  //     //         .pause(); // Pause video on navigation
                  //     //     context.push(Routes.Tinder);
                  //     //   },
                  //     //   child: const Text('Navigate'),
                  //     // ),
                  //     ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class AdvancedTikTokTabBar extends StatefulWidget {
  @override
  _AdvancedTikTokTabBarState createState() => _AdvancedTikTokTabBarState();
}

class _AdvancedTikTokTabBarState extends State<AdvancedTikTokTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              // color: Colors.red,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 0.08.sw,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 5.0,
                      )
                    ],
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // LIVE Icon with Glow Effect
              const Sizer(),
              _buildLiveIcon(onTap: () {
                context.push(Routes.LIVE);
              }),
              const Spacer(), // Explore Tab
              _buildTab("Spotlight", 0, onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                context.push(Routes.SPOTLIGHT);
              }),
              // Following Tab
              _buildTab("Snap", 1, onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                context.push(Routes.SNAP);
              }),

              // For You Tab with rounded underline
              _buildTab("Reels", 2, onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReelsRecordingScreen(),
                  ),
                );
              }),
              const Spacer(),
              // Search Icon with custom SVG
              _buildSearchIcon(onTap: () {
                context.push(Routes.Tinder);
              }),
              const Sizer(),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Live Icon with Glow Effect
  Widget _buildLiveIcon({required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 0.08.sw,
        width: 0.08.sw,
        child: Stack(
          children: [
            // Shadow layer
            Transform.translate(
              offset: const Offset(1, 1), // Adjust the offset as needed

              child: ImageFiltered(
                enabled: true,
                imageFilter: ImageFilter.blur(
                  sigmaX: 0.0,
                  sigmaY: 1.5,
                ),
                child: SvgPicture.asset(
                  'assets/images/live_icon.svg',
                  color: Colors.black87, // Shadow color
                  width: 70.w,
                  height: 70.w,
                ),
              ),
            ),
            // Actual SVG
            SvgPicture.asset(
              'assets/images/live_icon.svg',
              color: Colors.white,
              width: 70.w,
              height: 70.w,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildLiveIcon({required VoidCallback? onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: SizedBox(
  //       height: 70.w,
  //       width: 70.w,
  //       child: Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           // Shadow layer with blur effect
  //           Positioned(
  //             left: 2.0,
  //             bottom: 2.0,
  //             right: 2,
  //             top: 2,
  //             child: ImageFiltered(
  //               enabled: true,
  //               imageFilter: ImageFilter.blur(
  //                 sigmaX: 0.0,
  //                 sigmaY: 1.5,
  //               ),
  //               child: SvgPicture.asset(
  //                 'assets/images/live_icon.svg',
  //                 color: Colors.black87, // Shadow color
  //                 width: 60.w,
  //                 height: 60.w,
  //               ),
  //             ),
  //           ),
  //           // Main icon
  //           SvgPicture.asset(
  //             'assets/images/live_icon.svg',
  //             color: Colors.white, // Main icon color
  //             width: 60.w,
  //             fit: BoxFit.scaleDown,
  //             height: 60.w,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Method to build each tab with smooth underline animation
  Widget _buildTab(String text, int index,
      {bool hasUnderline = false, required VoidCallback? onTap}) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0, left: 4.0, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 5.0,
                  )
                ],
              ),
            ),
            // Rounded Underline effect for selected tab
            if (hasUnderline || isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(top: 6.0),
                height: 3.0,
                width: 35.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 5.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(top: 6.0),
                height: 3.0,
                width: 35.0,
              ),
          ],
        ),
      ),
    );
  }

  // Custom Search Icon with Glow Effect
  Widget _buildSearchIcon({required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Icon(
          size: 0.08.sw,
          FontAwesomeIcons.magnifyingGlass,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 5.0,
            )
          ],
        ),
      ),
    );
  }
}

class CustomChewieControls extends StatefulWidget {
  final ChewieController chewieController;

  const CustomChewieControls({
    Key? key,
    required this.chewieController,
  }) : super(key: key);

  @override
  State<CustomChewieControls> createState() => _CustomChewieControlsState();
}

class _CustomChewieControlsState extends State<CustomChewieControls> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // // Play/Pause Button
        // Align(
        //   alignment: Alignment.center,
        //   child: IconButton(
        //     icon: Icon(
        //       widget.chewieController.videoPlayerController.value.isPlaying
        //           ? Icons.pause_circle_filled
        //           : Icons.play_circle_filled,
        //       color: Colors.white,
        //       size: 50.0,
        //     ),
        //     onPressed: () {
        //       if (widget
        //           .chewieController.videoPlayerController.value.isPlaying) {
        //         setState(() {
        //           widget.chewieController.videoPlayerController.pause();
        //         });
        //       } else {
        //         setState(() {
        //           widget.chewieController.videoPlayerController.play();
        //         });
        //       }
        //     },
        //   ),
        // ),
        //
        // // Bottom Controls (e.g., Progress Bar, Fullscreen, etc.)
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: VideoProgressIndicator(
            widget.chewieController.videoPlayerController,
            allowScrubbing: true,
            padding: EdgeInsets.zero,
            colors: const VideoProgressColors(
              playedColor: Colors.black54,
              // backgroundColor: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}

class AdvancedChewieWithProgressBar extends StatefulWidget {
  final String videoUrl;

  const AdvancedChewieWithProgressBar({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _AdvancedChewieWithProgressBarState createState() =>
      _AdvancedChewieWithProgressBarState();
}

class _AdvancedChewieWithProgressBarState
    extends State<AdvancedChewieWithProgressBar> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: true,
      showControls: false,
      // Hide default Chewie controls
      allowFullScreen: false,
      aspectRatio: 2 / 4,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(
          key: PageStorageKey(widget.videoUrl),
          controller: _chewieController,
        ),
        // Advanced Custom Progress Bar
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: CustomProgressBar(
            videoPlayerController: _videoPlayerController,
          ),
        ),
      ],
    );
  }
}

class CustomProgressBar extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const CustomProgressBar({Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  bool _isDragging = false;
  bool _wasPlaying = false;
  double _dragValue = 0.0;

  VideoPlayerController get controller => widget.videoPlayerController;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!value.isInitialized) {
          return Container(); // Handle uninitialized controller
        }

        final duration = value.duration;
        final position = _isDragging
            ? Duration(milliseconds: _dragValue.toInt())
            : value.position;
        final bufferedEnd = value.buffered.isNotEmpty
            ? value.buffered.last.end.inMilliseconds
            : 0;
        final durationInMs = duration.inMilliseconds > 0
            ? duration.inMilliseconds
            : 1; // Prevent division by zero

        final playedPart = (_isDragging
                ? _dragValue / durationInMs
                : position.inMilliseconds / durationInMs)
            .clamp(0.0, 1.0);
        final bufferedPart = bufferedEnd / durationInMs;

        return Column(
          children: [
            // Time labels
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         _formatDuration(position),
            //         style: const TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //       Text(
            //         _formatDuration(duration),
            //         style: const TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //     ],
            //   ),
            // ),
            // Progress bar
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                setState(() {
                  _isDragging = true;
                  _wasPlaying = controller.value.isPlaying;
                  if (_wasPlaying) {
                    controller.pause();
                  }
                });
                HapticFeedback.lightImpact();
              },
              onHorizontalDragUpdate: (details) {
                final box = context.findRenderObject() as RenderBox;
                final tapPos = box.globalToLocal(details.globalPosition);
                final relative = tapPos.dx / box.size.width;
                final position = relative * durationInMs;
                setState(() {
                  _dragValue = position.clamp(0.0, durationInMs.toDouble());
                });
              },
              onHorizontalDragEnd: (details) {
                controller
                    .seekTo(Duration(milliseconds: _dragValue.toInt()))
                    .then((_) {
                  if (_wasPlaying) {
                    controller.play();
                  }
                });
                setState(() {
                  _isDragging = false;
                });
              },
              onTapDown: (details) {
                final box = context.findRenderObject() as RenderBox;
                final tapPos = box.globalToLocal(details.globalPosition);
                final relative = tapPos.dx / box.size.width;
                final position = relative * durationInMs;
                controller.seekTo(Duration(milliseconds: position.toInt()));
                HapticFeedback.lightImpact();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth - 24; // Adjust for padding
                  final thumbSize = _isDragging ? 16.0 : 10.0;
                  final thumbPos = (playedPart * width) -
                      (thumbSize / 2) +
                      2; // Adjust for margin

                  return Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Background
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Buffered
                        // FractionallySizedBox(
                        //   widthFactor: bufferedPart,
                        //   child: Container(
                        //     height: 4,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey[500],
                        //       borderRadius: BorderRadius.circular(2),
                        //     ),
                        //   ),
                        // ),
                        // Played
                        FractionallySizedBox(
                          widthFactor: playedPart,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Thumb
                        Positioned(
                          left: thumbPos.clamp(0.0, width),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: thumbSize,
                            height: thumbSize,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
