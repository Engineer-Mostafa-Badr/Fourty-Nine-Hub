import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../domain/entity/viewer_entity.dart';

class ViewersModal {
  static void show({
    required BuildContext context,
    required List<ViewerEntity> viewers,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ViewersModalContent(viewers: viewers),
    );
  }
}

class _ViewersModalContent extends StatelessWidget {
  final List<ViewerEntity> viewers;

  const _ViewersModalContent({required this.viewers});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: AppColors.c0B1035,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(context),
          Divider(),
          _buildViewersList(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.only(top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Views',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              ManageVibration.vibrate();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewersList() {
    if (viewers.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility_off,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No viewers yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: viewers.length,
        itemBuilder: (context, index) {
          final viewer = viewers[index];
          return _buildViewerItem(viewer);
        },
      ),
    );
  }

  Widget _buildViewerItem(ViewerEntity viewer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: viewer.profileImage.isNotEmpty
                ? CachedNetworkImageProvider(viewer.profileImage)
                : null,
            child: viewer.profileImage.isEmpty
                ? Icon(Icons.person, color: Colors.grey, size: 24)
                : null,
          ),
          SizedBox(width: 12),

          // Viewer Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewer.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _formatViewTime(viewer.viewTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // View indicator
          Icon(
            Icons.visibility,
            size: 16,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }

  String _formatViewTime(DateTime viewTime) {
    final now = DateTime.now();
    final difference = now.difference(viewTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }
}
