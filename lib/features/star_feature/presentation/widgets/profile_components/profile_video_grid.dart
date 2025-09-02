import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../domain/entity/star_entity.dart';
import '../common/thumbnail_widget.dart';
import '../talent_card/talent_card.dart';

class ProfileVideoGrid extends StatelessWidget {
  final List<StarEntity> videos;
  final bool isGridView;
  final Function(StarEntity)? onVideoTap;

  const ProfileVideoGrid({
    super.key,
    required this.videos,
    this.isGridView = true,
    this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              context.isArabic ? 'لا توجد فيديوهات' : 'No videos yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return isGridView ? _buildGridView(context) : _buildListView(context);
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 12,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildGridVideoItem(context, video, index);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildListVideoItem(context, video, index),
        );
      },
    );
  }

  Widget _buildGridVideoItem(
      BuildContext context, StarEntity video, int index) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onVideoTap?.call(video);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: ThumbnailWidget(
              width: double.infinity,
              height: double.infinity,
              duration: '7:54',
              showVolumeIcon: true,
              showPlayIcon: true,
              onTap: () {
                ManageVibration.vibrate();
                onVideoTap?.call(video);
              },
            ),
          ),
          SizedBox(height: 8),

          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildListVideoItem(
      BuildContext context, StarEntity video, int index) {
    final thumbnailWidth = MediaQuery.of(context).size.width * 0.4;
    final thumbnailHeight = thumbnailWidth * 0.56;

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onVideoTap?.call(video);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ThumbnailWidget(
              width: thumbnailWidth,
              height: thumbnailHeight,
              duration: '7:54',
              showVolumeIcon: true,
            ),
            SizedBox(width: 16),

            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${video.user.firstName} ${video.user.lastName}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${video.totalViews} views • 7 days ago", // Format properly
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // More button
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                _showMoreOptions(context, video);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, StarEntity video) {
    // Implementation for showing video options
  }
}
