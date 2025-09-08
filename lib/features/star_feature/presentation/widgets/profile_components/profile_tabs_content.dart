import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../controller/playlist_cubit/playlist_cubit.dart';
import 'profile_home_tab.dart';
import 'profile_playlists_tab.dart';
import 'profile_videos_tab.dart';

class ProfileTabsContent extends StatelessWidget {
  final TabController tabController;
  final List<StarEntity> extendedVideos;
  final bool isCurrentUser;
  final String? userId;

  const ProfileTabsContent({
    super.key,
    required this.tabController,
    required this.extendedVideos,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        // Home Tab - عرض All Videos (For You + New Songs)
        ProfileHomeTab(
          videos: extendedVideos,
          isCurrentUser: isCurrentUser,
        ),

        // Videos Tab - عرض فيديوهات الشخص المحدد
        ProfileVideosTab(
          videos: extendedVideos,
          isCurrentUser: isCurrentUser,
          userId: userId,
        ),

        // Playlists Tab - استخدام PlaylistCubit
        BlocProvider(
          create: (context) => serviceLocator<PlaylistCubit>(),
          child: ProfilePlaylistsTab(
            isCurrentUser: isCurrentUser,
            userId: userId,
          ),
        ),
      ],
    );
  }
}
