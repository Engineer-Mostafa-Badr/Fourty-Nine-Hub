import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/explore_reels_cubit/reel_cubit.dart';
import '../controllers/preload_cubit/preload_bloc.dart';
import '../controllers/preload_cubit/preload_state.dart';
import '../widgets/components/reels_widget.dart';
import '../widgets/components/tiktok_bar.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';

class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    return WillPopScope(
      // << change here
      onWillPop: () async {
        final bloc = context.read<PreloadBloc>();
        bloc.beginExit(); // pause/mute immediately
        await bloc.shutdown(); // clear refs
        return true; // allow pop
      },
      child: const CustomScaffold(
        resizeToAvoidBottomInset: false,
        body: ReelsScreen(),
      ),
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
  bool _didHandleFirstPageChange = false;
  final _pageController = PageController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PreloadBloc>().handleScreenReturn();
    });
    _checkAndReloadIfNeeded();
  }

  void _checkAndReloadIfNeeded() {
    final reelsCubit = context.read<ReelsCubit>();
    final preloadBloc = context.read<PreloadBloc>();

    if (reelsCubit.state.globalReels.isEmpty ||
        preloadBloc.state.urls.isEmpty) {
      reelsCubit.fetchReels();
      preloadBloc.getVideosFromApi();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PreloadBloc, PreloadState>(
      builder: (context, state) {
        if (state.urls.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.SECONDARY_COLOR),
          );
        }

        return Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)),
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.urls.length,
                allowImplicitScrolling: true,
                onPageChanged: (index) {
                  final b = context.read<PreloadBloc>();

                  if (!_didHandleFirstPageChange) {
                    _didHandleFirstPageChange = true;
                    b.onVideoIndexChanged(index);
                    return;
                  }

                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 150), () {
                    if (!mounted) return;
                    b.onVideoIndexChanged(index);
                  });
                },
                itemBuilder: (context, index) {
                  final bool isTailLoading =
                      (state.isLoading && index == state.urls.length - 1);

                  return ReelsWidget(
                    index: index,
                    isLoading: isTailLoading,
                    url: state.urls[index],
                  );
                },
              ),
            ),
            const Positioned(
              top: 57,
              right: 16,
              left: 16,
              child: AdvancedTikTokTabBar(),
            ),
          ],
        );
      },
    );
  }
}
