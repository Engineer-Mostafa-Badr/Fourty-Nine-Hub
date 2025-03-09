import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../widgets/youtube_video_card.dart';

class YouTubeView extends StatefulWidget {
  const YouTubeView({super.key});

  @override
  State<YouTubeView> createState() => _YouTubeViewState();
}

class _YouTubeViewState extends State<YouTubeView> {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    scrollController;
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: BottomNavigator(
        scrollController: scrollController,
        isScrollingDown: _isScrollingDown,
        mainCategory: 2,
        index: 2,
      ),
      floatingActionButton: _isScrollingDown
          ? null
          : const FloatingButton(
              changeView: 0,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildVideosList(scrollController),
    );
  }

  Widget _buildVideosList(ScrollController scrollController) {
    return ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) => const YoutubeVideoCard(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 8);
  }
}
