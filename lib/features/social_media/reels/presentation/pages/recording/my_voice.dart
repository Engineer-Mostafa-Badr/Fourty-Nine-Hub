import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/media_preview.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;

import '../../../../../../res/style/app_colors.dart';
import 'recording_shared.dart';
import '../../shared/filter_utiles.dart';

import 'package:easy_localization/easy_localization.dart';

class MyVoiceVideoRecordingScreen extends StatefulWidget {
  final String? comeFrom;
  final String? totalPrice;
  final String? advertisementType;
  const MyVoiceVideoRecordingScreen(
      {super.key, this.comeFrom, this.totalPrice, this.advertisementType});

  @override
  MyVoiceVideoRecordingScreenState createState() =>
      MyVoiceVideoRecordingScreenState();
}

class MyVoiceVideoRecordingScreenState
    extends State<MyVoiceVideoRecordingScreen> with TickerProviderStateMixin {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  String? videoPath;
  String? filteredVideoPath;
  bool isFrontCamera = true;
  bool isRecording = false;
  late AnimationController _animationController;
  Timer? _stopTimer;
  Timer? _notifyTimer;
  int _secondsRemaining = 15;
  int currentIndex = 0;
  bool? showUploadReelButton;

  bool showGalleryBtn = false;

  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;
  File? _selectedImage;
  File? _selectedVideo;
  FlashMode _flashMode = FlashMode.off;
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initializeAnimationController();
    _initializeFlashAnimation();
  }

  void _initializeFlashAnimation() {
    _flashAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _flashAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_flashAnimationController);
  }
  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      await _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
    } catch (e) {
      log("Camera initialization error: $e");
      _showErrorDialog(LocaleKeys.error_dialog_camera_init_fail.tr());
    }
  }
  void _changeFlashMode() {
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.off;
      }
      else {
        _flashMode = FlashMode.off;
      }
    });

    _controller!.setFlashMode(_flashMode);
    _flashAnimationController.forward(from: 0.0);
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
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
      _showErrorDialog(LocaleKeys.error_dialog_controller_init_fail.tr());
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
        showUploadReelButton = false;
        isRecording = true;
        showGalleryBtn = false;
      });

      _animationController.reset();
      _animationController.forward();
      _startTimers();
    } catch (e) {
      log("Error starting recording: $e");
      _showErrorDialog(LocaleKeys.error_dialog_start_recording_fail.tr());
    }
  }

  void _startTimers() {
    _secondsRemaining = 15;
    _notifyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });
    });

    _stopTimer = Timer(const Duration(seconds: 15), _stopRecording);
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

      showUploadReelButton = await _mergeVideoWithFilter();

    } catch (e) {
      log("Error stopping recording: $e");
      _showErrorDialog(LocaleKeys.error_dialog_stop_recording_fail.tr());
    }
  }

  void _resetRecordingState() {
    _animationController.stop();
    _animationController.reset();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
  }

  String? _thumbnailPath;

  Future<void> _generateThumbnail(String videoThumbnail) async {
    final directory = await getTemporaryDirectory();
    final thumbnail = await thumb.VideoThumbnail.thumbnailFile(
      video: videoThumbnail,
      // Replace with your video URL or file path
      thumbnailPath: directory.path,
      imageFormat: thumb.ImageFormat.JPEG,
      maxWidth: 128,
      quality: 75,
    );

    setState(() {
      _thumbnailPath = thumbnail;
    });
  }

  Future<bool?> _mergeVideoWithFilter() async {
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
        await _generateThumbnail(filteredVideoPath!);
        _navigateToPlaybackScreen();
        if (savedSuccessfully ?? false) {
          log('Saved');
        } else {
          throw Exception('error_dialog_save_video_fail');
        }
        return savedSuccessfully;

      } else {
        final failStackTrace = await session.getFailStackTrace();
        throw Exception(
            "FFmpeg process failed with return code $returnCode\n$failStackTrace");
      }
    } catch (e) {
      log("Error in _mergeVideoWithFilter: $e");
      _showErrorDialog(
          LocaleKeys.error_dialog_video_process_fail.tr(args: [e.toString()]));
      filteredVideoPath = null;
    }
    return false;
  }
  void _navigateToPlaybackScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlaybackScreen(filteredVideoPath!,_thumbnailPath!,true),
      ),
    );
  }


  void _switchCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            LocaleKeys.error_dialog_title.tr(),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              LocaleKeys.error_dialog_ok_button.tr(),
              style: const TextStyle(color: AppColors.SECONDARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _applyFilter(filters[index]),
              child: Container(
                width: 150.h,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _selectedFilter == filters[index]
                          ? Colors.blue
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          FilterLibrary.filterImagesPaths[index].toString(),
                        ),
                      ),
                      Text(
                          context.isArabic
                              ? filters[index].arName
                              : filters[index].enName,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.sp,
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
      body: SafeArea(
        child: Stack(
          children: [
            _buildCameraPreview(),
            if (isRecording) _buildTimerPopup(),
            Positioned(
              bottom: 250.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                //  _buildFilterSelector(),
                  _buildControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: _selectedFilter?.colorFilter ??
                const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
            child: CameraPreview(_controller!),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
              vertical: 40.h,
              horizontal: 20.w
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _buildSwitchCameraButton(50.sp),
                    IconButton(
                      icon: Icon(
                        size: 50.sp,
                        _flashMode == FlashMode.off
                            ? FontAwesomeIcons.bolt
                            : FontAwesomeIcons.bolt,
                        color: _flashMode == FlashMode.off
                            ? Colors.grey
                            : _flashMode == FlashMode.auto
                            ? Colors.yellow.shade100
                            : Colors.yellow,
                      ),
                      onPressed: _changeFlashMode,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:  Icon(Icons.clear,size: 50.sp,))
              ],
            ),
          ),
        ],
      ),
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
            LocaleKeys.timer_recording_stops_in.tr() +
                _secondsRemaining.toString() +
                LocaleKeys.timer_seconds.tr(),
            style: TextStyle(color: Colors.white, fontSize: 30.sp),
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
          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 100.w,),
              Center(
                child: IconButton(
                  color: Colors.white,
                  icon: Stack(
                    children: [
                      Icon(
                        size: 60.sp,
                        Icons.photo_library,
                      ),
                    ],
                  ),
                  onPressed: () {
                    _pickMediaFromGallery()
                      .then((value) {
                    if(_selectedImage?.path !=null) {
                     return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsRecordingScreen(
                              // voiceMediaId: widget.reel.audioMedia,
                              // voiceSignedUrl: widget.audio.audioSignedUrl,
                            ),
                          ));
                    }
                  });
                  }, // Pick an image from gallery
                ),
              ),
              SizedBox(width: 100.w,),
              GestureDetector(
                onLongPress: () => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white70, width: 8.w),
                      ),
                      child: CustomPaint(
                        painter: ProgressPainter(
                          progress: _animationController.value,
                          color: Colors.pink,
                        ),
                        child: Icon(
                          Icons.fiber_manual_record,
                          color: Colors.white.withOpacity(0.9),
                          size: MediaQuery.of(context).size.width * 0.22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             // Expanded(child: _buildSwitchCameraButton(60.h)),
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
        Icons.flip_camera_android,
        semanticLabel: LocaleKeys.controls_switch_camera.tr(),
        size: width,
      ),
    );
  }


  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
    _flashAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickMediaFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);

        // Determine the file type based on extension
        final fileType = pickedFile.path.split('.').last.toLowerCase();
        final isImage = ['jpg', 'jpeg', 'png'].contains(fileType);

        setState(() {
          if (isImage) {
            _selectedImage = pickedFile;
            _selectedVideo = null;
          } else {
            _selectedVideo = pickedFile;
            _selectedImage = null;
          }
        });

        // Navigate to MediaPreviewScreen with the media path and type
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              mediaPath: pickedFile.path,
              isImage: isImage,
            ),
          ),
        );
      } else {
        print("No media selected.");
      }
    } catch (e) {
      print("Error picking media: $e");
    }
  }


  Widget _buildMediaPreview() {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!);
    } else if (_selectedVideo != null) {
      return Text("Video selected: ${_selectedVideo!.path}");
    } else {
      return Text("No media selected.");
    }
  }

}
