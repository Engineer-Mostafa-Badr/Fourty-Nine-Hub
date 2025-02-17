import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class BuildMediaCard extends StatelessWidget {
  const BuildMediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        final createPostCubit = context.read<CreatePostCubit>();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: state.images!.length == 1 ? 1 : 2,
            childAspectRatio: state.images!.length == 1 ? 1:1 ,
          ),
          itemCount: state.images!.length < 4 ? state.images!.length : 4,
          itemBuilder: (context, index) => ClickableWidget(
            // Handle image interactions
            onTap: () {
              if (index != 3 || (index == 3 && state.images!.length == 4)) {
                List<XFile> images = state.images!.map((e) => e.file).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: const [],
                      files: images,
                      initialIndex: index,
                    ),
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) => ImageDetailsScreen(
                //     image: state.images![index].file.path,
                //     isFile: true,
                //     onRemoveImage: () {
                //       createPostCubit.removePhoto(state.images![index]);
                //       context.pop();
                //     },
                //   ),
                // );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    List<XFile> images = state.images!.map((e) => e.file).toList();

                    return ShowAllImages(
                    images: state.images??[],
                    onRemoveImage: (UploadFileEntity image) {
                      createPostCubit.removePhoto(image);
                    },
                  );
                  },
                );
              }
            },
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                          end: 10, bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                            File(state.images?[index].file.path ?? ''),
                          ),
                        ),
                      ),
                    ),
                    if (index == 3 && state.images!.length > 4)
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 10, bottom: 10),
                        // padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Label(
                            text: "+${state.images!.length - 4}",
                            style: Styles.headerText(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if(state.images!.length >4?index<3:index<4)
                  PositionedDirectional(
                    end: 15,
                    top: 5,
                    child: ClickableWidget(
                      onTap: () {
                        context
                            .read<CreatePostCubit>()
                            .removePhoto(state.images?[index]);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
