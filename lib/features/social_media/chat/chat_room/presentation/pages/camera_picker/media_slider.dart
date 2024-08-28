part of 'camera_picker.dart';

class MediaSliderViewParams {
  final List<XFile> media;
  final int? initialIndex;

  MediaSliderViewParams({required this.media, this.initialIndex});
}

class MediaSliderView extends StatefulWidget {
  final MediaSliderViewParams params;

  const MediaSliderView({super.key, required this.params});

  @override
  State<MediaSliderView> createState() => _MediaSliderViewState();
}

class _MediaSliderViewState extends State<MediaSliderView> {
  late int _selectedIndex;
  late PageController _pageController;
  late List<XFile> _media;

  @override
  void initState() {
    _selectedIndex = widget.params.initialIndex ?? 0;
    _media = widget.params.media;
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

  FlutterStoryEditorController controller = FlutterStoryEditorController();
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _media.length,
                    itemBuilder: (context, index) {
                      final file = File(_media[index].path);
                      if (file.isImage) {
                        return Image.file(file);
                      } else {
                        return VideoPlayerWidget(
                          videoFile: file,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 20.zH,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.zW),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _BaseIcon(
                          icon: Icons.close,
                          onTap: () {
                            context.pop();
                          },
                        ),
                        _BaseIcon(
                          icon: Icons.edit,
                          onTap: () {
                            final file = File(_media[_selectedIndex].path);
                            late Widget child;
                            if (file.isImage) {
                              child = ProImageEditor.file(
                                file,
                                // configs: ProImageEditorConfigs(
                                //
                                // ),
                                onImageEditingComplete: (Uint8List bytes) async {
                                  /*
                       Your code to handle the edited image. Upload it to your server as an example.
                       You can choose to use await, so that the loading-dialog remains visible until your code is ready, or no async, so that the loading-dialog closes immediately.
                       By default, the bytes are in `jpg` format.
                      */
                                  CliLogger.info(bytes.toString());
                                  // Navigator.pop(context);
                                },
                              );
                            } else {
                              child = FlutterStoryEditor(
                                  controller: controller,
                                  captionController: _captionController,
                                  selectedFiles: [file],
                                  onSaveClickListener: (files) {
                                    // Here you go with your edited files.
                                  });
                            }
                            showBottomSheet(
                              context: context,
                              builder: (context) => child,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.zH,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 150.zW,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      scrollDirection: Axis.horizontal,
                      itemCount: _media.length,
                      separatorBuilder: (context, index) => const Sizer(),
                      itemBuilder: (context, index) {
                        final file = File(_media[index].path);
                        if (file.isImage) {
                          return _mediaContainer(
                              index: index, image: FileImage(file));
                        } else {
                          return FutureBuilder<Uint8List?>(
                            future: generateThumbnail(path: file.path),
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
                                    width: 150.zW,
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
            );
          }
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
            _media.removeAt(index);
            _selectedIndex = 0;
          });
          if (_media.isEmpty) {
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
        width: 150.zW,
        decoration: BoxDecoration(
          border: _selectedIndex == index
              ? Border.all(color: Colors.white, width: 3)
              : null,
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
                  _selectedIndex == index
                      ? Icons.delete
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((value) => setState(() {}));
    _controller.addListener(() {
      if (_controller.value.isInitialized && _controller.value.isCompleted) {
        setState(() {});
      }
    });

    // Use the controller to loop the video.
    // _controller.setLooping(false);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              if (!_controller.value.isPlaying)
                Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 300.zW,
                ),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
