import 'dart:io';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/next_media_preview.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/shared/filter_utiles.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import '../../../../../../service_locator/service_locator.dart';
import 'package:image/image.dart' as img;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';


class MediaPreviewScreen extends StatefulWidget {
  final String mediaPath;
  final bool isImage;

  const MediaPreviewScreen({
    required this.mediaPath,
    required this.isImage,
  });

  @override
  _MediaPreviewScreenState createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  VideoPlayerController? _videoController;
  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;
  String? _croppedImagePath;

  Future<File> applyFilterAndSaveImage(String originalPath, String filterType) async {
    // Load the original image
    final originalImage = img.decodeImage(File(originalPath).readAsBytesSync());

    // Apply a filter (example: grayscale)
    img.Image filteredImage;
    if (filterType == 'grayscale') {
      filteredImage = img.grayscale(originalImage!);
    } else if (filterType == 'invert') {
      filteredImage = img.invert(originalImage!);
    } else {
      filteredImage = originalImage!;
    }

    // Save the filtered image to a temporary file
    final tempDir = Directory.systemTemp;
    final filteredImagePath = '${tempDir.path}/filtered_image.png';
    File(filteredImagePath).writeAsBytesSync(img.encodePng(filteredImage));

    return File(filteredImagePath);
  }


  Future<String> applyFilterAndSaveVideo(String originalPath, String filterCommand) async {
    final tempDir = Directory.systemTemp;
    final filteredVideoPath = '${tempDir.path}/filtered_video.mp4';

    // Construct the FFmpeg command
    final command = '-i $originalPath -vf "$filterCommand" $filteredVideoPath';

    // Execute FFmpeg command
    await FFmpegKit.execute(command).then((session) {
      final returnCode = session.getReturnCode();
      // if (ReturnCode.isSuccess(returnCode)) {
      //   print('Filter applied successfully and saved to $filteredVideoPath');
      // } else {
      //   print('Failed to apply filter. Return code: $returnCode');
      //   throw Exception('Error applying filter to video.');
      // }
    });

    return filteredVideoPath;
  }



  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });

      _videoController?.addListener(() {
        if (_videoController!.value.position ==
            _videoController!.value.duration) {
          _videoController?.seekTo(Duration.zero);
          _videoController?.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.pause(); // Stop playback immediately
    _videoController?.removeListener(() {});
    _videoController?.dispose();
    super.dispose();
  }


  void _applyFilter(Filter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Future<void> _cropImage() async {
    final originalFile = File(widget.mediaPath);
    final originalImage = originalFile.readAsBytesSync();
    final decodedImage = img.decodeImage(originalImage);

    if (decodedImage != null) {
      // Define the crop area (e.g., 100x100 square starting at position (50, 50))
      int cropWidth = 100; // Define the width of the cropped area
      int cropHeight = 100; // Define the height of the cropped area
      int startX = 50; // Starting X position (from left)
      int startY = 50; // Starting Y position (from top)

      // Crop the image using the defined coordinates and size
      final croppedImage = img.copyCrop(
        decodedImage,
        x: startX,
        y: startY,
        width: cropWidth,
        height: cropHeight,
      );

      // Save the cropped image
      final croppedImagePath =
          path.join(path.dirname(widget.mediaPath), 'cropped_image.jpg');
      final croppedFile = File(croppedImagePath)
        ..writeAsBytesSync(img.encodeJpg(croppedImage));

      setState(() {
        _croppedImagePath = croppedFile.path;
      });
    } else {
      // Handle decoding failure
      print('Failed to decode image.');
    }
  }

  Widget _buildFilterSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _applyFilter(filters[index]);
              },
              child: Container(
                width: 150.h,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 52.r,
                        backgroundColor: _selectedFilter == filters[index]
                            ? AppColors.SECONDARY_COLOR
                            : Colors.transparent,
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: AssetImage(
                            FilterLibrary.filterImagesPaths[index].toString(),
                          ),
                        ),
                      ),
                      Text(
                        context.isArabic
                            ? filters[index].arName
                            : filters[index].enName,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Styles.mediumText(
                            color: AppColors.AUTH_CONTAINER_COLOR),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return _buildFilterSelector();
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: widget.isImage
                      ? ColorFiltered(
                    colorFilter: _selectedFilter?.colorFilter ??
                        const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: FileImage(
                            File(_croppedImagePath ?? widget.mediaPath),
                          ),
                        ),
                      ),
                    ),
                  )
                      : _videoController != null &&
                      _videoController!.value.isInitialized
                      ? Center(
                    child: ColorFiltered(
                      colorFilter: _selectedFilter?.colorFilter ??
                          const ColorFilter.mode(
                              Colors.transparent, BlendMode.multiply),
                      child: AspectRatio(
                        aspectRatio:
                        _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildContainer(
                          onTap: widget.isImage
                              ? () async {
                            final filteredFile =
                            await applyFilterAndSaveImage(
                                widget.mediaPath, 'grayscale');
                            final fileType =
                            _determineFileType(filteredFile.path);
                            final fileSize = await filteredFile.length();

                            await serviceLocator<StoryCubit>()
                                .uploadStoryVideoOrImage(
                              filteredFile,
                              fileType,
                              fileSize,
                              description: '',
                            )
                                .then((value) {
                              showSuccessMessage(context, 'Filtered Story uploaded');
                            });
                          }
                              : () async {
                            final filteredPath =
                            await applyFilterAndSaveVideo(
                                widget.mediaPath, 'hue=s=0');
                            final file = File(filteredPath);
                            final fileType =
                            _determineFileType(file.path);
                            final fileSize = await file.length();

                            await serviceLocator<StoryCubit>()
                                .uploadStoryVideoOrImage(
                              file,
                              fileType,
                              fileSize,
                              description: '',
                            )
                                .then((value) {
                              showSuccessMessage(context, 'Filtered Story uploaded');
                            });
                          },
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          textColor: AppColors.QUANTITY_COLOR,
                          title: 'Story',
                          image: true,
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: buildContainer(
                          onTap: () {
                            if (!widget.isImage && _videoController?.value.isPlaying == true) {
                              _videoController?.pause();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NextMediaPreview(
                                  mediaPath: widget.mediaPath,
                                  isImage: widget.isImage,
                                ),
                              ),
                            ).then((_) {
                              // Resume video when returning to this screen
                              if (!widget.isImage) {
                                _videoController?.play();
                              }
                            });
                          },
                          color: AppColors.SECONDARY_COLOR,
                          textColor: AppColors.AUTH_CONTAINER_COLOR,
                          title: 'Next',
                        ),
                      ),
                    ],
                  ),
                ),
                const Sizer(),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showFilterBottomSheet();
                        },
                        icon: Icon(
                          Icons.filter,
                          size: 60.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // await _cropImage();
                        },
                        icon: Icon(
                          Icons.crop,
                          size: 60.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 60.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildContainer({
    required Function onTap,
    required Color color,
    required Color textColor,
    required String title,
    bool image = false,
  }) {
    final user = context.read<UserCubit>().state.data;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image)
              CircleAvatar(
                radius: 30.w,
                backgroundColor: Colors.blue,
                child: ImageFromInternet(
                  image: user?.profilePicture ?? UIConst.profilePlaceHolder,
                  height: 50.h,
                  width: 50.w,
                  isCircle: true,
                ),
              ),
            if (image)
              SizedBox(
                width: 10.w,
              ),
            Text(
              title,
              style: Styles.headerText(color: textColor, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ],
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
