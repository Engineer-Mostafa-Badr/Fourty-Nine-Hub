import 'package:flutter/material.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../service_locator/service_locator.dart';
import 'get_all_talents.dart';

class TalentVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Function(Duration)? onDurationLoaded;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onDurationLoaded,
  });

  @override
  State<TalentVideoPlayer> createState() => _TalentVideoPlayerState();
}

class _TalentVideoPlayerState extends State<TalentVideoPlayer> {
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer(_controller)),

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
                    builder: (context) => TalentVideoPlayer(videoUrl: mediaUrl),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Video Player Section
              Container(
                color: Colors.black,
                child: _isInitialized
                    ? _buildVideoPlayer()
                    : const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Center(
                          child: CustomCircularProgressIndicator(color: Colors.white),
                        ),
                      ),
              ),
              Sizer(),
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
      ),
    );
  }
}
