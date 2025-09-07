
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/profile_components/playlist/playlist_card.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ProfilePlaylistsTab extends StatelessWidget {
  final List<PlaylistEntity> playlists;

  const ProfilePlaylistsTab({
    super.key,
    required this.playlists,
  });

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return PlaylistCard(
          playlist: playlist,
          onTap: () => _handlePlaylistTap(context, playlist),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_play,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            context.isArabic ? 'لا توجد قوائم تشغيل' : 'No playlists yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            context.isArabic
                ? 'ابدأ في إنشاء قوائم التشغيل الخاصة بك'
                : 'Start creating your own playlists',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handlePlaylistTap(BuildContext context, PlaylistEntity playlist) {
    ManageVibration.vibrate();

    // Navigate to playlist page
    Navigator.pushNamed(
      context,
      '/playlist-details',
      arguments: playlist,
    );
  }
}
