import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'recording_shared.dart';


class MixVoiceVideoRecordingScreen extends StatefulWidget {
  const MixVoiceVideoRecordingScreen({super.key});

  @override
  MixVoiceVideoRecordingScreenState createState() =>
      MixVoiceVideoRecordingScreenState();
}

class MixVoiceVideoRecordingScreenState
    extends State<MixVoiceVideoRecordingScreen> with TickerProviderStateMixin {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  String? videoPath;
  String? mergedVideoPath;
  bool isFrontCamera = true;
  bool isRecording = false;
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _stopTimer;
  Timer? _notifyTimer;
  int _secondsRemaining = 30;

  bool showGalleryBtn = false;
  String voiceUrl =
      'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/start.ogg';

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initializeAnimationController();
    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    try {
      await _audioPlayer.setUrl('$voiceUrl');
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
      _audioPlayer.play(); // Start the audio playback

      _startTimers();
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

      if (videoPath != null) {
        await GallerySaver.saveVideo(videoPath!);
        setState(() {
          showGalleryBtn = true;
        });
      }
    } catch (e) {
      log("Error stopping recording: $e");
      _showErrorDialog("Failed to stop recording.");
    }
  }

  void _resetRecordingState() {
    _animationController.stop();
    _audioPlayer.stop();
    _animationController.reset();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
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
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return CameraPreview(_controller!);
  }

  Widget _buildTimerPopup() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Recording stops in $_secondsRemaining seconds',
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
                  : const SizedBox(
                      width: 50,
                    ),
              GestureDetector(
                onLongPress: () => _startRecording(),

                onLongPressEnd: (_) => _stopRecording(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white70, width: 4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
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
        builder: (context) => VideoPlaybackScreen(videoPath!),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    // _audioPlayer.dispose();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
    super.dispose();
  }
}
