import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'post_body_create_post_instagram_grid_view.dart';
import 'show_image_create_post_instagram_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
                  context
                      .read<CreatePostInstagramCubit>()
                      .changeMultiSelectGalleryPost();
                },
                child: BlocBuilder<CreatePostInstagramCubit,
                    CreatePostInstagramState>(
                  buildWhen: (previous, current) {
                    return previous.multiSelectGalleryPost !=
                        current.multiSelectGalleryPost;
                  },
                  builder: (context, state) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: ShapeDecoration(
                        color: state.multiSelectGalleryPost
                            ? (AppColors.c0B1035)
                            : (context.isDarkMode
                                ? const Color(0xFF333333)
                                : const Color(0xFFD9D9D9)),
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
                          Icon(
                            Icons.my_library_add_outlined,
                            size: 11,
                            color: state.multiSelectGalleryPost
                                ? Colors.white
                                : (context.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Label(
                            text: LocaleKeys.selectMultiple.localize,
                            style: Styles.smallText(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: state.multiSelectGalleryPost
                                  ? Colors.white
                                  : (context.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
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
      ManageVibration.vibrate();
                  context.read<CreatePostInstagramCubit>().pickImage();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: ShapeDecoration(
                    color: context.isDarkMode
                        ? const Color(0xFF333333)
                        : const Color(0xFFD9D9D9),
                    shape: const OvalBorder(),
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
          child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
            builder: (context, state) {
              return PostBodyCreatePostInstagramGridView(
                galleryPost:
                    context.read<CreatePostInstagramCubit>().state.galleryPost,
                multiSelect: context
                    .read<CreatePostInstagramCubit>()
                    .state
                    .multiSelectGalleryPost,
                // selectedMeda:
                //     context.read<CreatePostInstagramCubit>().state.selectedMeda,
              );
            }
          ),
        ),
      ],
    );
  }
}