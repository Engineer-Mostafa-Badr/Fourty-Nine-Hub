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
        // pause safely (no direct map indexing)
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
  /// we skip the first onPageChanged callback so initial reel can auto-play
  bool _didHandleFirstPageChange = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Ensure controllers are fresh & first items are initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PreloadBloc>().handleScreenReturn();
    });

    _checkAndReloadIfNeeded();
  }

  void _checkAndReloadIfNeeded() {
    final reelsCubit = context.read<ReelsCubit>();
    final preloadBloc = context.read<PreloadBloc>();

    // If no reels data or no URLs, reload
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
            return _buildCustomLoading();
          }

          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              Positioned.fill(
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.urls.length,
                  onPageChanged: (index) {
                    final b = context.read<PreloadBloc>();

                    // Skip the very first call at startup (keep the initial reel playing)
                    if (!_didHandleFirstPageChange) {
                      _didHandleFirstPageChange = true;
                      // still update focus so state stays consistent
                      b.onVideoIndexChanged(index);
                      return;
                    }

                    // Pause neighbors FIRST, then update index (frees codec)
                    b.forcePauseAround(index);
                    b.onVideoIndexChanged(index);
                  },
                  itemBuilder: (context, index) {
                    final b = context.read<PreloadBloc>();
                    final controller = state.controllers[index];

                    // show loader at the very end while urls still loading
                    final bool isTailLoading =
                        (state.isLoading && index == state.urls.length - 1);

                    // If no controller yet…
                    if (controller == null) {
                      // …and this item is focused, initialize it (preferNetwork for faster first frame)
                      if (index == state.focusedIndex) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // preferNetwork speeds up first play vs waiting for cache
                          b.initializeControllerAtIndex(index,
                              preferNetwork: true);
                        });
                      }

                      return _buildVideoLoadingWidget(
                        index,
                        b.isVideoLoading(index) || isTailLoading,
                      );
                    }

                    // Only render the focused page’s video to keep resource usage low
                    if (state.focusedIndex == index) {
                      return ReelsWidget(
                        index: index,
                        isLoading: isTailLoading,
                        controller: controller,
                        receiverId: 1,
                      );
                    } else {
                      // Keep offscreen items lightweight
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // Top bar
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

  Widget _buildCustomLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.SECONDARY_COLOR,
      ),
    );
  }

  Widget _buildVideoLoadingWidget(int index, bool isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const CircularProgressIndicator(
              color: AppColors.SECONDARY_COLOR,
            )
          else
            const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 48,
            ),
          const SizedBox(height: 16),
          Text(
            isLoading ? 'Loading video...' : 'Video failed to load',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          if (!isLoading) ...[
            const SizedBox(height: 8),
            const Text(
              'Swipe to next video',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
