import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../presentation_exports.dart';
import 'profile_home_tab.dart';
import 'profile_playlists_tab.dart';
import 'profile_videos_tab.dart';
import 'profile_watch_later_tab.dart';

class ProfileTabsContent extends StatelessWidget {
  final TabController tabController;
  final List<StarEntity> extendedVideos;
  final bool isCurrentUser;
  final String? userId;
  final bool isLoadingUserVideos;

  const ProfileTabsContent({
    super.key,
    required this.tabController,
    required this.extendedVideos,
    required this.isCurrentUser,
    this.userId,
    this.isLoadingUserVideos = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      // Home Tab - عرض For You + User's content
      ProfileHomeTab(
        videos: extendedVideos,
        isCurrentUser: isCurrentUser,
        userId: userId,
      ),

      // Videos Tab - عرض فيديوهات المستخدم الحقيقية
      ProfileVideosTab(
        videos: extendedVideos, // Pass real user videos
        isCurrentUser: isCurrentUser,
        userId: userId,
      ),

      // Playlists Tab - Create safe fallback for PlaylistCubit
      _buildPlaylistsTab(isCurrentUser, userId),

      // Watch Later Tab - Only for current user
      if (isCurrentUser)
        ProfileWatchLaterTab(
          isCurrentUser: isCurrentUser,
          userId: userId,
        ),
    ];

    print('📋 ProfileTabsContent: Creating ${children.length} tab views for isCurrentUser: $isCurrentUser');
    print('📋 TabController length: ${tabController.length}');

    return TabBarView(
      controller: tabController,
      children: children,
    );
  }

  Widget _buildPlaylistsTab(bool isCurrentUser, String? userId) {
    try {
      return BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: ProfilePlaylistsTab(
          isCurrentUser: isCurrentUser,
          userId: userId,
        ),
      );
    } catch (e) {
      print('PlaylistCubit error: $e');
      // Return a fallback widget instead of crashing
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_play,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Playlists not available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please try again later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
