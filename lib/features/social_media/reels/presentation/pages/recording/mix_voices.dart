// import 'dart:async';
// import 'dart:developer';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'recording_shared.dart';
//
//
// class MixVoiceVideoRecordingScreen extends StatefulWidget {
//   const MixVoiceVideoRecordingScreen({super.key});
//
//   @override
//   MixVoiceVideoRecordingScreenState createState() =>
//       MixVoiceVideoRecordingScreenState();
// }
//
// class MixVoiceVideoRecordingScreenState
//     extends State<MixVoiceVideoRecordingScreen> with TickerProviderStateMixin {
//   CameraController? _controller;
//   late List<CameraDescription> cameras;
//   String? videoPath;
//   String? mergedVideoPath;
//   bool isFrontCamera = true;
//   bool isRecording = false;
//   late AnimationController _animationController;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   Timer? _stopTimer;
//   Timer? _notifyTimer;
//   int _secondsRemaining = 30;
//
//   bool showGalleryBtn = false;
//   String voiceUrl =
//       'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/start.ogg';
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//     _initializeAnimationController();
//     _loadAndPlayAudio();
//   }
//
//   Future<void> _loadAndPlayAudio() async {
//     try {
//       await _audioPlayer.setUrl('$voiceUrl');
//       _audioPlayer.setLoopMode(LoopMode.one);
//     } catch (e) {
//       log("Audio playback error: $e");
//     }
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       cameras = await availableCameras();
//       await _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
//     } catch (e) {
//       log("Camera initialization error: $e");
//       _showErrorDialog("Failed to initialize the camera.");
//     }
//   }
//
//   void _initializeAnimationController() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 30),
//     )..addListener(() {
//         setState(() {});
//       });
//   }
//
//   Future<void> _initializeCameraController(
//       CameraDescription cameraDescription) async {
//     _controller = CameraController(
//       cameraDescription,
//       ResolutionPreset.high,
//       enableAudio: true,
//     );
//
//     try {
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       log("Controller initialization error: $e");
//       _showErrorDialog("Failed to initialize the camera controller.");
//     }
//   }
//
//   void _startRecording() async {
//     if (_controller!.value.isRecordingVideo) return;
//
//     try {
//       final directory = await getTemporaryDirectory();
//       videoPath =
//           '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
//       await _controller!.startVideoRecording();
//       setState(() {
//         isRecording = true;
//         showGalleryBtn = false;
//       });
//
//       _animationController.reset();
//       _animationController.forward();
//       _audioPlayer.play(); // Start the audio playback
//
//       _startTimers();
//     } catch (e) {
//       log("Error starting recording: $e");
//       _showErrorDialog("Failed to start recording.");
//     }
//   }
//
//   void _startTimers() {
//     _secondsRemaining = 30;
//     _notifyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _secondsRemaining--;
//       });
//     });
//
//     _stopTimer = Timer(const Duration(seconds: 30), _stopRecording);
//   }
//
//   void _stopRecording() async {
//     if (!_controller!.value.isRecordingVideo) return;
//
//     try {
//       final videoFile = await _controller!.stopVideoRecording();
//       videoPath = videoFile.path;
//       setState(() {
//         isRecording = false;
//       });
//
//       _resetRecordingState();
//
//       if (videoPath != null) {
//         await GallerySaver.saveVideo(videoPath!);
//         setState(() {
//           showGalleryBtn = true;
//         });
//       }
//     } catch (e) {
//       log("Error stopping recording: $e");
//       _showErrorDialog("Failed to stop recording.");
//     }
//   }
//
//   void _resetRecordingState() {
//     _animationController.stop();
//     _audioPlayer.stop();
//     _animationController.reset();
//     _stopTimer?.cancel();
//     _notifyTimer?.cancel();
//   }
//
//   void _switchCamera() {
//     setState(() {
//       isFrontCamera = !isFrontCamera;
//     });
//     _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
//   }
//
//   void _showErrorDialog(String message) {
//     _stopRecording();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const Scaffold(
//           backgroundColor: Colors.black,
//           body: Center(
//               child: CupertinoActivityIndicator(
//             color: Colors.white,
//             radius: 25,
//           )));
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           _buildCameraPreview(),
//           _buildControls(),
//           if (isRecording) _buildTimerPopup(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCameraPreview() {
//     return CameraPreview(_controller!);
//   }
//
//   Widget _buildTimerPopup() {
//     return Positioned(
//       top: 40,
//       left: 0,
//       right: 0,
//       child: Center(
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.7),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             'Recording stops in $_secondsRemaining seconds',
//             style: const TextStyle(color: Colors.white, fontSize: 18.sp),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildControls() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//
//               showGalleryBtn
//                   ? IconButton(
//                       onPressed: _navigateToPlaybackScreen,
//                       icon: const Icon(
//                         Icons.video_collection,
//                         color: Colors.white,
//                         size: 50,
//                       ),
//                     )
//                   : SizedBox(
//                       width: 50,
//                     ),
//               GestureDetector(
//                 onLongPress: () => _startRecording(),
//
//                 onLongPressEnd: (_) => _stopRecording(),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(0),
//                       margin: EdgeInsets.all(0),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         border: Border.all(color: Colors.white70, width: 4),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: CustomPaint(
//                           painter: ProgressPainter(
//                             progress: _animationController.value,
//                             color: Colors.pink,
//                           ),
//                           child: Icon(
//                             Icons.fiber_manual_record,
//                             color: Colors.white.withOpacity(0.9),
//                             size: MediaQuery.of(context).size.width * 0.23,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildSwitchCameraButton(50),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSwitchCameraButton(double width) {
//     return IconButton(
//       onPressed: _switchCamera,
//       icon: Icon(
//         Icons.cameraswitch,
//         semanticLabel: 'Switch Camera',
//         color: Colors.white,
//         size: width,
//       ),
//     );
//   }
//
//   void _navigateToPlaybackScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VideoPlaybackScreen(videoPath!),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     _animationController.dispose();
//     // _audioPlayer.dispose();
//     _stopTimer?.cancel();
//     _notifyTimer?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../service_locator/service_locator.dart';
import '../../controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../../shared/filter_utiles.dart';
import 'recording_shared.dart';

class MixVoiceVideoRecordingScreen extends StatefulWidget {
  final String voiceUrl;
  final String? comeFrom;
  final String? totalPrice;
  final String? advertisementType;
  const MixVoiceVideoRecordingScreen(
      {super.key,
      required this.voiceUrl,
      this.comeFrom,
      this.totalPrice,
      this.advertisementType});

  @override
  MixVoiceVideoRecordingScreenState createState() =>
      MixVoiceVideoRecordingScreenState();
}

class MixVoiceVideoRecordingScreenState
    extends State<MixVoiceVideoRecordingScreen> with TickerProviderStateMixin {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  String? videoPath;
  String? filteredVideoPath;
  bool isFrontCamera = true;
  bool isRecording = false;
  late AnimationController _animationController;
  Timer? _stopTimer;
  Timer? _notifyTimer;
  int _secondsRemaining = 30;
  int currentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool showGalleryBtn = false;

  // String voiceUrl =
  //     'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/start.ogg';
  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initializeAnimationController();
    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    try {
      await _audioPlayer.setUrl(widget.voiceUrl);
      _audioPlayer.setLoopMode(LoopMode.one);
    } catch (e) {
      log("Audio playback error: $e");
    }
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      await _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
    } catch (e) {
      log("Camera initialization error: $e");
      _showErrorDialog("Failed to initialize the camera.");
    }
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
        setState(() {});
      });
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      log("Controller initialization error: $e");
      _showErrorDialog("Failed to initialize the camera controller.");
    }
  }

  void _applyFilter(Filter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _startRecording() async {
    if (_controller!.value.isRecordingVideo) return;

    try {
      final directory = await getTemporaryDirectory();
      videoPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _controller!.startVideoRecording();
      setState(() {
        isRecording = true;
        showGalleryBtn = false;
      });

      _animationController.reset();
      _animationController.forward();
      _startTimers();
      _audioPlayer.setVolume(0.5);
      _audioPlayer.play(); // Start the audio playback
    } catch (e) {
      log("Error starting recording: $e");
      _showErrorDialog("Failed to start recording.");
    }
  }

  void _startTimers() {
    _secondsRemaining = 30;
    _notifyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });
    });

    _stopTimer = Timer(const Duration(seconds: 30), _stopRecording);
  }

  void _stopRecording() async {
    if (!_controller!.value.isRecordingVideo) return;

    try {
      final videoFile = await _controller!.stopVideoRecording();
      videoPath = videoFile.path;
      setState(() {
        isRecording = false;
      });

      _resetRecordingState();
      await _mergeVideoWithFilter();
    } catch (e) {
      log("Error stopping recording: $e");
      _showErrorDialog("Failed to stop recording.");
    }
  }

  void _resetRecordingState() {
    _animationController.stop();
    _animationController.reset();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
    _audioPlayer.stop();
  }

  Future _mergeVideoWithFilter() async {
    final directory = await getTemporaryDirectory();
    filteredVideoPath =
        '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Construct the FFmpeg command with the selected filter and horizontal flip
    final filterCommand = _selectedFilter?.ffmpegFilter != null
        ? '${_selectedFilter!.ffmpegFilter},hflip' // Add hflip to the existing filter
        : 'hflip'; // Just use hflip if no other filter is selected

    final commandArgs = [
      '-i', videoPath!,
      '-vf', filterCommand, // Apply the filter and horizontal flip
      '-c:v', 'mpeg4', // Use `mpeg4` for faster encoding
      '-q:v', '5', // Lower quality for faster processing
      '-b:v', '1M', // Lower bitrate
      filteredVideoPath!,
    ];

    log("Executing FFmpeg command: ${commandArgs.join(' ')}");

    try {
      final session = await FFmpegKit.executeWithArguments(commandArgs);
      final returnCode = await session.getReturnCode();
      final output = await session.getOutput();
      log("FFmpeg output: $output");

      if (ReturnCode.isSuccess(returnCode)) {
        log("FFmpeg process succeeded");
        final savedSuccessfully =
            await GallerySaver.saveVideo(filteredVideoPath!);
        if (savedSuccessfully ?? false) {
          serviceLocator<ReelsCubit>().uploadReel(File(filteredVideoPath!),
              advertisementType: widget.advertisementType,
              comeFrom: widget.comeFrom,
              totalPrice: widget.totalPrice);

          setState(() {
            showGalleryBtn = true;
          });
        } else {
          throw Exception("Failed to save video to gallery");
        }
      } else {
        final failStackTrace = await session.getFailStackTrace();
        throw Exception(
            "FFmpeg process failed with return code $returnCode\n$failStackTrace");
      }
    } catch (e) {
      log("Error in _mergeVideoWithFilter: $e");
      _showErrorDialog("Failed to process the video: ${e.toString()}");
      filteredVideoPath = null;
    }
  }

  void _switchCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
  }

  void _showErrorDialog(String message) {
    _stopRecording();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSelector() {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _applyFilter(filters[index]),
            child: Container(
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(
                    color: _selectedFilter == filters[index]
                        ? Colors.blue
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      FilterLibrary.filterImagesPaths[index].toString(),
                    ),
                  ),
                  FittedBox(
                    child: Text(filters[index].name,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: CupertinoActivityIndicator(
            color: Colors.white,
            radius: 25,
          )));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraPreview(),
          _buildControls(),
          if (isRecording) _buildTimerPopup(),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return ColorFiltered(
      colorFilter: _selectedFilter?.colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildTimerPopup() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Recording stops in $_secondsRemaining seconds',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              showGalleryBtn
                  ? IconButton(
                      onPressed: _navigateToPlaybackScreen,
                      icon: const Icon(
                        Icons.video_collection,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    ),
              GestureDetector(
                onLongPress: () => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white70, width: 4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CustomPaint(
                          painter: ProgressPainter(
                            progress: _animationController.value,
                            color: Colors.pink,
                          ),
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: Colors.white.withOpacity(0.9),
                            size: MediaQuery.of(context).size.width * 0.23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSwitchCameraButton(50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCameraButton(double width) {
    return IconButton(
      onPressed: _switchCamera,
      icon: Icon(
        Icons.cameraswitch,
        semanticLabel: 'Switch Camera',
        color: Colors.white,
        size: width,
      ),
    );
  }

  void _navigateToPlaybackScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlaybackScreen(filteredVideoPath!),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
    _audioPlayer.stop();

    super.dispose();
  }
}
