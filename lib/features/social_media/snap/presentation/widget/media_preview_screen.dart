import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/snap/utils/filters.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/widget/custom_scaffold.dart';

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

  int selectedFilterIndex = 0;
  PageController _pageController = PageController();
  final GlobalKey _globalKey = GlobalKey();
  bool isSelected = false;
  bool isCollapsed = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
    _pageController = PageController();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _captureFilteredImage(int index) async {
    try {
      if (widget.mediaPath.isEmpty) {
        print('mediaPath is not initialized');
        return;
      }

      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print('Error: RepaintBoundary is null');
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        print('Error: ByteData is null');
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save the filtered image
      final directory = await getApplicationDocumentsDirectory();
      String filePath =
          '${directory.path}/filtered_image_${DateTime.now().millisecondsSinceEpoch}.png';

      File filteredImage = await File(filePath).writeAsBytes(pngBytes);
      showSuccessMessage(context, 'Video saved to gallery!');

      if (filteredImage.existsSync()) {
        // Optionally save to the gallery
        // await GallerySaver.saveImage(filteredImage.path);
        print('Filtered image saved at: ${filteredImage.path}');
      } else {
        print('Error: Saved image does not exist');
      }
    } catch (e) {
      print('Error capturing filtered image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              key: _globalKey,
              child: ColorFiltered(
                colorFilter: advancedFilters[_currentIndex]['colorFilter'],
                // Focused filter
                child: Image.file(
                  File(widget.mediaPath),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Sizer(),
                buildSaveButton(context, widget.mediaPath, widget.mediaType),
                Sizer(
                  width: 50.w,
                ),
                buildStoryButton(context, selectedFile: File(widget.mediaPath)),
                // const Spacer(),
                // buildSendToButton(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              //margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: kToolbarHeight),
                  width: isCollapsed ? 0 : MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: isCollapsed
                      ? null
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: advancedFilters.length,
                              onPageChanged: (index) {
                                setState(() {
                                  selectedFilterIndex = index;
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                isSelected = selectedFilterIndex == index;

                                log("${isSelected}88888888888888888888888888888888888$selectedFilterIndex  $index");
                                final filter = advancedFilters[index];

                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: isSelected ? 1.0 : 0.5,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    child: Padding(
                                      padding: EdgeInsets.all(30.w),
                                      child: Transform.scale(
                                        scale: isSelected ? 1 : 0.6,
                                        child: ColorFiltered(
                                          colorFilter: filter['colorFilter'],
                                          child: Container(),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 90.h, horizontal: 10.w),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear)),
          )
        ],
      ),
    );
  }

  Widget buildSaveButton(BuildContext context, filePath, mediaType) {
    return GestureDetector(
      onTap: () async {
        await _captureFilteredImage(_currentIndex);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.file_download_outlined, size: 50.sp, color: Colors.white),
          Text(
            LocaleKeys.save.localize,
            style: Styles.smallText(fontSize: 60.sp),
          )
        ],
      ),
    );
  }

  Widget buildStoryButton(context, {selectedFile}) {
    return GestureDetector(
      onTap: () async {
        final file = selectedFile;
        final fileType = _determineFileType(file!.path);
        final fileSize = await file.length();

        await serviceLocator<StoryCubit>()
            .uploadStoryVideoOrImageOrVoice(file, fileType, fileSize,
                description: '')
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Story created')),
                ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 50.sp, color: Colors.white),
          Text(
            'Story',
            style: Styles.smallText(fontSize: 60.sp),
          )
        ],
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
      return 'image/jpeg';
    } else {
      throw Exception('Unsupported file type');
    }
  }
}
