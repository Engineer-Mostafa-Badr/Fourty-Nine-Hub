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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../routes/routes.dart';
import '../../../stories/presentation/pages/more_stories.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'audio_reel_view.dart';
import 'package:easy_localization/easy_localization.dart';

// class InstagramAudioScreen extends StatefulWidget {
//   final Audio audio;
//   final Reel reel;
//
//   const InstagramAudioScreen(
//       {super.key, required this.audio, required this.reel});
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
//   Widget _buildActionButton(IconData icon, VoidCallback function,
//       {Color? iconColor}) {
//     return IconButton(
//       onPressed: function,
//       icon: Icon(
//         icon,
//         size: 50.h,
//         color: iconColor,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reelCubit = context.watch<ReelsCubit>();
//     return Scaffold(
//       backgroundColor: isDarkTheme(context) ? Colors.black87 : Colors.white,
//       appBar: AppBar(
//         backgroundColor: isDarkTheme(context) ? Colors.black87 : Colors.white,
//         toolbarHeight: kToolbarHeight * 0.8,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             size: 50.h,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Audio', textScaleFactor: 1.0, // Disable font scaling
//
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
//         ),
//         actions: [
//           _buildActionButton(
//             Icons.send,
//             () {
//               Share.share(
//                 widget.audio.audioSignedUrl,
//                 subject: 'Check out this reel!',
//               );
//             },
//           ),
//           BlocBuilder<ReelsCubit, ReelsState>(
//             builder: (context, state) {
//               return _buildActionButton(
//                 widget.reel.isSaved && widget.reel.saveCount > 0
//                     ? Icons.bookmark
//                     : Icons.bookmark_border,
//                 iconColor: AppColors.YELLOW_COLOR,
//                 () async {
//                   try {
//                     context.read<ReelsCubit>().saveReel(widget.reel.id).then(
//                         (val) => showSnackBarAfterBuild(context,
//                             message: "Reel $val",
//                             icon: val != 'unsaved successfully'
//                                 ? Icons.check_circle
//                                 : Icons.unpublished,
//                             backgroundColor: Colors.white,
//                             textColor: AppColors.QUANTITY_COLOR));
//                   } catch (e) {
//                     // Handle error (e.g., show a snack bar)
//                   }
//                 },
//               );
//             },
//           ),
//           _buildActionButton(
//             Icons.report_outlined,
//             () {
//               bottomSheet(
//                 context: context,
//                 widget: ReportView(
//                   id: widget.reel.id,
//                   categoryId: '66684135dbb427ee42aa0141',
//                 ),
//               );
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () =>
//                   context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 150.h,
//                     height: 150.h,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: NetworkImage(widget.audio.audioPicture),
//                           fit: BoxFit.cover),
//                       color: Colors.blue, // Background color of the container
//                       borderRadius:
//                           BorderRadius.circular(15), // Rounded corners
//                     ),
//                   ),
//                   // CircleAvatar(
//                   //
//                   //   radius: 30,
//                   //   backgroundImage: NetworkImage(
//                   //     widget.audio.audioPicture,
//                   //   ),
//                   // ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           capitalizeAndSplit2Only(widget.audio.audioName),
//                           softWrap: true,
//                           textScaleFactor: 1.0,
//                           // Disable font scaling
//
//                           style: TextStyle(
//                             fontSize: 40.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           capitalizeAndSplit(widget.audio.username),
//                           softWrap: true,
//                           textScaleFactor: 1.0,
//                           // Disable font scaling
//
//                           style: TextStyle(
//                             fontSize: 35.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           reelText(widget.audio.reelsCount),
//                           textScaleFactor: 1.0,
//                           // Disable font scaling
//
//                           style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 30.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 20.h,),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: ElevatedButton(
//                     style: const ButtonStyle(
//                         backgroundColor:
//                             MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
//                     onPressed: () {
//                       _player.dispose();
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ReelsRecordingScreen(
//                               voiceUrl: widget.audio.audioSignedUrl,
//                             ),
//                           ));
//                     },
//                     child: Text(
//                       'Use Audio', textScaleFactor: 1.0, // Disable font scaling
//
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                           fontSize: 35.sp),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           _hasError
//               ? const Center(
//                   child: Text(
//                     'Failed to load audio!', textScaleFactor: 1.0,
//                     // Disable font scaling
//
//                     style: TextStyle(),
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       StreamBuilder<PlayerState>(
//                         stream: _player.playerStateStream,
//                         builder: (context, snapshot) {
//                           final playerState = snapshot.data;
//                           final playing = playerState?.playing;
//                           if (playing != true) {
//                             return IconButton(
//                               icon: const Icon(
//                                 Icons.play_arrow,
//                               ),
//                               onPressed: _togglePlayPause,
//                             );
//                           } else {
//                             return IconButton(
//                               icon: const Icon(
//                                 Icons.pause,
//                               ),
//                               onPressed: _togglePlayPause,
//                             );
//                           }
//                         },
//                       ),
//                       Expanded(
//                         child: StreamBuilder<Duration>(
//                           stream: _player.positionStream,
//                           builder: (context, snapshot) {
//                             final position = snapshot.data ?? Duration.zero;
//                             final duration = _player.duration ?? Duration.zero;
//
//                             double sliderValue =
//                                 position.inMilliseconds.toDouble();
//                             if (sliderValue >
//                                 duration.inMilliseconds.toDouble()) {
//                               sliderValue = duration.inMilliseconds.toDouble();
//                             }
//
//                             return Slider(
//                               value: sliderValue,
//                               max: duration.inMilliseconds.toDouble(),
//                               onChanged: (value) {
//                                 _player.seek(
//                                     Duration(milliseconds: value.toInt()));
//                               },
//                               // activeColor: Colors.white,
//                               // inactiveColor: Colors.grey,
//                             );
//                           },
//                         ),
//                       ),
//                       StreamBuilder<Duration>(
//                         stream: _player.positionStream,
//                         builder: (context, snapshot) {
//                           final position = snapshot.data ?? Duration.zero;
//                           final positionText = formatDuration(position);
//                           return Text(
//                             positionText, textScaleFactor: 1.0,
//                             // Disable font scaling
//
//                             style: TextStyle(
//                               fontSize: 30.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//           reelCubit.state.reelsForAudio != null
//               ? Expanded(
//                   child: BlocConsumer<ReelsCubit, ReelsState>(
//                     listener: (context, state) {
//                       // TODO: implement listener
//                     },
//                     builder: (context, state) {
//                       return GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           childAspectRatio: 0.6,
//                           mainAxisSpacing: 4,
//                           crossAxisSpacing: 4,
//                         ),
//                         itemCount: state.reelsForAudio!.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               // reelCubit.updatePlayingIndex(index);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => BlocProvider.value(
//                                       value: serviceLocator<ReelsCubit>(),
//                                       child: ReelsScreenForAudio(
//                                         navigateTo: index,
//                                         reels: state.reelsForAudio!,
//                                       ),
//                                     ),
//                                   ));
//                             },
//                             child: Stack(
//                               children: [
//                                 Image.network(
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                   state
//                                       .reelsForAudio![index].thumbnailSignedUrl,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Center(
//                                     child: CupertinoActivityIndicator(),
//                                   ),
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Positioned(
//                                   bottom: 8,
//                                   left: 2,
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.play_arrow, size: 16),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         state.reelsForAudio![index].viewCount
//                                             .toString(),
//                                         textScaleFactor: 1.0,
//                                         // Disable font scaling
//
//                                         style: TextStyle(
//                                           fontSize: 25.sp,
//                                           fontWeight: FontWeight.normal,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 )
//               : const Center(
//                   child: CupertinoActivityIndicator(),
//                 ),
//         ],
//       ),
//     );
//   }
//
//   String reelText(int reelCount) {
//     if (reelCount == 0) {
//       return 'No reels';
//     } else if (reelCount == 1) {
//       return '1 reel';
//     } else {
//       return '$reelCount reels';
//     }
//   }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }
// }

// ------------------------------------------------------------------------
//after localize

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
      icon: Icon(
        icon,
        size: 50.h,
        color: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reelCubit = context.watch<ReelsCubit>();
    return Scaffold(
      backgroundColor: isDarkTheme(context) ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkTheme(context) ? Colors.black87 : Colors.white,
        toolbarHeight: kToolbarHeight * 0.8,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 50.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          LocaleKeys.audio.tr(), // Localized "Audio"
          textScaleFactor: 1.0,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
        ),

        actions: [
          _buildActionButton(
            Icons.send,
            iconColor: Colors.black87,
                () {
              Share.share(
                widget.audio.audioSignedUrl,
                subject: LocaleKeys.check_out_reel.tr(),
              );
            },
          ),
          BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              return _buildActionButton(
                widget.reel.isSaved && widget.reel.saveCount > 0
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                iconColor: widget.reel.isSaved && widget.reel.saveCount > 0
                    ? AppColors.YELLOW_COLOR:Colors.black87,
                    () async {
                  try {
                    context.read<ReelsCubit>().saveReel(widget.reel.id).then(
                            (val) =>
                            showSnackBarAfterBuild(context,
                                message: val == 'unsaved successfully'
                                    ? LocaleKeys.reel_unsaved.tr()
                                    : LocaleKeys.reel_saved.tr(),
                                icon: val != 'unsaved successfully'
                                    ? Icons.check_circle
                                    : Icons.unpublished,
                                backgroundColor: Colors.white,
                                textColor: AppColors.QUANTITY_COLOR));
                  } catch (e) {
                    // Handle error
                  }
                },
              );
            },
          ),
          _buildActionButton(
            Icons.report_outlined,
            iconColor: AppColors.PRIMARY_COLOR_DARK,
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
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () =>
                  context.push(Routes.OTHERSACCOUNT,
                      extra: widget.reel.user.id),
              child: Row(
                children: [
                  Container(
                    width: 150.h,
                    height: 150.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.audio.audioPicture),
                          fit: BoxFit.cover),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeAndSplit2Only(widget.audio.audioName),
                          softWrap: true,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          capitalizeAndSplit(widget.audio.username),
                          softWrap: true,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          reelText(widget.audio.reelsCount),
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
                    onPressed: () {
                      _player.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReelsRecordingScreen(
                                  voiceUrl: widget.audio.audioSignedUrl,
                                ),
                          ));
                    },
                    child: Text(
                      LocaleKeys.use_audio.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 35.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _hasError
              ? Center(
            child: Text(
              LocaleKeys.audio_load_fail.tr(),
              textScaleFactor: 1.0,
              style: const TextStyle(),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
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
                        icon: const Icon(
                          Icons.play_arrow,
                        ),
                        onPressed: _togglePlayPause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(
                          Icons.pause,
                        ),
                        onPressed: _togglePlayPause,
                      );
                    }
                  },
                ),
                Expanded(
                  child: StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _player.duration ?? Duration.zero;

                      double sliderValue =
                      position.inMilliseconds.toDouble();
                      if (sliderValue >
                          duration.inMilliseconds.toDouble()) {
                        sliderValue = duration.inMilliseconds.toDouble();
                      }

                      return Slider(
                        value: sliderValue,
                        max: duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _player.seek(
                              Duration(milliseconds: value.toInt()));
                        },
                      );
                    },
                  ),
                ),
                StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final positionText = formatDuration(position);
                    return Text(
                      positionText,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          reelCubit.state.reelsForAudio != null
              ? Expanded(
            child: BlocConsumer<ReelsCubit, ReelsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: state.reelsForAudio!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider.value(
                                    value: serviceLocator<ReelsCubit>(),
                                    child: ReelsScreenForAudio(
                                      navigateTo: index,
                                      reels: state.reelsForAudio!,
                                    ),
                                  ),
                            ));
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            width: double.infinity,
                            height: double.infinity,
                            state
                                .reelsForAudio![index].thumbnailSignedUrl,
                            errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 8,
                            left: 2,
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  state.reelsForAudio![index].viewCount
                                      .toString(),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
              : const Center(
            child: CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  String reelText(int reelCount) {
    if (reelCount == 0) {
      return LocaleKeys.no_reels.tr();
    } else if (reelCount == 1) {
      return LocaleKeys.one_reel.tr();
    } else {
      return "$reelCount ${LocaleKeys.multiple_reels.tr()}";
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
