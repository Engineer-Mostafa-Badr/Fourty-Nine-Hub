import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../core/widget/common/dots_widget.dart';
import '../../../../../core/widget/common/favorite_icon.dart';

import '../../domain/entities/restaurant.dart';

class ImagesProfileForRestaurant extends StatefulWidget {
  const ImagesProfileForRestaurant({
    super.key,
    this.restaurantMedia,
    this.heightCarousel,
    this.widthForImages,
    this.autoPlay,
    this.isFavorite,
    this.onFavoritePressed,
    this.isMyRestaurant,
    this.isVerified,
  });
  final List<RestaurantMediaEntity>? restaurantMedia;
  final double? heightCarousel;
  final double? widthForImages;
  final bool? autoPlay;
  final bool? isFavorite;
  final VoidCallback? onFavoritePressed;
  final bool? isMyRestaurant;
  final bool? isVerified;

  @override
  State<ImagesProfileForRestaurant> createState() =>
      _ImagesProfileForRestaurantState();
}

class _ImagesProfileForRestaurantState
    extends State<ImagesProfileForRestaurant> {
  int currentIndex = 0;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite ?? false;
  }

  @override
  void didUpdateWidget(ImagesProfileForRestaurant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      isFavorite = widget.isFavorite ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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

            // Favorite Icon
            if (widget.onFavoritePressed != null &&
                widget.isMyRestaurant != true)
              PositionedDirectional(
                end: 16,
                top: 16,
                child: FavoriteIcon(
                  isFavourite: isFavorite,
                  onPressedFavorite: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    widget.onFavoritePressed!();
                  },
                ),
              ),
          ],
        ),
        // Dots Indicator
        if ((widget.restaurantMedia?.length ?? 0) > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DotsWidget(
              length: widget.restaurantMedia?.length ?? 0,
              currentIndex: currentIndex,
            ),
          ),
      ],
    );
  }
}
