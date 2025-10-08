import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/utils/enums.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/common/loading_indicator.dart';
import '../../presentation_exports.dart';

class ProfileWatchLaterTab extends StatefulWidget {
  final bool isCurrentUser;
  final String? userId;

  const ProfileWatchLaterTab({
    super.key,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  State<ProfileWatchLaterTab> createState() => _ProfileWatchLaterTabState();
}

class _ProfileWatchLaterTabState extends State<ProfileWatchLaterTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load watch later videos when tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isCurrentUser) {
        _loadWatchLaterVideos();
      }
    });
  }

  void _loadWatchLaterVideos() {
    final cubit = context.read<StarCubit>();
    // Use the watch later use case to load videos
    cubit.loadWatchLaterVideos();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Only show watch later for current user
    if (!widget.isCurrentUser) {
      return _buildNotAvailableForOtherUsers(context);
    }

    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        // Check if we have watch later videos in the state
        final watchLaterVideos = state.watchLaterTalents;

        // Show loading if currently loading and no videos yet
        if (state.isLoading(TalentCategory.watchLater) &&
            watchLaterVideos.isEmpty) {
          return const Center(
            child: StarLoadingIndicator(),
          );
        }

        // Show empty state if no videos
        if (watchLaterVideos.isEmpty) {
          return _buildEmptyState(context);
        }

        // Build the videos list - use simple ListView instead of CustomScrollView
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: watchLaterVideos.length +
                (state.isLoading(TalentCategory.watchLater) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == watchLaterVideos.length) {
                // Load more indicator
                if (state.isLoading(TalentCategory.watchLater)) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: const Center(
                      child: StarLoadingIndicator(),
                    ),
                  );
                }
                return SizedBox.shrink();
              }

              final video = watchLaterVideos[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: TalentCard(
                  key: ValueKey('watch_later_${video.id}'),
                  talent: video,
                  cubit: context.read<StarCubit>(),
                ),
              );
            },
          ),
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
            Icons.watch_later_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            context.isArabic
                ? 'لا يوجد فيديوهات للشاهد لاحقاً'
                : 'No videos in Watch Later',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            context.isArabic
                ? 'اضغط على أيقونة "الشاهد لاحقاً" في أي فيديو لإضافته هنا'
                : 'Tap the "Watch Later" icon on any video to add it here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Go back to main tabs or refresh
              _loadWatchLaterVideos();
            },
            icon: Icon(Icons.refresh),
            label: Text(
              context.isArabic ? 'تحديث' : 'Refresh',
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAvailableForOtherUsers(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            context.isArabic ? 'غير متاح' : 'Not Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Text(
            context.isArabic
                ? 'قائمة "الشاهد لاحقاً" متاحة فقط للمستخدم الحالي'
                : 'Watch Later is only available for your own profile',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
