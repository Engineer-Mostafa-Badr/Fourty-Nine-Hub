import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/components/tiktok_bar.dart';
import '../widgets/components/unified_widget_view.dart';

// Entry point of the reels view
class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: ReelsScreen(),
    );
  }
}


class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchInitialReels();
  }

  // Fetch the initial set of reels
  void _fetchInitialReels() {
    if (mounted) {
      context.read<ReelsCubit>().fetchReels();
    }
  }

  // Handles the page change to update the current page and fetch more reels if necessary
  void _handlePageChange(int index) {
    final reelsCubit = context.read<ReelsCubit>();
    // if (index + 1 < reelsCubit.state.globalReels!.length) {
    //   for (int i = 0; i < 5; i++) {
    //     pr('reel url index inside for $i');
    //     VideoPlayerController.networkUrl(
    //             reelsCubit.state.globalReels![index + i].videoMedia.toUri)
    //         .initialize()
    //         .then((value) => pr(
    //             'intialized successfully ${reelsCubit.state.globalReels![index + i].videoMedia.toUri}'))
    //         .catchError((e) => pr(
    //             'error happened ${reelsCubit.state.globalReels![index + i].videoMedia.toUri}'));
    //   }
    // }
    setState(() {
      _currentPage = index;
    });
    if (index == (reelsCubit.state.globalReels?.length ?? 0) - 1 && mounted) {
      reelsCubit.fetchReels();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Required to keep the widget alive between page changes
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: (state.globalReels?.length ?? 0) +
                    ((state.globalReelsHasReachedMax ?? false) ? 0 : 1),
                onPageChanged: _handlePageChange,
                itemBuilder: (context, index) {
                  if (index >= (state.globalReels?.length ?? 0)) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        radius: 25,
                        color: Colors.red,
                      ),
                    );
                  }
                  return UnifiedReelItem(
                    reel: state.globalReels![index],
                    isVisible: _currentPage == index,
                    index:index,
                    itemType: ReelItemType.main,
                  );
                },
              ),
            ),
            const Positioned(
                top: kToolbarHeight * 0.5,
                right: 4,
                left: 4,
                child: AdvancedTikTokTabBar()),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
