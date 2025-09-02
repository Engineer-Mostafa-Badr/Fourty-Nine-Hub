import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

import 'profile_video_grid.dart';

class ProfileVideosTab extends StatefulWidget {
  final List<StarEntity> videos;

  const ProfileVideosTab({
    super.key,
    required this.videos,
  });

  @override
  State<ProfileVideosTab> createState() => _ProfileVideosTabState();
}

class _ProfileVideosTabState extends State<ProfileVideosTab>
    with AutomaticKeepAliveClientMixin {
  bool _isGridView = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        // View Toggle Header
        _buildViewToggle(),

        // Videos Content
        Expanded(
          child: ProfileVideoGrid(
            videos: widget.videos,
            isGridView: _isGridView,
            onVideoTap: _handleVideoTap,
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.videos.length} videos',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: _isGridView ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() => _isGridView = true);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: !_isGridView ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() => _isGridView = false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleVideoTap(StarEntity video) {
    // Navigate to video player
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: video,
    );
  }
}
