import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/privacy_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

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
  String? _storyText;
  String? _descriptionText;

  @override
  void dispose() {
    _disposeVideoControllers();
    _pageController.dispose();
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
    'Colors.black': Colors.black,
    'Colors.blue': Colors.blue,
    'Colors.green': Colors.green,
    'Colors.yellow': Colors.yellow,
    'Colors.orange': Colors.orange,
    'Colors.purple': Colors.purple,
  };

  Color currentColor = Colors.blueGrey;

  void getRandomColor() {
    final random = Random();
    setState(() {
      currentColor = colorMap.values.elementAt(random.nextInt(colorMap.length));
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
    return Scaffold(
      backgroundColor: currentColor,
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
    );
  }

  Widget _buildTopControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_selectedPageIndex == 0)
          IconButton(
            icon: Icon(
              Icons.color_lens_outlined,
              color: currentColor == Colors.white ? Colors.black : Colors.white,
              size: 30,
            ),
            onPressed: getRandomColor,
            style: ElevatedButton.styleFrom(
              backgroundColor: currentColor,
            ),
          ),
        if ((_storyText != null && _storyText!.isNotEmpty) ||
            (_selectedFile != null))
          IconButton(
            icon: const Icon(Icons.privacy_tip_outlined,
                color: Colors.black, size: 30),
            onPressed: () {
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
            if (_selectedPageIndex == 1)
              _buildIconButton(
                icon: Icons.image,
                color: Colors.black,
                onPressed: _pickImageFromGallery,
              ),
            if (_selectedPageIndex == 2)
              _buildIconButton(
                icon: Icons.videocam,
                color: Colors.black,
                onPressed: _pickVideo,
              ),
            if (_selectedPageIndex != 0) _buildCaptureButton(),
            if (_selectedPageIndex == 0) const Spacer(),
            _buildIconButton(
              icon: Icons.send,
              color: Colors.black,
              onPressed: () async {
                if (_selectedPageIndex == 0) {
                  if (_storyText != null && _storyText!.isNotEmpty) {
                    await serviceLocator<StoryCubit>()
                        .createTextStory(
                            "${getColorStringFromColor(currentColor)}~$_storyText")
                        .then((value) => Navigator.pop(context));
                  }
                }
                if (_selectedPageIndex == 1 || _selectedPageIndex == 2) {
                  if (_selectedFile != null) {
                    final file = _selectedFile;
                    final fileType = _determineFileType(file!.path);
                    final fileSize = await file.length();

                    await serviceLocator<StoryCubit>()
                        .uploadStoryVideoOrImage(file, fileType, fileSize,
                            description: _descriptionText)
                        .then((value) => Navigator.pop(context));
                  } else {
                    _selectedPageIndex == 2
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    LocaleKeys.pleaseUploadVideo.localize)),
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    LocaleKeys.pleaseUploadImage.localize)),
                          );
                  }
                }
              },
            ),
            if (_selectedPageIndex == 0)
              const SizedBox(
                width: 30,
              ),
          ],
        ),
        if (_selectedPageIndex != 0) _buildDescriptionField(),
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
    } else {
      throw Exception('Unsupported file type');
    }
  }

  Widget _buildTextStoryInput() {
    FocusNode focusNode = FocusNode();

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
              cursorColor: Colors.white,
              maxLines: null,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Colors.black,
                  ),
                ],
              ),
              decoration: InputDecoration(
                hintText: LocaleKeys.write_story.tr(),
                // Localized text
                hintStyle: TextStyle(
                  fontSize: 50.sp,
                  color: Colors.white70,
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

  Widget _buildImagePreview(BuildContext context) {
    if (_selectedFile == null) {
      return Center(
        child: Text(
            context.isArabic ? 'لم يتم اختيار صوره' : 'No image selected',
            style: const TextStyle(color: Colors.black54)),
      );
    }
    return _selectedFile != null
        ? Image.file(
            _selectedFile!,
            fit: BoxFit.fitHeight,
            errorBuilder: (context, error, stackTrace) => Image.network(
              UIConst.imagePlaceHolder,
              fit: BoxFit.fitHeight,
            ),
          )
        : Image.network(
            UIConst.imagePlaceHolder,
            fit: BoxFit.fitHeight,
          );
  }

  Widget _buildVideoPreview() {
    if (_selectedFile == null) {
      return Center(
        child: Text(
            context.isArabic ? 'لم يتم اختيار فيديو' : 'No video selected',
            style: const TextStyle(color: Colors.black54)),
      );
    }

    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
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
      height: kToolbarHeight * 1.2,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            _buildModeSelectorButton(0, LocaleKeys.text.tr()),
            // Localized text
            _buildModeSelectorButton(1, LocaleKeys.picture.tr()),
            // Localized text
            _buildModeSelectorButton(2, LocaleKeys.video.tr()),
            // Localized text
            const Spacer(),
          ],
        ),
      ),
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
