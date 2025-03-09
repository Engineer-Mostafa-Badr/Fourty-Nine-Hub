import 'dart:async';

import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<Widget> widgets;
  final double height;
  final bool autoPlay;
  final ValueChanged<int>? onPageChanged;
  final Duration autoPlayInterval;

  const CarouselSliderWidget({
    super.key,
    this.onPageChanged,
    required this.widgets,
    this.height = 400,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final PageController _pageController = PageController();
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      _currentPage++;
      if (_currentPage >= widget.widgets.length) {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        onPageChanged: widget.onPageChanged,
        controller: _pageController,
        itemCount: widget.widgets.length,
        itemBuilder: (context, index) {
          return widget.widgets[index];
        },
      ),
    );
  }
}
