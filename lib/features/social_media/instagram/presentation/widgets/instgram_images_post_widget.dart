import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/image_post_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class InstgramImagesPostWidget extends StatefulWidget {
  const InstgramImagesPostWidget({
    super.key,
    // required this.images,
    required this.instagramPostEntity,
  });
  // final List images;
  final InstagramPostEntity instagramPostEntity;

  @override
  State<InstgramImagesPostWidget> createState() =>
      _InstgramImagesPostWidgetState();
}

class _InstgramImagesPostWidgetState extends State<InstgramImagesPostWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.instagramPostEntity.medias.length == 1) {
      return ImagePostWidget(
        // imageUrl: widget.images.first,
        instagramPostEntity: widget.instagramPostEntity,
      );
      // return Container(
      //   height: 400,
      //   decoration: BoxDecoration(
      //       color: Colors.green,
      //       image: DecorationImage(
      //           image: NetworkImage(widget.images.first), fit: BoxFit.cover)),
      // );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 400,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: widget.instagramPostEntity.medias.length,
              itemBuilder: (context, index) {
                return ImagePostWidget(
                  // imageUrl: widget.images[index],
                  instagramPostEntity: widget.instagramPostEntity,
                );

                // return Container(
                //   alignment: Alignment.topRight,
                //   padding: const EdgeInsets.all(8),
                //   height: 400,
                //   color: Colors.red,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Colors.black.withValues(alpha: 0.5),
                //     ),
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                //     child: Text(
                //       "${currentIndex + 1}/${widget.images.length}",
                //       style: Styles.mediumText(
                //           color: Colors.white, fontWeight: FontWeight.w400),
                //     ),
                //   ),
                // );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                widget.instagramPostEntity.medias.length,
                (index) {
                  return AnimatedContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    duration: const Duration(milliseconds: 300),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index
                          ? AppColors.PRIMARY_COLOR
                          : Colors.grey,
                    ),
                  );
                },
              )
            ],
          )
        ],
      );
    }
  }
}
