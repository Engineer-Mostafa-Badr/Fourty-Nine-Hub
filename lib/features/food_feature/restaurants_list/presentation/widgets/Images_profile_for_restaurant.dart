import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';

import '../../../../../res/style/app_colors.dart';
import '../../domain/entities/restaurant.dart';

class ImagesProfileForRestaurant extends StatefulWidget {
  const ImagesProfileForRestaurant({
    super.key,
    this.restaurantMedia,
    this.heightCarousel,
    this.widthForImages,
    this.autoPlay,
  });
  final List<RestaurantMediaEntity>? restaurantMedia;
  final double? heightCarousel;
  final double? widthForImages;
  final bool? autoPlay;
  @override
  State<ImagesProfileForRestaurant> createState() =>
      _ImagesProfileForRestaurantState();
}

class _ImagesProfileForRestaurantState
    extends State<ImagesProfileForRestaurant> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSliderWidget(
          autoPlay: widget.autoPlay ?? false,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          height: widget.heightCarousel ?? 200,
          widgets: widget.restaurantMedia
                  ?.map(
                    (e) => SquareImage(
                      fit: BoxFit.cover,
                      width: widget.widthForImages ?? 100,
                      radius: 0,
                      url: e.mediaKey,
                    ),
                  )
                  .toList() ??
              [],
        ),
        Positioned(
          bottom: 20,
          child: Row(
            children: List.generate(
              widget.restaurantMedia?.length ?? 0,
              (index) => Icon(
                Icons.circle,
                color: index == currentIndex
                    ? AppColors.BG_GRAY_COLOR
                    : AppColors.LIGHT_GRAY_COLOR2,
                size: index == currentIndex ? 19 : 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
