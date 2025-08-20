// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../common/functions/helper/numbers_helper.dart';
// import '../../../../core/extensions/context_extension.dart';
// import '../../../../core/extensions/string_extension.dart';
// import '../../../../core/widget/custom_circular_progress_indicator.dart';
// import '../controller/cubit/star_cubit.dart';
// import '../controller/cubit/star_state.dart';
// import '../../../../service_locator/service_locator.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:video_player/video_player.dart';

// import '../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../core/extensions/numbers_extensions.dart';
// import '../../../../core/localization/locale_keys.g.dart';
// import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// import '../../domain/entity/star_entity.dart';
// import '../helper/custom_video_player.dart';
// import '../../../../helpers/manage_vibration.dart' as manageVibration;

// class TalentVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final StarEntity talent;
//   final Function(Duration)? onDurationLoaded;

//   const TalentVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     this.onDurationLoaded,
//     required this.talent,
//   });

//   @override
//   State<TalentVideoPlayer> createState() => _TalentVideoPlayerState();
// }

// class _TalentVideoPlayerState extends State<TalentVideoPlayer>
//     with WidgetsBindingObserver {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;

//   // Floating player state
//   final bool _isFloating = false;
//   final Offset _floatingPosition = const Offset(100, 100);
//   bool _isPlaying = true;
//   final bool _showFloatingControls = false;
//   final bool _isDragging = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//         widget.onDurationLoaded?.call(_controller.value.duration);
//         _controller.play();
//       });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     // Only dispose controller if it's not being used by floating player
//     if (!FloatingVideoManager.isPlayerVisible) {
//       _controller.dispose();
//     }
//     // _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   String formatDuration(Duration duration) {
//     if (duration == Duration.zero) return '00:00';

//     final minutes = duration.inMinutes.remainder(60).toString();
//     final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

//     if (duration.inHours > 0) {
//       final hours = duration.inHours.toString();
//       return '$hours:$minutes:$seconds';
//     }

//     return '$minutes:$seconds';
//   }

// //   void _toggleFullScreen() {
// //     if (MediaQuery.of(context).orientation == Orientation.portrait) {
// //       SystemChrome.setPreferredOrientations([
// //         DeviceOrientation.landscapeLeft,
// //         DeviceOrientation.landscapeRight,
// //       ]);
// //     } else {
// //       SystemChrome.setPreferredOrientations([
// //         DeviceOrientation.portraitUp,
// //         DeviceOrientation.portraitDown,
// //       ]);
// //     }
// //   }
// //
// //   void _toggleFloatingMode() {
// //     setState(() {
// //       _isFloating = !_isFloating;
// //       if (_isFloating) {
// //         // Save current position when entering floating mode
// //         _floatingPosition = Offset(
// //           MediaQuery.of(context).size.width - 320,
// //           MediaQuery.of(context).size.height * 0.3,
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget _buildFullScreenVideo() {
// //     return Stack(
// //       children: [
// //         VideoPlayer(_controller),
// //         Positioned.fill(child: _buildVideoControls(isFullScreen: true)),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildVideoPlayer({bool isFloating = false}) {
// //     return Stack(
// //       alignment: Alignment.center,
// //       children: [
// //         Container(
// //           height: 200,
// //           width: double.infinity,
// //           color: Colors.black,
// //         ),
// //         SizedBox(
// //           height: 200,
// //           child: AspectRatio(
// //             aspectRatio: _controller.value.aspectRatio,
// //             child: VideoPlayer(_controller),
// //           ),
// //         ),
// //         if (!isFloating || _showFloatingControls)
// //           Positioned.fill(child: _buildVideoControls(isFloating: isFloating)),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildVideoControls({
// //     bool isFullScreen = false,
// //     bool isFloating = false,
// //   }) {
// //     return Stack(
// //       alignment: Alignment.center,
// //       children: [
// //         // Background progress track
// //         Positioned(
// //           bottom: 4,
// //           left: 0,
// //           right: 0,
// //           child: Container(
// //             height: 2,
// //             color: Colors.grey[300],
// //           ),
// //         ),
// //
// //         // Progress indicator
// //         Positioned(
// //           bottom: 0,
// //           left: 0,
// //           right: 0,
// //           child: ValueListenableBuilder<VideoPlayerValue>(
// //             valueListenable: _controller,
// //             builder: (context, value, child) {
// //               if (!value.isInitialized || value.duration == Duration.zero) {
// //                 return const SizedBox();
// //               }
// //
// //               final progressFraction =
// //                   value.position.inMilliseconds / value.duration.inMilliseconds;
// //               final safeFraction = progressFraction.clamp(0.0, 1.0);
// //               final screenWidth = MediaQuery.of(context).size.width;
// //
// //               return SizedBox(
// //                 height: 10,
// //                 child: Stack(
// //                   children: [
// //                     Positioned(
// //                       left: 0,
// //                       top: 4,
// //                       child: Container(
// //                         height: 2,
// //                         width: screenWidth * safeFraction,
// //                         color: AppColors.SECONDARY_COLOR,
// //                       ),
// //                     ),
// //                     Positioned(
// //                       left: screenWidth * safeFraction - 5,
// //                       child: Container(
// //                         height: 10,
// //                         width: 10,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.circle,
// //                           color: AppColors.SECONDARY_COLOR,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //
// //         // Play/Pause button
// //         ValueListenableBuilder<VideoPlayerValue>(
// //           valueListenable: _controller,
// //           builder: (context, value, child) {
// //             return AnimatedOpacity(
// //               opacity: (value.isPlaying && !isFloating) ? 0.0 : 1.0,
// //               duration: const Duration(milliseconds: 300),
// //               child: IconButton(
// //                 icon: Icon(
// //                   value.isPlaying ? Icons.pause : Icons.play_arrow,
// //                   size: 50,
// //                   color: Colors.white.withValues(alpha: 0.8),
// //                 ),
// //                 onPressed: _togglePlayPause,
// //               ),
// //             );
// //           },
// //         ),
// //
// //         // Time display
// //         if (!isFloating)
// //           Positioned(
// //             bottom: 15,
// //             left: 10,
// //             child: ValueListenableBuilder<VideoPlayerValue>(
// //               valueListenable: _controller,
// //               builder: (context, value, child) {
// //                 return Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                   decoration: BoxDecoration(
// //                     color: Colors.black54,
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                   child: Text(
// //                     '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //
// //         // Full-screen button
// //         if (!isFloating)
// //           Positioned(
// //             bottom: 15,
// //             right: 10,
// //             child: GestureDetector(
// //               onTap: _toggleFullScreen,
// //               child: Container(
// //                 padding: const EdgeInsets.all(4),
// //                 decoration: BoxDecoration(
// //                   color: Colors.black54,
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Icon(
// //                   MediaQuery.of(context).orientation == Orientation.portrait
// //                       ? Icons.fullscreen
// //                       : Icons.fullscreen_exit,
// //                   color: Colors.white,
// //                   size: 20,
// //                 ),
// //               ),
// //             ),
// //           ),
// // // Floating mode button
// //         if (!isFullScreen)
// //           Positioned(
// //             top: 10,
// //             right: 50,
// //             child: GestureDetector(
// //               onTap: () {
// //                 FloatingVideoManager.showFloatingPlayer(
// //                   context: context,
// //                   videoUrl: widget.videoUrl,
// //                   talent: widget.talent,
// //                   controller: _controller,
// //                   isPlaying: _isPlaying,
// //                 );
// //                 Navigator.pop(context); // Go back to previous screen
// //               },
// //               child: Container(
// //                 padding: const EdgeInsets.all(5),
// //                 decoration: BoxDecoration(
// //                   color: Colors.black54,
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: const Icon(Icons.picture_in_picture,
// //                     color: Colors.white, size: 20),
// //               ),
// //             ),
// //           ),
// //         // Floating mode button
// //         // if (!isFullScreen && !isFloating)
// //         //   Positioned(
// //         //     top: 10,
// //         //     right: 50,
// //         //     child: GestureDetector(
// //         //       onTap: _toggleFloatingMode,
// //         //       child: Container(
// //         //         padding: const EdgeInsets.all(5),
// //         //         decoration: BoxDecoration(
// //         //           color: Colors.black54,
// //         //           borderRadius: BorderRadius.circular(20),
// //         //         ),
// //         //         child: const Icon(Icons.picture_in_picture, color: Colors.white, size: 20),
// //         //       ),
// //         //     ),
// //         //   ),
// //       ],
// //     );
// //   }

//   // Widget _buildFloatingPlayer() {
//   //   return Positioned(
//   //     left: _floatingPosition.dx,
//   //     top: _floatingPosition.dy,
//   //     child: GestureDetector(
//   //       onPanStart: (details) {
//   //         setState(() {
//   //           _isDragging = true;
//   //           _showFloatingControls = true;
//   //         });
//   //       },
//   //       onPanUpdate: (details) {
//   //         setState(() {
//   //           _floatingPosition = Offset(
//   //             _floatingPosition.dx + details.delta.dx,
//   //             _floatingPosition.dy + details.delta.dy,
//   //           );
//   //         });
//   //       },
//   //       onPanEnd: (details) {
//   //         setState(() {
//   //           _isDragging = false;
//   //         });
//   //         // Hide controls after a delay
//   //         Future.delayed(const Duration(seconds: 2), () {
//   //           if (!_isDragging) {
//   //             setState(() {
//   //               _showFloatingControls = false;
//   //             });
//   //           }
//   //         });
//   //       },
//   //       onTap: () {
//   //         setState(() {
//   //           _showFloatingControls = !_showFloatingControls;
//   //         });
//   //       },
//   //       child: AnimatedContainer(
//   //         duration: const Duration(milliseconds: 300),
//   //         width: _showFloatingControls ? 300 : 160,
//   //         height: _showFloatingControls ? 200 : 100,
//   //         decoration: BoxDecoration(
//   //           color: Colors.black,
//   //           borderRadius: BorderRadius.circular(12),
//   //           boxShadow: [
//   //             BoxShadow(
//   //               color: Colors.black.withValues(alpha: 0.5),
//   //               blurRadius: 10,
//   //               spreadRadius: 2,
//   //             )
//   //           ],
//   //         ),
//   //         child: ClipRRect(
//   //           borderRadius: BorderRadius.circular(12),
//   //           child: Stack(
//   //             children: [
//   //               _buildVideoPlayer(isFloating: true),
//   //
//   //               // Floating player controls
//   //               if (_showFloatingControls)
//   //                 Positioned(
//   //                   top: 0,
//   //                   left: 0,
//   //                   right: 0,
//   //                   child: Container(
//   //                     height: 40,
//   //                     padding: const EdgeInsets.symmetric(horizontal: 8),
//   //                     decoration: BoxDecoration(
//   //                       gradient: LinearGradient(
//   //                         begin: Alignment.topCenter,
//   //                         end: Alignment.bottomCenter,
//   //                         colors: [
//   //                           Colors.black.withValues(alpha: 0.7),
//   //                           Colors.transparent,
//   //                         ],
//   //                       ),
//   //                     ),
//   //                     child: Row(
//   //                       children: [
//   //                         Expanded(
//   //                           child: Text(
//   //                             widget.talent.title,
//   //                             maxLines: 1,
//   //                             overflow: TextOverflow.ellipsis,
//   //                             style: const TextStyle(
//   //                               color: Colors.white,
//   //                               fontSize: 14,
//   //                               fontWeight: FontWeight.bold,
//   //                             ),
//   //                           ),
//   //                         ),
//   //                         IconButton(
//   //                           icon: const Icon(Icons.close,
//   //                               color: Colors.white, size: 20),
//   //                           onPressed: _toggleFloatingMode,
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ),
//   //
//   //               if (_showFloatingControls)
//   //                 Positioned(
//   //                   bottom: 0,
//   //                   left: 0,
//   //                   right: 0,
//   //                   child: Container(
//   //                     height: 40,
//   //                     padding: const EdgeInsets.symmetric(horizontal: 8),
//   //                     decoration: BoxDecoration(
//   //                       gradient: LinearGradient(
//   //                         begin: Alignment.bottomCenter,
//   //                         end: Alignment.topCenter,
//   //                         colors: [
//   //                           Colors.black.withValues(alpha: 0.7),
//   //                           Colors.transparent,
//   //                         ],
//   //                       ),
//   //                     ),
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.center,
//   //                       children: [
//   //                         IconButton(
//   //                           icon: Icon(
//   //                             _isPlaying ? Icons.pause : Icons.play_arrow,
//   //                             color: Colors.white,
//   //                             size: 20,
//   //                           ),
//   //                           onPressed: _togglePlayPause,
//   //                         ),
//   //                         IconButton(
//   //                           icon: const Icon(Icons.fullscreen,
//   //                               color: Colors.white, size: 20),
//   //                           onPressed: _toggleFullScreen,
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ),
//   //
//   //               // Small play/pause button when controls are hidden
//   //               if (!_showFloatingControls)
//   //                 Center(
//   //                   child: IconButton(
//   //                     icon: Icon(
//   //                       _isPlaying ? Icons.pause : Icons.play_arrow,
//   //                       color: Colors.white,
//   //                       size: 24,
//   //                     ),
//   //                     onPressed: _togglePlayPause,
//   //                   ),
//   //                 ),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildVideoInfo(StarEntity talent) {
//     final createdAt = talent.createdAt ?? DateTime.now();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             talent.title, // Replace with actual video title
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             "${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
//             // Replace with actual stats
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               SizedBox(
//                 width: 32,
//                 height: 32,
//                 child: ProfileWithStoriesBorder(
//                   profilePictureUrl: talent.user.image ?? '',
//                   storiesCount: talent.storyCount ?? 0,
//                 ),
//               ),
//               // CircleAvatar(
//               //   radius: 15,
//               //   backgroundImage: talent.user.image.isNotEmpty
//               //       ? CachedNetworkImageProvider(talent.user.image)
//               //       : null,
//               // ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${talent.user.firstName} ${talent.user.lastName}',
//                       // Replace with actual user name
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ...List.generate(
//                 5,
//                 (index) => Padding(
//                   padding: const EdgeInsets.only(right: 4.0),
//                   child: Image.asset(
//                     index < talent.averageRating.floor()
//                         ? "assets/49-New-icons/star_gold.png"
//                         : "assets/49-New-icons/star.png",
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               // IconButton(
//               //   icon: const Icon(Icons.thumb_up_outlined),
//               //   onPressed: () {
//               //     // Handle like
//               //   },
//               // ),
//               // IconButton(
//               //   icon: const Icon(Icons.thumb_down_outlined),
//               //   onPressed: () {
//               //     // Handle dislike
//               //   },
//               // ),
//               // IconButton(
//               //   icon: const Icon(Icons.share),
//               //   onPressed: () {
//               //     // Handle share
//               //   },
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRelatedVideos() {
//     return BlocBuilder<StarCubit, StarState>(
//       builder: (context, state) {
//         print('Status==> ${state.status}');
//         if (state.status == StarStates.loading && state.star == null) {
//           return const Center(child: CustomCircularProgressIndicator());
//         }

//         final videos = state.star ?? [];

//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: videos.length,
//           itemBuilder: (context, index) {
//             final video = videos[index];
//             final mediaUrl =
//                 video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';

//             if (mediaUrl.isEmpty || mediaUrl == widget.videoUrl) {
//               return const SizedBox();
//             }

//             return InkWell(
//               onTap: () {
//       manageVibration.ManageVibration.vibrate();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TalentVideoPlayer(
//                       videoUrl: mediaUrl,
//                       talent: video,
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Thumbnail
//                     Container(
//                       width: 120,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey[300],
//                       ),
//                       clipBehavior: Clip.hardEdge,
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           if (!mediaUrl.toLowerCase().contains('.mp4'))
//                             CachedNetworkImage(
//                               imageUrl: mediaUrl,
//                               fit: BoxFit.cover,
//                               placeholder: (context, url) => Container(
//                                 color: Colors.grey[300],
//                                 child: const Center(
//                                     child: CustomCircularProgressIndicator()),
//                               ),
//                               errorWidget: (context, url, error) => Container(
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.error),
//                               ),
//                             ),
//                           if (mediaUrl.toLowerCase().contains('.mp4'))
//                             const Center(
//                               child: Icon(
//                                 Icons.play_circle_fill,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Video info
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             video.title,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${video.user.firstName} • ${video.totalViews} views',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // if (isPortrait && !_isFloating)
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Video Player Section
//                   // Container(
//                   //   child: _isInitialized
//                   //       ? _buildVideoPlayer()
//                   //       : const AspectRatio(
//                   //           aspectRatio: 16 / 9,
//                   //           child: Center(
//                   //             child: CustomCircularProgressIndicator(
//                   //               color: Colors.white,
//                   //             ),
//                   //           ),
//                   //         ),
//                   // ),
//                   SizedBox(
//                     height: isPortrait ? 200: MediaQuery.of(context).size.height-32,
//                     child: CustomVideoPlayer(
//                       videoUrl: widget.videoUrl,
//                       title: widget.talent.title,
//                       inFocus: true,
//                     ),
//                   ),
//                   Sizer(),
//                   _buildVideoInfo(widget.talent),
//                   Sizer(height: 32),
//                   // Content Section
//                   BlocProvider.value(
//                     value: serviceLocator<StarCubit>()..loadInitialData(),
//                     child: _buildRelatedVideos(),
//                   ),
//                 ],
//               ),
//             ),
//           )
//           // else if (!isPortrait)
//           //   SafeArea(child: _buildFullScreenVideo()),
//           //
//           // // Floating player overlay
//           // if (_isFloating) _buildFloatingPlayer(),
//         ],
//       ),
//     );
//   }
// }
// //
// // class FloatingVideoManager {
// //   static OverlayEntry? _overlayEntry;
// //
// //   // static VideoPlayerController? _controller;
// //   // static bool _isPlaying = false;
// //   // static StarEntity? _currentTalent;
// //   // static String? _currentVideoUrl;
// //
// //   static void showFloatingPlayer({
// //     required BuildContext context,
// //     required String videoUrl,
// //     required StarEntity talent,
// //     required VideoPlayerController controller,
// //     required bool isPlaying,
// //   }) {
// //     // Close existing player if any
// //     closeFloatingPlayer();
// //
// //     // _controller = controller;
// //     // _isPlaying = isPlaying;
// //     // _currentTalent = talent;
// //     // _currentVideoUrl = videoUrl;
// //
// //     _overlayEntry = OverlayEntry(
// //       builder: (context) => FloatingVideoPlayer(
// //         controller: controller,
// //         talent: talent,
// //         videoUrl: videoUrl,
// //         isPlaying: isPlaying,
// //       ),
// //     );
// //
// //     Overlay.of(context).insert(_overlayEntry!);
// //   }
// //
// //   static void closeFloatingPlayer() {
// //     if (_overlayEntry != null) {
// //       _overlayEntry?.remove();
// //       _overlayEntry = null;
// //     }
// //     // Don't dispose controller - it's managed by the screen
// //     // _controller = null;
// //     // _currentTalent = null;
// //     // _currentVideoUrl = null;
// //   }
// //
// //   static bool get isPlayerVisible => _overlayEntry != null;
// // }
// //
// // class FloatingVideoPlayer extends StatefulWidget {
// //   final VideoPlayerController controller;
// //   final StarEntity talent;
// //   final String videoUrl;
// //   final bool isPlaying;
// //
// //   const FloatingVideoPlayer({
// //     super.key,
// //     required this.controller,
// //     required this.talent,
// //     required this.videoUrl,
// //     required this.isPlaying,
// //   });
// //
// //   @override
// //   State<FloatingVideoPlayer> createState() => _FloatingVideoPlayerState();
// // }
// //
// // class _FloatingVideoPlayerState extends State<FloatingVideoPlayer> {
// //   late bool _isPlaying;
// //   late VideoPlayerController _controller;
// //   late Offset _position;
// //
// //   // late Offset _position = Offset(
// //   //    MediaQuery.of(navigatorKey.currentContext!).size.width *0.7,
// //   //    MediaQuery.of(navigatorKey.currentContext!).size.height * 0.8,
// //   //  );
// //   bool _showControls = false;
// //   bool _isDragging = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = widget.controller;
// //     _isPlaying = widget.isPlaying;
// //     if (_isPlaying) {
// //       _controller.play();
// //     }
// //     _position = Offset(
// //       MediaQuery.of(navigatorKey.currentContext!).size.width -
// //           _floatingSize.width -
// //           4,
// //       MediaQuery.of(navigatorKey.currentContext!).size.height -
// //           _floatingSize.height -
// //           4,
// //     );
// //   }
// //
// //   void _togglePlayPause() {
// //     setState(() {
// //       _isPlaying = !_isPlaying;
// //       _isPlaying ? _controller.play() : _controller.pause();
// //     });
// //   }
// //
// //   // Calculate floating player dimensions based on video orientation
// //   Size get _floatingSize {
// //     var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
// //     final baseWidth = _showControls ? width * .9 : width * .6;
// //
// //     if (!_controller.value.isInitialized) {
// //       return Size(baseWidth, baseWidth * 16 / 9); // Default landscape
// //     }
// //
// //     // Use the video's actual dimensions
// //     final videoWidth = _controller.value.size.width;
// //     final videoHeight = _controller.value.size.height;
// //
// //     if (videoWidth > videoHeight) {
// //       // Landscape video
// //       return Size(baseWidth, baseWidth * videoHeight / videoWidth);
// //     } else {
// //       // Portrait video
// //       return Size(baseWidth * videoWidth / videoHeight, baseWidth);
// //     }
// //   }
// //
// //   // // Get video rotation angle (for videos with orientation metadata)
// //   // double get _rotationAngle {
// //   //   if (!_controller.value.isInitialized) return 0;
// //   //
// //   //   switch (_controller.value.orientation) {
// //   //     case 90:
// //   //       return -pi / 2; // Rotate -90° for 90° metadata
// //   //     case 180:
// //   //       return pi; // Rotate 180°
// //   //     case 270:
// //   //       return pi / 2; // Rotate 90° for 270° metadata
// //   //     default:
// //   //       return 0;
// //   //   }
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Positioned(
// //       left: _position.dx,
// //       top: _position.dy,
// //       child: Material(
// //         color: Colors.transparent,
// //         child: GestureDetector(
// //           onPanStart: (details) {
// //             setState(() {
// //               _isDragging = true;
// //               _showControls = true;
// //             });
// //           },
// //           onPanUpdate: (details) {
// //             setState(() {
// //               _position = Offset(
// //                 _position.dx + details.delta.dx,
// //                 _position.dy + details.delta.dy,
// //               );
// //             });
// //           },
// //           onPanEnd: (details) {
// //             setState(() => _isDragging = false);
// //             Future.delayed(const Duration(seconds: 2), () {
// //               if (!_isDragging && mounted) {
// //                 setState(() => _showControls = false);
// //               }
// //             });
// //           },
// //           onTap: () => setState(() => _showControls = !_showControls),
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 300),
// //             width: _floatingSize.width,
// //             height: _floatingSize.height,
// //             decoration: BoxDecoration(
// //               color: Colors.black,
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withValues(alpha: 0.5),
// //                   blurRadius: 10,
// //                   spreadRadius: 2,
// //                 )
// //               ],
// //             ),
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(12),
// //               child: Stack(
// //                 children: [
// //                   // Video player with rotation support
// //                   if (_controller.value.isInitialized)
// //                     Center(
// //                       child: AspectRatio(
// //                         aspectRatio: _controller.value.aspectRatio,
// //                         child: VideoPlayer(_controller),
// //                       ),
// //                     )
// //                   else
// //                     const Center(child: CircularProgressIndicator()),
// //
// //                   // Floating player controls
// //                   if (_showControls)
// //                     Positioned(
// //                       top: 0,
// //                       left: 0,
// //                       right: 0,
// //                       child: Container(
// //                         height: 40,
// //                         padding: const EdgeInsets.symmetric(horizontal: 8),
// //                         decoration: BoxDecoration(
// //                           gradient: LinearGradient(
// //                             begin: Alignment.topCenter,
// //                             end: Alignment.bottomCenter,
// //                             colors: [
// //                               Colors.black.withValues(alpha: 0.7),
// //                               Colors.transparent,
// //                             ],
// //                           ),
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             Expanded(
// //                               child: Text(
// //                                 widget.talent.title,
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis,
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                             IconButton(
// //                               icon: const Icon(Icons.close,
// //                                   color: Colors.white, size: 20),
// //                               onPressed:
// //                                   FloatingVideoManager.closeFloatingPlayer,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //
// //                   if (_showControls)
// //                     Positioned(
// //                       bottom: 0,
// //                       left: 0,
// //                       right: 0,
// //                       child: Container(
// //                         height: 40,
// //                         padding: const EdgeInsets.symmetric(horizontal: 8),
// //                         decoration: BoxDecoration(
// //                           gradient: LinearGradient(
// //                             begin: Alignment.bottomCenter,
// //                             end: Alignment.topCenter,
// //                             colors: [
// //                               Colors.black.withValues(alpha: 0.7),
// //                               Colors.transparent,
// //                             ],
// //                           ),
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             IconButton(
// //                               icon: Icon(
// //                                 _isPlaying ? Icons.pause : Icons.play_arrow,
// //                                 color: Colors.white,
// //                                 size: 20,
// //                               ),
// //                               onPressed: _togglePlayPause,
// //                             ),
// //                             IconButton(
// //                               icon: const Icon(Icons.open_in_full,
// //                                   color: Colors.white, size: 20),
// //                               onPressed: () {
// //                                 FloatingVideoManager.closeFloatingPlayer();
// //                                 navigatorKey.currentState!.push(
// //                                   MaterialPageRoute(
// //                                     builder: (context) => TalentVideoPlayer(
// //                                       videoUrl: widget.videoUrl,
// //                                       talent: widget.talent,
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //
// //                   // Small play/pause button when controls are hidden
// //                   if (!_showControls)
// //                     Center(
// //                       child: IconButton(
// //                         icon: Icon(
// //                           _isPlaying ? Icons.pause : Icons.play_arrow,
// //                           color: Colors.white,
// //                           size: 24,
// //                         ),
// //                         onPressed: _togglePlayPause,
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

//!
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/functions/helper/numbers_helper.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import '../../../../service_locator/service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../core/extensions/numbers_extensions.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../domain/entity/star_entity.dart';
import '../helper/custom_video_player.dart';
import '../../../../helpers/manage_vibration.dart' as manageVibration;
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';

//!

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
  bool _isPlaying = true;
  bool _showControls = false;
  bool _showFullDescription = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSubscribed = false;
  bool _isFullscreen = false;
  Timer? _hideControlsTimer;
  bool _isDragging = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data - replace with actual data
  List<String> comments = [
    "Will AI Replace this Ui Ux Designers Skills and Jobs if they take What The Purpose of Learning...",
    "Amazing video! Keep it up! 👏",
    "This is so helpful, thank you for sharing",
    "Love your content, can't wait for more videos",
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        widget.onDurationLoaded?.call(_controller.value.duration);
        _controller.play();
      });
  }

  @override
  void didChangeMetrics() {
    final orientation = MediaQuery.of(context).orientation;
    setState(() {
      _isFullscreen = orientation == Orientation.landscape;
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    // Only dispose controller if not used by floating player
    if (!FloatingVideoManager.isPlayerVisible) {
      _controller.dispose();
    }
    // _controller.dispose();
    _commentController.dispose();
    _scrollController.dispose();
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
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _seekToPosition(double localX, double maxWidth) {
    if (_controller.value.duration.inMilliseconds > 0) {
      final position = (localX / maxWidth).clamp(0.0, 1.0);
      final duration = _controller.value.duration;
      final newPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).round(),
      );
      _controller.seekTo(newPosition);
      _performHapticFeedback();
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showControls && !_isDragging) {
        setState(() => _showControls = false);
      }
    });
  }

// إضافة method للـ haptic feedback
  void _performHapticFeedback() {
    HapticFeedback.selectionClick();
  }

  Widget _buildVideoPlayer() {
    final screenSize = MediaQuery.of(context).size;
    final videoHeight = _isFullscreen ? screenSize.height : 250.0;

    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) {
          _startHideControlsTimer();
        }
      },
      // إضافة onPanUpdate للـ fullscreen controls
      onPanUpdate: _isFullscreen
          ? (details) {
              if (!_showControls) {
                setState(() => _showControls = true);
                _startHideControlsTimer();
              }
            }
          : null,
      child: Container(
        height: videoHeight,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Video Player
            if (_isInitialized)
              Center(
                child: _isFullscreen
                    ? VideoPlayer(_controller)
                    : AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Controls Overlay
            if (_showControls) ...[
              // Top Controls
              Positioned(
                top: _isFullscreen ? 24 : 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button مع تحسين الـ navigation
                    GestureDetector(
                      onTap: () {
                        _performHapticFeedback();
                        if (_isFullscreen) {
                          _toggleFullscreen();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFullscreen
                              ? Icons
                                  .fullscreen_exit // تغيير الأيقونة في fullscreen
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Right controls
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cast feature coming soon')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cast,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.flag),
                                      title: const Text('Report'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.info),
                                      title: const Text('Video info'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            FloatingVideoManager.showFloatingPlayer(
                              context: context,
                              videoUrl: widget.videoUrl,
                              title: widget.talent.title,
                              controller: _controller,
                              isPlaying: _isPlaying,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.picture_in_picture,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Center Controls (Play/Pause) مع تحسين الـ haptic
              if (_isInitialized)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Previous video')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          _togglePlayPause();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Next video')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Controls مع تحسين المؤشر
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20,
                    bottom: _isFullscreen ? 20 : 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Time and Fullscreen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time
                          if (_isInitialized)
                            ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: _controller,
                              builder: (context, value, child) {
                                return Text(
                                  '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),

                          // Fullscreen button
                          GestureDetector(
                            onTap: () {
                              _performHapticFeedback();
                              _toggleFullscreen();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                _isFullscreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Progress Bar محسن
                      if (_isInitialized)
                        ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            final progress = value.duration.inMilliseconds > 0
                                ? value.position.inMilliseconds /
                                    value.duration.inMilliseconds
                                : 0.0;

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return GestureDetector(
                                  onTapDown: (details) {
                                    _performHapticFeedback();
                                    _seekToPosition(details.localPosition.dx,
                                        constraints.maxWidth);
                                  },
                                  onHorizontalDragStart: (details) {
                                    setState(() => _isDragging = true);
                                    _hideControlsTimer?.cancel();
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    _seekToPosition(details.localPosition.dx,
                                        constraints.maxWidth);
                                  },
                                  onHorizontalDragEnd: (details) {
                                    setState(() => _isDragging = false);
                                    _startHideControlsTimer();
                                  },
                                  child: Container(
                                    height: 24,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        // Background track
                                        Container(
                                          height: 4,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        // Progress bar
                                        Container(
                                          height: 4,
                                          width: constraints.maxWidth *
                                              progress.clamp(0.0, 1.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        // Thumb (Circle) مع إصلاح المشكلة
                                        Positioned(
                                          left: (constraints.maxWidth *
                                                      progress.clamp(0.0, 1.0) -
                                                  8)
                                              .clamp(0.0,
                                                  constraints.maxWidth - 16),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    final createdAt = widget.talent.createdAt ?? DateTime.now();
    final description =
        "Build your design system - Lesson 3 : Introduction to design systems. In this comprehensive tutorial, we'll explore the fundamentals of creating scalable design systems that can grow with your product and team. Learn about component libraries, design tokens, and best practices for maintaining consistency across your digital products.";
    final shouldShowMore = description.length > 80;
    final displayedDescription = _showFullDescription || !shouldShowMore
        ? description
        : '${description.substring(0, 80)}...';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Title
          Text(
            widget.talent.title.isNotEmpty
                ? widget.talent.title
                : "Build your design system - Lesson 3 : Introduction to design systems",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Views, Date, and More
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "270K views",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    " • ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    timeago.format(createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    " • ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Config 2022",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // const Spacer(),
              if (shouldShowMore)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFullDescription = !_showFullDescription;
                    });
                  },
                  child: Text(
                    _showFullDescription ? "...less" : "...more",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          // Show description if expanded
          if (_showFullDescription && shouldShowMore) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // User Info Row
          Row(
            children: [
              // Profile Picture
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: widget.talent.user.image.isNotEmpty == true
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.talent.user.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.black,
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
              ),
              const SizedBox(width: 12),

              // Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.talent.user.firstName.isNotEmpty
                          ? widget.talent.user.firstName
                          : 'Figma',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '62.4K subscribers',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Subscribe/Bell Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSubscribed = !_isSubscribed;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(_isSubscribed ? 'Subscribed!' : 'Unsubscribed'),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isSubscribed ? Colors.red : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSubscribed
                            ? Icons.notifications
                            : Icons.notifications_none,
                        size: 18,
                        color: _isSubscribed ? Colors.white : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isSubscribed ? 'Subscribed' : 'Subscribe',
                        style: TextStyle(
                          color:
                              _isSubscribed ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!_isSubscribed) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  '652',
                  () {
                    setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) _isDisliked = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(_isLiked ? 'Liked!' : 'Like removed')),
                    );
                  },
                  isActive: _isLiked,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                  '',
                  () {
                    setState(() {
                      _isDisliked = !_isDisliked;
                      if (_isDisliked) _isLiked = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              _isDisliked ? 'Disliked!' : 'Dislike removed')),
                    );
                  },
                  isActive: _isDisliked,
                ),
                const SizedBox(width: 8),
                _buildActionButton(Icons.share, 'Share', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Share Video',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.copy),
                            title: const Text('Copy link'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Link copied to clipboard')),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('Share via...'),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                _buildActionButton(Icons.download, 'Download', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download started')),
                  );
                }),
                const SizedBox(width: 8),
                _buildActionButton(Icons.more_horiz, '', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.save_alt),
                            title: const Text('Save to playlist'),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: const Icon(Icons.flag),
                            title: const Text('Report'),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.blue[700] : Colors.grey[700],
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.blue[700] : Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comments Header
          Row(
            children: [
              Text(
                'Comments',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${comments.length}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Comments List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) =>
                _buildCommentItem(comments[index], index),
          ),

          const SizedBox(height: 24),

          // Add Comment Section
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.grey[600]),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            comments.insert(0, _commentController.text);
                            _commentController.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comment added')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String comment, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Comment Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'User ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format(
                        DateTime.now().subtract(Duration(hours: index + 1))),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment liked')),
                      );
                    },
                    child: Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${12 - index}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment disliked')),
                      );
                    },
                    child: Icon(
                      Icons.thumb_down_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reply to comment')),
                      );
                    },
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // More options
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text('Report comment'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.block),
                      title: const Text('Block user'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(
            Icons.more_vert,
            size: 18,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedVideos() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Related Videos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          // Related videos list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Show 5 related videos
            itemBuilder: (context, index) => _buildRelatedVideoItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideoItem(int index) {
    final List<String> videoTitles = [
      'Config 2022 Opening Keynote - Dylan Field',
      'Design Systems at Scale - Advanced Techniques',
      'Component Libraries: Best Practices',
      'Figma Auto Layout Tutorial',
      'Building Design Tokens for Consistency',
    ];

    final List<String> channelNames = [
      'Figma',
      'Design System Hub',
      'UI/UX Academy',
      'Figma Academy',
      'Design Tools Pro',
    ];

    final List<String> viewCounts = [
      '1.2M views',
      '850K views',
      '640K views',
      '420K views',
      '380K views',
    ];

    final List<String> durations = [
      '12:40',
      '8:25',
      '15:30',
      '6:15',
      '11:45',
    ];

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${videoTitles[index]}...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Placeholder for video thumbnail
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[400]!,
                          Colors.grey[600]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white.withOpacity(0.8),
                        size: 40,
                      ),
                    ),
                  ),
                  // Duration overlay
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        durations[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                    videoTitles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        channelNames[index],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${viewCounts[index]} • ${2 + index} years ago',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // More options
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.watch_later),
                          title: const Text('Save to Watch Later'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.playlist_add),
                          title: const Text('Add to playlist'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.not_interested),
                          title: const Text('Not interested'),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      // Fullscreen mode - only show video player
      return Scaffold(
        backgroundColor: Colors.black,
        body: _buildVideoPlayer(),
      );
    }

    // Normal mode - show everything
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player (Fixed)
            _buildVideoPlayer(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Video Info
                    _buildVideoInfo(),

                    // Divider
                    Container(
                      height: 8,
                      color: Colors.grey[100],
                    ),

                    // Comments Section
                    _buildCommentsSection(),

                    // Divider
                    Container(
                      height: 8,
                      color: Colors.grey[100],
                    ),

                    // Related Videos
                    _buildRelatedVideos(),

                    // Bottom padding for better scrolling experience
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
