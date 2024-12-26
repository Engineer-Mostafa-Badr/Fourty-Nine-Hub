// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/snap/presentation/widget/media_preview_screen.dart';
// import 'package:fourtyninehub/features/social_media/snap/utils/filters.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/search_app_users.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/const.dart';
// import '../../../../../routes/routes.dart';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class FaceDetectionCamera extends StatefulWidget {
//   @override
//   _GlassesOverlayCameraState createState() => _GlassesOverlayCameraState();
// }
//
// class _GlassesOverlayCameraState extends State<FaceDetectionCamera> {
//   late CameraController _cameraController;
//   late FaceDetector _faceDetector;
//   bool _isDetecting = false;
//   List<Face> _detectedFaces = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(
//         enableContours: true,
//         enableClassification: true,
//       ),
//     );
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _cameraController = CameraController(
//       cameras[0],
//       ResolutionPreset.high,
//     );
//
//     await _cameraController.initialize();
//     _cameraController.startImageStream((CameraImage image) {
//       if (!_isDetecting) {
//         _isDetecting = true;
//         _detectFaces(image);
//       }
//     });
//   }
//
//   Future<void> _detectFaces(CameraImage image) async {
//     try {
//       final inputImage = _convertCameraImageToInputImage(image);
//       final faces = await _faceDetector.processImage(inputImage);
//       setState(() {
//         _detectedFaces = faces;
//       });
//     } catch (e) {
//       print("Face detection error: $e");
//     } finally {
//       _isDetecting = false;
//     }
//   }
//
//   InputImage _convertCameraImageToInputImage(CameraImage image) {
//     // Combine image bytes
//     final bytes = image.planes.map((plane) => plane.bytes).expand((b) => b).toList();
//
//     // Define metadata directly (if required by your use case)
//     final metadata = InputImageMetadata(
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       rotation: InputImageRotation.rotation0deg, // Adjust as needed
//       format: InputImageFormat.nv21, // Ensure this matches your CameraImage format
//       // planeData: image.planes
//       //     .map((plane) => InputImagePlaneMetadata(
//       //   bytesPerRow: plane.bytesPerRow,
//       //   height: plane.height,
//       //   width: plane.width,
//       // ))
//       //     .toList(),
//       bytesPerRow: 1,
//     );
//
//     // Create InputImage
//     return InputImage.fromBytes(
//       bytes: Uint8List(1),
//      // inputImageFormat: InputImageFormat.nv21, // Adjust if needed
//       metadata: metadata, // Pass the updated metadata
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           CameraPreview(_cameraController),
//           ..._detectedFaces.map((face) {
//             final leftEye = face.landmarks[FaceLandmarkType.leftEye];
//             final rightEye = face.landmarks[FaceLandmarkType.rightEye];
//
//
//             if (leftEye != null && rightEye != null) {
//               final glassesWidth = (rightEye.position.x - leftEye.position.x).abs() * 2;
//               final glassesHeight = glassesWidth * 0.5;
//
//
//               return Positioned(
//                 left: leftEye.position.x - glassesWidth / 2,
//                 top: leftEye.position.y - glassesHeight / 2,
//                 child: Image.asset(
//                   'assets/glasses.png',
//                   width: double.parse('$glassesWidth'),
//                   height: glassesHeight,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             }
//             return Container();
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// // class FaceDetectionCamera extends StatefulWidget {
// //   @override
// //   _FaceDetectionCameraState createState() => _FaceDetectionCameraState();
// // }
// //
// // class _FaceDetectionCameraState extends State<FaceDetectionCamera> {
// //   late CameraController _cameraController;
// //   late List<CameraDescription> _cameras;
// //   bool _isInitialized = false;
// //   final FaceDetector _faceDetector = FaceDetector(
// //     options: FaceDetectorOptions(
// //       performanceMode: FaceDetectorMode.accurate,
// //       enableLandmarks: true,
// //       enableContours: true,
// //     ),
// //   );
// //
// //   bool isBusy = false;
// //   List<Face> detectedFaces = [];
// //   String selectedEmoji = "🙂";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeCamera();
// //   }
// //
// //   Future<void> _initializeCamera() async {
// //     // Fetch available cameras
// //     _cameras = await availableCameras();
// //     // Check if we have at least one camera available
// //     if (_cameras.isNotEmpty) {
// //       // Initialize the camera controller with the first camera
// //       _cameraController = CameraController(
// //         _cameras[0],
// //         ResolutionPreset.high,
// //       );
// //
// //       // Add a listener to handle changes in the camera's lifecycle
// //       _cameraController.addListener(() {
// //         if (mounted) {
// //           setState(() {});
// //         }
// //       });
// //
// //       try {
// //         // Initialize the camera controller
// //         await _cameraController.initialize();
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //       } catch (e) {
// //         print('Error initializing camera: $e');
// //       }
// //     } else {
// //       print('No cameras available');
// //     }
// //   }
// //
// //   Future<void> detectFaces(CameraImage image) async {
// //     final WriteBuffer allBytes = WriteBuffer();
// //     for (var plane in image.planes) {
// //       allBytes.putUint8List(plane.bytes);
// //     }
// //     final bytes = allBytes.done().buffer.asUint8List();
// //
// //     final InputImage inputImage = InputImage.fromBytes(
// //       bytes: bytes,
// //       metadata: InputImageMetadata(
// //         size: Size(image.width.toDouble(), image.height.toDouble()),
// //         rotation: InputImageRotation.rotation0deg,
// //         format: InputImageFormat.yuv420,
// //         bytesPerRow: image.planes[0].bytesPerRow,
// //       ),
// //     );
// //
// //     final List<Face> faces = await _faceDetector.processImage(inputImage);
// //
// //     if (mounted) {
// //       setState(() {
// //         detectedFaces = faces;
// //       });
// //     }
// //   }
// //
// //   Future<void> capturePicture() async {
// //     if (!_cameraController.value.isInitialized) return;
// //
// //     try {
// //       XFile file = await _cameraController.takePicture();
// //       if (file != null) {
// //         final imagePath = file.path;
// //         print("Image captured at: $imagePath");
// //         // You can add a method to overlay the emoji and save or display the image
// //         saveImageWithEmoji(imagePath);
// //       }
// //     } catch (e) {
// //       print("Error capturing picture: $e");
// //     }
// //   }
// //
// //   Future<void> saveImageWithEmoji(String imagePath) async {
// //     // Logic to load and overlay the emoji on the captured image
// //     // This could involve using an image processing library like `flutter_image_compress` or `image` package
// //     print("Feature to save the image with emoji to be implemented.");
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isInitialized) {
// //       // Display a loading indicator if the camera is not initialized yet
// //       return Center(
// //         child: CircularProgressIndicator(),
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Face Emoji Overlay"),
// //       ),
// //       body: _cameraController.value.isInitialized
// //           ? Stack(
// //         children: [
// //           CameraPreview(_cameraController),
// //           if (detectedFaces.isNotEmpty)
// //             CustomPaint(
// //               painter: EmojiPainter(detectedFaces, selectedEmoji),
// //               size: MediaQuery.of(context).size,
// //             ),
// //           Positioned(
// //             bottom: 20,
// //             left: 20,
// //             right: 20,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 EmojiButton(emoji: "🙂", onTap: () => setEmoji("🙂")),
// //                 EmojiButton(emoji: "😎", onTap: () => setEmoji("😎")),
// //                 EmojiButton(emoji: "😂", onTap: () => setEmoji("😂")),
// //                 EmojiButton(emoji: "🥳", onTap: () => setEmoji("🥳")),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 80,
// //             right: 20,
// //             child: FloatingActionButton(
// //               onPressed: capturePicture,
// //               child: Icon(Icons.camera),
// //             ),
// //           ),
// //         ],
// //       )
// //           : Center(child: CircularProgressIndicator()),
// //     );
// //   }
// //
// //   void setEmoji(String emoji) {
// //     setState(() {
// //       selectedEmoji = emoji;
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _cameraController.dispose();
// //     _faceDetector.close();
// //     super.dispose();
// //   }
// // }
// //
// // class EmojiPainter extends CustomPainter {
// //   final List<Face> faces;
// //   final String emoji;
// //
// //   EmojiPainter(this.faces, this.emoji);
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final textPainter = TextPainter(
// //       textAlign: TextAlign.center,
// //       textDirection: TextDirection.ltr,
// //     );
// //
// //     for (var face in faces) {
// //       final boundingBox = face.boundingBox;
// //
// //       // Calculate position and size for emoji
// //       final emojiSize = boundingBox.width;
// //       final offset = Offset(
// //         boundingBox.center.dx - emojiSize / 2,
// //         boundingBox.top - emojiSize / 2,
// //       );
// //
// //       // Draw emoji
// //       textPainter.text = TextSpan(
// //         text: emoji,
// //         style: TextStyle(fontSize: emojiSize),
// //       );
// //       textPainter.layout();
// //       textPainter.paint(canvas, offset);
// //     }
// //   }
// //
// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => true;
// // }
// //
// // class EmojiButton extends StatelessWidget {
// //   final String emoji;
// //   final VoidCallback onTap;
// //
// //   const EmojiButton({
// //     required this.emoji,
// //     required this.onTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         margin: EdgeInsets.symmetric(horizontal: 8.0),
// //         padding: EdgeInsets.all(12.0),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           shape: BoxShape.circle,
// //         ),
// //         child: Text(
// //           emoji,
// //           style: TextStyle(fontSize: 24),
// //         ),
// //       ),
// //     );
// //   }
// // }