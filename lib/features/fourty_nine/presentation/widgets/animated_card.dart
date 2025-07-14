import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCards extends StatefulWidget {
  final List<Widget> cardsList;

  const AnimatedCards({super.key, required this.cardsList});

  @override
  State<AnimatedCards> createState() => _AnimatedCardsState();
}

class _AnimatedCardsState extends State<AnimatedCards> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      if (_controller.hasClients && widget.cardsList.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.cardsList.length;
        _controller.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: widget.cardsList.length,
        itemBuilder: (context, index) {
          return widget.cardsList[index];
        },
      ),
    );
  }
}



class AnimatedCardsListView extends StatefulWidget {
  final List<Widget> cardsList;
  final Function(ScrollController) setupScrollController;

  const AnimatedCardsListView({super.key, required this.cardsList,required this.setupScrollController});

  @override
  State<AnimatedCardsListView> createState() => _AnimatedCardsListViewState();
}

class _AnimatedCardsListViewState extends State<AnimatedCardsListView> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    widget.setupScrollController(_scrollController);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_scrollController.hasClients || widget.cardsList.isEmpty) return;

      // Scroll by a fixed amount (e.g., one card height)
      _scrollOffset += 150; // adjust based on card height

      if (_scrollOffset >= _scrollController.position.maxScrollExtent) {
        // Reset to top smoothly
        _scrollOffset = 0;
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.animateTo(
          _scrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }



  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3, // or any fixed height
      child: ListView.separated(
        separatorBuilder: (context,i)=>SizedBox(height: 8.h,),
        controller: _scrollController,
        // physics:const NeverScrollableScrollPhysics(),
        itemCount: widget.cardsList.length,
        itemBuilder: (context, index) {
          return widget.cardsList[index];
        },
      ),
    );
  }
}
