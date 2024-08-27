import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/CarouselSlider.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';

class ImagesProfileForRestaurant extends StatefulWidget {
  const ImagesProfileForRestaurant({
    super.key,
    this.restaurantMedia,
    this.heightCarousel,
    this.widthForImages,
  });
  final List<RestaurantMediaModel>? restaurantMedia;
  final double? heightCarousel;
  final double? widthForImages;
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
                      radius: 5,
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
                color: index == currentIndex ? Colors.black87 : Colors.black26,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
