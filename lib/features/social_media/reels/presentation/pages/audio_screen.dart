// import 'dart:developer';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:video_player/video_player.dart';
//
// import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
//
// /// InstagramAudioScreen is a stateful widget displaying a more complex audio screen with play/pause functionality.
// ///
// ///
// ///
//
// class InstagramAudioScreen extends StatefulWidget {
//   final Audio audio;
//
//   const InstagramAudioScreen({super.key, required this.audio});
//
//   @override
//   State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
// }
//
// class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
//   late AudioPlayer _player;
//   bool _hasError = false;
//   bool _isCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<ReelsCubit>().fetchReelsWithSameAudio(widget.audio.id);
//
//     _player = AudioPlayer();
//
//     // Listen to the player state stream for completion
//     _player.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         setState(() {
//           _isCompleted = true;
//           _player.seek(Duration.zero).then((value) => _player.pause());
//         });
//       }
//     });
//
//     _initializeAudio();
//   }
//
//   Future<void> _initializeAudio() async {
//     try {
//       await _player.setUrl(widget.audio.audioSignedUrl);
//       // _player.play();
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//       });
//       log('Error loading audio: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     if (_isCompleted) {
//       // Restart the audio if it has completed
//       _player.seek(Duration.zero);
//       setState(() {
//         _isCompleted = false;
//       });
//     }
//
//     setState(() {
//       if (_player.playing) {
//         _player.pause();
//       } else {
//         _player.play();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reelCubit = context.watch<ReelsCubit>();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: const Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//         ),
//         title: const Text('Audio',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//         actions: const [
//           Icon(
//             Icons.share,
//             color: Colors.white,
//           ),
//           SizedBox(width: 16),
//           Icon(Icons.bookmark, color: Colors.white),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                     widget.audio.audioPicture,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         capitalizeAndSplit(widget.audio.audioName),
//                         softWrap: true,
//                         style: const TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(capitalizeAndSplit(widget.audio.username),
//                           style: const TextStyle(color: Colors.white)),
//                       Text('${widget.audio.reelsCount} reels',
//                           style: const TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Center(
//             child: SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 32.0),
//                 child: ElevatedButton(
//                   style: const ButtonStyle(
//                       backgroundColor: MaterialStatePropertyAll(
//                           AppColors.PRIMARY_COLOR_DARK)),
//                   onPressed: () {
//                     _player.dispose();
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ReelsRecordingScreen(
//                                 voiceUrl: widget.audio.audioSignedUrl,
//                               ),
//                         ));
//                   },
//                   child: const Text(
//                     'Use audio',
//                     textScaler: TextScaler.linear(1.1),
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           _hasError
//               ? const Center(
//             child: Text(
//               'Failed to load audio!',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           )
//               : Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 StreamBuilder<PlayerState>(
//                   stream: _player.playerStateStream,
//                   builder: (context, snapshot) {
//                     final playerState = snapshot.data;
//                     // final processingState = playerState?.processingState;
//                     final playing = playerState?.playing;
//                     // if (processingState == ProcessingState.loading ||
//                     //     processingState == ProcessingState.buffering) {
//                     //   return const CupertinoActivityIndicator();
//                     // } else
//                     if (playing != true) {
//                       return IconButton(
//                         icon: const Icon(Icons.play_arrow,
//                             color: Colors.white),
//                         onPressed: _togglePlayPause,
//                       );
//                     } else {
//                       return IconButton(
//                         icon:
//                         const Icon(Icons.pause, color: Colors.white),
//                         onPressed: _togglePlayPause,
//                       );
//                     }
//                   },
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.0),
//                     child: StreamBuilder<Duration>(
//                       stream: _player.positionStream,
//                       builder: (context, snapshot) {
//                         final position = snapshot.data ?? Duration.zero;
//                         final duration =
//                             _player.duration ?? Duration.zero;
//
//                         // Ensure the slider value is within bounds
//                         double sliderValue =
//                         position.inMilliseconds.toDouble();
//                         if (sliderValue >
//                             duration.inMilliseconds.toDouble()) {
//                           sliderValue =
//                               duration.inMilliseconds.toDouble();
//                         }
//
//                         return Slider(
//                           value: sliderValue,
//                           max: duration.inMilliseconds.toDouble(),
//                           onChanged: (value) {
//                             _player.seek(
//                                 Duration(milliseconds: value.toInt()));
//                           },
//                           activeColor: Colors.white,
//                           inactiveColor: Colors.grey,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 StreamBuilder<Duration>(
//                   stream: _player.positionStream,
//                   builder: (context, snapshot) {
//                     final position = snapshot.data ?? Duration.zero;
//                     final positionText = formatDuration(position);
//                     return Text(positionText,
//                         style: const TextStyle(color: Colors.white));
//                   },
//                 ),
//               ],
//             ),
//           ),
//           reelCubit.state.reelsForAudio != null
//               ? Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(8.0),
//               gridDelegate:
//               const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.6,
//                 mainAxisSpacing: 4,
//                 crossAxisSpacing: 4,
//               ),
//               itemCount: reelCubit.state.reelsForAudio!.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Update the playing index in the cubit
//                       reelCubit.updatePlayingIndex(index);
//                     },
//                     child: BlocBuilder<ReelsCubit, ReelsState>(
//                       builder: (context, state) {
//                         return Stack(
//                           children: [
//                             Image.network(
//                               width: double.infinity,
//                               height: double.infinity,
//                               reelCubit.state.reelsForAudio![index]
//                                   .thumbnailSignedUrl!,
//                               fit: BoxFit.cover,
//                             ),
//                             Positioned(
//                               bottom: 8,
//                               left: 2,
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.play_arrow,
//                                       color: Colors.white, size: 16),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     reelCubit
//                                         .state.reelsForAudio![index].name!,
//                                     style:
//                                     const TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//               : const Center(
//             child: CupertinoActivityIndicator(
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }
// }
//

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../widgets/comments.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class InstagramAudioScreen extends StatefulWidget {
  final Audio audio;
  final Reel reel;

  const InstagramAudioScreen(
      {super.key, required this.audio, required this.reel});

  @override
  State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
}

class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
  late AudioPlayer _player;
  bool _hasError = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    context.read<ReelsCubit>().fetchReelsWithSameAudio(widget.audio.id);

    _player = AudioPlayer();

    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _isCompleted = true;
          _player.seek(Duration.zero).then((value) => _player.pause());
        });
      }
    });

    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await _player.setUrl(widget.audio.audioSignedUrl);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      log('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isCompleted) {
      _player.seek(Duration.zero);
      setState(() {
        _isCompleted = false;
      });
    }

    setState(() {
      if (_player.playing) {
        _player.pause();
      } else {
        _player.play();
      }
    });
  }

  Widget _buildActionButton(IconData icon, VoidCallback function,
      {Color? iconColor}) {
    return IconButton(
      onPressed: function,
      icon: FaIcon(
        icon,
        color: iconColor ?? Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reelCubit = context.watch<ReelsCubit>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Audio',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          _buildActionButton(
            FontAwesomeIcons.paperPlane,
            () {
              Share.share(
                widget.audio.audioSignedUrl,
                subject: 'Check out this reel!',
              );
            },
          ),
          BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              return _buildActionButton(
                FontAwesomeIcons.solidBookmark,
                () async {
                  try {
                    context.read<ReelsCubit>().saveReel(widget.reel.id).then(
                        (val) => showSnackBarAfterBuild(context,
                            message: "Reel $val",
                            icon: val != 'unsaved successfully'
                                ? Icons.check_circle
                                : Icons.unpublished,
                            backgroundColor: Colors.white,
                            textColor: AppColors.QUANTITY_COLOR));
                  } catch (e) {
                    // Handle error (e.g., show a snack bar)
                  }
                },
              );
            },
          ),
          _buildActionButton(
            Icons.report_outlined,
            () {
              bottomSheet(
                context: context,
                widget: ReportView(
                  id: widget.reel.id,
                  categoryId: '66684135dbb427ee42aa0141',
                ),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.audio.audioPicture),
                        fit: BoxFit.cover),
                    color: Colors.blue, // Background color of the container
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                // CircleAvatar(
                //
                //   radius: 30,
                //   backgroundImage: NetworkImage(
                //     widget.audio.audioPicture,
                //   ),
                // ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeAndSplit(widget.audio.audioName),
                        softWrap: true,
                        style:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(capitalizeAndSplit(widget.audio.username),
                          style: const TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text('${widget.audio.reelsCount} reels',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
                  onPressed: () {
                    _player.dispose();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReelsRecordingScreen(
                            voiceUrl: widget.audio.audioSignedUrl,
                          ),
                        ));
                  },
                  child: const Text(
                    'Use audio',
                    textScaler: TextScaler.linear(1.2),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          _hasError
              ? const Center(
                  child: Text(
                    'Failed to load audio!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;
                          if (playing != true) {
                            return IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              onPressed: _togglePlayPause,
                            );
                          } else {
                            return IconButton(
                              icon:
                                  const Icon(Icons.pause, color: Colors.white),
                              onPressed: _togglePlayPause,
                            );
                          }
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration =
                                  _player.duration ?? Duration.zero;

                              double sliderValue =
                                  position.inMilliseconds.toDouble();
                              if (sliderValue >
                                  duration.inMilliseconds.toDouble()) {
                                sliderValue =
                                    duration.inMilliseconds.toDouble();
                              }

                              return Slider(
                                value: sliderValue,
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final positionText = formatDuration(position);
                          return Text(positionText,
                              style: const TextStyle(color: Colors.white));
                        },
                      ),
                    ],
                  ),
                ),
          reelCubit.state.reelsForAudio != null
              ? Expanded(
                  child: BlocConsumer<ReelsCubit, ReelsState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: state.reelsForAudio!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // reelCubit.updatePlayingIndex(index);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: serviceLocator<ReelsCubit>(),
                                        child: ReelItemFromAudio(
                                          key: ValueKey(
                                              state.reelsForAudio![index].id),
                                          reel: state.reelsForAudio![index],
                                          isVisible: true,
                                        ),
                                      ),
                                    ));
                              },
                              child: Stack(
                                children: [
                                  Image.network(
                                    width: double.infinity,
                                    height: double.infinity,
                                    state.reelsForAudio![index]
                                        .thumbnailSignedUrl,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.play_arrow,
                                            color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          state.reelsForAudio![index].viewCount
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
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
                  ),
                )
              : const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ReelsScreenForAudio extends StatefulWidget {
  final List<Reel> reels;

  const ReelsScreenForAudio({super.key, required this.reels});

  @override
  ReelsScreenForAudioState createState() => ReelsScreenForAudioState();
}

class ReelsScreenForAudioState extends State<ReelsScreenForAudio> {
  final PageController _pageController = PageController();
  final int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (widget.reels.isEmpty) {
          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }
        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.reels.length,
          itemBuilder: (context, index) {
            if (index >= widget.reels.length) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 25),
              );
            }
            return ReelItemFromAudio(
              key: ValueKey(widget.reels[index].id),
              reel: widget.reels[index],
              isVisible: _currentPage == index,
            );
          },
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

//----------------------------------------------------------------------------------------

class ReelItemFromAudio extends StatefulWidget {
  final Reel reel;
  final bool isVisible;

  const ReelItemFromAudio(
      {super.key, required this.reel, required this.isVisible});

  @override
  ReelItemFromAudioState createState() => ReelItemFromAudioState();
}

class ReelItemFromAudioState extends State<ReelItemFromAudio>
    with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ReelItemFromAudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _playVideo() : _pauseVideo();
    }
  }

  Future<void> _initializePlayer() async {
    if (!await _checkConnectivity()) return;

    await _initializeVideoController();
    _setupChewieController();
    _setInitialVideoState();
  }

  Future<void> _initializeVideoController() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      await _videoPlayerController.initialize();
    } catch (error) {
      if (mounted) {
        _handleVideoError('Failed to load video');
      }
    }
  }

  void _setupChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.isVisible,
      looping: true,
      showControls: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
    );
  }

  void _setInitialVideoState() {
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _isPlaying = widget.isVisible;
      });
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        _handleVideoError('No internet connection');
      }
      return false;
    }
    return true;
  }

  void _handleVideoError(String message) {
    if (mounted) {
      setState(() {
        _isInitialized = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _playVideo() {
    if (_isInitialized && !_isPlaying) {
      _chewieController?.play();
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _showPlayPauseIcon = true;
        });
      }
      _hidePlayPauseIconAfterDelay();
    }
  }

  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _chewieController?.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _showPlayPauseIcon = true;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }

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
    return GestureDetector(
      onTap: _togglePlayPause,
      onVerticalDragEnd: (details) {
        // Check if the swipe was upwards (primaryVelocity < 0)
        if (details.primaryVelocity! < 0) {
          // Show the bottom sheet for any upward swipe
          ProfileBottomSheet.show(context, widget.reel);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoOrPlaceholder(),
          _buildPlayPauseIcon(),
          _buildOverlay(),
          if (!_isInitialized)
            const Center(
              child: CupertinoActivityIndicator(radius: 25),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoOrPlaceholder() {
    if (_isInitialized && _chewieController != null) {
      return FittedBox(
        fit: BoxFit.fitHeight,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: Chewie(controller: _chewieController!),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.reel.thumbnailSignedUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CupertinoActivityIndicator(radius: 25),
        ),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }
  }

  Widget _buildPlayPauseIcon() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Center(
        child: AnimatedOpacity(
          opacity: _showPlayPauseIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: kToolbarHeight + 20),
        Expanded(
          child: GestureDetector(
            onTap: _togglePlayPause,
          ),
        ),
        _buildReelInfo(),
      ],
    );
  }

  Widget _buildReelInfo() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: SizedBox(
        height: height * 0.5,
        width: double.infinity,
        child: Stack(
          children: [
            // Positioned(
            //
            //   top: 100,
            //   right: 100,
            //   child: Padding(
            //     padding: EdgeInsets.all(8.0),
            //     child: IconButton(
            //
            //       onPressed: () {
            //         _pauseVideo();
            //
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const ReelsRecordingScreen(),
            //             ));
            //       },
            //       icon: const FaIcon(
            //         Icons.camera_alt_outlined,
            //         color: Colors.white,
            //         size: 35,
            //       ),
            //     ),
            //   ),
            // ),

            Positioned(
              bottom: 16,
              left: 4,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildUserAvatar(),
                      SizedBox(width: 12),
                      FittedBox(child: _buildUserInfo()),
                    ],
                  ),
                  _buildAudioAndButtons(width),
                ],
              ),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: CachedNetworkImageProvider(
          widget.reel.user.profilePictureSignedUrl!,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserName(),
        _buildReelNameAndViews(),
      ],
    );
  }

  Widget _buildUserName() {
    return Row(
      children: [
        Text(
          capitalizeAndSplit(
              '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
          style:  TextStyle(
            fontSize: 26.sp,
            decoration: TextDecoration.none,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4),
        if (widget.reel.user.verified)
          const Icon(
            Icons.verified,
            color: AppColors.PRIMARY_COLOR_DARK,
            size: 25,
          ),
      ],
    );
  }

  Widget _buildReelNameAndViews() {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              widget.reel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(
                color: AppColors.DARK_GRAY_COLOR,
                decoration: TextDecoration.none,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 16),
          FaIcon(
            FontAwesomeIcons.eye,
            size: 20,
            color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
          ),
          SizedBox(width: 8),
          Text(
            widget.reel.viewCount.toString(),
            style:  TextStyle(
              color: AppColors.DARK_GRAY_COLOR,
              fontSize: 18.sp,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioAndButtons(double width) {
    return Row(
      children: [
        SizedBox(width: 4),
        // FaIcon(
        //   FontAwesomeIcons.music,
        //   color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
        // ),
        Container(
          color: Colors.blueGrey.withOpacity(0.2),
          width: width / 2,
          child: ScrollingText(text: widget.reel.audio.audioName),
        ),
        SizedBox(width: 4),
        RoundedButtonWithImage(
          imagePath: widget.reel.audio.audioPicture,
          onPressed: () {
            _pauseVideo();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: serviceLocator<ReelsCubit>()
                    ..fetchReelsWithSameAudio(widget.reel.audio.id),
                  child: InstagramAudioScreen(
                    audio: widget.reel.audio,
                    reel: widget.reel,
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final reelsCubit = context.read<ReelsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          widget.reel.likeCount == 0
              ? FontAwesomeIcons.heart
              : FontAwesomeIcons.solidHeart,
          widget.reel.likeCount,
          () async {
            await _handleLikeAction(reelsCubit);
          },
          iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
        ),
        _buildActionButton(
          FontAwesomeIcons.comment,
          widget.reel.commentCount,
          () async {
            await _handleCommentAction(reelsCubit);
          },
        ),
        _buildActionButton(
          FontAwesomeIcons.paperPlane,
          widget.reel.shareCount,
          () async {
            _handleShareAction(widget.reel.videoMedia);
          },
        ),
        _buildActionButton(
          widget.reel.saveCount == 0
              ? FontAwesomeIcons.bookmark
              : FontAwesomeIcons.solidBookmark,
          widget.reel.saveCount,
          () async {
            await _handleSaveAction(reelsCubit);
          },
          iconColor:
              widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
        ),
        _buildActionButton(
          Icons.card_giftcard,
          0,
          () {
            showGiftBottomSheet(context, receiverId: widget.reel.user.id);
          },
        ),
        _buildActionButton(
          Icons.report_outlined,
          0,
          () {
            bottomSheet(
              context: context,
              widget: ReportView(
                id: widget.reel.user.id,
                categoryId: '66684135dbb427ee42aa0141',
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.likeReel(widget.reel.id);
      final response = reelsCubit.state.likeReelResponse;
      if (response?.message == "Reel liked successfully") {
        setState(() => widget.reel.likeCount++);
      } else if (response?.message == "Reel unlike successfully") {
        setState(() => widget.reel.likeCount--);
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.getComments(widget.reel.id);
      showCommentsBottomSheet(context, reel: widget.reel);
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  void _handleShareAction(String videoUrl) {
    Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.saveReel(widget.reel.id);
      final response = reelsCubit.state.reelSaveResponse;
      if (response!.message == "saved successfully") {
        setState(() => widget.reel.saveCount++);
      } else if (response.message == "unsaved successfully") {
        setState(() => widget.reel.saveCount--);
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  Widget _buildActionButton(IconData icon, int count, VoidCallback function,
      {Color? iconColor}) {
    return IconButton(
      onPressed: function,
      icon: Column(
        children: [
          FaIcon(
            icon,
            color: iconColor ?? Colors.white,
            size: 30,
          ),
          SizedBox(height: 2.h),
          if (count != 0)
            Text(
              '$count',
              style: const TextStyle(color: Colors.white),
            )
          else
            Sizer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pauseVideo();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

class ProfileBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Reel reel;

  const ProfileBottomSheet(
      {super.key, required this.scrollController, required this.reel});

  static void show(BuildContext context, Reel reel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ProfileBottomSheet(
          scrollController: scrollController,
          reel: reel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: ProfileContent(reel: reel),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final Reel reel;

  const ProfileContent({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.75,
          width: double.infinity,
          child: Image.network(
            reel.user.coverPictureSignedUrl!.isEmpty ||
                    reel.user.coverPictureSignedUrl == null
                ? reel.user.profilePictureSignedUrl!
                : reel.user.coverPictureSignedUrl!,
            errorBuilder: (context, error, stackTrace) => Image.network(
              UIConst.profilePlaceHolder,
            ),
            fit: BoxFit.cover,
          ),
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileHeader(reel: reel),
                SizedBox(height: 20.h),
                ActionButton(reel: reel),
                SizedBox(height: 20.h),
                LocationAndContact(reel: reel),
                SizedBox(height: 20.h),
                SizedBox(height: 20.h),
                // SocialLink(reel: reel),
                // SizedBox(height: 20.h),
                Description(reel: reel),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        Sizer(),
        MediaHighlights(reel: reel),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Reel reel;

  const ProfileHeader({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 65,
          backgroundColor:
              reel.user.story ? AppColors.SECONDARY_COLOR : Colors.transparent,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              reel.user.profilePictureSignedUrl ?? UIConst.profilePlaceHolder,
            ),
            onBackgroundImageError: (exception, stackTrace) =>
                const NetworkImage(
              UIConst.profilePlaceHolder,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      capitalizeAndSplit2Only(
                          "${reel.user.firstName} ${reel.user.lastName}"),
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (reel.user.verified)
                    const Icon(
                      Icons.verified,
                      color: AppColors.SECONDARY_COLOR,
                    )
                ],
              ),
              Text(
                '${reel.user.firstName}${reel.user.lastName} · ${reel.user.job ?? ''}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final Reel reel;

  const ActionButton({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final currentUserId = serviceLocator<UserCubit>().state.data!.id;
    return SizedBox(
      width: double.infinity,
      child: Builder(builder: (context) {
        if (currentUserId == reel.user.id) {
          return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: const Text('Your Account'));
        } else if (reel.user.isFriend) {
          return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: const Text('Friend'));
        }
        return ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: const Text('+ Add'));
      }),
    );
  }
}

class LocationAndContact extends StatelessWidget {
  final Reel reel;

  const LocationAndContact({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (reel.user.country!.isNotEmpty)
          _buildInfoRow(Icons.location_on,
              '${capitalize(reel.user.country ?? '')}, ${capitalize(reel.user.city ?? '')}'),
        if (reel.user.phone!.isNotEmpty)
          _buildInfoRow(Icons.contact_mail, '${reel.user.phone}'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}

class SocialLink extends StatelessWidget {
  final Reel reel;

  const SocialLink({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.link),
        SizedBox(width: 5),
        Text(
          'instagram.com/...',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  final Reel reel;

  const Description({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (reel.user.bio!.isNotEmpty)
          const Icon(
            FontAwesomeIcons.userPen,
            size: 20,
          ),
        Sizer(),
        Sizer(),
        Text(
          reel.user.bio ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class MediaHighlights extends StatelessWidget {
  final Reel reel;

  const MediaHighlights({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: (reel.user.birthday!.isEmpty &&
              reel.user.country!.isEmpty &&
              reel.user.job!.isEmpty)
          ? Sizer()
          : GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                MediaHighlightItem(
                  label:
                      reel.user.birthday!.isEmpty || reel.user.birthday == null
                          ? 'AST 1999'
                          : reel.user.birthday!,
                  icon: Icons.event,
                  reel: reel,
                ),
                MediaHighlightItem(
                    label: capitalize(reel.user.country ?? '') ?? '',
                    icon: Icons.flag,
                    reel: reel),
                MediaHighlightItem(
                    label: capitalize(reel.user.job ?? ''),
                    icon: FontAwesomeIcons.briefcase,
                    reel: reel),
              ],
            ),
    );
  }
}

class MediaHighlightItem extends StatelessWidget {
  final Reel reel;

  final String label;
  final IconData icon;

  const MediaHighlightItem(
      {super.key, required this.label, required this.icon, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 40),
          ),
        ),
        SizedBox(height: 5.h),
        Expanded(
          child: Text(label,
              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: GestureDetector(
//         onVerticalDragEnd: (details) {
//           // Check if the user swipes up (primaryVelocity is negative for upward swipes)
//           if (details.primaryVelocity! < 0) {
//             // If the swipe is upward, show the bottom sheet
//             ProfileBottomSheet.show(context,widget);
//           }
//         },
//         child: Container(
//           color: Colors.red,
//           height: double.infinity,
//           width: double.infinity,
//           child: Center(
//             child: Text('Swipe up to show profile'),
//           ),
//         ),
//       ),
//     );
//   }
// }
