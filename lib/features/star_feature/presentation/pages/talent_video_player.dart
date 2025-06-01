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
import '../../domain/entity/star_entity.dart';
import 'get_all_talents.dart';

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

    // Add orientation listener
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Reset orientation preferences
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _controller.dispose();
    super.dispose();
  }

  // Toggle play/pause function
  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  // Helper function to format duration
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

  void _toggleFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // Lock to landscape for full-screen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Return to portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  // Widget _buildVideoPlayer() {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(bottom: 5.0),
  //         child: AspectRatio(
  //           aspectRatio:
  //               MediaQuery.of(context).orientation == Orientation.portrait
  //                   ? 16 / 9
  //                   : MediaQuery.of(context).size.aspectRatio,
  //           child: VideoPlayer(_controller),
  //         ),
  //       ),
  //
  //       // Background progress track
  //       Positioned(
  //         bottom: 5,
  //         left: 0,
  //         right: 0,
  //         child: Container(
  //           height: 2,
  //           color: Colors.grey[300],
  //         ),
  //       ),
  //
  //       // Progress indicator (starts from left)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: ValueListenableBuilder<VideoPlayerValue>(
  //           valueListenable: _controller,
  //           builder: (context, value, child) {
  //             if (!value.isInitialized || value.duration == Duration.zero) {
  //               return const SizedBox();
  //             }
  //
  //             final progressFraction =
  //                 value.position.inMilliseconds / value.duration.inMilliseconds;
  //             final safeFraction = progressFraction.clamp(0.0, 1.0);
  //             final screenWidth = MediaQuery.of(context).size.width;
  //
  //             return SizedBox(
  //               height: 10, // Space for thumb circle
  //               child: Stack(
  //                 children: [
  //                   // Progress bar
  //                   Positioned(
  //                     left: 0,
  //                     top: 4, // Vertically center with thumb
  //                     child: Container(
  //                       height: 2,
  //                       width: screenWidth * safeFraction,
  //                       color: AppColors.SECONDARY_COLOR,
  //                     ),
  //                   ),
  //
  //                   // Thumb circle
  //                   Positioned(
  //                     left: screenWidth * safeFraction - 5,
  //                     // Center circle on progress
  //                     child: Container(
  //                       height: 10,
  //                       width: 10,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: AppColors.SECONDARY_COLOR,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //
  //       // Play/Pause button
  //       ValueListenableBuilder<VideoPlayerValue>(
  //         valueListenable: _controller,
  //         builder: (context, value, child) {
  //           return AnimatedOpacity(
  //             opacity: value.isPlaying ? 0.0 : 1.0,
  //             duration: const Duration(milliseconds: 300),
  //             child: IconButton(
  //               icon: Icon(
  //                 value.isPlaying ? Icons.pause : Icons.play_arrow,
  //                 size: 50,
  //                 color: Colors.white.withValues(alpha: 0.8),
  //               ),
  //               onPressed: _togglePlayPause,
  //             ),
  //           );
  //         },
  //       ),
  //
  //       // Time display at bottom left
  //       Positioned(
  //         bottom: 15,
  //         left: 10,
  //         child: ValueListenableBuilder<VideoPlayerValue>(
  //           valueListenable: _controller,
  //           builder: (context, value, child) {
  //             return Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //               decoration: BoxDecoration(
  //                 color: Colors.black54,
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //               child: Text(
  //                 '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //
  //       // Full-screen button (add to Stack children)
  //       Positioned(
  //         bottom: 15,
  //         right: 10,
  //         child: GestureDetector(
  //           onTap: _toggleFullScreen,
  //           child: Container(
  //             padding: const EdgeInsets.all(4),
  //             decoration: BoxDecoration(
  //               color: Colors.black54,
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: Icon(
  //               MediaQuery.of(context).orientation == Orientation.portrait
  //                   ? Icons.fullscreen
  //                   : Icons.fullscreen_exit,
  //               color: Colors.white,
  //               size: 20,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildVideoDetails(StarEntity talent) {
    final createdAt = talent.createdAt ?? DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45.r,
            backgroundImage: talent.user.image.isNotEmpty
                ? CachedNetworkImageProvider(talent.user.image)
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  talent.title,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
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
        ],
      ),
    );
  }

  Widget _buildFullScreenVideo() {
    return Stack(
      children: [
        VideoPlayer(_controller),
        Positioned.fill(child: _buildVideoControls()),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(_controller),
        ),
        Positioned.fill(child: _buildVideoControls()),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background progress track
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: Colors.grey[300],
          ),
        ),

        // Progress indicator
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (!value.isInitialized || value.duration == Duration.zero) {
                return const SizedBox();
              }

              final progressFraction =
                  value.position.inMilliseconds / value.duration.inMilliseconds;
              final safeFraction = progressFraction.clamp(0.0, 1.0);
              final screenWidth = MediaQuery.of(context).size.width;

              return SizedBox(
                height: 10,
                child: Stack(
                  children: [
                    // Progress bar
                    Positioned(
                      left: 0,
                      top: 4,
                      child: Container(
                        height: 2,
                        width: screenWidth * safeFraction,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),

                    // Thumb circle
                    Positioned(
                      left: screenWidth * safeFraction - 5,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Play/Pause button
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: _togglePlayPause,
              ),
            );
          },
        ),

        // Time display
        Positioned(
          bottom: 15,
          left: 10,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),

        // Full-screen button
        Positioned(
          bottom: 15,
          right: 10,
          child: GestureDetector(
            onTap: _toggleFullScreen,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? Icons.fullscreen
                    : Icons.fullscreen_exit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Title', // Replace with actual video title
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // const CircleAvatar(
              //   radius: 20,
              //   // Replace with actual user avatar
              //   backgroundImage: NetworkImage('https://placeholder.com/user'),
              // ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name', // Replace with actual user name
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1K views • 2 days ago', // Replace with actual stats
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up_outlined),
                onPressed: () {
                  // Handle like
                },
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down_outlined),
                onPressed: () {
                  // Handle dislike
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Handle share
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
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
                    SizedBox(
                      width: 120,
                      height: 80,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
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

    return PopScope(
      canPop: isPortrait,
      onPopInvoked: (didPop) {
        if (!didPop && !isPortrait) {
          _toggleFullScreen();
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: isPortrait
            ? SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Video Player Section
                      Container(
                        child: _isInitialized
                            ? _buildVideoPlayer()
                            : const AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Center(
                                  child: CustomCircularProgressIndicator(
                                      color: Colors.white),
                                ),
                              ),
                      ),
                      Sizer(),
                      _buildVideoDetails(widget.talent),
                      Sizer(
                        height: 32,
                      ),
                      // Content Section
                      BlocProvider.value(
                        value: serviceLocator<StarCubit>()
                          // ..loadInitialData()
                          ..getAllTalents(),
                        child: const GetAllTalents(),
                      ),
                    ],
                  ),
                ),
              )
            : SafeArea(child: _buildFullScreenVideo()),
      ),
    );
  }
}
