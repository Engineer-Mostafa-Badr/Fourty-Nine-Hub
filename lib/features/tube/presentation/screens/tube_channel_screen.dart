import 'package:flutter/material.dart';

class TubeChannelScreen extends StatefulWidget {
  const TubeChannelScreen({super.key});

  @override
  State<TubeChannelScreen> createState() => _TubeChannelScreenState();
}

class _TubeChannelScreenState extends State<TubeChannelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ChannelHeader(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  indicatorWeight: 2,
                  tabs: const [
                    Tab(text: "Home"),
                    Tab(text: "My Videos"),
                    Tab(text: "Watch Later"),
                    Tab(text: "Playlists"),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            HomeTab(),
            MyVideosTab(),
            WatchLaterTab(),
            PlaylistsTab(),
          ],
        ),
      ),
    );
  }
}

// ======================== Channel Header ========================
class ChannelHeader extends StatelessWidget {
  const ChannelHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
      child: Column(
        children: [
          // Channel Avatar
          const CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(
              'https://yt3.ggpht.com/ytc/AIdro_m3h3L5iA1oW3j0r2v7n4z7t2v0v7n4z7t2v0v7=s176-c-k-c0x00ffffff-no-rj',
            ),
          ),
          const SizedBox(height: 12),

          // Channel Name
          const Text(
            "TechBit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Channel Handle
          const Text(
            "@techbit",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          // Subscriber Count
          const Text(
            "1.2M subscribers",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          // Subscribe Button
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Subscribe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================== Tab Pages ========================

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Welcome to TechBit!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildVideoCard(),
        _buildVideoCard(),
        _buildVideoCard(),
      ],
    );
  }

  Widget _buildVideoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 68,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.play_arrow, size: 30, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Flutter UI Tutorial - YouTube Clone",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "10K views • 2 days ago",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 18),
        ],
      ),
    );
  }
}

class MyVideosTab extends StatelessWidget {
  const MyVideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildMyVideoItem();
      },
    );
  }

  Widget _buildMyVideoItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.play_circle_outline, size: 50),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.black.withOpacity(0.8),
                  child: const Text(
                    "10:24",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How to Build a Full YouTube Clone in Flutter",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "150K views • 1 week ago",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WatchLaterTab extends StatelessWidget {
  const WatchLaterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPlaylistHeader("Watch Later • 12 videos"),
        const SizedBox(height: 16),
        ...List.generate(5, (_) => _buildWatchLaterItem()),
      ],
    );
  }

  Widget _buildPlaylistHeader(String title) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.grey),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("Play all")),
      ],
    );
  }

  Widget _buildWatchLaterItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 68,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.play_arrow)),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  color: Colors.black.withOpacity(0.7),
                  child: const Text(
                    "12:30",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Advanced State Management in Flutter",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "Flutter Dev • 45K views",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 18),
        ],
      ),
    );
  }
}

class PlaylistsTab extends StatelessWidget {
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPlaylistCard("Flutter Tutorials", 24),
        _buildPlaylistCard("Dart Programming", 18),
        _buildPlaylistCard("UI/UX Design", 32),
        _buildPlaylistCard("Backend with Firebase", 15),
      ],
    );
  }

  Widget _buildPlaylistCard(String title, int videoCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 68,
                color: Colors.grey[300],
                child: const Center(
                  child:
                      Icon(Icons.playlist_play, size: 40, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  color: Colors.black.withOpacity(0.8),
                  child: Text(
                    "$videoCount",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "$videoCount videos • View all",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
