import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:photo_manager/photo_manager.dart';

class PostBodyCreatePostInstagramGridView extends StatelessWidget {
  const PostBodyCreatePostInstagramGridView({
    super.key,
    required this.onTap,
    required this.images,
    required this.multiSelect,
    required this.selectedMeda,
  });

  final void Function(int)? onTap;
  final List<AssetEntity> images;
  final bool multiSelect;
  final List<AssetEntity> selectedMeda;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 3,
            mainAxisSpacing: 2,
          ),
          itemCount: images.length + (state.hasMoreImages ? 1 : 0),
          itemBuilder: (context, index) {
            // إذا وصلنا للعنصر الأخير وهناك المزيد، نعرض مؤشر تحميل ونحمل المزيد
            if (index == state.images.length && state.hasMoreImages) {
              context
                  .read<CreatePostInstagramCubit>()
                  .loadMoreImages(); // استدعاء دالة تحميل المزيد
              return const Center(child: CircularProgressIndicator());
            }
            if (index < state.images.length) {
              return FutureBuilder<File?>(
                // future: images[index].originBytes, // تصغير الصور
                future: images[index].file,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return GestureDetector(
                        onTap: () {
                          context
                              .read<CreatePostInstagramCubit>()
                              .onTapImage(index);
                        },
                        child:
                            // true ?
                            ImageFromInternet(
                          image: snapshot.data!.path,
                          fromFile: true,
                        )
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
                  }
                  return Container(color: Colors.grey);
                },
              );
            }
          },
        );
      },
    );
  }
}
