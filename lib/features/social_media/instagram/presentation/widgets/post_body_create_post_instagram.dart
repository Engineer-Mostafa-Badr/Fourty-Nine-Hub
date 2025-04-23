import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_body_create_post_instagram_grid_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/show_image_create_post_instagram_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PostBodyCreatePostInstagram extends StatelessWidget {
  const PostBodyCreatePostInstagram({
    super.key,
    // required this.selectedImage,
    // required this.images,
  });

  // final Future<File?>? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (selectedImage == null)
        const ShowImageCreatePostInstagramWidget(),
        // else
        // FutureBuilder<File?>(
        //   future: selectedImage,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Stack(
        //         children: [
        //           SizedBox(
        //             width: double.infinity,
        //             height: MediaQuery.of(context).size.height * 0.45,
        //             child: InteractiveViewer(
        //               boundaryMargin: const EdgeInsets.all(20),
        //               minScale: 1.0, // الحد الأدنى للتكبير
        //               maxScale: 4.0, // الحد الأقصى للتكبير
        //               scaleEnabled: true, // تمكين التكبير
        //               child: Image.file(
        //                 snapshot.data!,
        //                 fit:
        //                     fit, // تضمن عرض الصورة بالكامل مع الحفاظ على الأبعاد
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 0,
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   if (fit == BoxFit.contain) {
        //                     fit = BoxFit.cover;
        //                   } else {
        //                     fit = BoxFit.contain;
        //                   }
        //                 });
        //               },
        //               child: Container(
        //                 width: 35,
        //                 height: 35,
        //                 margin: const EdgeInsets.all(10),
        //                 decoration: const BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     color: AppColors.PRIMARY_COLOR),
        //                 child: const Icon(
        //                   Icons.expand,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //           )
        //         ],
        //       );
        //     } else {
        //       return Center(
        //         child: Text(
        //           "Select Image",
        //           style: Styles.headerText(fontWeight: FontWeight.w400),
        //         ),
        //       );
        //     }
        //   },
        // ),
        Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Label(
                text: LocaleKeys.recents.localize,
                style: Styles.headerText(),
              ),
              const SizedBox(
                width: 6,
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.read<CreatePostInstagramCubit>().changeMultiSelect();
                },
                child: BlocBuilder<CreatePostInstagramCubit,
                    CreatePostInstagramState>(
                  buildWhen: (previous, current) {
                    return previous.multiSelect != current.multiSelect;
                  },
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   color: state.multiSelect
                      //       ? Colors.white
                      //       : AppColors.PRIMARY_COLOR,
                      // ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.my_library_add_outlined,
                            size: 11,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Label(
                            text: LocaleKeys.selectMultiple.localize,
                            style: Styles.smallText(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () async {
                  context.read<CreatePostInstagramCubit>().pickImage();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xff5F6368),
                      size: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: PostBodyCreatePostInstagramGridView(
            images: context.read<CreatePostInstagramCubit>().state.images,
            multiSelect:
                context.read<CreatePostInstagramCubit>().state.multiSelect,
            selectedMeda:
                context.read<CreatePostInstagramCubit>().state.selectedMeda,
            onTap: (index) {
              context.read<CreatePostInstagramCubit>().onTapImage(index);
            },
          ),
        ),
      ],
    );
  }
}
