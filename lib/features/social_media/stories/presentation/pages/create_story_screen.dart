// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';
// ignore: library_prefixes
import 'dart:math' as forRandom;

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/privacy_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:camera/camera.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../res/style/const.dart';
import '../../../../../service_locator/service_locator.dart';
import '../cubit/stories_cubit.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // For localization keys

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  final PageController _pageController = PageController();
  int _selectedPageIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String? _storyText = "";
  String? _descriptionText;

  CameraController? _cameraController;
  // XFile? _capturedImage;
  bool _isCameraInitialized = false;
  late List<CameraDescription> cameras;

  @override
  initState() {
    super.initState();
    initializeCameras();
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // Use the first available camera
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      print('No cameras available');
    }
    setState(() {});
  }

  Future<void> _initializeCamera() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // Use the first available camera
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      print('No cameras available');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      setState(() {
        _selectedFile = File(image.path);
      });
    }
  }

  void _closeImagePreview() {
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    _pageController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _disposeVideoControllers() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _videoPlayerController = null;
    _chewieController = null;
  }

  Future<void> _initializeVideoPlayer(File videoFile) async {
    _disposeVideoControllers();
    _videoPlayerController = VideoPlayerController.file(videoFile);

    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      autoPlay: true,
      looping: false,
      showControls: true,
      placeholder: const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );

    setState(() {});
  }

  final Map<String, Color> colorMap = {
    'Colors.red': Colors.red,
    'Colors.white': Colors.blueGrey,
    // 'Colors.black': Colors.black,
    'Colors.blue': Colors.blue,
    'Colors.green': Colors.green,
    'Colors.yellow': Colors.yellow,
    'Colors.orange': Colors.orange,
    'Colors.purple': Colors.purple,
  };

  Color currentColor = Colors.blueGrey;

  void getRandomColor() {
    final random = forRandom.Random();
    setState(() {
      currentColor = colorMap.values.elementAt(random.nextInt(colorMap.length));
    });
  }

  final List<String> fontFamilies = [
    'Roboto',
    'Courier New',
    'Times New Roman',
    'Verdana',
    'Amiri',
  ];

  int _currentFontIndex = 0;
  String currentFontFamily = 'Roboto';
  void getNextFontFamily() {
    setState(() {
      _currentFontIndex = (_currentFontIndex + 1) % fontFamilies.length;
      currentFontFamily = fontFamilies[_currentFontIndex];
    });
  }

  String getColorStringFromColor(Color color) {
    String? colorString;
    colorMap.forEach((key, value) {
      if (value == color) {
        colorString = key;
      }
    });

    return colorString ?? 'Unknown Color'; // Return a default if not found
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: _selectedPageIndex != 0 ? Colors.black : currentColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: _buildTopControls(),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _disposeVideoControllers();
                    _selectedPageIndex = index;
                  });
                },
                children: [
                  _buildTextStoryInput(),
                  _buildImagePreview(context),
                  _buildVideoPreview(),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_selectedPageIndex == 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              // padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.color_lens_outlined,
                  color: currentColor == Colors.white
                      ? Colors.black
                      : Colors.white,
                  size: 22,
                ),
                onPressed: getRandomColor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        if (_selectedPageIndex == 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: TextButton(
                onPressed: getNextFontFamily,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'T',
                  style: TextStyle(
                    fontFamily: currentFontFamily,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        // if ((_storyText != null && _storyText!.isNotEmpty) ||
        //     (_selectedFile != null))
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedPageIndex != 0
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.5),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.more_horiz, color: Colors.white, size: 22),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => serviceLocator<StoryCubit>(),
                        child: const StatusPrivacyScreen(),
                      ),
                    ));
              },
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedPageIndex != 0
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.5),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.close,
                size: 22,
                color: Colors.white,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // if (_selectedPageIndex == 1)
            // _buildIconButton(
            //   icon: Icons.image,
            //   color: Colors.black,
            //   onPressed: _pickImageFromGallery,
            // ),
            if (_selectedPageIndex == 2)
              _buildIconButton(
                icon: Icons.videocam,
                color: Colors.black,
                onPressed: _pickVideo,
              ),
            // if (_selectedPageIndex != 0) _buildCaptureButton(),
            if (_selectedPageIndex == 0) const Spacer(),
            if (_selectedPageIndex == 0)
              const SizedBox(
                width: 30,
              ),
          ],
        ),
        // if (_selectedPageIndex != 0) _buildDescriptionField(),
        _buildModeSelector(),
      ],
    );
  }

  String _determineFileType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    if (extension == '.mp4') {
      return 'video/mp4';
    } else if (['.jpg', '.jpeg', '.png'].contains(extension)) {
      return 'image/jpeg';
    } else if (extension == '.mp3') {
      return 'audio/mp3';
    } else {
      throw Exception('Unsupported file type');
    }
  }

  Widget _buildTextStoryInput() {
    FocusNode focusNode = FocusNode();

    if (_isRecording) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: MediaQuery.of(context).size.height * 0.35),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16.0),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: CachedNetworkImageProvider(
                      context.read<UserCubit>().state.data!.profilePicture ??
                          UIConst.profilePlaceHolder,
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: -8,
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 24.0),
              // Animated Row
              AnimatedRecording(context: context),
              const Spacer(),
              TimeCounter(context: context),
            ],
          ),
        ),
      );
    } else if (mp3File != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: MediaQuery.of(context).size.height * 0.335),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 24.0,
                          backgroundImage: CachedNetworkImageProvider(
                            context
                                    .read<UserCubit>()
                                    .state
                                    .data!
                                    .profilePicture ??
                                UIConst.profilePlaceHolder,
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: -8,
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: VoiceMessageView(
                        counterTextStyle: const TextStyle(color: Colors.white),
                        activeSliderColor: AppColors.BACKGROUND_COLOR,
                        circlesColor: AppColors.PRIMARY_COLOR_DARK,
                        notActiveSliderColor: Colors.black.withOpacity(0),
                        backgroundColor: Colors.transparent,
                        innerPadding: 12,
                        cornerRadius: 12,
                        controller: VoiceController(
                          audioSrc: mp3File!.path,
                          maxDuration: const Duration(minutes: 1000),
                          isFile: true,
                          onComplete: () async {},
                          onPause: () async {},
                          onPlaying: () async {},
                          onError: (p0) {},
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8.0),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        mp3File = null;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Divider(
                  color: AppColors.LIGHT_GRAY_COLOR2,
                  height: 70,
                  indent: MediaQuery.of(context).size.width * 0.32,
                  endIndent: MediaQuery.of(context).size.width * 0.3,
                  // thickness: 2,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Container(
          color: currentColor,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: TextField(
                focusNode: focusNode,
                autofocus: true,
                cursorColor: Colors.white,
                maxLines: null,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: currentFontFamily,
                  color: Colors.white,
                  // shadows: [
                  //   Shadow(
                  //     offset: Offset(1.0, 1.0),
                  //     blurRadius: 4.0,
                  //     color: Colors.black,
                  //   ),
                  // ],
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys.write_story.tr(),
                  // Localized text
                  hintStyle: TextStyle(
                    fontSize: 50.sp,
                    fontFamily: currentFontFamily,
                    color: Colors.white70.withOpacity(0.3),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                onChanged: (text) {
                  setState(() {
                    _storyText = text;
                  });
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  // Widget _buildImagePreview(BuildContext context) {
  //   if (_selectedFile == null) {
  //     return Center(
  //       child: Text(
  //           context.isArabic ? 'لم يتم اختيار صوره' : 'No image selected',
  //           style: const TextStyle(color: Colors.black54)),
  //     );
  //   }
  //   return _selectedFile != null
  //       ? Image.file(
  //           _selectedFile!,
  //           fit: BoxFit.fitHeight,
  //           errorBuilder: (context, error, stackTrace) => Image.network(
  //             UIConst.imagePlaceHolder,
  //             fit: BoxFit.fitHeight,
  //           ),
  //         )
  //       : Image.network(
  //           UIConst.imagePlaceHolder,
  //           fit: BoxFit.fitHeight,
  //         );
  // }

  Widget _buildImagePreview(BuildContext context) {
    return Stack(
      children: [
        // Camera preview or captured image
        _selectedFile == null
            ? _isCameraInitialized
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(_cameraController!),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  )
            : Image.file(
                _selectedFile!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

        // if (_selectedFile == null)
        //   Positioned(
        //     top: 10,
        //     right: 10,
        //     child: IconButton(
        //       icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
        //       onPressed: () async {
        //         if (cameras.length > 1) {
        //           final newIndex =
        //               cameras.indexOf(_cameraController!.description) == 0
        //                   ? 1
        //                   : 0;
        //           _cameraController = CameraController(
        //             cameras[newIndex],
        //             ResolutionPreset.high,
        //           );
        //           await _cameraController!.initialize();
        //           setState(() {});
        //         }
        //       },
        //     ),
        //   ),
        // Capture button and bottom menu
        if (_selectedFile == null)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera, color: Colors.white, size: 48),
              onPressed: _capturePhoto,
            ),
          ),
        if (_selectedFile == null)
          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                onPressed: _pickImageFromGallery,
              ),
            ),
          ),
        if (_selectedFile == null)
          Positioned(
            bottom: 20,
            right: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: IconButton(
                icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                onPressed: () async {
                  if (cameras.length > 1) {
                    final newIndex =
                        cameras.indexOf(_cameraController!.description) == 0
                            ? 1
                            : 0;
                    _cameraController = CameraController(
                      cameras[newIndex],
                      ResolutionPreset.high,
                    );
                    await _cameraController!.initialize();
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        if (_selectedFile != null)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildDescriptionField(),
          )
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        _selectedFile == null && _cameraController != null
            ? _isCameraInitialized
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(_cameraController!),
                  )
                : const Center(child: CircularProgressIndicator())
            : _videoPlayerController != null
                ? Center(
                    child: AspectRatio(
                      aspectRatio:
                          _videoPlayerController?.value.aspectRatio ?? 1.0,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  )
                : const SizedBox(),
        if (_selectedFile == null &&
            _cameraController != null &&
            _cameraController!.value.isInitialized &&
            !_cameraController!.value.isRecordingVideo)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
              onPressed: _captureVideo,
            ),
          ),
        if (_selectedFile == null &&
            _cameraController != null &&
            _cameraController!.value.isInitialized &&
            !_cameraController!.value.isRecordingVideo)
          Positioned(
            bottom: 20,
            right: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: IconButton(
                icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                onPressed: () async {
                  if (cameras.length > 1) {
                    final newIndex =
                        cameras.indexOf(_cameraController!.description) == 0
                            ? 1
                            : 0;
                    _cameraController = CameraController(
                      cameras[newIndex],
                      ResolutionPreset.high,
                    );
                    await _cameraController!.initialize();
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        if (_selectedFile == null &&
            _cameraController != null &&
            _cameraController!.value.isInitialized &&
            !_cameraController!.value.isRecordingVideo)
          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: IconButton(
                icon: const Icon(Icons.image, color: Colors.white),
                onPressed: _pickVideoFromGallery,
              ),
            ),
          ),
        if (_selectedFile == null &&
            _cameraController != null &&
            _cameraController!.value.isInitialized &&
            _cameraController!.value.isRecordingVideo)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: IconButton(
              icon: Stack(
                children: [
                  const _VideoCircularIndicator(
                    duration: Duration(
                      seconds: 30,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.transparent, width: 4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.PRIMARY_COLOR_DARK,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: _captureVideo,
            ),
          ),
        if (_selectedFile != null)
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: IconButton(
              icon: _videoPlayerController?.value.isPlaying ?? false
                  ? const SizedBox()
                  : const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
              onPressed: () {
                setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                });
              },
            ),
          ),
        if (_selectedFile != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDescriptionField(),
          )
      ],
    );
  }

  Future<void> _captureVideo() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      if (_cameraController!.value.isRecordingVideo) {
        final file = await _cameraController!.stopVideoRecording();

        // Rename the file to add .mp4 extension
        final directory = file.path.substring(0, file.path.lastIndexOf('/'));
        final newFilePath =
            '$directory/${DateTime.now().millisecondsSinceEpoch}.mp4';
        final newFile = await File(file.path).rename(newFilePath);

        setState(() {
          _selectedFile = newFile;
          _videoPlayerController = VideoPlayerController.file(_selectedFile!)
            ..initialize().then((_) {
              setState(() {});
              // _videoPlayerController!.play();
            });
        });
      } else {
        await _cameraController!.startVideoRecording();
        setState(() {});
        // Stop recording automatically after 30 seconds
        Future.delayed(const Duration(seconds: 30), () async {
          if (_cameraController != null &&
              _cameraController!.value.isRecordingVideo) {
            final file = await _cameraController!.stopVideoRecording();

            // Rename the file to add .mp4 extension
            final directory =
                file.path.substring(0, file.path.lastIndexOf('/'));
            final newFilePath =
                '$directory/${DateTime.now().millisecondsSinceEpoch}.mp4';
            final newFile = await File(file.path).rename(newFilePath);

            setState(() {
              _selectedFile = newFile;
              _videoPlayerController =
                  VideoPlayerController.file(_selectedFile!)
                    ..initialize().then((_) {
                      setState(() {});
                      // _videoPlayerController!.play();
                    });
            });
          }
        });
      }
    }
  }

  void _resetVideo() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.seekTo(Duration.zero);
      _videoPlayerController!.pause();
    }
  }

  Future<void> _pickVideoFromGallery() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the directory of the picked file
      final directory =
          pickedFile.path.substring(0, pickedFile.path.lastIndexOf('/'));

      // Create a new file path with the .mp4 extension
      final newFilePath =
          '$directory/${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Rename the file to add .mp4 extension
      final newFile = await File(pickedFile.path).copy(newFilePath);

      setState(() {
        _selectedFile = newFile;
        _videoPlayerController = VideoPlayerController.file(_selectedFile!)
          ..initialize().then((_) {
            setState(() {});
            // _videoPlayerController!.play();
          });
      });
    }
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: TextField(
                  cursorColor: Colors.white,
                  cursorErrorColor: Colors.red,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      hintText: LocaleKeys.add_description.tr(),
                      // Localized text
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.transparent),
                  onChanged: (text) {
                    setState(() {
                      _descriptionText = text;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onPressed,
    );
  }

  Widget _buildCaptureButton() {
    return IconButton(
      onPressed: () async {
        if (_selectedPageIndex == 1) {
          await _pickImageFromCamera();
        } else if (_selectedPageIndex == 2) {
          await _recordVideo();
        }
      },
      icon: const Icon(Icons.camera_alt, color: Colors.black, size: 36),
    );
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 60));

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);

      setState(() {
        _selectedFile = videoFile;
        _initializeVideoPlayer(videoFile);
      });
    }
  }

  Widget _buildModeSelector() {
    return Container(
      clipBehavior: Clip.none,
      height: kToolbarHeight * 1.1,
      color: _selectedPageIndex != 0
          ? Colors.white.withOpacity(0.2)
          : Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            (_storyText != null && _storyText!.isNotEmpty ||
                    mp3File != null ||
                    _selectedFile != null)
                ? InkWell(
                    onTap: () {
                      // open story privacy screen
                    },
                    child: SizedBox(
                      height: 40,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.data_saver_off,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  context.isArabic
                                      ? "الحالة (جهات الاتصال)"
                                      : "Status (Contacts)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            // const Spacer(),
            (_storyText != null &&
                    _storyText!.isEmpty &&
                    !_isRecording &&
                    mp3File == null &&
                    _selectedFile == null)
                ? _buildModeSelectorButton(0, LocaleKeys.text.tr())
                : const SizedBox(),
            // Localized text
            (_storyText != null &&
                    _storyText!.isEmpty &&
                    !_isRecording &&
                    mp3File == null &&
                    _selectedFile == null)
                ? _buildModeSelectorButton(
                    1, context.isArabic ? 'صوره' : 'Photo')
                : const SizedBox(),
            // Localized text
            (_storyText != null &&
                    _storyText!.isEmpty &&
                    !_isRecording &&
                    mp3File == null &&
                    _selectedFile == null)
                ? _buildModeSelectorButton(2, LocaleKeys.video.tr())
                : const SizedBox(),
            // Localized text
            !_isRecording ? const Spacer() : const SizedBox(),
            _selectedPageIndex == 0
                ? (_storyText != null && _storyText!.isNotEmpty ||
                        mp3File != null)
                    ? Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            if (_selectedPageIndex == 0) {
                              if (_storyText != null &&
                                  _storyText!.isNotEmpty) {
                                await serviceLocator<StoryCubit>()
                                    .createTextStory(
                                      text: _storyText!,
                                      color:
                                          getColorStringFromColor(currentColor),
                                      fontFamily: currentFontFamily,
                                    )
                                    .then((value) => Navigator.pop(context));
                              } else if (mp3File != null) {
                                // send voic story

                                final file = mp3File;
                                final fileType = _determineFileType(file!.path);
                                final fileSize = await file.length();

                                await serviceLocator<StoryCubit>()
                                    .uploadStoryVideoOrImageOrVoice(
                                      file,
                                      fileType,
                                      fileSize,
                                      description: _descriptionText,
                                      color:
                                          getColorStringFromColor(currentColor),
                                    )
                                    .then((value) => Navigator.pop(context));
                              } else {
                                showErrorMessage(
                                    context,
                                    context.isArabic
                                        ? 'من فضلك ادخل النص'
                                        : 'Please enter text');
                              }
                            }
                          },
                        ),
                      )
                    :
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: AppColors.PRIMARY_COLOR,
                    //   ),
                    //   child: IconButton(
                    //     icon: const Icon(
                    //       Icons.mic,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //     padding: const EdgeInsets.all(0),
                    //     onPressed: () async {

                    //       // create voice story
                    //     },
                    //   ),
                    // )
                    SizedBox(
                        width: _isRecording
                            ? MediaQuery.of(context).size.width - 32
                            : 45,
                        child: _micButton(context),
                      )
                : const SizedBox(),
            (_selectedPageIndex != 0 && _selectedFile != null)
                ? Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        if (_selectedPageIndex == 1 ||
                            _selectedPageIndex == 2) {
                          if (_selectedFile != null) {
                            final file = _selectedFile;
                            final fileType = _determineFileType(file!.path);
                            final fileSize = await file.length();

                            await serviceLocator<StoryCubit>()
                                .uploadStoryVideoOrImageOrVoice(
                                    file, fileType, fileSize,
                                    description: _descriptionText)
                                .then((value) => Navigator.pop(context));
                          } else {
                            _selectedPageIndex == 2
                                ? showErrorMessage(
                                    context,
                                    LocaleKeys.pleaseUploadVideo.localize,
                                  )
                                : showErrorMessage(context,
                                    LocaleKeys.pleaseUploadImage.localize);
                          }
                        }
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isRecording = false;
  File? mp3File;

  Widget _micButton(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _isRecording
            ? const SizedBox()
            : Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
        SocialMediaRecorder(
          maxRecordTimeInSecond: 60,
          startRecording: () async {
            _isRecording = true;
            setState(() {});
          },

          stopRecording: (time) async {
            _isRecording = false;

            setState(() {});
          },
          encode: AudioEncoderType.AAC, // Ensure it's recorded in AAC

          sendRequestFunction: (File soundFile, String time) async {
            _isRecording = false;
            setState(() {});
            log("sound file path is : ${soundFile.path}");
            // Rename the file to .mp3
            String newPath = soundFile.path.replaceAll('.m4a', '.mp3');
            log("new path is : $newPath");
            mp3File = await soundFile.rename(newPath);

            log(mp3File!.path); // Log the new file path
            setState(() {});

            // Play the audio file locally
            // await audioPlayer.play(
            //   DeviceFileSource(mp3File!.path),
            //   volume: 0,
            // );
          },
          initRecordPackageWidth: 45,
          fullRecordPackageHeight: 45,
          recordIcon:
              Icon(Icons.mic, color: AppColors.BACKGROUND_COLOR, size: 40.h),
          recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
          recordIconWhenLockBackGroundColor: AppColors.PRIMARY_COLOR,
          counterBackGroundColor: Colors.transparent,
          cancelTextBackGroundColor: Colors.transparent,
          backGroundColor: Colors.transparent,
          cancelTextStyle: const TextStyle(color: Colors.white),
          counterTextStyle: const TextStyle(color: Colors.transparent),
          radius: BorderRadius.circular(60),
        ),
      ],
    );
  }

  Widget _buildModeSelectorButton(int index, String mode) {
    bool isSelected = _selectedPageIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white12 : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _disposeVideoControllers();
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _disposeVideoControllers();
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);

      setState(() {
        _selectedFile = videoFile;
        _initializeVideoPlayer(videoFile);
      });
    }
  }
}

class TimeCounter extends StatefulWidget {
  const TimeCounter({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<TimeCounter> createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  int counter = 60;
  @override
  void initState() {
    super.initState();
    decreaseCounter();
  }

  void decreaseCounter() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        counter--;
        if (counter <= 0) {
          return;
        }
      });
      if (counter > 0) {
        decreaseCounter();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        '0:$counter',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class AnimatedRecording extends StatefulWidget {
  const AnimatedRecording({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<AnimatedRecording> createState() => _AnimatedRecordingState();
}

class _AnimatedRecordingState extends State<AnimatedRecording> {
  bool _isVisible = true;

  void _toggleVisibility() {
    // تغيير الحالة بشكل دوري
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVisible = !_isVisible;
      });
      _toggleVisibility();
    });
  }

  @override
  void initState() {
    super.initState();
    _toggleVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _isVisible ? 1.0 : 0.0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            context.isArabic ? "تسجيل صوت" : 'Recording...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCircularIndicator extends StatefulWidget {
  final Duration duration;

  const _VideoCircularIndicator({required this.duration});

  @override
  State<_VideoCircularIndicator> createState() =>
      __VideoCircularIndicatorState();
}

class __VideoCircularIndicatorState extends State<_VideoCircularIndicator> {
  Timer? _timer;
  int _time = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick <= widget.duration.inSeconds) {
        setState(() {
          _time = timer.tick;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: CircularProgressIndicator(
        value: 1 - (_time / widget.duration.inSeconds),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: AppColors.SECONDARY_COLOR,
      ),
    );
  }
}
