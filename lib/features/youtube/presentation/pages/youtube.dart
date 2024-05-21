import 'package:flutter/material.dart';
import '../../../../common/widgets/dynamic/sizer.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../widgets/youtube_video_card.dart';

class YouTubeView extends StatelessWidget {
  const YouTubeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 2,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(
        changeView: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildVideosList(),
    );
  }

  Widget _buildVideosList() {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => const YoutubeVideoCard(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 8);
  }
}
