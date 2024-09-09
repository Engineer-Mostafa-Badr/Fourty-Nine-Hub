import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:video_player/video_player.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CameraScreen(),
    );
  }
}



class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  bool isRecordingVideo = false;
  bool isVideoMode = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  // Initialize the camera
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    _initializeControllerFuture = _controller?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Capture image and navigate to preview screen
  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller?.takePicture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = join(directory.path, '${DateTime.now()}.png');
        await image.saveTo(imagePath);
        _navigateToPreviewScreen(imagePath, 'image');
      }
    } catch (e) {
      print(e);
    }
  }

  // Start or stop video recording and navigate to preview screen
  Future<void> _toggleVideoRecording() async {
    if (isRecordingVideo) {
      XFile? videoFile = await _controller?.stopVideoRecording();
      setState(() {
        isRecordingVideo = false;
      });

      if (videoFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final videoPath = join(directory.path, '${DateTime.now()}.mp4');
        File(videoFile.path).copy(videoPath);
        _navigateToPreviewScreen(videoPath, 'video');
      }
    } else {
      await _controller?.startVideoRecording();
      setState(() {
        isRecordingVideo = true;
      });
    }
  }

  // Navigate to preview screen after capturing media
  void _navigateToPreviewScreen(String filePath, String mediaType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPreviewScreen(filePath: filePath, mediaType: mediaType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.white, size: 40),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isVideoMode) {
                            _toggleVideoRecording();
                          } else {
                            _captureImage();
                          }
                        },
                        child: Icon(
                          isVideoMode
                              ? (isRecordingVideo
                              ? Icons.stop
                              : Icons.videocam)
                              : Icons.camera_alt,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isVideoMode ? Icons.photo_camera : Icons.videocam,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            isVideoMode = !isVideoMode;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class MediaPreviewScreen extends StatelessWidget {
  final String filePath;
  final String mediaType; // 'image' or 'video'

  MediaPreviewScreen({required this.filePath, required this.mediaType});

  // Save media (image or video) to gallery
  Future<void> _saveMedia(BuildContext context) async {
    if (mediaType == 'image') {
      await GallerySaver.saveImage(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to gallery!')),
      );
    } else if (mediaType == 'video') {
      await GallerySaver.saveVideo(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved to gallery!')),
      );
    }
  }

  // Discard media with a dialog confirmation
  Future<void> _discardMedia(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to choose an option
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to abandon your Snapsterpiece?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                File(filePath).delete(); // Delete the file
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$mediaType discarded!')),
                );
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to the previous screen
              },
              child: Text('Abandon'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media preview
          Positioned.fill(
            child: mediaType == 'image'
                ? Image.file(
              File(filePath),
              fit: BoxFit.cover,
            )
                : VideoPlayerWidget(filePath: filePath),
          ),

          // Bottom buttons (Save, Story, Send To) - Matching your provided image
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Save button (download icon)
                Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.download_rounded, size: 30, color: Colors.white),
                    onPressed: () => _saveMedia(context),
                  ),
                ),
                // Story button (middle, with avatar icon)
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Story action
                  },
                  icon: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'), // Replace with actual avatar
                    radius: 15,
                  ),
                  label: Text('Story', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                // Send To button (right)
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Send action
                    },
                    icon: Icon(Icons.send, color: Colors.black),
                    label: Text('Send To', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// VideoPlayerWidget for video preview
class VideoPlayerWidget extends StatefulWidget {
  final String filePath;
  VideoPlayerWidget({required this.filePath});

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
        : Center(child: CircularProgressIndicator());
  }
}
