import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';

class ImagesAndVideosSlider extends StatefulWidget {
  final List<XFile> media;

  const ImagesAndVideosSlider({super.key, required this.media});

  @override
  State<ImagesAndVideosSlider> createState() => _ImagesAndVideosSliderState();
}

class _ImagesAndVideosSliderState extends State<ImagesAndVideosSlider> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
    _pageController.addListener(() {
      setState(() {
        _selectedIndex = _pageController.page!.toInt();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.media.length,
                itemBuilder: (context, index) {
                  final file = File(widget.media[index].path);
                  if (file.isPhoto) {
                    return Image.file(file);
                  } else {
                    return _VideoPlayerScreen(
                      videoFile: file,
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.media.length ?? 0,
                  separatorBuilder: (context, index) => const Sizer(),
                  itemBuilder: (context, index) {
                    final file = File(widget.media[index].path);
                    if (file.isPhoto) {
                      return _mediaContainer(
                          index: index, image: FileImage(file));
                    } else {
                      return FutureBuilder<Uint8List?>(
                        future: file.generateThumbnail(),
                        builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            return _mediaContainer(
                                index: index,
                                image: MemoryImage(snapshot.data!),
                                isPhoto: false);
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaContainer(
      {required int index, required ImageProvider image, bool isPhoto = true}) {
    return InkWell(
      onTap: () {
        if (_selectedIndex == index) {
          setState(() {
            widget.media.removeAt(index);
            _selectedIndex = 0;
          });
          if (widget.media.isEmpty) {
            context.pop();
          }
        } else {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border:
              _selectedIndex == index ? Border.all(color: Colors.white) : null,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
        child: isPhoto
            ? index == _selectedIndex
                ? const Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )
                : null
            : Center(
                child: Icon(
                  _selectedIndex == index ? Icons.delete : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _VideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  const _VideoPlayerScreen({super.key, required this.videoFile});

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(widget.videoFile);

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return InkWell(
            onTap: () {
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
