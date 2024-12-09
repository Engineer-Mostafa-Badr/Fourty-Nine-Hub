import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/live_card.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_state.dart';

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
    if (_pageController.page! >= (cubit.rooms.length - 1).toDouble() &&
        !cubit.isLoadingMore &&
        cubit.hasMoreData) {
      cubit.getRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<StreamCubit>().loadRoomsData(),
      child: Scaffold(
        body: BlocBuilder<StreamCubit, StreamState>(
          builder: (context, state) {
            final cubit = context.read<StreamCubit>();
            if (cubit.state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return PageView.builder(
              controller: _pageController,
              itemCount: cubit.rooms.length + (cubit.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < cubit.rooms.length) {
                  return LiveCard(live: cubit.rooms[index]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
