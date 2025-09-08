import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

import '../../controller/star_cubit/star_cubit.dart';
import '../../utils/enums.dart';
import '../common/loading_indicator.dart';
import 'profile_video_grid.dart';

class ProfileVideosTab extends StatefulWidget {
  final List<StarEntity> videos; // fallback data
  final bool isCurrentUser;
  final String? userId; // ID للمستخدم المطلوب عرض فيديوهاته

  const ProfileVideosTab({
    super.key,
    required this.videos,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  State<ProfileVideosTab> createState() => _ProfileVideosTabState();
}

class _ProfileVideosTabState extends State<ProfileVideosTab>
    with AutomaticKeepAliveClientMixin {
  bool _isGridView = true;
  late StarCubit _starCubit;
  List<StarEntity> _userVideos = [];
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _starCubit = context.read<StarCubit>();
    _loadUserVideos();
  }

  void _loadUserVideos() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.isCurrentUser) {
      // إذا كان المستخدم الحالي، استخدم fetchMyTubeVideos
      await _starCubit.loadTalents(TalentCategory.myTalents, refresh: true);
    } else {
      // إذا كان مستخدم آخر، استخدم الفيديوهات المرسلة أو اعمل API call
      // هنا يمكن إضافة API call للحصول على فيديوهات المستخدم المحدد
      _userVideos = widget.videos;
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<StarEntity> get _displayVideos {
    if (widget.isCurrentUser) {
      return _starCubit.state.myTalents;
    }
    return _userVideos;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        final videosToShow = _displayVideos;
        final isLoading = _isLoading ||
            (widget.isCurrentUser && state.isLoading(TalentCategory.myTalents));

        return Column(
          children: [
            // View Toggle Header
            _buildViewToggle(videosToShow, isLoading),

            // Videos Content
            Expanded(
              child: isLoading && videosToShow.isEmpty
                  ? Center(
                      child: StarLoadingIndicator(
                        message: widget.isCurrentUser
                            ? 'Loading your videos...'
                            : 'Loading videos...',
                      ),
                    )
                  : ProfileVideoGrid(
                      videos: videosToShow,
                      isGridView: _isGridView,
                      onVideoTap: _handleVideoTap,
                      starCubit: _starCubit,
                      isCurrentUser: widget.isCurrentUser,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewToggle(List<StarEntity> videos, bool isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isLoading ? 'Loading...' : '${videos.length} videos',
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
              // Refresh button
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey[700],
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        _loadUserVideos();
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleVideoTap(StarEntity video) {
    // Navigate to video player with options menu
    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';

    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'video': video,
        'mediaUrl': mediaUrl,
        'cubit': _starCubit,
      },
    );
  }
}
