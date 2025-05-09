import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/image_post_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../helpers/media_helper.dart';
import 'header_post_instagram.dart';

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
        currentIndex: 0,
        instagramPostEntity: widget.instagramPostEntity,
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 450,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: widget.instagramPostEntity.medias.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if ((MediaHelper.getMediaTypeFromExtension(
                        widget.instagramPostEntity.medias[index])) !=
                        MediaType.video)
                      HeaderPostInstagram(
                        imageUrl: widget.instagramPostEntity.profilePictureUrl ?? '',
                        userName: '${widget.instagramPostEntity.firstName} ${widget.instagramPostEntity.lastName}',
                        userTags: widget.instagramPostEntity.userTags,
                        isReel: (MediaHelper.getMediaTypeFromExtension(
                            widget.instagramPostEntity.medias[index])) ==
                            MediaType.video,
                        country: widget.instagramPostEntity.locationName,
                        userId: widget.instagramPostEntity.userId,
                        postId: widget.instagramPostEntity.id,
                        isFollow: widget.instagramPostEntity.isFollow,
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    ImagePostWidget(
                      currentIndex: index,
                      instagramPostEntity: widget.instagramPostEntity,
                    ),
                  ],
                );
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
                          ? (context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR)
                          : (context.isDarkMode
                              ? const Color(0x26FFFFFF)
                              : Colors.grey),
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
