import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/live_card.dart';
import '../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

class VideoStreamTabBar extends StatefulWidget {
  const VideoStreamTabBar({super.key});

  @override
  State<VideoStreamTabBar> createState() => _VideoStreamTabBarState();
}

class _VideoStreamTabBarState extends State<VideoStreamTabBar> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_onPageScroll);
    context.read<StreamCubit>().loadRoomsData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    final cubit = context.read<StreamCubit>();

    // Trigger pagination when reaching the last loaded page
    if (_pageController.position.pixels >=
            _pageController.position.maxScrollExtent - 100 &&
        !cubit.isLoadingMore &&
        cubit.hasMoreData) {
      cubit.getRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StreamCubit, StreamState>(
        builder: (context, state) {
          final cubit = context.read<StreamCubit>();
          if (cubit.state.isLoading) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          return PageView.builder(
            controller: _pageController,
            // scrollDirection: Axis.vertical, // Vertical scrolling
            onPageChanged: (i) {},
            itemCount: cubit.rooms.length + (cubit.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < cubit.rooms.length) {
                return LiveCard(live: cubit.rooms[index]);
              } else {
                // Show loading indicator on the last extra page
                return const Center(child: CustomCircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
