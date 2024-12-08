import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/snap/presentation/pages/snap_view.dart';
import 'package:fourtyninehub/features/social_media/snap/utils/filters.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

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
  OverlayEntry? _overlayEntry;

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
  final GlobalKey _globalKey = GlobalKey();
  bool isSelected = false;
  bool isCollapsed = false;

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

  Future<void> _capturePng() async {
    try {
      // Check if the camera controller is initialized
      if (widget.mediaPath.isEmpty) {
        print('mediaPath is not initialized');
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
          widget.mediaPath = savedImage.path; // Update the selected image
          print('Image captured and saved at ${widget.mediaPath}');
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
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
                  ? RepaintBoundary(
                key: _globalKey,
                child: ColorFiltered(
                  colorFilter: advancedFilters[selectedFilterIndex]
                  ['colorFilter'],
                  child: Image.file(
                    File(widget.mediaPath),
                  ),
                ),
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
              bottom: 0,
              left: 0,
              right: 0,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Sizer(),
                    buildSaveButton(
                        context, widget.mediaPath, widget.mediaType),
                    const Sizer(),
                    buildStoryButton(context,
                        selectedFile: File(widget.mediaPath)),
                    const Sizer(),
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _capturePng();
                          // Handle Send action
                        },
                        icon: const Icon(Icons.check_circle_rounded,
                            color: AppColors.PRIMARY_COLOR),
                        label: const Text('Apply Filter',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const Sizer(),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          icon: Icon(isCollapsed ? Icons.edit : Icons.edit_off,
                              size: 30, color: Colors.white),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _pageController.jumpToPage(
                                  selectedFilterIndex); // Change this index to the desired page.
                            });
                            setState(() {
                              isCollapsed = !isCollapsed;
                            });
                          }),
                    ),
                    const Sizer(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: kToolbarHeight),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: kToolbarHeight),
                    width: isCollapsed ? 0 : MediaQuery.of(context).size.width,

                    // Full width when expanded
                    alignment: Alignment.center,

                    // Align content to the left
                    child: isCollapsed
                        ? null
                        : Stack(
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
                              border: Border.all(
                                  color: Colors.white, width: 6),
                            ),
                          ),
                        ),
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
                            isSelected = selectedFilterIndex == index;

                            log("${isSelected}88888888888888888888888888888888888$selectedFilterIndex  $index");
                            final filter = advancedFilters[index];

                            return AnimatedOpacity(
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
                                    scale: isSelected ? 1 : 0.6,
                                    // Scaling effect
                                    child: ColorFiltered(
                                      colorFilter: filter['colorFilter'],
                                      child: CircleAvatar(
                                        backgroundImage:
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        backgroundColor: AppColors.PRIMARY_COLOR,
        backgroundImage: NetworkImage(
          serviceLocator<UserCubit>().state.data != null
              ? serviceLocator<UserCubit>().state.data!.profilePicture!
              : UIConst.profilePlaceHolder,
        ),
        onBackgroundImageError: (_, __) => Image.asset(
          UIConst.profilePlaceHolder,
        ),
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
}