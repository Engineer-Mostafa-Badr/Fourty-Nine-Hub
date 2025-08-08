import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../domain/entities/instagram_post_entity.dart';
import 'image_post_widget.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../core/widget/SmoothIndicator/scrollig_dots_effect.dart';
import '../../../../../core/widget/SmoothIndicator/smooth_page_indicator.dart';
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
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    if (widget.instagramPostEntity.medias.length == 1) {
      return Column(
        children: [
          if (MediaHelper.getMediaTypeFromExtension(
                  widget.instagramPostEntity.medias[0]) !=
              MediaType.video)
            HeaderPostInstagram(
              imageUrl: widget.instagramPostEntity.profilePictureUrl ?? '',
              userName:
                  '${widget.instagramPostEntity.firstName} ${widget.instagramPostEntity.lastName}',
              userTags: widget.instagramPostEntity.userTags,
              isReel: MediaHelper.getMediaTypeFromExtension(
                      widget.instagramPostEntity.medias[0]) ==
                  MediaType.video,
              country: widget.instagramPostEntity.locationName,
              userId: widget.instagramPostEntity.userId,
              postId: widget.instagramPostEntity.id,
              isFollow: widget.instagramPostEntity.isFollow,
            ),
          ImagePostWidget(
            // imageUrl: widget.images.first,
            currentIndex: 0,
            instagramPostEntity: widget.instagramPostEntity,
          ),
        ],
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
                print(MediaHelper.getMediaTypeFromExtension(
                    widget.instagramPostEntity.medias[index]));
                return Column(
                  children: [
                    if (MediaHelper.getMediaTypeFromExtension(
                            widget.instagramPostEntity.medias[index]) !=
                        MediaType.video)
                      HeaderPostInstagram(
                        imageUrl:
                            widget.instagramPostEntity.profilePictureUrl ?? '',
                        userName:
                            '${widget.instagramPostEntity.firstName} ${widget.instagramPostEntity.lastName}',
                        userTags: widget.instagramPostEntity.userTags,
                        isReel: MediaHelper.getMediaTypeFromExtension(
                                widget.instagramPostEntity.medias[index]) ==
                            MediaType.video,
                        country: widget.instagramPostEntity.locationName,
                        userId: widget.instagramPostEntity.userId,
                        postId: widget.instagramPostEntity.id,
                        isFollow: widget.instagramPostEntity.isFollow,
                      ),
                    const SizedBox(height: 5),
                    ImagePostWidget(
                      currentIndex: index,
                      instagramPostEntity: widget.instagramPostEntity,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: widget.instagramPostEntity.medias.length,
            effect: ScrollingDotsEffect(
              activeStrokeWidth: 2.6,
              activeDotScale: 1.3,
              maxVisibleDots: 7,
              radius: 8,
              spacing: 5,
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
              dotColor:
                  context.isDarkMode ? const Color(0x26FFFFFF) : Colors.grey,
            ),
          ),
        ],
      );
    }
  }
}
