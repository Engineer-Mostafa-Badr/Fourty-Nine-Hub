import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ShowImageCreatePostInstagramWidget extends StatelessWidget {
  const ShowImageCreatePostInstagramWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) =>
          previous.selectedGalleryPost != current.selectedGalleryPost ||
          previous.isImageCover != current.isImageCover,
      builder: (context, state) {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            height: state.selectedGalleryPost.isEmpty
                ? 0
                : MediaQuery.of(context).size.height * 0.35,
            child: state.selectedGalleryPost.isEmpty
                ? const SizedBox()
                : Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 1.0, // الحد الأدنى للتكبير
                          maxScale: 6.0, // الحد الأقصى للتكبير
                          scaleEnabled: true, // تمكين التكبير
                          child: AssetEntityImage(
                            state.selectedGalleryPost.last,
                            fit: state.isImageCover
                                ? BoxFit.cover
                                : BoxFit.contain,
                          ),
                          // child: Image.file(state.selectedGalleryPost.last, fit: BoxFit.cover
                          //     // fit, // تضمن عرض الصورة بالكامل مع الحفاظ على الأبعاد
                          //     ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<CreatePostInstagramCubit>()
                                .changeCoverImage();
                          },
                          child: Container(
                            width: 37,
                            height: 37,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(3),
                            decoration: const ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: OvalBorder(),
                            ),
                            child: SvgPicture.asset(
                              state.isImageCover
                                  ? Assets.narrowIcon
                                  : Assets.expandIcon,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
            // : FutureBuilder<File?>(
            //     future: state.selectedImages.last,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Stack(
            //           children: [
            //             SizedBox(
            //               width: double.infinity,
            //               height: MediaQuery.of(context).size.height * 0.45,
            //               child: InteractiveViewer(
            //                 boundaryMargin: const EdgeInsets.all(20),
            //                 minScale: 1.0, // الحد الأدنى للتكبير
            //                 maxScale: 4.0, // الحد الأقصى للتكبير
            //                 scaleEnabled: true, // تمكين التكبير
            //                 child: Image.file(snapshot.data!,
            //                     fit: BoxFit.cover
            //                     // fit, // تضمن عرض الصورة بالكامل مع الحفاظ على الأبعاد
            //                     ),
            //               ),
            //             ),
            //             Positioned(
            //               bottom: 0,
            //               child: GestureDetector(
            //                 onTap: () {
            //                   // setState(() {
            //                   //   if (fit == BoxFit.contain) {
            //                   //     fit = BoxFit.cover;
            //                   //   } else {
            //                   //     fit = BoxFit.contain;
            //                   //   }
            //                   // });
            //                 },
            //                 child: Container(
            //                   width: 37,
            //                   height: 37,
            //                   margin: const EdgeInsets.all(10),
            //                   padding: const EdgeInsets.all(3),
            //                   decoration: const ShapeDecoration(
            //                     color: Color(0xFFD9D9D9),
            //                     shape: OvalBorder(),
            //                   ),
            //                   child: SvgPicture.asset(
            //                     Assets.expandIcon,
            //                   ),
            //                 ),
            //               ),
            //             )
            //           ],
            //         );
            //       } else {
            //         return Center(
            //           child: Text(
            //             "${LocaleKeys.select.localize} ${LocaleKeys.photo.localize}",
            //             style: Styles.headerText(fontWeight: FontWeight.w400),
            //           ),
            //         );
            //       }
            //     },
            //   ),
            );
      },
    );
  }
}
