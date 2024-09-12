import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/snap/utils/filters.dart';
import 'package:image_filter_pro/named_color_filter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import 'package:path/path.dart' as path;
import 'package:image_filter_pro/photo_filter.dart';

import '../../../reels/presentation/shared/filter_utiles.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdvancedSnapchatCameraScreen();
  }
}

// class AdvancedSnapchatCameraScreen extends StatefulWidget {
//   @override
//   _AdvancedSnapchatCameraScreenState createState() =>
//       _AdvancedSnapchatCameraScreenState();
// }
//
// class _AdvancedSnapchatCameraScreenState
//     extends State<AdvancedSnapchatCameraScreen> with TickerProviderStateMixin {
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool isReady = false;
//   bool isFrontCamera = false;
//   bool isRecording = false;
//   FlashMode _flashMode = FlashMode.off;
//   double _currentZoomLevel = 1.0;
//   double _maxZoomLevel = 5.0;
//
//   // Animation controllers
//   late AnimationController _flashAnimationController;
//   late Animation<double> _flashAnimation;
//
//   // Filter PageView properties
//   int selectedFilterIndex = 0; // Tracks which filter is applied
//   PageController _pageController =
//       PageController(viewportFraction: 0.3); // Controls the page scrolling
//   int totalFilters = 10; // Total number of filters
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _initializeFlashAnimation();
//   }
//
//   /// Initializes the camera and sets up necessary configurations
//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();
//       _cameraController = CameraController(
//         _cameras[0],
//         ResolutionPreset.high,
//         enableAudio: true,
//       );
//       await _cameraController.initialize();
//       setState(() {
//         isReady = true;
//       });
//     } catch (e) {
//       // Enhanced error logging for easier debugging
//       log("Camera initialization error: $e");
//     }
//   }
//
//   /// Initializes flash mode animations
//   void _initializeFlashAnimation() {
//     _flashAnimationController = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     _flashAnimation =
//         Tween<double>(begin: 0.0, end: 1.0).animate(_flashAnimationController);
//   }
//
//   /// Switches between front and back cameras
//   void _switchCamera() {
//     setState(() {
//       isFrontCamera = !isFrontCamera;
//     });
//     _cameraController = CameraController(
//       isFrontCamera ? _cameras[1] : _cameras[0],
//       ResolutionPreset.high,
//       enableAudio: true,
//     );
//     _cameraController.initialize().then((_) {
//       setState(() {});
//     }).catchError((e) {
//       log("Error switching camera: $e");
//     });
//   }
//
//   /// Takes a picture using the camera
//   Future<void> _takePicture() async {
//     if (!_cameraController.value.isInitialized) return;
//
//     try {
//       await _cameraController.takePicture();
//     } catch (e) {
//       log("Error capturing image: $e");
//     }
//   }
//
//   /// Toggles video recording
//   Future<void> _toggleRecording() async {
//     if (!_cameraController.value.isInitialized) return;
//
//     try {
//       if (isRecording) {
//         await _cameraController.stopVideoRecording();
//         setState(() {
//           isRecording = false;
//         });
//       } else {
//         await _cameraController.startVideoRecording();
//         setState(() {
//           isRecording = true;
//         });
//       }
//     } catch (e) {
//       log("Recording error: $e");
//     }
//   }
//
//   /// Changes the flash mode and triggers flash animation
//   void _changeFlashMode() {
//     setState(() {
//       if (_flashMode == FlashMode.off) {
//         _flashMode = FlashMode.auto;
//       } else if (_flashMode == FlashMode.auto) {
//         _flashMode = FlashMode.torch;
//       } else {
//         _flashMode = FlashMode.off;
//       }
//     });
//
//     _cameraController.setFlashMode(_flashMode);
//     _flashAnimationController.forward(from: 0.0);
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _flashAnimationController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isReady || !_cameraController.value.isInitialized) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onScaleUpdate: (details) {
//           if (details.scale != 1.0) {
//             _currentZoomLevel =
//                 (_currentZoomLevel * details.scale).clamp(1.0, _maxZoomLevel);
//             _cameraController.setZoomLevel(_currentZoomLevel);
//           }
//         },
//         child: Stack(
//           children: [
//             // Camera Preview
//             CameraPreview(_cameraController),
//
//             // Swipe Gesture Detection
//             GestureDetector(
//               onHorizontalDragEnd: (details) {
//                 if (details.primaryVelocity! > 0) {
//                   log("Swiped right: open chat");
//                 } else if (details.primaryVelocity! < 0) {
//                   log("Swiped left: open stories");
//                 }
//               },
//             ),
//
//             // Flash Mode Animation
//             _buildFlashModeWidget(),
//
//             // Top Control Icons
//             _buildTopIcons(),
//
//             // Bottom Capture Controls
//             // _buildBottomControls(),
//
//             // Filters carousel at the bottom using PageView
//             // Align(
//             //   alignment: Alignment.bottomRight,
//             //   child: Container(
//             //     color: Colors.red, // Make the container transparent
//             //     height: 200,
//             //     width: MediaQuery.of(context).size.width * 0.7,
//             //     child: Stack(
//             //       alignment: Alignment.center,
//             //       children: [
//             //         // Center circle indicator
//             //         Center(
//             //           child: Container(
//             //             height: 100,
//             //             width: 100,
//             //             decoration: BoxDecoration(
//             //               shape: BoxShape.circle,
//             //               border: Border.all(color: Colors.white, width: 3),
//             //             ),
//             //           ),
//             //         ),
//             //
//             //         // Filter PageView
//             //         PageView.builder(
//             //           controller: _pageController,
//             //           itemCount: totalFilters,
//             //           onPageChanged: (index) {
//             //             setState(() {
//             //               selectedFilterIndex = index;
//             //               log("Filter $index applied");
//             //             });
//             //           },
//             //           itemBuilder: (context, index) {
//             //             bool isSelected = selectedFilterIndex == index;
//             //
//             //             return Container(
//             //               height: 100,
//             //               width: 100,
//             //               decoration: BoxDecoration(
//             //                 shape: BoxShape.circle,
//             //                 border: Border.all(color: Colors.white, width: 3),
//             //               ),
//             //               child: InkWell(
//             //                 onTap: () {
//             //                   if (selectedFilterIndex == index) {
//             //                     log("Filter $index selected");
//             //                   }
//             //                 },
//             //                 child: AnimatedOpacity(
//             //                   duration: Duration(milliseconds: 300),
//             //                   opacity: isSelected ? 1.0 : 0.3,
//             //                   child: AnimatedContainer(
//             //                     duration: Duration(milliseconds: 300),
//             //                     curve: Curves.easeOut,
//             //                     width: isSelected ? 100 : 80,
//             //                     height: isSelected ? 100 : 80,
//             //                     decoration: BoxDecoration(
//             //                       shape: BoxShape.circle,
//             //                       border: Border.all(
//             //                           color: isSelected
//             //                               ? Colors.blue
//             //                               : Colors.white.withOpacity(0.5),
//             //                           width: isSelected ? 4 : 2),
//             //                     ),
//             //                     child: CircleAvatar(
//             //                       backgroundColor: Colors.grey[800],
//             //                       child: Icon(
//             //                         Icons.filter_vintage,
//             //                         color:
//             //                             isSelected ? Colors.blue : Colors.white,
//             //                       ),
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //             );
//             //           },
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // )
//
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height *
//                     0.25, // Responsive height
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         // height: MediaQuery.of(context).size.height *
//                         //     0.25, // Responsive height
//                         // color: Colors.blue, // Make the container transparent
//                         child: Center(
//                             child: IconButton(
//                           color: Colors.white,
//                           icon: Stack(
//                             children: [
//                               const Icon(
//                                 size: 30,
//                                 Icons.photo_library,
//                               ),
//                               Positioned(
//                                   right: 0,
//                                   top: 0,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.red,
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     width: 10,
//                                     height: 10,
//                                   )),
//                             ],
//                           ),
//                           onPressed: () {},
//                         )),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 7,
//                       child: Container(
//                         // color: Colors.red, // Make the container transparent
//                         // height: MediaQuery.of(context).size.height *
//                         //     0.25, // Responsive height
//                         // width: MediaQuery.of(context).size.width *
//                         //     0.8, // Responsive width
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Center circle indicator
//                             Center(
//                               child: Container(
//                                 height: MediaQuery.of(context).size.height *
//                                     0.13, // Responsive circle height
//                                 width: MediaQuery.of(context).size.height *
//                                     0.13, // Responsive circle width
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border:
//                                       Border.all(color: Colors.white, width: 6),
//                                 ),
//                               ),
//                             ),
//
//                             // Filter PageView with spacing between items
//                             PageView.builder(
//                               controller: _pageController,
//                               itemCount: totalFilters,
//                               onPageChanged: (index) {
//                                 setState(() {
//                                   selectedFilterIndex = index;
//                                   log("Filter $index applied -----------------------------------------------------------------------/\\");
//                                 });
//                               },
//                               itemBuilder: (context, index) {
//                                 bool isSelected = selectedFilterIndex == index;
//
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 6.0),
//                                   child: Container(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.12,
//                                     // Responsive height
//                                     width: MediaQuery.of(context).size.height *
//                                         0.12,
//                                     // Responsive width
//                                     // decoration: BoxDecoration(
//                                     //   shape: BoxShape.circle,
//                                     //   border: Border.all(color: Colors.white, width: 2),
//                                     // ),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (selectedFilterIndex == index) {
//                                           _takePicture();
//                                           log("Filter $index selected  applied -----------------------------------------------------------------------/\\");
//                                         }
//                                       },
//                                       onLongPress: _toggleRecording,
//                                       child: AnimatedOpacity(
//                                         duration:
//                                             const Duration(milliseconds: 300),
//                                         opacity: isSelected ? 1.0 : 0.3,
//                                         // Fade unselected filters
//                                         child: AnimatedContainer(
//                                           duration:
//                                               const Duration(milliseconds: 300),
//                                           curve: Curves.easeOut,
//                                           width: isSelected
//                                               ? MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.12 // Bigger when selected
//                                               : MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.1,
//                                           // Smaller when not selected
//                                           height: isSelected
//                                               ? MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.12
//                                               : MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.1,
//                                           // decoration: BoxDecoration(
//                                           //   shape: BoxShape.circle,
//                                           //   border: Border.all(
//                                           //       color: isSelected
//                                           //           ? Colors.blue
//                                           //           : Colors.white
//                                           //               .withOpacity(0.5),
//                                           //       width: isSelected ? 4 : 2),
//                                           // ),
//                                           child: CircleAvatar(
//                                             backgroundColor: Colors.grey[800],
//                                             child: Icon(
//                                               Icons.filter_vintage,
//                                               color: isSelected
//                                                   ? Colors.blue
//                                                   : Colors.white,
//                                               size: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.05, // Responsive icon size
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds the widget that shows flash mode animation
//   Widget _buildFlashModeWidget() {
//     return Positioned(
//       top: 60,
//       left: 50,
//       child: FadeTransition(
//         opacity: _flashAnimation,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.6),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             _flashMode == FlashMode.off
//                 ? "Flash Off"
//                 : _flashMode == FlashMode.auto
//                     ? "Flash Auto"
//                     : "Flash On",
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Builds the widget containing the top icons
//   Widget _buildTopIcons() {
//     return Positioned(
//       top: 40,
//       left: 16,
//       right: 16,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const CircleAvatar(
//             backgroundColor: Colors.red,
//             radius: 20,
//             child: Icon(Icons.person, color: Colors.white),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_on,
//                   color:
//                       _flashMode == FlashMode.off ? Colors.grey : Colors.yellow,
//                 ),
//                 onPressed: _changeFlashMode,
//               ),
//               const SizedBox(width: 16),
//               const Icon(Icons.search, color: Colors.white),
//               const SizedBox(width: 16),
//               IconButton(
//                 icon: const Icon(Icons.cached, color: Colors.white, size: 30),
//                 onPressed: _switchCamera,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Builds the widget containing bottom capture controls
//   Widget _buildBottomControls() {
//     return Positioned(
//       bottom: 100,
//       left: 0,
//       right: 0,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             icon: Icon(
//               isRecording ? Icons.stop : Icons.videocam,
//               color: Colors.red,
//               size: 30,
//             ),
//             onPressed: _toggleRecording,
//           ),
//           GestureDetector(
//             onTap: _takePicture,
//             onLongPress: _toggleRecording,
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 35,
//               child: CircleAvatar(
//                 backgroundColor: Colors.black,
//                 radius: 30,
//                 child: Icon(
//                   isRecording ? Icons.videocam : Icons.camera_alt,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//============================================================================================

class AdvancedSnapchatCameraScreen extends StatefulWidget {
  @override
  _AdvancedSnapchatCameraScreenState createState() =>
      _AdvancedSnapchatCameraScreenState();
}

class _AdvancedSnapchatCameraScreenState
    extends State<AdvancedSnapchatCameraScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _advancedFilters = advancedFilters;

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool isReady = false;
  bool isFrontCamera = false;
  bool isRecording = false;
  FlashMode _flashMode = FlashMode.off;
  double _currentZoomLevel = 1.0;
  final double _maxZoomLevel = 5.0;
  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Animation controllers
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    // Simulate a 3-second delay to hide the overlay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _hideOverlay();
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible:
                  false, // Prevents tapping outside to dismiss the overlay
            ),
          ),
          const Center(
            child: CupertinoActivityIndicator(
              radius: 25,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  // Filter PageView properties
  int selectedFilterIndex = 0; // Tracks which filter is applied
  final PageController _pageController =
      PageController(viewportFraction: 0.3); // Controls the page scrolling
  int totalFilters = 10; // Total number of filters
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFlashAnimation();
  }

  /// Initializes the camera and sets up necessary configurations
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController.initialize();
      setState(() {
        isReady = true;
      });
    } catch (e) {
      log("Camera initialization error: $e");
    }
  }

  /// Initializes flash mode animations
  void _initializeFlashAnimation() {
    _flashAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _flashAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_flashAnimationController);
  }

  /// Switches between front and back cameras
  void _switchCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    _cameraController = CameraController(
      isFrontCamera ? _cameras[1] : _cameras[0],
      ResolutionPreset.high,
      enableAudio: true,
    );
    _cameraController.initialize().then((_) {
      setState(() {});
    }).catchError((e) {
      log("Error switching camera: $e");
    });
  }

  /// Takes a picture using the camera
  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) return;

    // try {
    //   await _cameraController.takePicture();
    // } catch (e) {
    //   log("Error capturing image: $e");
    // }

    try {
      final XFile pickedFile = await _cameraController.takePicture();
      if (pickedFile.path.isNotEmpty) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Set the image file
        });
      } else {
        print("No image taken.");
      }
    } catch (e) {
      print("Error taking image: $e");
    }
  }

  /// Toggles video recording
  Future<void> _toggleRecording() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      if (isRecording) {
        await _cameraController.stopVideoRecording();
        setState(() {
          isRecording = false;
        });
      } else {
        await _cameraController.startVideoRecording();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      log("Recording error: $e");
    }
  }

  /// Changes the flash mode and triggers flash animation
  void _changeFlashMode() {
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.auto;
      } else if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.torch;
      } else {
        _flashMode = FlashMode.off;
      }
    });

    _cameraController.setFlashMode(_flashMode);
    _flashAnimationController.forward(from: 0.0);
  }

  /// Picks an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Set the image file
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _flashAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _capturePng() async {
    try {
      // Check if the camera controller is initialized
      if (!_cameraController.value.isInitialized) {
        print('Camera is not initialized');
        return;
      }

      // Capture the widget as an image
      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      // Check if boundary is null
      if (boundary == null) {
        print('Error: RepaintBoundary is null');
        return;
      }

      // Capture the image from the RepaintBoundary
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      // Check if byteData is null
      if (byteData == null) {
        print('Error: ByteData is null');
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get the directory to save the image
      final directory = await getApplicationDocumentsDirectory();
      String path =
          '${directory.path}/filtered_image_${DateTime.now().millisecondsSinceEpoch}.png'; // Use timestamp to generate a unique file name

      // Save (and overwrite) the image as a PNG file
      File imgFile = File(path);

      // Write the new image
      File savedImage = await imgFile.writeAsBytes(pngBytes);

      // Ensure the state is updated after saving and file is valid
      if (savedImage.existsSync()) {
        setState(() {
          _selectedImage = savedImage; // Update the selected image
          print('Image captured and saved at ${_selectedImage!.path}');
        });
      } else {
        print('Error: Saved image does not exist');
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady || !_cameraController.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onScaleUpdate: (details) {
          if (details.scale != 1.0) {
            _currentZoomLevel =
                (_currentZoomLevel * details.scale).clamp(1.0, _maxZoomLevel);
            _cameraController.setZoomLevel(_currentZoomLevel);
          }
        },
        child: Stack(
          children: [
            // Camera Preview
            // RepaintBoundary to capture the image with the applied filter

            RepaintBoundary(
              key: _globalKey,
              // Force the RepaintBoundary to repaint on every build
              child: ColorFiltered(
                colorFilter: advancedFilters[selectedFilterIndex]
                    ['colorFilter'],
                child: CameraPreview(_cameraController),
              ),
            ),

            // // Image overlay if an image is picked from gallery
            // if (_selectedImage != null)
            //   Positioned(
            //     bottom: 20,
            //     right: 20,
            //     child: Image.file(
            //       _selectedImage!,
            //       width: 100,
            //       height: 100,
            //       fit: BoxFit.cover,
            //     ),
            //   ),

            // Swipe Gesture Detection
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  log("Swiped right: open chat");
                } else if (details.primaryVelocity! < 0) {
                  log("Swiped left: open stories");
                }
              },
            ),

            // Flash Mode Animation
            // _buildFlashModeWidget(),

            // Top Control Icons
            _buildTopIcons(),

            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.25, // Responsive height
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: IconButton(
                            color: Colors.white,
                            icon: Stack(
                              children: [
                                const Icon(
                                  size: 30,
                                  Icons.photo_library,
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      width: 10,
                                      height: 10,
                                    )),
                              ],
                            ),
                            onPressed: () => _pickImageFromGallery()
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaPreview(
                                          mediaPath: _selectedImage!.path,
                                          mediaType: MediaType.image),
                                    ))), // Pick an image from gallery
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.13, // Responsive circle height
                                width: MediaQuery.of(context).size.height *
                                    0.13, // Responsive circle width
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 6),
                                ),
                              ),
                            ),

                            // Filter PageView with spacing between items
                            // PageView.builder(
                            //   controller: _pageController,
                            //   itemCount: advancedFilters.length,
                            //   onPageChanged: (index) {
                            //     setState(() {
                            //       selectedFilterIndex = index;
                            //       log("Filter $index applied");
                            //     });
                            //   },
                            //   itemBuilder: (context, index) {
                            //     bool isSelected = selectedFilterIndex == index;
                            //     final filter = advancedFilters[index];
                            //
                            //     return Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 6.0),
                            //       child: Container(
                            //         height: MediaQuery.of(context).size.height *
                            //             0.12, // Responsive height
                            //         width: MediaQuery.of(context).size.height *
                            //             0.12, // Responsive width
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             if (selectedFilterIndex == index) {
                            //               _showOverlay(context);
                            //
                            //               // _takePicture();
                            //               _capturePng().then((value) {
                            //                 setState(() {
                            //                   // _selectedImage = value;
                            //                   log("${_selectedImage!.path}____________________");
                            //                   Navigator.push(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                         builder: (context) =>
                            //                             MediaPreview(
                            //                                 mediaPath:
                            //                                     _selectedImage!
                            //                                         .path,
                            //                                 mediaType: MediaType
                            //                                     .image),
                            //                       ));
                            //                 });
                            //               });
                            //               log("Filter $index selected");
                            //             }
                            //           },
                            //           onLongPress: _toggleRecording,
                            //           child: AnimatedOpacity(
                            //             duration:
                            //                 const Duration(milliseconds: 300),
                            //             opacity: isSelected ? 1.0 : 0.3,
                            //             // Fade unselected filters
                            //             child: AnimatedContainer(
                            //               duration:
                            //                   const Duration(milliseconds: 300),
                            //               curve: Curves.easeOut,
                            //               width: isSelected
                            //                   ? MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       0.12 // Bigger when selected
                            //                   : MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       0.1,
                            //               height: isSelected
                            //                   ? MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       0.12
                            //                   : MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       0.1,
                            //               child: ColorFiltered(
                            //                 colorFilter: filter['colorFilter'],
                            //                 child: CircleAvatar(
                            //                   // backgroundColor: Colors.grey[800],
                            //
                            //                   backgroundImage: const NetworkImage(
                            //                       'https://images.unsplash.com/photo-1723496954926-d6b4c06d9276?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                            //                   // backgroundColor: Colors.grey[800],
                            //
                            //                   child: Text(
                            //                     filter['name'],
                            //                     style: const TextStyle(
                            //                         color: Colors.white),
                            //                   ),
                            //                   // child: Icon(
                            //                   //   Icons.filter_vintage,
                            //                   //   color: isSelected
                            //                   //       ? Colors.blue
                            //                   //       : Colors.white,
                            //                   //   size: MediaQuery.of(context)
                            //                   //           .size
                            //                   //           .height *
                            //                   //       0.05, // Responsive icon size
                            //                   // ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            PageView.builder(
                              controller: _pageController,
                              itemCount: advancedFilters.length,
                              onPageChanged: (index) {
                                setState(() {
                                  selectedFilterIndex = index;
                                  log("Filter $index applied");
                                });
                              },
                              itemBuilder: (context, index) {
                                bool isSelected = selectedFilterIndex == index;

                                if (index == 0) isSelected = true;

                                log("${isSelected}88888888888888888888888888888888888");
                                final filter = advancedFilters[index];

                                return GestureDetector(
                                  onTap: () {

                                    // if (selectedFilterIndex == index) {
                                    //   _showOverlay(context);
                                    //
                                    //   // _takePicture();
                                    //   _capturePng().then((value) {
                                    //     setState(() {
                                    //       log("${_selectedImage!.path}____________________");
                                    //       Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 MediaPreview(
                                    //                     mediaPath:
                                    //                         _selectedImage!
                                    //                             .path,
                                    //                     mediaType:
                                    //                         MediaType.image),
                                    //           ));
                                    //     });
                                    //   });
                                    //   log("Filter $index selected");
                                    // }

                                  },
                                  onLongPress: _toggleRecording,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isSelected ? 1.0 : 0.5,
                                    // Fade unselected filters
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Transform.scale(
                                          scale: isSelected ? 1.2 : 0.8,
                                          // Scaling effect
                                          child: ColorFiltered(
                                            colorFilter: filter['colorFilter'],
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  //     const NetworkImage(
                                                  //   'https://images.unsplash.com/photo-1723496954926-d6b4c06d9276?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                                  // ),
                                                  const AssetImage(
                                                      'assets/filters/camera_filter.webp'),
                                              child: Text(
                                                filter['name'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Builds the widget that shows flash mode animation
  Widget _buildFlashModeWidget() {
    return Positioned(
      top: 40,
      left: 100,
      child: FadeTransition(
        opacity: _flashAnimation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _flashMode == FlashMode.off
                ? "Flash Off"
                : _flashMode == FlashMode.auto
                    ? "Flash Auto"
                    : "Flash On",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Builds the widget containing the top icons
  Widget _buildTopIcons() {
    return Positioned(
      top: 40,
      left: 8,
      right: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              IconButton(
                color: Colors.red,
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.shareNodes,
                    size: 30,
                    color: Colors.white,
                  ))
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.loop, color: Colors.white, size: 30),
                onPressed: _switchCamera,
              ),
              // FadeTransition(
              //   opacity: _flashAnimation,
              //   child: Container(
              //     padding: const EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.6),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       _flashMode == FlashMode.off
              //           ? "Flash Off"
              //           : _flashMode == FlashMode.auto
              //               ? "Flash Auto"
              //               : "Flash On",
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              IconButton(
                icon: Icon(
                  size: 30,
                  _flashMode == FlashMode.off
                      ? FontAwesomeIcons.bolt
                      : _flashMode == FlashMode.auto
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
              IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.search,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//============================================================================================
// class AdvancedSnapchatCameraScreen extends StatefulWidget {
//   @override
//   _AdvancedSnapchatCameraScreenState createState() =>
//       _AdvancedSnapchatCameraScreenState();
// }
//
// class _AdvancedSnapchatCameraScreenState
//     extends State<AdvancedSnapchatCameraScreen> with TickerProviderStateMixin {
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool isReady = false;
//   bool isFrontCamera = false;
//   bool isRecording = false;
//   FlashMode _flashMode = FlashMode.off;
//   double _currentZoomLevel = 1.0;
//   double _maxZoomLevel = 5.0;
//
//   // Animation controllers
//   late AnimationController _flashAnimationController;
//   late Animation<double> _flashAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _flashAnimationController = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     _flashAnimation = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(_flashAnimationController);
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     _cameraController = CameraController(
//       _cameras[0],
//       ResolutionPreset.high,
//       enableAudio: true,
//     );
//     await _cameraController.initialize();
//     setState(() {
//       isReady = true;
//     });
//   }
//
//   void _switchCamera() {
//     setState(() {
//       isFrontCamera = !isFrontCamera;
//     });
//     _cameraController = CameraController(
//       isFrontCamera ? _cameras[1] : _cameras[0],
//       ResolutionPreset.high,
//       enableAudio: true,
//     );
//     _cameraController.initialize().then((_) {
//       setState(() {});
//     });
//   }
//
//   void _takePicture() async {
//     if (!_cameraController.value.isInitialized) return;
//
//     try {
//       await _cameraController.takePicture();
//     } catch (e) {
//       log(e);
//     }
//   }
//
//   void _toggleRecording() async {
//     if (!_cameraController.value.isRecordingVideo) {
//       try {
//         await _cameraController.startVideoRecording();
//         setState(() {
//           isRecording = true;
//         });
//       } catch (e) {
//         log(e);
//       }
//     } else {
//       await _cameraController.stopVideoRecording();
//       setState(() {
//         isRecording = false;
//       });
//     }
//   }
//
//   void _changeFlashMode() {
//     setState(() {
//       if (_flashMode == FlashMode.off) {
//         _flashMode = FlashMode.auto;
//       } else if (_flashMode == FlashMode.auto) {
//         _flashMode = FlashMode.torch;
//       } else {
//         _flashMode = FlashMode.off;
//       }
//     });
//
//     _cameraController.setFlashMode(_flashMode);
//     _flashAnimationController.forward(from: 0.0); // Trigger flash animation
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _flashAnimationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isReady || !_cameraController.value.isInitialized) {
//       return Container(
//         color: Colors.black,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onScaleUpdate: (details) {
//           if (details.scale != 1.0) {
//             _currentZoomLevel = (_currentZoomLevel * details.scale)
//                 .clamp(1.0, _maxZoomLevel); // Pinch to zoom
//             _cameraController.setZoomLevel(_currentZoomLevel);
//           }
//         },
//         child: Stack(
//           children: [
//             // Camera Preview
//             CameraPreview(_cameraController),
//
//             // Swipe Animation / Gesture Detector
//             GestureDetector(
//               onHorizontalDragEnd: (details) {
//                 if (details.primaryVelocity! > 0) {
//                   log("Swiped right: open chat");
//                   // Add transition to chat screen with animation
//                 } else if (details.primaryVelocity! < 0) {
//                   log("Swiped left: open stories");
//                   // Add transition to story screen with animation
//                 }
//               },
//             ),
//
//             // Flash Mode Animation
//             Positioned(
//               top: 60,
//               left: 50,
//               child: FadeTransition(
//                 opacity: _flashAnimation,
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     _flashMode == FlashMode.off
//                         ? "Flash Off"
//                         : _flashMode == FlashMode.auto
//                         ? "Flash Auto"
//                         : "Flash On",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Top Icons (Profile, Search, Flash control)
//             Positioned(
//               top: 40,
//               left: 16,
//               right: 16,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.red,
//                     radius: 20,
//                     child: Icon(Icons.person, color: Colors.white),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.flash_on,
//                           color: _flashMode == FlashMode.off
//                               ? Colors.grey
//                               : Colors.yellow,
//                         ),
//                         onPressed: _changeFlashMode,
//                       ),
//                       SizedBox(width: 16),
//                       Icon(Icons.search, color: Colors.white),
//                       SizedBox(width: 16),
//                       IconButton(
//                         icon: Icon(Icons.cached, color: Colors.white, size: 30),
//                         onPressed: _switchCamera,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Bottom Controls (Capture button, Zoom slider, Filters)
//             Positioned(
//               bottom: 100,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       isRecording ? Icons.stop : Icons.videocam,
//                       color: Colors.red,
//                       size: 30,
//                     ),
//                     onPressed: _toggleRecording,
//                   ),
//                   GestureDetector(
//                     onTap: _takePicture,
//                     onLongPress: _toggleRecording,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 35,
//                       child: CircleAvatar(
//                         backgroundColor: Colors.black,
//                         radius: 30,
//                         child: Icon(
//                           isRecording ? Icons.videocam : Icons.camera_alt,
//                           color: Colors.white,
//                           size: 35,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Icon(Icons.photo_library, color: Colors.white, size: 30),
//                 ],
//               ),
//             ),
//
//             // Filters carousel at the bottom
//             Positioned(
//               bottom: 16,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           log("Filter $index applied");
//                           // Apply real-time filter effect here
//                         },
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 200),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.5), width: 2),
//                           ),
//                           child: CircleAvatar(
//                             backgroundColor: Colors.grey[800],
//                             radius: 30,
//                             child: Icon(Icons.filter_vintage,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
          _cameras![cameraIndex],
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
                    onPressed: () async {
                      if (mediaType == 'image') {
                        _applyFilterToImage();
                      }
                      if (mediaType == 'video') {
                        // await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           MyVoiceVideoRecordingScreen(filePath),
                        //     )).then((value) {
                        //   setState(() {
                        //     filePath = value.toString();
                        //   });
                        //   log("${filePath}111111111111111111111111111111111111111111111111111111111111111111111111111");
                        // });
                        // setState(() {});
                      }
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
        if (success!) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video saved to gallery!')),
          );
        }
        log('Video saved: $success');
      });
    } else {
      log(filePath.toString());
      log('Error: The file is not a video.');
    }
    // await GallerySaver.saveVideo(filePath);
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
    icon: const CircleAvatar(
      // backgroundImage: AssetImage('assets/avatar.png'),
      // backgroundColor: Colors.red, radius: 15,
      radius: 15,
      // backgroundImage:
      //     NetworkImage(serviceLocator<UserCubit>().state.data!.profilePicture!),
      // onBackgroundImageError: (exception, stackTrace) => Sizer(),
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
  String mediaPath;
  MediaType mediaType;

  MediaPreview({super.key, required this.mediaPath, required this.mediaType});

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
                buildSaveButton(context, widget.mediaPath, widget.mediaType),
                buildStoryButton(context, selectedFile: File(widget.mediaPath)),
                buildSendToButton(),
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

class MyVoiceVideoRecordingScreen extends StatefulWidget {
  final String? videoPath;

  const MyVoiceVideoRecordingScreen(this.videoPath, {super.key});

  @override
  MyVoiceVideoRecordingScreenState createState() =>
      MyVoiceVideoRecordingScreenState();
}

class MyVoiceVideoRecordingScreenState
    extends State<MyVoiceVideoRecordingScreen> with TickerProviderStateMixin {
  String? filteredVideoPath;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.videoPath!))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;

  void _applyFilter(Filter filter) {
    setState(() {
      _selectedFilter = filter;
    });
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
      '-i', widget.videoPath!,
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
        // Navigator.pop(context, filteredVideoPath.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MediaPreview(
                  mediaPath: filteredVideoPath.toString(),
                  mediaType: MediaType.video),
            ));
      }

      // if (ReturnCode.isSuccess(returnCode)) {
      //   log("FFmpeg process succeeded");
      //   final savedSuccessfully =
      //       await GallerySaver.saveVideo(filteredVideoPath!);
      //   if (savedSuccessfully ?? false) {
      //     serviceLocator<ReelsCubit>().uploadReel(
      //       File(filteredVideoPath!),
      //     );
      //   } else {
      //     throw Exception("Failed to save video to gallery");
      //   }
      // } else {
      //   final failStackTrace = await session.getFailStackTrace();
      //   throw Exception(
      //       "FFmpeg process failed with return code $returnCode\n$failStackTrace");
      // }
    } catch (e) {
      log("Error in _mergeVideoWithFilter: $e");
      filteredVideoPath = null;
    }
  }

  Widget _buildFilterSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _applyFilter(filters[index]),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 5),
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
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: FloatingActionButton.small(
          shape: const CircleBorder(),
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: () async {
            await _mergeVideoWithFilter();
          },
          tooltip: 'Accept Edit',
          child: const Icon(Icons.check_circle),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: widget.videoPath != null &&
                      _videoController != null &&
                      _videoController!.value.isInitialized
                  ? ColorFiltered(
                      colorFilter: _selectedFilter?.colorFilter ??
                          const ColorFilter.mode(
                              Colors.transparent, BlendMode.srcOver),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : const CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }
}
