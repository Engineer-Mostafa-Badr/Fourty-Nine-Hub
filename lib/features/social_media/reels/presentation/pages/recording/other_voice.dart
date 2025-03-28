import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;

import '../../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../../core/widget/custom_scaffold.dart';
import '../../shared/filter_utiles.dart';
import 'recording_shared.dart';

class OtherVoiceVideoRecordingScreen extends StatefulWidget {
  final String voiceUrl;
  final String voiceMediaId;
  final String? comeFrom;
  final String? totalPrice;
  final String? advertisementType;

  const OtherVoiceVideoRecordingScreen(
      {super.key,
      required this.voiceUrl,
      required this.voiceMediaId,
      this.comeFrom,
      this.totalPrice,
      this.advertisementType});

  @override
  OtherVoiceVideoRecordingScreenState createState() =>
      OtherVoiceVideoRecordingScreenState();
}

class OtherVoiceVideoRecordingScreenState
    extends State<OtherVoiceVideoRecordingScreen>
    with TickerProviderStateMixin {
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
  int _secondsRemaining = 15;
  bool? showUploadReelButton;

  bool showGalleryBtn = false;
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

  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;

  void _applyFilter(Filter filter) {
    setState(() {
      _selectedFilter = filter;
    });
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
  void initState() {
    super.initState();
    _initCamera();
    _initializeAnimationController();
    _loadAndPlayAudio();
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
      _showErrorDialog(LocaleKeys.error_dialog_controller_init_fail.tr());
    }
  }

  Future _loadAndPlayAudio() async {
    print('Audio try to play');
    await _audioPlayer.setUrl(widget.voiceUrl);
    _audioPlayer.setLoopMode(LoopMode.one);
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
      _audioPlayer.play(); // Start the audio playback

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

    _stopTimer = Timer(const Duration(seconds: 30), _stopRecording);
  }

  void _stopRecording() async {
    if (!_controller!.value.isRecordingVideo) return;
    final videoFile = await _controller!.stopVideoRecording();
    videoPath = videoFile.path;
    setState(() {
      isRecording = false;
    });
    _resetRecordingState();
    showUploadReelButton = await _mergeVideoWithAudio();
  }

  void _resetRecordingState() {
    _animationController.stop();
    _audioPlayer.stop();
    _animationController.reset();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
  }

  Future<bool?> _mergeVideoWithAudio() async {
    final directory = await getTemporaryDirectory();
    mergedVideoPath =
        '${directory.path}/merged_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Combine the selected filter with the horizontal flip (if any filter exists)
    final filterCommand = _selectedFilter?.ffmpegFilter != null
        ? '${_selectedFilter!.ffmpegFilter},hflip' // Apply horizontal flip after the selected filter
        : 'hflip'; // Apply horizontal flip if no filter is selected
    // FFmpeg command arguments
    final commandArgs = [
      '-i', videoPath!, // Input video path
      '-i', widget.voiceUrl, // Input audio path
      if (filterCommand.isNotEmpty) ...['-vf', filterCommand], // Apply filters
      '-map', '0:v:0', // Use video stream from the first input
      '-map', '1:a:0', // Use audio stream from the second input
      '-c:v', 'mpeg4', // Use MPEG-4 codec for video
      '-q:v', '5', // Lower quality for faster processing
      '-b:v', '1M', // Set bitrate to 1 Mbps
      '-c:a', 'aac', // Use AAC codec for audio
      '-shortest', // Trim the output to the shortest stream
      mergedVideoPath!, // Output file path
    ];

    log("Executing FFmpeg command: ${commandArgs.join(' ')}");

    final session = await FFmpegKit.executeWithArguments(commandArgs);
    var returned = await session.getReturnCode();
    var logs = await session.getAllLogs();
    var stats = await session.getAllStatistics();
    log('stats length ${stats.length.toString()}');
    log('logs ${logs.toString()}');
    log('returned ${returned?.getValue().toString()}');
    // final savedSuccessfully = await GallerySaver.saveVideo(mergedVideoPath!);
    await _generateThumbnail(mergedVideoPath!);
    // if (savedSuccessfully ?? false) {
    //   print('saved');
    //   setState(() {
    //     showGalleryBtn = true; // Show the gallery button if save is successful
    //   });
    //   showSuccessMessage(
    //       context, "Video saved successfully and ready to be shared");
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           VideoPlaybackScreen(mergedVideoPath!, _thumbnailPath!, false),
    //     ),
    //   );
    // }
    // final output = await session.getOutput();
    // log("alibaba output: $output");
    // log('final merged file path ${mergedVideoPath.toString()}');
    // final file = File(mergedVideoPath!);
    // log("Merged video file size: ${file.lengthSync()} bytes");
    return false;
  }

  void _switchCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    _initializeCameraController(cameras[isFrontCamera ? 1 : 0]);
  }

  void _showErrorDialog(String message) {
    showAnimatedDialog(context,AlertDialog(
        title: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            LocaleKeys.message,
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
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Padding(
    //       padding: EdgeInsets.all(16.0),
    //       child: Text(
    //         LocaleKeys.message,
    //       ),
    //     ),
    //     content: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Text(
    //         message,
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text(
    //           LocaleKeys.error_dialog_ok_button.tr(),
    //           style: const TextStyle(color: AppColors.SECONDARY_COLOR),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const CustomScaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: CupertinoActivityIndicator(
            color: Colors.white,
            radius: 25,
          )));
    }

    return CustomScaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
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
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox(
      height: double.infinity,
      child: ColorFiltered(
        colorFilter: _selectedFilter?.colorFilter ??
            const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
        child: CameraPreview(_controller!),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              showGalleryBtn
                  ? Expanded(
                      child: IconButton(
                        onPressed: _navigateToPlaybackScreen,
                        icon: Icon(
                          Icons.video_collection,
                          color: Colors.white,
                          size: 60.h,
                        ),
                      ),
                    )
                  : const Spacer(),
              Expanded(
                child: GestureDetector(
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
              ),
              Expanded(child: _buildSwitchCameraButton(60.h)),
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
        semanticLabel: LocaleKeys.controls_switch_camera.tr(),
        color: Colors.white,
        size: width,
      ),
    );
  }

  void _navigateToPlaybackScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlaybackScreen(
          mergedVideoPath!,
          _thumbnailPath!,
          false,
          audioMediaId: widget.voiceMediaId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    _audioPlayer.dispose();
    _stopTimer?.cancel();
    _notifyTimer?.cancel();
    super.dispose();
  }
}
