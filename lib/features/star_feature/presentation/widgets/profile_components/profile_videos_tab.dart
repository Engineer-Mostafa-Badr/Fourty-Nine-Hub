import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../controller/star_cubit/star_cubit.dart';
import '../../utils/enums.dart';
import '../common/loading_indicator.dart';
import 'profile_video_grid.dart';

class ProfileVideosTab extends StatefulWidget {
  final List<StarEntity> videos; // fallback data for other users
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
      // إذا كان المستخدم الحالي، استخدم myTalents من StarCubit
      await _starCubit.loadTalents(TalentCategory.myTalents, refresh: true);
    } else {
      // إذا كان مستخدم آخر، استخدم الفيديوهات المرسلة من ProfilePageView
      // هذه الفيديوهات تأتي من البيانات الأصلية وليس البيانات الثابتة
      _userVideos = widget.videos;

      // يمكن إضافة API call هنا لجلب فيديوهات المستخدم المحدد من السيرفر
      // await _starCubit.fetchUserVideos(widget.userId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<StarEntity> get _displayVideos {
    if (widget.isCurrentUser) {
      // للمستخدم الحالي، استخدم myTalents من StarCubit
      return _starCubit.state.myTalents;
    } else {
      // للمستخدمين الآخرين، استخدم الفيديوهات المرسلة
      return _userVideos;
    }
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
            // View Toggle Header with enhanced info
            _buildViewToggleHeader(videosToShow, isLoading),

            // Videos Content
            Expanded(
              child: isLoading && videosToShow.isEmpty
                  ? Center(
                      child: StarLoadingIndicator(
                        message: widget.isCurrentUser
                            ? (context.isArabic
                                ? 'جاري تحميل فيديوهاتك...'
                                : 'Loading your videos...')
                            : (context.isArabic
                                ? 'جاري تحميل الفيديوهات...'
                                : 'Loading videos...'),
                      ),
                    )
                  : videosToShow.isEmpty
                      ? Center(
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
                                widget.isCurrentUser
                                    ? (context.isArabic
                                        ? 'لا توجد فيديوهات بعد'
                                        : 'No videos yet')
                                    : (context.isArabic
                                        ? 'لا توجد فيديوهات'
                                        : 'No videos available'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (widget.isCurrentUser) ...[
                                SizedBox(height: 8),
                                Text(
                                  context.isArabic
                                      ? 'ابدأ في رفع أول فيديو لك'
                                      : 'Start uploading your first video',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _loadUserVideos,
                                icon: Icon(Icons.refresh, size: 18),
                                label: Text(
                                  context.isArabic
                                      ? 'إعادة المحاولة'
                                      : 'Try Again',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildViewToggleHeader(List<StarEntity> videos, bool isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Video count and view toggle row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Video count and user info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading
                          ? (context.isArabic
                              ? 'جاري التحميل...'
                              : 'Loading...')
                          : (context.isArabic
                              ? '${videos.length} فيديو'
                              : '${videos.length} videos'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (!isLoading && videos.isNotEmpty) ...[
                      SizedBox(height: 2),
                      Text(
                        widget.isCurrentUser
                            ? (context.isArabic
                                ? 'فيديوهاتك المرفوعة'
                                : 'Your uploaded videos')
                            : (context.isArabic
                                ? 'فيديوهات هذا المستخدم'
                                : 'This user\'s videos'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // View controls
              Row(
                children: [
                  // Grid view button
                  _buildViewButton(
                    icon: Icons.grid_view,
                    isSelected: _isGridView,
                    onTap: () => setState(() => _isGridView = true),
                    tooltip: context.isArabic ? 'عرض الشبكة' : 'Grid view',
                  ),
                  SizedBox(width: 8),

                  // List view button
                  _buildViewButton(
                    icon: Icons.list,
                    isSelected: !_isGridView,
                    onTap: () => setState(() => _isGridView = false),
                    tooltip: context.isArabic ? 'عرض القائمة' : 'List view',
                  ),
                  SizedBox(width: 8),

                  // Refresh button
                  _buildViewButton(
                    icon: Icons.refresh,
                    isSelected: false,
                    onTap: isLoading ? null : _loadUserVideos,
                    tooltip: context.isArabic ? 'تحديث' : 'Refresh',
                  ),
                ],
              ),
            ],
          ),

          // Sort and filter options (if needed)
          if (!isLoading && videos.isNotEmpty) ...[
            SizedBox(height: 12),
            Row(
              children: [
                // Sort by
                InkWell(
                  onTap: () => _showSortOptions(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sort,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          context.isArabic ? 'ترتيب' : 'Sort',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // Filter by date (if current user)
                if (widget.isCurrentUser)
                  InkWell(
                    onTap: () => _showFilterOptions(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            context.isArabic ? 'فلتر' : 'Filter',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.blue[200]!, width: 1)
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.blue[600] : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.isArabic ? 'ترتيب الفيديوهات' : 'Sort Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildSortOption(
              context,
              context.isArabic ? 'الأحدث أولاً' : 'Newest first',
              Icons.access_time,
              () {
                Navigator.pop(context);
                // Implement sorting logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'الأقدم أولاً' : 'Oldest first',
              Icons.history,
              () {
                Navigator.pop(context);
                // Implement sorting logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'الأكثر مشاهدة' : 'Most viewed',
              Icons.visibility,
              () {
                Navigator.pop(context);
                // Implement sorting logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'أعلى تقييم' : 'Highest rated',
              Icons.star,
              () {
                Navigator.pop(context);
                // Implement sorting logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.isArabic ? 'فلترة الفيديوهات' : 'Filter Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildSortOption(
              context,
              context.isArabic ? 'اليوم' : 'Today',
              Icons.today,
              () {
                Navigator.pop(context);
                // Implement filter logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'هذا الأسبوع' : 'This week',
              Icons.date_range,
              () {
                Navigator.pop(context);
                // Implement filter logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'هذا الشهر' : 'This month',
              Icons.calendar_month,
              () {
                Navigator.pop(context);
                // Implement filter logic
              },
            ),
            _buildSortOption(
              context,
              context.isArabic ? 'كل الوقت' : 'All time',
              Icons.all_inclusive,
              () {
                Navigator.pop(context);
                // Implement filter logic
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleVideoTap(StarEntity video) {
    // Navigate to video player with enhanced options
    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';

    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'video': video,
        'mediaUrl': mediaUrl,
        'cubit': _starCubit,
        'isCurrentUser': widget.isCurrentUser,
        'userId': widget.userId,
      },
    );
  }
}
