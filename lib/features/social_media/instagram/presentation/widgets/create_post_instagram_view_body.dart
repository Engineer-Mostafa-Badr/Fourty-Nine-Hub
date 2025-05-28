import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/custom_error.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/app_bar_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/floating_action_button_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_body_create_post_instagram.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreatePostInstagramViewBody extends StatelessWidget {
  const CreatePostInstagramViewBody({super.key});

  // @override
  // void initState() {
  //   super.initState();
  //   // context.read<CreatePostInstagramCubit>().loadImages(context);
  // }
  // Future<void> loadImages() async {
  //   final hasPermission = await requestPermission();
  //   if (hasPermission) {
  //     final fetchedImages = await fetchAllImages();
  //     setState(() {
  //       images = fetchedImages;
  //       selectedImage = images.first.file;
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Permission denied!')),
  //     );
  //   }
  // }
  // Future<List<AssetEntity>> fetchAllImages() async {
  //   final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
  //       // type: RequestType.fromTypes([RequestType.image, RequestType.video]), // جلب الصور فقط
  //       type: RequestType.image);
  //   if (albums.isNotEmpty) {
  //     final AssetPathEntity album = albums.first; // اختر الألبوم الأول
  //     List<AssetEntity> allImages = [];
  //     int page = 0; // ابدأ من الصفحة الأولى
  //     const int pageSize = 100;
  //     while (true) {
  //       // جلب الصور في الصفحة الحالية
  //       final List<AssetEntity> images =
  //           await album.getAssetListPaged(page: page, size: pageSize);
  //       if (images.isEmpty) {
  //         break; // إذا لم تكن هناك صور إضافية، أخرج من الحلقة
  //       }
  //       allImages.addAll(images); // أضف الصور إلى القائمة النهائية
  //       page++; // انتقل إلى الصفحة التالية
  //     }
  //     return allImages;
  //   }
  //   return [];
  // }
  // bool multiSelect = false;
  // List<AssetEntity> selectedMeda = [];
  // BoxFit? fit;
  // Future<bool> requestPermission() async {
  //   final PermissionState result = await PhotoManager.requestPermissionExtend();
  //   return result.isAuth; // تحقق من أن الإذن مُعطى
  // }
  // List postTypes = ["Post", "Story", "Reel"];
  // int postTypeSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const Center(child: CustomCircularProgressIndicator());
    // }
    // if (images.isEmpty) {
    //   return const Center(child: Text('No images found!'));
    // }
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isLoading) {
          return const CustomLoading();
        }
        if (state.status.isError) {
          return CustomError(
            errMessage:
                getFailureMessage(state.failure ?? UnknownFailure(''), context),
          );
        }
        return Stack(
          children: [
            BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
              buildWhen: (previous, current) =>
                  previous.postTypeSelectedIndex !=
                  current.postTypeSelectedIndex,
              builder: (context, state) {
                return Column(
                  children: [
                    AppBarCreatePostInstagram(
                      postIndex: context
                          .read<CreatePostInstagramCubit>()
                          .postTypes[state.postTypeSelectedIndex]
                          .index,
                      onPressed: () {
                        if (state.postTypeSelectedIndex == 0) {
                          bool isGalleryPostEmpty = context
                              .read<CreatePostInstagramCubit>()
                              .state
                              .selectedGalleryPost
                              .isEmpty;
                          if (isGalleryPostEmpty) {
                            showErrorMessage(
                              context,
                              LocaleKeys.youMustSelectAtLeastOneImage.localize,
                            );
                          } else {
                            context.pushNamed(
                              Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
                              extra: context.read<CreatePostInstagramCubit>(),
                            );
                            // context
                            //     .read<CreatePostInstagramCubit>()
                            //     .nextPage(context);
                          }
                        }
                        else if (state.postTypeSelectedIndex == 2) {
                          context.push(Routes.REELS);
                          // bool isGalleryReelEmpty = context
                          //     .read<CreatePostInstagramCubit>()
                          //     .state
                          //     .selectedGalleryReels
                          //     .isEmpty;
                          // if (isGalleryReelEmpty) {
                          //   showErrorMessage(
                          //     context,
                          //     LocaleKeys.youMustSelectAtLeastOneVideo.localize,
                          //   );
                          // } else {
                          //   context.pushNamed(
                          //     Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
                          //     extra: context.read<CreatePostInstagramCubit>(),
                          //   );
                          // }
                        }
                      },
                    ),
                    if (state.postTypeSelectedIndex == 0)
                      const Expanded(
                        child: PostBodyCreatePostInstagram(
                            // images: state.images,
                            // selectedImage: selectedImage,
                            ),
                      ),
                    // if (state.postTypeSelectedIndex == 1)
                    //   const Expanded(child: Placeholder()),

                    // if (state.postTypeSelectedIndex == 2)
                    //   const Expanded(child: ReelBodyCreatePostInstagram()),
                  ],
                );
              },
            ),
            const Positioned(
              // left: 0,
              right: 0,
              bottom: 25,
              child: FloatingActionButtonCreatePostInstagram(),
              // child: Container(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(10), // لجعل الحواف دائرية
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(
              //         sigmaX: 10.0, // التمويه على المحور X
              //         sigmaY: 10.0, // التمويه على المحور Y
              //       ),
              //       child: Container(
              //         width: double.infinity,
              //         padding: const EdgeInsets.symmetric(horizontal: 8),
              //         height: 50,
              //         margin: const EdgeInsets.symmetric(horizontal: 70),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(50),
              //           color: Colors.black
              //               .withOpacity(0.6), // لون شفاف لإظهار التأثير الزجاجي
              //           // border: Border.all(
              //           //   color: Colors.white.withOpacity(
              //           //       0.3), // إطار شفاف لتحسين الشكل
              //           //   width: 1,
              //           // ),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             ...List.generate(postTypes.length, (index) {
              //               return Container(
              //                 margin: const EdgeInsets.symmetric(horizontal: 5),
              //                 child: Text(
              //                   postTypes[index],
              //                   style: Styles.headerText(
              //                       color: index == 0 ? Colors.white : Colors.grey,
              //                       fontWeight: index == 0
              //                           ? FontWeight.bold
              //                           : FontWeight.w400),
              //                 ),
              //               );
              //             }),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ],
        );
      },
    );
  }
}

class ReelBodyCreatePostInstagram extends StatefulWidget {
  const ReelBodyCreatePostInstagram({super.key});

  @override
  State<ReelBodyCreatePostInstagram> createState() =>
      _ReelBodyCreatePostInstagramState();
}

class _ReelBodyCreatePostInstagramState
    extends State<ReelBodyCreatePostInstagram> {
  // VideoPlayerController? _controller;

  @override
  void initState() {
    context.read<CreatePostInstagramCubit>().fetchVideos(context);
    super.initState();
  }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostInstagramCubit, CreatePostInstagramState>(
      listener: (context, state) {
        if (state.isPermissionGranted == false) {
          showErrorMessage(context, LocaleKeys.permissionDenied.localize);
        }
      },
      builder: (context, state) {
        if (state.loadingReelsScreen) {
          return const CustomLoading();
        }
        if (state.galleryReels.isEmpty) {
          return Center(
            child: Label(
              text: LocaleKeys.youHaveNoVideosToDisplay.localize,
              style: Styles.mediumText(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        return Column(
          children: [
            // if (state.selectedGalleryReels.isNotEmpty)
            //   Container(
            //     height: 240,
            //     width: double.infinity,
            //     color: Colors.black,
            //     child: state.isVideoInitialized && _controller != null
            //         ? Stack(
            //             alignment: Alignment.center,
            //             children: [
            //               AspectRatio(
            //                 aspectRatio: _controller!.value.aspectRatio,
            //                 child: VideoPlayer(_controller!),
            //               ),
            //               _buildVideoControls(),
            //             ],
            //           )
            //         : const Center(child: CustomCircularProgressIndicator()),
            //   ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Label(
                    text: LocaleKeys.recents.localize,
                    style: Styles.mediumText(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ),
                  const Spacer(),
                  BlocBuilder<CreatePostInstagramCubit,
                      CreatePostInstagramState>(
                    buildWhen: (previous, current) =>
                        previous.multiSelectGalleryReel !=
                        current.multiSelectGalleryReel,
                    builder: (context, state) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          context
                              .read<CreatePostInstagramCubit>()
                              .changeMultiSelectGalleryReel();
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: state.multiSelectGalleryReel
                                  ? AppColors.c6E6E70
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              context.isDarkMode
                                  ? Assets.createPostInstagramMultiImageIconDark
                                  : Assets.createPostInstagramMultiImageIcon,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 123 / 221,
                ),
                itemCount: state.galleryReels
                    .length, // images.length + (state.hasMoreImages ? 1 : 0),
                itemBuilder: (context, index) {
                  return _buildVideoThumbnail(
                    state.galleryReels[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoThumbnail(AssetEntity assets) {
    return GestureDetector(
      onTap: () => context.read<CreatePostInstagramCubit>().onTapGalleryReel(
            itemOfGallery: assets,
          ),
      onLongPress: () {
        context.read<CreatePostInstagramCubit>().onTapGalleryReel(
              itemOfGallery: assets,
            );
        context.read<CreatePostInstagramCubit>().changeMultiSelectGalleryReel();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AssetEntityImage(
            assets,
            width: double.infinity,
            height: double.infinity,
            isOriginal: false,
            // thumbnailSize: const ThumbnailSize(200, 200),
            thumbnailFormat: ThumbnailFormat.jpeg,
            fit: BoxFit.cover,
          ),
          PositionedDirectional(
            bottom: 6,
            end: 5,
            child: Label(
              text:
                  assets.duration == 0 ? "" : _formatDuration(assets.duration),
              style: Styles.smallText(
                fontSize: 24,
                color:
                    context.isDarkMode ? const Color(0xFF0D0D0D) : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // // أيقونة التشغيل
          // Icon(
          //   Icons.play_circle_outline,
          //   color: Colors.white.withOpacity(0.8),
          //   size: 30,
          // ),

          // مؤشر إذا كان هذا الفيديو هو المحدد حاليًا
          if (context
              .read<CreatePostInstagramCubit>()
              .state
              .selectedGalleryReels
              .contains(assets))
            Positioned.fill(
              child: Container(
                // width: double.infinity,
                // height: double.infinity,
                decoration: const BoxDecoration(
                  // border: Border.all(color: AppColors.c161F68, width: 2),
                  // borderRadius: BorderRadius.circular(8),
                  color: Colors.white38,
                ),
              ),
            ),
          if (context
              .read<CreatePostInstagramCubit>()
              .state
              .multiSelectGalleryReel)
            PositionedDirectional(
              top: 6,
              start: 5,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Colors.white12,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    )),
                child: context
                        .read<CreatePostInstagramCubit>()
                        .state
                        .selectedGalleryReels
                        .contains(assets)
                    ? Container(
                        width: 29,
                        height: 29,
                        decoration: const BoxDecoration(
                          color: AppColors.c161F68,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Label(
                          text:
                              '${context.read<CreatePostInstagramCubit>().state.selectedGalleryReels.indexOf(assets) + 1}',
                          style: Styles.smallText(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildVideoControls() {
  //   return GestureDetector(
  //     onTap: () {
  //       if (_controller == null) return;
  //       setState(() {
  //         if (_controller!.value.isPlaying) {
  //           _controller!.pause();
  //         } else {
  //           _controller!.play();
  //         }
  //       });
  //     },
  //     child: Container(
  //       color: Colors.transparent,
  //       child: Center(
  //         child: _controller != null && !_controller!.value.isPlaying
  //             ? const Icon(
  //                 Icons.play_arrow,
  //                 size: 50,
  //                 color: Colors.white70,
  //               )
  //             : Container(),
  //       ),
  //     ),
  //   );
  // }

  String _formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    final int minutes = duration.inMinutes;
    final int remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

// class ImageCard extends StatefulWidget {
//   const ImageCard({super.key, required this.media});
//   final File media;

//   @override
//   State<ImageCard> createState() => _ImageCardState();
// }

// class _ImageCardState extends State<ImageCard> {
//   late VideoP
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
