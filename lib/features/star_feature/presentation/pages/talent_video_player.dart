import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../core/extensions/numbers_extensions.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../main.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../domain/entity/star_entity.dart';
import '../custom_video_player.dart';

class TalentVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final StarEntity talent;
  final Function(Duration)? onDurationLoaded;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onDurationLoaded,
    required this.talent,
  });

  @override
  State<TalentVideoPlayer> createState() => _TalentVideoPlayerState();
}

class _TalentVideoPlayerState extends State<TalentVideoPlayer>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  // Floating player state
  bool _isFloating = false;
  Offset _floatingPosition = const Offset(100, 100);
  bool _isPlaying = true;
  bool _showFloatingControls = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        widget.onDurationLoaded?.call(_controller.value.duration);
        _controller.play();
      });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    // Only dispose controller if it's not being used by floating player
    if (!FloatingVideoManager.isPlayerVisible) {
      _controller.dispose();
    }
    // _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    if (duration == Duration.zero) return '00:00';

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

//   void _toggleFullScreen() {
//     if (MediaQuery.of(context).orientation == Orientation.portrait) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//     }
//   }
//
//   void _toggleFloatingMode() {
//     setState(() {
//       _isFloating = !_isFloating;
//       if (_isFloating) {
//         // Save current position when entering floating mode
//         _floatingPosition = Offset(
//           MediaQuery.of(context).size.width - 320,
//           MediaQuery.of(context).size.height * 0.3,
//         );
//       }
//     });
//   }
//
//   Widget _buildFullScreenVideo() {
//     return Stack(
//       children: [
//         VideoPlayer(_controller),
//         Positioned.fill(child: _buildVideoControls(isFullScreen: true)),
//       ],
//     );
//   }
//
//   Widget _buildVideoPlayer({bool isFloating = false}) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: 200,
//           width: double.infinity,
//           color: Colors.black,
//         ),
//         SizedBox(
//           height: 200,
//           child: AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           ),
//         ),
//         if (!isFloating || _showFloatingControls)
//           Positioned.fill(child: _buildVideoControls(isFloating: isFloating)),
//       ],
//     );
//   }
//
//   Widget _buildVideoControls({
//     bool isFullScreen = false,
//     bool isFloating = false,
//   }) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Background progress track
//         Positioned(
//           bottom: 4,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 2,
//             color: Colors.grey[300],
//           ),
//         ),
//
//         // Progress indicator
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: ValueListenableBuilder<VideoPlayerValue>(
//             valueListenable: _controller,
//             builder: (context, value, child) {
//               if (!value.isInitialized || value.duration == Duration.zero) {
//                 return const SizedBox();
//               }
//
//               final progressFraction =
//                   value.position.inMilliseconds / value.duration.inMilliseconds;
//               final safeFraction = progressFraction.clamp(0.0, 1.0);
//               final screenWidth = MediaQuery.of(context).size.width;
//
//               return SizedBox(
//                 height: 10,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       left: 0,
//                       top: 4,
//                       child: Container(
//                         height: 2,
//                         width: screenWidth * safeFraction,
//                         color: AppColors.SECONDARY_COLOR,
//                       ),
//                     ),
//                     Positioned(
//                       left: screenWidth * safeFraction - 5,
//                       child: Container(
//                         height: 10,
//                         width: 10,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: AppColors.SECONDARY_COLOR,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//
//         // Play/Pause button
//         ValueListenableBuilder<VideoPlayerValue>(
//           valueListenable: _controller,
//           builder: (context, value, child) {
//             return AnimatedOpacity(
//               opacity: (value.isPlaying && !isFloating) ? 0.0 : 1.0,
//               duration: const Duration(milliseconds: 300),
//               child: IconButton(
//                 icon: Icon(
//                   value.isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 50,
//                   color: Colors.white.withValues(alpha: 0.8),
//                 ),
//                 onPressed: _togglePlayPause,
//               ),
//             );
//           },
//         ),
//
//         // Time display
//         if (!isFloating)
//           Positioned(
//             bottom: 15,
//             left: 10,
//             child: ValueListenableBuilder<VideoPlayerValue>(
//               valueListenable: _controller,
//               builder: (context, value, child) {
//                 return Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//         // Full-screen button
//         if (!isFloating)
//           Positioned(
//             bottom: 15,
//             right: 10,
//             child: GestureDetector(
//               onTap: _toggleFullScreen,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Icon(
//                   MediaQuery.of(context).orientation == Orientation.portrait
//                       ? Icons.fullscreen
//                       : Icons.fullscreen_exit,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
// // Floating mode button
//         if (!isFullScreen)
//           Positioned(
//             top: 10,
//             right: 50,
//             child: GestureDetector(
//               onTap: () {
//                 FloatingVideoManager.showFloatingPlayer(
//                   context: context,
//                   videoUrl: widget.videoUrl,
//                   talent: widget.talent,
//                   controller: _controller,
//                   isPlaying: _isPlaying,
//                 );
//                 Navigator.pop(context); // Go back to previous screen
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Icon(Icons.picture_in_picture,
//                     color: Colors.white, size: 20),
//               ),
//             ),
//           ),
//         // Floating mode button
//         // if (!isFullScreen && !isFloating)
//         //   Positioned(
//         //     top: 10,
//         //     right: 50,
//         //     child: GestureDetector(
//         //       onTap: _toggleFloatingMode,
//         //       child: Container(
//         //         padding: const EdgeInsets.all(5),
//         //         decoration: BoxDecoration(
//         //           color: Colors.black54,
//         //           borderRadius: BorderRadius.circular(20),
//         //         ),
//         //         child: const Icon(Icons.picture_in_picture, color: Colors.white, size: 20),
//         //       ),
//         //     ),
//         //   ),
//       ],
//     );
//   }

  // Widget _buildFloatingPlayer() {
  //   return Positioned(
  //     left: _floatingPosition.dx,
  //     top: _floatingPosition.dy,
  //     child: GestureDetector(
  //       onPanStart: (details) {
  //         setState(() {
  //           _isDragging = true;
  //           _showFloatingControls = true;
  //         });
  //       },
  //       onPanUpdate: (details) {
  //         setState(() {
  //           _floatingPosition = Offset(
  //             _floatingPosition.dx + details.delta.dx,
  //             _floatingPosition.dy + details.delta.dy,
  //           );
  //         });
  //       },
  //       onPanEnd: (details) {
  //         setState(() {
  //           _isDragging = false;
  //         });
  //         // Hide controls after a delay
  //         Future.delayed(const Duration(seconds: 2), () {
  //           if (!_isDragging) {
  //             setState(() {
  //               _showFloatingControls = false;
  //             });
  //           }
  //         });
  //       },
  //       onTap: () {
  //         setState(() {
  //           _showFloatingControls = !_showFloatingControls;
  //         });
  //       },
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         width: _showFloatingControls ? 300 : 160,
  //         height: _showFloatingControls ? 200 : 100,
  //         decoration: BoxDecoration(
  //           color: Colors.black,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withValues(alpha: 0.5),
  //               blurRadius: 10,
  //               spreadRadius: 2,
  //             )
  //           ],
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(12),
  //           child: Stack(
  //             children: [
  //               _buildVideoPlayer(isFloating: true),
  //
  //               // Floating player controls
  //               if (_showFloatingControls)
  //                 Positioned(
  //                   top: 0,
  //                   left: 0,
  //                   right: 0,
  //                   child: Container(
  //                     height: 40,
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         colors: [
  //                           Colors.black.withValues(alpha: 0.7),
  //                           Colors.transparent,
  //                         ],
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             widget.talent.title,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.close,
  //                               color: Colors.white, size: 20),
  //                           onPressed: _toggleFloatingMode,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //               if (_showFloatingControls)
  //                 Positioned(
  //                   bottom: 0,
  //                   left: 0,
  //                   right: 0,
  //                   child: Container(
  //                     height: 40,
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         begin: Alignment.bottomCenter,
  //                         end: Alignment.topCenter,
  //                         colors: [
  //                           Colors.black.withValues(alpha: 0.7),
  //                           Colors.transparent,
  //                         ],
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         IconButton(
  //                           icon: Icon(
  //                             _isPlaying ? Icons.pause : Icons.play_arrow,
  //                             color: Colors.white,
  //                             size: 20,
  //                           ),
  //                           onPressed: _togglePlayPause,
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.fullscreen,
  //                               color: Colors.white, size: 20),
  //                           onPressed: _toggleFullScreen,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //               // Small play/pause button when controls are hidden
  //               if (!_showFloatingControls)
  //                 Center(
  //                   child: IconButton(
  //                     icon: Icon(
  //                       _isPlaying ? Icons.pause : Icons.play_arrow,
  //                       color: Colors.white,
  //                       size: 24,
  //                     ),
  //                     onPressed: _togglePlayPause,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVideoInfo(StarEntity talent) {
    final createdAt = talent.createdAt ?? DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            talent.title, // Replace with actual video title
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
            // Replace with actual stats
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: ProfileWithStoriesBorder(
                  profilePictureUrl: talent.user.image ?? '',
                  storiesCount: talent.storyCount ?? 0,
                ),
              ),
              // CircleAvatar(
              //   radius: 15,
              //   backgroundImage: talent.user.image.isNotEmpty
              //       ? CachedNetworkImageProvider(talent.user.image)
              //       : null,
              // ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${talent.user.firstName} ${talent.user.lastName}',
                      // Replace with actual user name
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Image.asset(
                    index < talent.averageRating.floor()
                        ? "assets/49-New-icons/star_gold.png"
                        : "assets/49-New-icons/star.png",
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // IconButton(
              //   icon: const Icon(Icons.thumb_up_outlined),
              //   onPressed: () {
              //     // Handle like
              //   },
              // ),
              // IconButton(
              //   icon: const Icon(Icons.thumb_down_outlined),
              //   onPressed: () {
              //     // Handle dislike
              //   },
              // ),
              // IconButton(
              //   icon: const Icon(Icons.share),
              //   onPressed: () {
              //     // Handle share
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        print('Status==> ${state.status}');
        if (state.status == StarStates.loading && state.star == null) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        final videos = state.star ?? [];

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            final mediaUrl =
                video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';

            if (mediaUrl.isEmpty || mediaUrl == widget.videoUrl) {
              return const SizedBox();
            }

            return InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TalentVideoPlayer(
                      videoUrl: mediaUrl,
                      talent: video,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (!mediaUrl.toLowerCase().contains('.mp4'))
                            CachedNetworkImage(
                              imageUrl: mediaUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                    child: CustomCircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          if (mediaUrl.toLowerCase().contains('.mp4'))
                            const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Video info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${video.user.firstName} • ${video.totalViews} views',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: [
          // if (isPortrait && !_isFloating)
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Video Player Section
                  // Container(
                  //   child: _isInitialized
                  //       ? _buildVideoPlayer()
                  //       : const AspectRatio(
                  //           aspectRatio: 16 / 9,
                  //           child: Center(
                  //             child: CustomCircularProgressIndicator(
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  // ),
                  SizedBox(
                    height: isPortrait ? 200: MediaQuery.of(context).size.height-32,
                    child: CustomVideoPlayer(
                      videoUrl: widget.videoUrl,
                      title: widget.talent.title,
                    ),
                  ),
                  Sizer(),
                  _buildVideoInfo(widget.talent),
                  Sizer(height: 32),
                  // Content Section
                  BlocProvider.value(
                    value: serviceLocator<StarCubit>()..loadInitialData(),
                    child: _buildRelatedVideos(),
                  ),
                ],
              ),
            ),
          )
          // else if (!isPortrait)
          //   SafeArea(child: _buildFullScreenVideo()),
          //
          // // Floating player overlay
          // if (_isFloating) _buildFloatingPlayer(),
        ],
      ),
    );
  }
}
//
// class FloatingVideoManager {
//   static OverlayEntry? _overlayEntry;
//
//   // static VideoPlayerController? _controller;
//   // static bool _isPlaying = false;
//   // static StarEntity? _currentTalent;
//   // static String? _currentVideoUrl;
//
//   static void showFloatingPlayer({
//     required BuildContext context,
//     required String videoUrl,
//     required StarEntity talent,
//     required VideoPlayerController controller,
//     required bool isPlaying,
//   }) {
//     // Close existing player if any
//     closeFloatingPlayer();
//
//     // _controller = controller;
//     // _isPlaying = isPlaying;
//     // _currentTalent = talent;
//     // _currentVideoUrl = videoUrl;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => FloatingVideoPlayer(
//         controller: controller,
//         talent: talent,
//         videoUrl: videoUrl,
//         isPlaying: isPlaying,
//       ),
//     );
//
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//   static void closeFloatingPlayer() {
//     if (_overlayEntry != null) {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     }
//     // Don't dispose controller - it's managed by the screen
//     // _controller = null;
//     // _currentTalent = null;
//     // _currentVideoUrl = null;
//   }
//
//   static bool get isPlayerVisible => _overlayEntry != null;
// }
//
// class FloatingVideoPlayer extends StatefulWidget {
//   final VideoPlayerController controller;
//   final StarEntity talent;
//   final String videoUrl;
//   final bool isPlaying;
//
//   const FloatingVideoPlayer({
//     super.key,
//     required this.controller,
//     required this.talent,
//     required this.videoUrl,
//     required this.isPlaying,
//   });
//
//   @override
//   State<FloatingVideoPlayer> createState() => _FloatingVideoPlayerState();
// }
//
// class _FloatingVideoPlayerState extends State<FloatingVideoPlayer> {
//   late bool _isPlaying;
//   late VideoPlayerController _controller;
//   late Offset _position;
//
//   // late Offset _position = Offset(
//   //    MediaQuery.of(navigatorKey.currentContext!).size.width *0.7,
//   //    MediaQuery.of(navigatorKey.currentContext!).size.height * 0.8,
//   //  );
//   bool _showControls = false;
//   bool _isDragging = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller;
//     _isPlaying = widget.isPlaying;
//     if (_isPlaying) {
//       _controller.play();
//     }
//     _position = Offset(
//       MediaQuery.of(navigatorKey.currentContext!).size.width -
//           _floatingSize.width -
//           4,
//       MediaQuery.of(navigatorKey.currentContext!).size.height -
//           _floatingSize.height -
//           4,
//     );
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//     });
//   }
//
//   // Calculate floating player dimensions based on video orientation
//   Size get _floatingSize {
//     var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
//     final baseWidth = _showControls ? width * .9 : width * .6;
//
//     if (!_controller.value.isInitialized) {
//       return Size(baseWidth, baseWidth * 16 / 9); // Default landscape
//     }
//
//     // Use the video's actual dimensions
//     final videoWidth = _controller.value.size.width;
//     final videoHeight = _controller.value.size.height;
//
//     if (videoWidth > videoHeight) {
//       // Landscape video
//       return Size(baseWidth, baseWidth * videoHeight / videoWidth);
//     } else {
//       // Portrait video
//       return Size(baseWidth * videoWidth / videoHeight, baseWidth);
//     }
//   }
//
//   // // Get video rotation angle (for videos with orientation metadata)
//   // double get _rotationAngle {
//   //   if (!_controller.value.isInitialized) return 0;
//   //
//   //   switch (_controller.value.orientation) {
//   //     case 90:
//   //       return -pi / 2; // Rotate -90° for 90° metadata
//   //     case 180:
//   //       return pi; // Rotate 180°
//   //     case 270:
//   //       return pi / 2; // Rotate 90° for 270° metadata
//   //     default:
//   //       return 0;
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: _position.dx,
//       top: _position.dy,
//       child: Material(
//         color: Colors.transparent,
//         child: GestureDetector(
//           onPanStart: (details) {
//             setState(() {
//               _isDragging = true;
//               _showControls = true;
//             });
//           },
//           onPanUpdate: (details) {
//             setState(() {
//               _position = Offset(
//                 _position.dx + details.delta.dx,
//                 _position.dy + details.delta.dy,
//               );
//             });
//           },
//           onPanEnd: (details) {
//             setState(() => _isDragging = false);
//             Future.delayed(const Duration(seconds: 2), () {
//               if (!_isDragging && mounted) {
//                 setState(() => _showControls = false);
//               }
//             });
//           },
//           onTap: () => setState(() => _showControls = !_showControls),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: _floatingSize.width,
//             height: _floatingSize.height,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.5),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 )
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Stack(
//                 children: [
//                   // Video player with rotation support
//                   if (_controller.value.isInitialized)
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: _controller.value.aspectRatio,
//                         child: VideoPlayer(_controller),
//                       ),
//                     )
//                   else
//                     const Center(child: CircularProgressIndicator()),
//
//                   // Floating player controls
//                   if (_showControls)
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         height: 40,
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withValues(alpha: 0.7),
//                               Colors.transparent,
//                             ],
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 widget.talent.title,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close,
//                                   color: Colors.white, size: 20),
//                               onPressed:
//                                   FloatingVideoManager.closeFloatingPlayer,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                   if (_showControls)
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         height: 40,
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                             colors: [
//                               Colors.black.withValues(alpha: 0.7),
//                               Colors.transparent,
//                             ],
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 _isPlaying ? Icons.pause : Icons.play_arrow,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: _togglePlayPause,
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.open_in_full,
//                                   color: Colors.white, size: 20),
//                               onPressed: () {
//                                 FloatingVideoManager.closeFloatingPlayer();
//                                 navigatorKey.currentState!.push(
//                                   MaterialPageRoute(
//                                     builder: (context) => TalentVideoPlayer(
//                                       videoUrl: widget.videoUrl,
//                                       talent: widget.talent,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                   // Small play/pause button when controls are hidden
//                   if (!_showControls)
//                     Center(
//                       child: IconButton(
//                         icon: Icon(
//                           _isPlaying ? Icons.pause : Icons.play_arrow,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         onPressed: _togglePlayPause,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
