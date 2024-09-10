import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:image_filter_pro/named_color_filter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

import 'package:path/path.dart' as path;
import 'package:flutter/rendering.dart';
import 'package:image_filter_pro/photo_filter.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaPreviewScreen();
  }
}

class FilteredImageWidget extends StatefulWidget {
  const FilteredImageWidget({super.key});

  @override
  FilteredImageWidgetState createState() => FilteredImageWidgetState();
}

class FilteredImageWidgetState extends State<FilteredImageWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickAndFilterImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await _applyFilterToImage();
    }
  }

  Future<void> _applyFilterToImage() async {
    if (_selectedImage == null) return;

    final filteredImage = await Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (context) => PhotoFilter(
          image: _selectedImage!,
          presets: defaultColorFilters,
          cancelIcon: Icons.cancel,
          applyIcon: Icons.check,
          backgroundColor: Colors.black,
          sliderColor: Colors.blue,
          sliderLabelStyle: const TextStyle(color: Colors.white),
          bottomButtonsTextStyle: const TextStyle(color: Colors.white),
          presetsLabelTextStyle: const TextStyle(color: Colors.white),
          applyingTextStyle: const TextStyle(color: Colors.white),
          compressImage: true,
          onFinishApplyingFilter: (p0) async {
            if (p0 != null) {
              await GallerySaver.saveImage(p0.path);
              _selectedImage = p0;
              setState(() {});
            }
          },
        ),
      ),
    );

    if (filteredImage != null) {
      setState(() {
        _selectedImage = filteredImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Filter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAndFilterImage,
              child: const Text('Pick and Filter Image'),
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

class MediaPreviewScreen extends StatefulWidget {
  const MediaPreviewScreen({super.key});

  @override
  State createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  String filePath = '';
  String mediaType = ''; // 'image' or 'video'
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  bool _isRecordingVideo = false;
  bool _isVideoMode = false;
  int _selectedCameraIndex = 0;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCameraIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![1],
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _controller?.initialize();
        setState(() {});
      } else {
        throw CameraException(
            'No cameras available', 'No cameras found on the device');
      }
    } on CameraException catch (e) {
      _showErrorDialog(
          'Camera initialization failed', e.description.toString());
    }
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final XFile? image = await _controller?.takePicture();
      if (image != null) {
        setState(() {
          filePath = image.path;
          mediaType = 'image';
        });
      }
      // await _applyFilterToImage();
    } on CameraException catch (e) {
      _showErrorDialog('Failed to capture image', e.description.toString());
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        filePath = pickedFile.path;
      });

      // await _applyFilterToImage();
    }
  }

// Pick a video from the gallery
  Future<void> _pickVideoFromGallery() async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Do something with the selected video
      setState(() {
        filePath = video.path;
      });
    }
  }

  Future<void> _toggleVideoRecording() async {
    if (_isRecordingVideo) {
      try {
        XFile? videoFile = await _controller?.stopVideoRecording();
        setState(() {
          _isRecordingVideo = false;
        });
        if (videoFile != null) {
          // Get temporary directory
          final directory = await getTemporaryDirectory();
          final tempFilePath = videoFile.path;
          final newFilePath = path.join(directory.path,
              'video_${DateTime.now().millisecondsSinceEpoch}.mp4');

          // Rename the file
          final tempFile = File(tempFilePath);
          final newFile = tempFile.renameSync(newFilePath);

          setState(() {
            filePath = newFile.path;
            mediaType = 'video';
          });
        }
      } on CameraException catch (e) {
        _showErrorDialog(
            'Failed to stop video recording', e.description.toString());
      }
    } else {
      try {
        await _controller?.startVideoRecording();
        setState(() {
          _isRecordingVideo = true;
        });
      } on CameraException catch (e) {
        _showErrorDialog(
            'Failed to start video recording', e.description.toString());
      }
    }
  }

  void _switchCamera() {
    if (_cameras != null && _cameras!.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
        _initializeCamera(_selectedCameraIndex);
      });
    }
  }

  Future<void> _discardMedia(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Are you sure you want to abandon your Snapsterpiece?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                File(filePath).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$mediaType discarded!')),
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Abandon'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCameraPreview() {
    return _controller != null && _controller!.value.isInitialized
        ? CameraPreview(_controller!)
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildPickImage() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              _buildCameraPreview(),
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: _buildCameraControls(),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCameraControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.image_outlined, color: Colors.white, size: 40),
          onPressed: _isVideoMode ? _pickVideoFromGallery : _pickImage,
        ),
        GestureDetector(
          onTap: _isVideoMode ? _toggleVideoRecording : _captureImage,
          child: Icon(
            _isVideoMode
                ? (_isRecordingVideo ? Icons.stop : Icons.videocam)
                : Icons.camera_alt,
            color: Colors.white,
            size: 60,
          ),
        ),
        IconButton(
          icon: Icon(
            _isVideoMode ? Icons.photo_camera : Icons.videocam,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _isVideoMode = !_isVideoMode;
            });
          },
        ),
      ],
    );
  }

  Future<void> _applyFilterToImage() async {
    File file = File(filePath);

    await Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (context) => PhotoFilter(
          image: file,
          presets: defaultColorFilters,
          cancelIcon: Icons.cancel,
          applyIcon: Icons.check,
          backgroundColor: Colors.black,
          sliderColor: Colors.blue,
          sliderLabelStyle: const TextStyle(color: Colors.white),
          bottomButtonsTextStyle: const TextStyle(color: Colors.white),
          presetsLabelTextStyle: const TextStyle(color: Colors.white),
          applyingTextStyle: const TextStyle(color: Colors.white),
          // compressImage: true,

          onFinishApplyingFilter: (p0) async {
            if (p0 != null) {
              setState(() {
                filePath = p0.path;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: filePath.isNotEmpty && mediaType.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    tooltip: 'Retake',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        filePath = '';
                        mediaType = '';
                      });
                    },
                    child: const Icon(Icons.photo_camera_front),
                  ),
                  FloatingActionButton.small(
                    tooltip: 'Edit',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _applyFilterToImage();
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.cameraswitch,
              ),
              onPressed: _switchCamera,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          filePath.isNotEmpty && mediaType.isNotEmpty
              ? Positioned.fill(
                  child: MediaPreview(
                      mediaPath: filePath,
                      mediaType: mediaType == 'video'
                          ? MediaType.video
                          : MediaType.image),
                )
              : Positioned.fill(child: _buildPickImage()),
          // ? Positioned.fill(child: _buildPickImage())
          // : Positioned.fill(
          //     child: mediaType == 'image'
          //         ? Image.file(
          //             File(filePath),
          //             fit: BoxFit.cover,
          //           )
          //         : VideoPlayerWidget(filePath: filePath),
          //   ),
          // if (filePath.isNotEmpty)
          //   Positioned(
          //     bottom: 10,
          //     left: 0,
          //     right: 0,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         _buildSaveButton(context),
          //         _buildStoryButton(),
          //         _buildSendToButton(),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}

Future<void> saveMedia(
    {required BuildContext context, filePath, mediaType}) async {
  if (filePath.isEmpty) return;

  if (mediaType == MediaType.image) {
    await GallerySaver.saveImage(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved to gallery!')),
    );
  } else if (mediaType == MediaType.video) {
    if (filePath.endsWith('.mp4') ||
        filePath.endsWith('.avi') ||
        filePath.endsWith('.mov')) {
      // Proceed with saving the video
      GallerySaver.saveVideo(filePath).then((bool? success) {
        log(filePath.toString());

        print('Video saved: $success');
      });
    } else {
      log(filePath.toString());
      print('Error: The file is not a video.');
    }
    // await GallerySaver.saveVideo(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video saved to gallery!')),
    );
  }
}

Widget buildSaveButton(BuildContext context, filePath, mediaType) {
  return Container(
    margin: const EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: const Icon(Icons.download_rounded, size: 30, color: Colors.white),
      onPressed: () =>
          saveMedia(context: context, filePath: filePath, mediaType: mediaType),
    ),
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

Widget buildStoryButton(context, {selectedFile}) {
  return ElevatedButton.icon(
    onPressed: () async {
      // Handle Story action

      // Convert the picked file to a File object
      final file = selectedFile;

      // Determine the file type based on the file extension
      final fileType = _determineFileType(file!.path);

      // Get the file size
      final fileSize = await file.length();

      // Call your upload method
      await serviceLocator<StoryCubit>()
          .uploadStoryVideoOrImage(file, fileType, fileSize, description: '')
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Story created')),
              ));
    },
    icon: CircleAvatar(
      // backgroundImage: AssetImage('assets/avatar.png'),
      // backgroundColor: Colors.red, radius: 15,
      radius: 15,
      backgroundImage:
          NetworkImage(serviceLocator<UserCubit>().state.data!.profilePicture!),
    ),
    label: const Text('Story', style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
  );
}

Widget buildSendToButton() {
  return Container(
    margin: const EdgeInsets.only(right: 20),
    child: ElevatedButton.icon(
      onPressed: () {
        // Handle Send action
      },
      icon: const Icon(Icons.send, color: Colors.black),
      label: const Text('Send To', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
// class MediaPreviewScreen extends StatefulWidget {
//   const MediaPreviewScreen({
//     super.key,
//   });
//
//   @override
//   State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
// }
//
// class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
//   String filePath = '';
//   String mediaType = ''; // 'image' or 'video'
//
//   // Save media (image or video) to gallery
//   Future<void> _saveMedia(BuildContext context) async {
//     if (mediaType == 'image') {
//       await GallerySaver.saveImage(filePath);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image saved to gallery!')),
//       );
//     } else if (mediaType == 'video') {
//       await GallerySaver.saveVideo(filePath);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Video saved to gallery!')),
//       );
//     }
//   }
//
//   // Discard media with a dialog confirmation
//   Future<void> _discardMedia(BuildContext context) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Force user to choose an option
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//               'Are you sure you want to abandon your Snapsterpiece?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 File(filePath).delete(); // Delete the file
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('$mediaType discarded!')),
//                 );
//                 Navigator.of(context).pop(); // Close dialog
//                 Navigator.of(context).pop(); // Return to the previous screen
//               },
//               child: const Text('Abandon'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   CameraController? _controller;
//
//   Future<void>? _initializeControllerFuture;
//
//   List<CameraDescription>? _cameras;
//
//   bool _isRecordingVideo = false;
//
//   bool _isVideoMode = false;
//
//   int _selectedCameraIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera(_selectedCameraIndex);
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeCamera(int cameraIndex) async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras != null && _cameras!.isNotEmpty) {
//         _controller = CameraController(
//           _cameras![cameraIndex],
//           ResolutionPreset.high,
//         );
//         _initializeControllerFuture = _controller?.initialize();
//         setState(() {});
//       } else {
//         throw CameraException(
//             'No cameras available', 'No cameras found on the device');
//       }
//     } on CameraException catch (e) {
//       _showErrorDialog(
//           'Camera initialization failed', e.description!.toString());
//     }
//   }
//
//   Future<void> _captureImage() async {
//     try {
//       await _initializeControllerFuture;
//       final XFile? image = await _controller?.takePicture();
//       if (image != null) {
//         // final String imagePath = await _saveMediaFile(image.path, 'png');
//         final String imagePath = image.path;
//         if (imagePath.isNotEmpty) {
//           setState(() {
//             filePath = imagePath;
//             mediaType = 'image';
//           });
//
//           // _navigateToPreviewScreen(imagePath, 'image');
//         }
//       }
//     } on CameraException catch (e) {
//       _showErrorDialog('Failed to capture image', e.description!.toString());
//     }
//   }
//
//   Future<void> _toggleVideoRecording() async {
//     if (_isRecordingVideo) {
//       try {
//         XFile? videoFile = await _controller?.stopVideoRecording();
//         setState(() {
//           _isRecordingVideo = false;
//         });
//
//         if (videoFile != null) {
//           // final String videoPath = await _saveMediaFile(videoFile.path, 'mp4');
//           final String videoPath = videoFile.path;
//           if (videoPath.isNotEmpty) {
//             setState(() {
//               filePath = videoPath;
//               mediaType = 'video';
//             });
//
//             // _navigateToPreviewScreen(videoPath, 'video');
//           }
//         }
//       } on CameraException catch (e) {
//         _showErrorDialog(
//             'Failed to stop video recording', e.description!.toString());
//       }
//     } else {
//       try {
//         await _controller?.startVideoRecording();
//         setState(() {
//           _isRecordingVideo = true;
//         });
//       } on CameraException catch (e) {
//         _showErrorDialog(
//             'Failed to start video recording', e.description!.toString());
//       }
//     }
//   }
//
//   void _switchCamera() {
//     if (_cameras != null && _cameras!.length > 1) {
//       setState(() {
//         _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
//         _initializeCamera(_selectedCameraIndex);
//       });
//     }
//   }
//
//   Future<String> _saveMediaFile(String sourcePath, String extension) async {
//     bool shouldSave = await _showSaveConfirmationDialog();
//     if (!shouldSave) {
//       return ''; // Return empty string if user chooses not to save
//     }
//
//     try {
//       bool? success;
//       if (extension == 'png' || extension == 'jpg') {
//         success =
//             await GallerySaver.saveImage(sourcePath, albumName: 'MyAppImages');
//       } else if (extension == 'mp4') {
//         success =
//             await GallerySaver.saveVideo(sourcePath, albumName: 'MyAppVideos');
//       } else {
//         throw UnsupportedError('Unsupported file type: $extension');
//       }
//
//       if (success!) {
//         _showSuccessDialog();
//         return sourcePath;
//       } else {
//         throw Exception('Failed to save media to gallery');
//       }
//     } catch (e) {
//       _showErrorDialog('Save Error', 'Failed to save media: ${e.toString()}');
//       return '';
//     }
//   }
//
//   Future<bool> _showSaveConfirmationDialog() async {
//     return await showDialog<bool>(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Save to Gallery'),
//                 content: const Text(
//                     'Do you want to save this media to your gallery?'),
//                 actions: <Widget>[
//                   TextButton(
//                     child: const Text('Cancel'),
//                     onPressed: () => Navigator.of(context).pop(false),
//                   ),
//                   TextButton(
//                     child: const Text('Save'),
//                     onPressed: () => Navigator.of(context).pop(true),
//                   ),
//                 ],
//               );
//             }) ??
//         false; // Return false if dialog is dismissed
//   }
//
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Success'),
//           content: const Text('Media saved to gallery successfully.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _navigateToPreviewScreen(String filePath, String mediaType) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const MediaPreviewScreen(),
//       ),
//     );
//   }
//
//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildCameraPreview() {
//     return _controller != null && _controller!.value.isInitialized
//         ? CameraPreview(_controller!)
//         : const Center(child: CircularProgressIndicator());
//   }
//
//   Widget _buildPickImage() {
//     return FutureBuilder<void>(
//       future: _initializeControllerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             children: [
//               _buildCameraPreview(),
//               Positioned(
//                 bottom: 80,
//                 left: 0,
//                 right: 0,
//                 child: _buildCameraControls(),
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
//
//   Widget _buildCameraControls() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.switch_camera, color: Colors.white, size: 40),
//           onPressed: _switchCamera,
//         ),
//         GestureDetector(
//           onTap: _isVideoMode ? _toggleVideoRecording : _captureImage,
//           child: Icon(
//             _isVideoMode
//                 ? (_isRecordingVideo ? Icons.stop : Icons.videocam)
//                 : Icons.camera_alt,
//             color: Colors.white,
//             size: 60,
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             _isVideoMode ? Icons.photo_camera : Icons.videocam,
//             color: Colors.white,
//             size: 40,
//           ),
//           onPressed: () {
//             setState(() {
//               _isVideoMode = !_isVideoMode;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Media preview
//           filePath.isEmpty
//               ? Positioned.fill(child: _buildPickImage())
//               : Positioned.fill(
//                   child: mediaType == 'image'
//                       ? Image.file(
//                           File(filePath),
//                           fit: BoxFit.cover,
//                         )
//                       : VideoPlayerWidget(filePath: filePath),
//                 ),
//
//           // Bottom buttons (Save, Story, Send To) - Matching your provided image
//           Positioned(
//             bottom: 10,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Save button (download icon)
//                 Container(
//                   margin: const EdgeInsets.only(left: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[800],
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.download_rounded,
//                         size: 30, color: Colors.white),
//                     onPressed: () => _saveMedia(context),
//                   ),
//                 ),
//                 // Story button (middle, with avatar icon)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Handle Story action
//                   },
//                   icon: const CircleAvatar(
//                     backgroundImage: AssetImage('assets/avatar.png'),
//                     // Replace with actual avatar
//                     radius: 15,
//                   ),
//                   label: const Text('Story',
//                       style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[800],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                   ),
//                 ),
//                 // Send To button (right)
//                 Container(
//                   margin: const EdgeInsets.only(right: 20),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // Handle Send action
//                     },
//                     icon: const Icon(Icons.send, color: Colors.black),
//                     label: const Text('Send To',
//                         style: TextStyle(color: Colors.black)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.yellow[700],
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// VideoPlayerWidget for video preview

class MediaPreview extends StatefulWidget {
  final String mediaPath;
  final MediaType mediaType;

  MediaPreview({required this.mediaPath, required this.mediaType});

  @override
  _MediaPreviewState createState() => _MediaPreviewState();
}

enum MediaType { image, video }

class _MediaPreviewState extends State<MediaPreview> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.mediaType == MediaType.video) {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play();
          });
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.mediaType == MediaType.image
                ? Image.file(
                    File(widget.mediaPath),
                    height: 500,
                    width: 500,
                  )
                : _videoController != null &&
                        _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const CircularProgressIndicator(),
          ),
          widget.mediaType == MediaType.video
              ? Positioned(
                  bottom: 10,
                  right: 10,
                  left: 10,
                  top: 10,
                  child: Icon(
                    size: 50,
                    color: Colors.white,
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                )
              : const Sizer(),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // buildSaveButton(context, widget.mediaPath, widget.mediaType),
                // buildStoryButton(context, selectedFile: File(widget.mediaPath)),
                // buildSendToButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String filePath;

  const VideoPlayerWidget({super.key, required this.filePath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
        _controller?.play(); // Auto-play the video
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? VideoPlayer(_controller!)
        : const Center(child: CircularProgressIndicator());
  }
}
