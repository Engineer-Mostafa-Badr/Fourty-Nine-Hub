import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ShowImageCreatePostInstagramWidget extends StatelessWidget {
  const ShowImageCreatePostInstagramWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) =>
          previous.selectedImage != current.selectedImage,
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: double.infinity,
          height:
              context.read<CreatePostInstagramCubit>().state.selectedImage ==
                      null
                  ? 0
                  : MediaQuery.of(context).size.height * 0.35,
          child: context.read<CreatePostInstagramCubit>().state.selectedImage ==
                  null
              ? const SizedBox()
              : FutureBuilder<File?>(
                  future: state.selectedImage,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: InteractiveViewer(
                              boundaryMargin: const EdgeInsets.all(20),
                              minScale: 1.0, // الحد الأدنى للتكبير
                              maxScale: 4.0, // الحد الأقصى للتكبير
                              scaleEnabled: true, // تمكين التكبير
                              child: Image.file(snapshot.data!,
                                  fit: BoxFit.cover
                                  // fit, // تضمن عرض الصورة بالكامل مع الحفاظ على الأبعاد
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   if (fit == BoxFit.contain) {
                                //     fit = BoxFit.cover;
                                //   } else {
                                //     fit = BoxFit.contain;
                                //   }
                                // });
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
                                  Assets.expandIcon,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "${LocaleKeys.select.localize} ${LocaleKeys.photo.localize}",
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        ),
                      );
                    }
                  },
                ),
        );
      },
    );
  }
}
