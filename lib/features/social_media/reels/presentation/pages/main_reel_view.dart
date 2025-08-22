import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import '../controllers/preload_cubit/preload_state.dart';
import '../widgets/components/reels_widget.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../controllers/preload_cubit/preload_bloc.dart';
import '../widgets/components/tiktok_bar.dart';
import 'package:flutter/services.dart';

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
        if (context
            .read<PreloadBloc>()
            .state
            .controllers[context.read<PreloadBloc>().state.focusedIndex]!
            .value
            .isPlaying) {
          context
              .read<PreloadBloc>()
              .state
              .controllers[context.read<PreloadBloc>().state.focusedIndex]
              ?.pause();
        }
        context
            .read<PreloadBloc>()
            .resetFocusedIndex(context.read<PreloadBloc>().state.focusedIndex);
        //   context.pop();
        // return Future.value(true);
      },
      canPop: true,
      child: CustomScaffold(
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

class ReelsScreenState extends State<ReelsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return PopScope(
      onPopInvoked: (res) {
        if (context
                .read<PreloadBloc>()
                .state
                .controllers[context.read<PreloadBloc>().state.focusedIndex]
                ?.value
                .isPlaying ??
            false) {
          context
              .read<PreloadBloc>()
              .state
              .controllers[context.read<PreloadBloc>().state.focusedIndex]
              ?.pause();
        }
        context
            .read<PreloadBloc>()
            .resetFocusedIndex(context.read<PreloadBloc>().state.focusedIndex);
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
                  child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
              )),
              Stack(
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      // physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: state.urls.length,
                      onPageChanged: (index) async {
                        context.read<PreloadBloc>().onVideoIndexChanged(index);
                      },
                      itemBuilder: (context, index) {
                        // Is at end and isLoading
                        final bool isLoading =
                            (state.isLoading && index == state.urls.length - 1);
                        final controller = state.controllers[index];
                        final preloadBloc = context.read<PreloadBloc>();

                        if (controller == null) {
                          // If no controller is available, try to initialize it
                          if (index == preloadBloc.state.focusedIndex) {
                            // Only auto-initialize the focused video to avoid performance issues
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              preloadBloc.initializeControllerAtIndex(index);
                            });
                          }

                          // Show loading indicator with better messaging
                          return _buildVideoLoadingWidget(
                              index, preloadBloc.isVideoLoading(index));
                        }

                        return state.focusedIndex == index
                            ? ReelsWidget(
                                index: index,
                                isLoading: isLoading,
                                controller: controller,
                                receiverId: 1,
                              )
                            : const SizedBox();
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
    ));
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
            Text(
              'Swipe to next video',
              style: const TextStyle(
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
