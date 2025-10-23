import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/tube/presentation/screens/tube_video_player_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_mini_player.dart';

// ==================== TUBE SCREEN WITH TABS ====================
class TubeScreen extends StatefulWidget {
  const TubeScreen({super.key});

  @override
  State<TubeScreen> createState() => _TubeScreenState();
}

class _TubeScreenState extends State<TubeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<TubeCubit>(),
      child: BlocBuilder<TubeCubit, TubeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('Tube', style: TextStyle(color: Colors.white)),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Subscribed'),
                  Tab(text: 'Favorites'),
                ],
              ),
            ),
            body: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: const [
                    AllVideosTab(),
                    SubscribedTab(),
                    FavoritesTab(),
                  ],
                ),
                if (state.isMinimized &&
                    state.currentVideo != null &&
                    !state.isLoading)
                  const MiniPlayer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==================== ALL VIDEOS TAB ====================
class AllVideosTab extends StatefulWidget {
  const AllVideosTab({super.key});

  @override
  State<AllVideosTab> createState() => _AllVideosTabState();
}

class _AllVideosTabState extends State<AllVideosTab> {
  late final ScrollController _scrollController;
  late final TubeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TubeCubit>();
    _scrollController = ScrollController();
    _cubit.loadInitialAllTubeVideos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cubit.getAllTubeVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        if (_cubit.isTubeVideosInitialLoading &&
            state.status == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final videos = _cubit.allTubeVideos;

        if (videos.isEmpty) {
          return const Center(
              child: Text('No videos yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16)));
        }

        return RefreshIndicator(
          color: Colors.red,
          backgroundColor: Colors.black,
          onRefresh: _cubit.loadInitialAllTubeVideos,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: videos.length + (_cubit.hasMoreTubeVideos ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= videos.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                );
              }
              final video = videos[index];
              return GestureDetector(
                onTap: () => _cubit.playVideo(video),
                child: _VideoCard(video: video),
              );
            },
          ),
        );
      },
    );
  }
}

class SubscribedTab extends StatefulWidget {
  const SubscribedTab({super.key});

  @override
  State<SubscribedTab> createState() => _SubscribedTabState();
}

class _SubscribedTabState extends State<SubscribedTab> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // TODO: implement your own pagination method for subscribed videos
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Subscribed videos',
            style: TextStyle(color: Colors.white70, fontSize: 16)));
  }
}

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // TODO: implement your own pagination method for favorite videos
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Favorite videos',
            style: TextStyle(color: Colors.white70, fontSize: 16)));
  }
}




class _VideoCard extends StatelessWidget {
  final GetAllTubeVideosEntity video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<TubeCubit>();
        cubit.playVideo(video);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit, // ✅ use the existing cubit instance
              child: VideoPlayerPage(video: video),
            ),
          ),
        );
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              video.thumbnail ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade800,
                child: const Center(
                    child: Icon(Icons.videocam_off, color: Colors.white70)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage:
                        NetworkImage(video.owner?.channelPicture ?? ''),
                    radius: 18,
                    backgroundColor: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.title ?? '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                          '${video.owner?.channelName ?? ''} • ${video.views ?? 0} views',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

