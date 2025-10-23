import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';


import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';


class VideoPlayerPage extends StatefulWidget {
  final GetAllTubeVideosEntity video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TubeCubit>();
    if (cubit.state.currentVideo?.id != widget.video.id) {
      cubit.playVideo(widget.video);
    } else {
      cubit.maximizePlayer();
    }
  }

  @override
  void dispose() {
    // if (!context.read<TubeCubit>().state.isMinimized) {
    //   context.read<TubeCubit>().closePlayer();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TubeCubit>().minimizePlayer();
            Navigator.pop(context);
          },
        ),
        actions: [
          // 👇 الزرار الجديد بتاع Background Mode
          // BlocBuilder<TubeCubit, TubeState>(
          //   builder: (context, state) {
          //     return IconButton(
          //       icon: Icon(
          //         state.isBackgroundMode
          //             ? Icons.headset_off
          //             : Icons.headset,
          //         color: state.isBackgroundMode ? Colors.green : Colors.blue,
          //       ),
          //       tooltip: state.isBackgroundMode
          //           ? 'Stop background mode'
          //           : 'Play in background',
          //       onPressed: () async {
          //         final cubit = context.read<TubeCubit>();
          //         final videoUrl = cubit.state.currentVideo?.videoUrl ?? "";
          //
          //         if (videoUrl.isEmpty) {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(
          //               content: Text("No video available for background playback"),
          //               duration: Duration(seconds: 2),
          //             ),
          //           );
          //           return;
          //         }
          //
          //         final newMode = !cubit.isBackgroundMode;
          //         await cubit.toggleBackgroundMode(newMode, videoUrl);
          //
          //         if (context.mounted) {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text(
          //                 newMode
          //                     ? '🎵 Background mode ON - Videos will continue playing'
          //                     : '🛑 Background mode OFF',
          //               ),
          //               duration: const Duration(seconds: 2),
          //               backgroundColor: newMode ? Colors.green : Colors.red,
          //             ),
          //           );
          //         }
          //       },
          //     );
          //   },
          // ),

          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<TubeCubit, TubeState>(
        builder: (context, state) {
          return ListView(
            children: [
              // Video Player Section
              SizedBox(
                height: 400.h,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 300 && !state.isLoading) {
                      context.read<TubeCubit>().minimizePlayer();
                      Navigator.pop(context);
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: state.chewieController?.videoPlayerController.value.aspectRatio ?? 16 / 9,
                    child: state.isLoading ||
                        state.chewieController == null ||
                        !state.chewieController!.videoPlayerController.value.isInitialized
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading video...',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                        : Chewie(controller: state.chewieController!),
                  ),
                ),
              ),

              // Video Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title ??"N/A",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.video.views} • ${widget.video.updatedAt}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildActionButton(Icons.thumb_up_outlined, '12K'),
                    _buildActionButton(Icons.thumb_down_outlined, 'Dislike'),
                    _buildActionButton(Icons.share, 'Share'),
                    _buildActionButton(Icons.download, 'Download'),
                    _buildActionButton(Icons.library_add, 'Save'),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFF272727)),

              // Channel Info
              // Padding(
              //   padding: const EdgeInsets.all(12),
              //   child: Row(
              //     children: [
              //       CircleAvatar(
              //         radius: 20,
              //         backgroundColor: Colors.blue,
              //         child: Text(
              //           widget.video.channel[0],
              //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               widget.video.channel,
              //               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              //             ),
              //             const Text(
              //               '1.2M subscribers',
              //               style: TextStyle(color: Colors.grey, fontSize: 12),
              //             ),
              //           ],
              //         ),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {},
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.red,
              //           foregroundColor: Colors.white,
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //         ),
              //         child: const Text('Subscribe'),
              //       ),
              //     ],
              //   ),
              // ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.video.description?? "N/A",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFF272727)),

              // Comments Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        // Text(
                        //   '${widget.video.comments.length}',
                        //   style: const TextStyle(fontSize: 14, color: Colors.grey),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // // First comment preview
                    // if (widget.video.comments.isNotEmpty)
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CircleAvatar(
                    //         radius: 12,
                    //         backgroundColor: Colors.green,
                    //         child: Text(
                    //           widget.video.comments.first.avatar,
                    //           style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 12),
                    //       Expanded(
                    //         child: Text(
                    //           widget.video.comments.first.text,
                    //           style: const TextStyle(fontSize: 13, color: Colors.white),
                    //           maxLines: 2,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       const Icon(Icons.arrow_drop_down, color: Colors.white),
                    //     ],
                    //   ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFF272727)),

              // All Comments
              // ...widget.video.comments.map((comment) => _buildComment(comment)),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget _buildComment(Comment comment) {
  //   String _formatLikes(int likes) {
  //     if (likes >= 1000) {
  //       return '${(likes / 1000).toStringAsFixed(1)}K';
  //     }
  //     return likes.toString();
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: const BoxDecoration(
  //       border: Border(bottom: BorderSide(color: Color(0xFF272727), width: 0.5)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             CircleAvatar(
  //               radius: 18,
  //               backgroundColor: Colors.green,
  //               child: Text(
  //                 comment.avatar,
  //                 style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text(
  //                         '@${comment.author.toLowerCase().replaceAll(' ', '')}',
  //                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
  //                       ),
  //                       const SizedBox(width: 8),
  //                       Text(
  //                         comment.timeAgo,
  //                         style: const TextStyle(fontSize: 12, color: Colors.grey),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     comment.text,
  //                     style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xFF272727),
  //                           borderRadius: BorderRadius.circular(18),
  //                         ),
  //                         child: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             const Icon(Icons.thumb_up_outlined, size: 16, color: Colors.white),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               _formatLikes(comment.likes),
  //                               style: const TextStyle(fontSize: 12, color: Colors.white),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(width: 8),
  //                       Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xFF272727),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(Icons.thumb_down_outlined, size: 16, color: Colors.white),
  //                       ),
  //                       const SizedBox(width: 16),
  //                       const Text(
  //                         'Reply',
  //                         style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             IconButton(
  //               icon: const Icon(Icons.more_vert, size: 20, color: Colors.white),
  //               onPressed: () {},
  //               padding: EdgeInsets.zero,
  //               constraints: const BoxConstraints(),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


