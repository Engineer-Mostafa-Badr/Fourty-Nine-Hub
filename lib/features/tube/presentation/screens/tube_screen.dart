import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/tube/presentation/screens/tube_favorites_videos_screen.dart';
import 'package:fourtyninehub/features/tube/presentation/screens/tube_home_videos_screen.dart';
import 'package:fourtyninehub/features/tube/presentation/screens/tube_video_player_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_card_widget.dart';
import '../widgets/video_mini_player.dart';


class TubeScreen extends StatefulWidget {
  const TubeScreen({super.key});

  @override
  State<TubeScreen> createState() => _TubeScreenState();
}

class _TubeScreenState extends State<TubeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // ✅ Removed unnecessary favorite loader to prevent double API calls
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && !_isSearching) {
        final cubit = context.read<TubeCubit>();
        switch (_tabController.index) {
          case 0:
          // cubit.loadInitialAllTubeVideos();
            break;
          case 1:
          // cubit.loadInitialSubscribedVideos();
            break;
          case 2:
          // ✅ No call here anymore
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Toggle between search bar and tabs
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      final cubit = context.read<TubeCubit>();

      if (_isSearching) {
        cubit.searchTubeVideos.clear();
        cubit.currentSearchTubeQuery = '';
      } else {
        _searchController.clear();
        cubit.currentSearchTubeQuery = '';
        // Reload current tab when exiting search
        switch (_tabController.index) {
          case 0:
          // cubit.loadInitialAllTubeVideos();
            break;
          case 1:
          // cubit.loadInitialSubscribedVideos();
            break;
          case 2:
          // ✅ Removed reload call here too
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Tube', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
                onPressed: _toggleSearch,
              ),
            ],
            bottom: !_isSearching
                ? TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.red,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Subscribed'),
                Tab(text: 'Favorites'),
              ],
            )
                : null,
          ),
          body: _isSearching
              ? _buildSearchField(context, state)
              : Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: const [
                  HomeVideosTubeScreen(),
                  SubscribedTab(),
                  TubeFavoriteScreen(),
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
    );
  }

  Widget _buildSearchField(BuildContext context, TubeState state) {
    final cubit = context.read<TubeCubit>();
    final searchResults = cubit.searchTubeVideos;

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search videos...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if (value.trim().isNotEmpty) {
                  cubit.loadInitialSearchTubeVideos(context, value);
                }
              },
            ),
          ),

          // 🧠 Results List
          Expanded(
            child: BlocBuilder<TubeCubit, TubeState>(
              builder: (context, state) {
                if (state.status == StateStatus.loading &&
                    cubit.isSearchTubeInitialLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }

                if (searchResults.isEmpty) {
                  return const Center(
                    child: Text(
                      "No videos found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: Colors.red,
                  backgroundColor: const Color(0xFF0F0F0F),
                  onRefresh: () async {
                    await cubit.loadInitialSearchTubeVideos(
                      context,
                      cubit.currentSearchTubeQuery,
                    );
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 200 &&
                          cubit.hasMoreSearchTubeVideos &&
                          !cubit.isSearchTubeLoadingMore) {
                        cubit.getSearchTubeVideos(context);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: searchResults.length +
                          (cubit.hasMoreSearchTubeVideos ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= searchResults.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(color: Colors.red),
                            ),
                          );
                        }
                        final video = searchResults[index];
                        return VideoCardTube(
                          video: video,
                          videoList: searchResults,

                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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


