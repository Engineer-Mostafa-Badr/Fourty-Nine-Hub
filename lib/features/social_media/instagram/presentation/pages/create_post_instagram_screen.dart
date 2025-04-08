import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/custom_error.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/app_bar_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/floating_action_button_create_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_body_create_post_instagram.dart';

class CreatePostInstagramScreen extends StatelessWidget {
  const CreatePostInstagramScreen({super.key});

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
    //   return const Center(child: CircularProgressIndicator());
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
                state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
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
                      postType: context
                          .read<CreatePostInstagramCubit>()
                          .postTypes[state.postTypeSelectedIndex],
                      onPressed: () {
                        if (state.postTypeSelectedIndex == 0) {
                          bool isEmpty = context
                              .read<CreatePostInstagramCubit>()
                              .state
                              .selectedImages
                              .isEmpty;
                          bool isEmpty2 = state.selectedImages.isEmpty;
                          if (isEmpty) {
                            showErrorMessage(
                              context,
                              LocaleKeys.youMustSelectAtLeastOneImage.localize,
                            );
                          } else {
                            context
                                .read<CreatePostInstagramCubit>()
                                .nextPage(context);
                          }
                        } else if (state.postTypeSelectedIndex == 2) {
                          if (true) {
                            showErrorMessage(
                              context,
                              LocaleKeys.youMustSelectAtLeastOneVideo.localize,
                            );
                          } else {}
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
                    if (state.postTypeSelectedIndex == 1)
                      const Expanded(child: Placeholder()),
                    if (state.postTypeSelectedIndex == 2)
                      const Expanded(child: Placeholder()),
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
