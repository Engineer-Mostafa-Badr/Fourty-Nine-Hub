

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';

import '../../data/models/new_reels_model.dart';

class ReelsScreenForAudio extends StatefulWidget {
  final List<Reel> reels;
  final int navigateTo;

  const ReelsScreenForAudio({super.key, required this.reels, required this.navigateTo});

  @override
  ReelsScreenForAudioState createState() => ReelsScreenForAudioState();
}

class ReelsScreenForAudioState extends State<ReelsScreenForAudio> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController with the navigateTo index
    _pageController = PageController(initialPage: widget.navigateTo);
    _currentPage = widget.navigateTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (widget.reels.isEmpty) {
            return const Center(
              child: CupertinoActivityIndicator(radius: 25),
            );
          }
          return PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.reels.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              if (index >= widget.reels.length) {
                return const Center(
                  child: CupertinoActivityIndicator(radius: 25),
                );
              }
              return ReelItemForInstagram(
                reel: widget.reels[index],
                isVisible: _currentPage == index,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
