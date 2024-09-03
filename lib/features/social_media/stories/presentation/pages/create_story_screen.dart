import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

import '../../../../../res/style/const.dart';
import '../../../../../service_locator/service_locator.dart';
import '../cubit/stories_cubit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
    // Dispose of existing controllers before initializing new ones
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          _buildTopControls(),
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
                _buildImagePreview(),
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
        IconButton(
          icon: const Icon(Icons.cached, color: Colors.black, size: 30),
          onPressed: () {
            // Switch camera action
          },
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedPageIndex != 0) _buildDescriptionField(),
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
                // Handle send action
                log("${_storyText}555555555555555555$_descriptionText");

                if (_selectedPageIndex == 0) {
                  await serviceLocator<StoryCubit>()
                      .createTextStory(_storyText!);
                  Navigator.pop(context);
                }
                if (_selectedPageIndex == 1 || _selectedPageIndex == 2) {
                  // Convert the picked file to a File object
                  final file = _selectedFile;

                  // Determine the file type based on the file extension
                  final fileType = _determineFileType(file!.path);

                  // Get the file size
                  final fileSize = await file.length();

                  // Call your upload method
                  await serviceLocator<StoryCubit>().uploadStoryVideoOrImage(
                      file, fileType, fileSize,
                      description: _descriptionText);
                  Navigator.pop(context);
                }
              },
            ),
            if (_selectedPageIndex == 0)
              const SizedBox(
                width: 30,
              ),
          ],
        ),
        _buildModeSelector(),
      ],
    );
  }

  String _determineFileType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    if (extension == '.mp4') {
      return 'video/mp4';
    } else if (['.jpg', '.jpeg', '.png'].contains(extension)) {
      return 'image/jpeg'; // Adjust this if you want different handling for PNG, etc.
    } else {
      throw Exception('Unsupported file type');
    }
  }

  Widget _buildTextStoryInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: TextField(
          cursorColor: Colors.black,
          maxLines: null,
          style: const TextStyle(fontSize: 28, color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Write your story...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            fillColor: Colors.transparent,
          ),
          onChanged: (text) {
            setState(() {
              _storyText = text;
            });
          },
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedFile == null) {
      return const Center(
        child: Text('No image selected', style: TextStyle(color: Colors.black)),
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
      return const Center(
        child: Text('No video selected', style: TextStyle(color: Colors.black)),
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
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: 2,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Add a description...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (text) {
          setState(() {
            _descriptionText = text;
          });
        },
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onPressed,
    );
  }

  Widget _buildCaptureButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (_selectedPageIndex == 1) {
          // Image mode
          await _pickImageFromCamera();
        } else if (_selectedPageIndex == 2) {
          // Video mode
          await _recordVideo();
        }
      },
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
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
    } else {
      print('No video recorded.');
    }
  }

  Widget _buildModeSelector() {
    return Container(
      height: kToolbarHeight,
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildModeSelectorButton(0, 'Text'),
          _buildModeSelectorButton(1, 'Photo'),
          _buildModeSelectorButton(2, 'Video'),
        ],
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
            border: isSelected
                ? const Border(
                    bottom: BorderSide(width: 3, color: Colors.redAccent),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.redAccent : Colors.black54,
                fontSize: 18,
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
        // Clear the video player as we are displaying an image
        _disposeVideoControllers();
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        // Clear the video player as we are displaying an image
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
    } else {
      print('No video selected.');
    }
  }
}
