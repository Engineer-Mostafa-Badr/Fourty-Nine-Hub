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

// Entry point of the reels view
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

    return PopScope(
      onPopInvoked: (res) {
        final b = context.read<PreloadBloc>();
        b.pauseCurrent();
        b.resetFocusedIndex(b.state.focusedIndex);
      },
      canPop: true,
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

  // Page controller + debounce to handle flings
  final _pageController = PageController();
  Timer? _pageChangeDebounce;

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

  @override
  void dispose() {
    _pageChangeDebounce?.cancel();
    _pageController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      onPopInvoked: (res) {
        final b = context.read<PreloadBloc>();
        b.pauseCurrent();
        b.resetFocusedIndex(b.state.focusedIndex);
      },
      canPop: true,
      child: BlocBuilder<PreloadBloc, PreloadState>(
        builder: (context, state) {
          if (state.urls.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.SECONDARY_COLOR,
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.black)),

              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  allowImplicitScrolling: true,
                  scrollDirection: Axis.vertical,
                  itemCount: state.urls.length,
                  onPageChanged: (index) {
                    final b = context.read<PreloadBloc>();

                    if (!_didHandleFirstPageChange) {
                      _didHandleFirstPageChange = true;
                      b.onVideoIndexChanged(index);
                      return;
                    }

                    // debounce rapid flings
                    _pageChangeDebounce?.cancel();
                    _pageChangeDebounce =
                        Timer(const Duration(milliseconds: 100), () {
                      b.onVideoIndexChanged(index);
                    });
                  },
                  itemBuilder: (context, index) {
                    final b = context.read<PreloadBloc>();
                    final controller = state.controllers[index];

                    final bool isTailLoading =
                        (state.isLoading && index == state.urls.length - 1);

                    if (controller == null) {
                      if (index == state.focusedIndex) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          b.prioritizedFocusInit(index); // focus-first
                        });
                      }
                      return _buildVideoLoadingWidget(
                        index,
                        b.isVideoLoading(index) || isTailLoading,
                      );
                    }

                    if (state.focusedIndex == index) {
                      return ReelsWidget(
                        index: index,
                        isLoading: isTailLoading,
                        controller: controller,
                        receiverId: 1,
                      );
                    } else {
                      return const SizedBox();
                    }
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
      ),
    );
  }

  Widget _buildVideoLoadingWidget(int index, bool isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const CircularProgressIndicator(color: AppColors.SECONDARY_COLOR)
          else
            const Icon(Icons.error_outline, color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          Text(
            isLoading ? 'Loading video...' : 'Video failed to load',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          if (!isLoading) ...[
            const SizedBox(height: 8),
            const Text(
              'Swipe to next video',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
