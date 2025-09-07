import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';

import 'profile_home_tab.dart';
import 'profile_playlists_tab.dart';
import 'profile_videos_tab.dart';

class ProfileTabsContent extends StatelessWidget {
  final TabController tabController;
  final List<StarEntity> extendedVideos;
  final List<PlaylistEntity> playlists;

  const ProfileTabsContent({
    super.key,
    required this.tabController,
    required this.extendedVideos,
    required this.playlists,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        // Home Tab
        ProfileHomeTab(videos: extendedVideos),

        // Videos Tab
        ProfileVideosTab(videos: extendedVideos),

        // Playlists Tab
        ProfilePlaylistsTab(playlists: playlists),
      ],
    );
  }
}
