import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class PostBodyCreatePostInstagramGridView extends StatelessWidget {
  const PostBodyCreatePostInstagramGridView({
    super.key,
    required this.galleryPost,
    required this.multiSelect,
    // required this.selectedMeda,
  });

  final List<AssetEntity> galleryPost;
  final bool multiSelect;
  // final List<File> selectedMeda;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      // buildWhen: (previous, current) => false,
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 3,
            mainAxisSpacing: 2,
          ),
          itemCount: galleryPost.length + (state.hasMoreImages ? 1 : 0),
          itemBuilder: (context, index) {
            // إذا وصلنا للعنصر الأخير وهناك المزيد، نعرض مؤشر تحميل ونحمل المزيد
            if (index == state.galleryPost.length && state.hasMoreImages) {
              context
                  .read<CreatePostInstagramCubit>()
                  .loadMoreImages(); // استدعاء دالة تحميل المزيد
              return const Center(child: CustomCircularProgressIndicator());
            }
            if (index < state.galleryPost.length) {
              return GestureDetector(
                onTap: () {
                  context
                      .read<CreatePostInstagramCubit>()
                      .onTapGalleryPost(itemOfGallery: galleryPost[index]);
                },
                child:
                    // true ?
                    Stack(
                  children: [
                    AssetEntityImage(
                      galleryPost[index],
                      isOriginal: false,
                    ),
                    if (state.selectedGalleryPost.contains(galleryPost[index]))
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    if (state.multiSelectGalleryPost)
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
                          child: state.selectedGalleryPost
                                  .contains(galleryPost[index])
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
                                        '${state.selectedGalleryPost.indexOf(galleryPost[index]) + 1}',
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
                //     ImageFromInternet(
                //   image: galleryPost[index].path,
                //   fromFile: true,
                // )
                // :

                //  Container(
                //     alignment: Alignment.topRight,
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //       image: MemoryImage(snapshot.data!),
                //       fit: BoxFit.cover,
                //     )),
                //     child: multiSelect
                //         ? Container(
                //             width: 25,
                //             height: 25,
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: Colors.white.withOpacity(0.4),
                //                 border: Border.all(color: Colors.white)),
                //             child: Center(
                //                 child:
                //                     selectedMeda.contains(images[index])
                //                         ? Text(
                //                             (selectedMeda.indexOf(
                //                                         images[index]) +
                //                                     1)
                //                                 .toString(),
                //                             style: Styles.headerText(
                //                                 color: Colors.white,
                //                                 fontSize: 30),
                //                           )
                //                         : null),
                //           )
                //         : null),
              );
              // return FutureBuilder<File?>(
              //   // future: images[index].originBytes, // تصغير الصور
              //   future: images[index].file,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done &&
              //         snapshot.data != null) {
              //       return GestureDetector(
              //           onTap: () {
              //             context
              //                 .read<CreatePostInstagramCubit>()
              //                 .onTapImage(index);
              //           },
              //           child:
              //               // true ?
              //               ImageFromInternet(
              //             image: snapshot.data!.path,
              //             fromFile: true,
              //           )
              //           // :
              //
              //           //  Container(
              //           //     alignment: Alignment.topRight,
              //           //     padding: const EdgeInsets.all(8),
              //           //     decoration: BoxDecoration(
              //           //         image: DecorationImage(
              //           //       image: MemoryImage(snapshot.data!),
              //           //       fit: BoxFit.cover,
              //           //     )),
              //           //     child: multiSelect
              //           //         ? Container(
              //           //             width: 25,
              //           //             height: 25,
              //           //             decoration: BoxDecoration(
              //           //                 shape: BoxShape.circle,
              //           //                 color: Colors.white.withOpacity(0.4),
              //           //                 border: Border.all(color: Colors.white)),
              //           //             child: Center(
              //           //                 child:
              //           //                     selectedMeda.contains(images[index])
              //           //                         ? Text(
              //           //                             (selectedMeda.indexOf(
              //           //                                         images[index]) +
              //           //                                     1)
              //           //                                 .toString(),
              //           //                             style: Styles.headerText(
              //           //                                 color: Colors.white,
              //           //                                 fontSize: 30),
              //           //                           )
              //           //                         : null),
              //           //           )
              //           //         : null),
              //           );
              //     }
              //     return Container(color: Colors.grey);
              //   },
              // );
            }
            return Container(color: Colors.grey);
          },
        );
      },
    );
  }
}
