import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<Widget> widgets;
  final double height;
  final bool autoPlay;
  const CarouselSliderWidget({
    super.key,
    required this.widgets,
    this.height = 400,
    this.autoPlay = false
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: height, autoPlay: autoPlay),
      items: widgets.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return i;
          },
        );
      }).toList(),
    );
  }
}
