import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_events.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_state.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/reels_widget.dart';

import '../controllers/preload_cubit/preload_bloc.dart';
import '../widgets/components/tiktok_bar.dart';
import '../widgets/components/unified_widget_view.dart';

// Entry point of the reels view
class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: ReelsScreen(),
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
      // bloc: BlocProvider.of<PreloadBloc>(context)..add(GetVideosFromApiEvent()),
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: state.urls.length,
                onPageChanged: (index) =>
                    context.read<PreloadBloc>().add(OnVideoIndexChanged(index)),
                itemBuilder: (context, index) {
                  // Is at end and isLoading
                  final bool _isLoading =
                      (state.isLoading && index == state.urls.length - 1);
                  final controller = state.controllers[index];

                  if (controller == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return state.focusedIndex == index
                      ? ReelsWidget(
                          isLoading: _isLoading,
                          controller: controller,
                        )
                      : const SizedBox();
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

}
