part of 'camera_picker.dart';

class MediaSliderViewParams {
  final List<File> media;
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
  late List<File> _media;

  @override
  void initState() {
    _selectedIndex = widget.params.initialIndex ?? 0;
    _media = widget.params.media;
    _pageController = PageController(initialPage: _selectedIndex);
    // _pageController.addListener(() {
    //   setState(() {
    //     _selectedIndex = _pageController.page!.toInt();
    //   });
    // });
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
        backgroundColor: Colors.black,
        body: Builder(builder: (context) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.zW),
                child: Row(
                  children: [
                    _BaseIcon(
                      icon: Icons.close,
                      onTap: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                    _BaseIcon(icon: Icons.plus_one_rounded, onTap: () {}),
                    SizedBox(width: 20.zW),
                    _BaseIcon(
                      icon: Icons.edit,
                      onTap: () async {
                        Uint8List? editedImage;
                        showDialog(
                          context: context,
                          builder: (context) => ProImageEditor.file(
                            _media[_selectedIndex],
                            onImageEditingComplete: (Uint8List bytes) async {
                              editedImage = bytes;
                              context.pop();
                            },
                          ),
                        ).then((value) async {
                          if (editedImage != null) {
                            _media[_selectedIndex] =
                            await _convertUint8ListToFile(editedImage!);
                            setState(() {});
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _media.length,
                  itemBuilder: (context, index) {
                    final file = _media[index];
                    if (file.isImage) {
                      return Image.file(file);
                    } else {
                      return _TrimmerView(file: file, onSave: (editedVideo) {});
                    }
                  },
                ),
              ),
              SizedBox(
                height: 150.zW,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  itemCount: _media.length,
                  separatorBuilder: (context, index) => const Sizer(),
                  itemBuilder: (context, index) {
                    CliLogger.info('building index: $index');
                    final file = _media[index];
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
            ],
          );
        }),
      ),
    );
  }

  Future<File> _convertUint8ListToFile(Uint8List uint8list) async {
    // Get the application's directory to store the file.
    final directory = await getApplicationDocumentsDirectory();

    // Create a unique file path
    String filePath =
        '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

    // Convert the Uint8List to an image using the image package.
    img.Image image = img.decodeImage(uint8list)!;

    // Encode the image as a PNG.
    List<int> pngBytes = img.encodePng(image);

    // Create a file from the Uint8List.
    File imgFile = File(filePath);

    // Write the file
    await imgFile.writeAsBytes(pngBytes);

    return imgFile;
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

class _TrimmerView extends StatefulWidget {
  final File file;
  final void Function(File video) onSave;

  const _TrimmerView({required this.file, required this.onSave});

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<_TrimmerView> {
  // final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? value;

    // await _trimmer.saveTrimmedVideo(
    //     startValue: _startValue,
    //     endValue: _endValue,
    //     onSave: (path) {
    //       setState(() {
    //         value = path;
    //         _progressVisibility = false;
    //       });
    //     });

    return value;
  }

  void _loadVideo() {
    // _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.zH),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Visibility(
            visible: _progressVisibility,
            child: const LinearProgressIndicator(
              backgroundColor: Colors.red,
            ),
          ),

          Expanded(
            child: InkWell(
                onTap: () async {
                  // bool playbackState = await _trimmer.videoPlaybackControl(
                  //   startValue: _startValue,
                  //   endValue: _endValue,
                  // );
                  // setState(() {
                  //   _isPlaying = playbackState;
                  // });
                },
                // child: VideoViewer(trimmer: _trimmer)
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(
              //   child: TrimViewer(
              //     trimmer: _trimmer,
              //     viewerHeight: 50.0,
              //     // viewerWidth: MediaQuery.of(context).size.width,
              //     onChangeStart: (value) => _startValue = value,
              //     onChangeEnd: (value) => _endValue = value,
              //     onChangePlaybackState: (value) =>
              //         setState(() => _isPlaying = value),
              //   ),
              // ),
              SizedBox(width: 5.zW),
              Center(child: _BaseIcon(icon: Icons.check, onTap: _saveVideo)),
            ],
          ),
          // const Sizer(),
          // ElevatedAppButton(
          //   onPressed: () async {
          //     if (_progressVisibility) {
          //       _saveVideo().then((outputPath) {
          //         CliLogger.info('OUTPUT PATH: $outputPath');
          //         if (outputPath != null) {
          //           widget.onSave(File(outputPath));
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //                 content: Text(LocaleKeys.suscessfullySaved.tr())),
          //           );
          //         }
          //       });
          //     }
          //   },
          //   label: LocaleKeys.save.tr(),
          // ),
          // TextButton(
          //   child: _isPlaying
          //       ? Icon(
          //           Icons.pause,
          //           size: 80.0,
          //           color: Colors.white,
          //         )
          //       : Icon(
          //           Icons.play_arrow,
          //           size: 80.0,
          //           color: Colors.white,
          //         ),
          //   onPressed: () async {
          //     bool playbackState = await _trimmer.videoPlaybackControl(
          //       startValue: _startValue,
          //       endValue: _endValue,
          //     );
          //     setState(() {
          //       _isPlaying = playbackState;
          //     });
          //   },
          // )
        ],
      ),
    );
  }
}