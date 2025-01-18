import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_state.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/reels_widget.dart';

import '../../../../../res/style/app_colors.dart';
import '../controllers/preload_cubit/preload_bloc.dart';
import '../widgets/components/tiktok_bar.dart';

// Entry point of the reels view
class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Scaffold(
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
  Widget build(BuildContext context) {
    return BlocBuilder<PreloadBloc, PreloadState>(
      builder: (context, state) {
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

                      if (controller == null) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.SECONDARY_COLOR,
                        ));
                      }
                      return state.focusedIndex == index
                          ? ReelsWidget(
                              index: index,
                              isLoading: isLoading,
                              controller: controller,
                            )
                          : const SizedBox();
                    },
                  ),
                ),
                const Positioned(
                    top: kToolbarHeight * 0.3,
                    right: 4,
                    left: 4,
                    child: AdvancedTikTokTabBar()),
              ],
            ),
          ],
        );
      },
    );
  }
}
