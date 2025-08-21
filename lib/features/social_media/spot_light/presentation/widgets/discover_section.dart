import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/other_profile_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverSection extends StatefulWidget {
  final bool isFetchingMore;

  const DiscoverSection({super.key, required this.isFetchingMore});

  @override
  DiscoverSectionState createState() => DiscoverSectionState();
}

class DiscoverSectionState extends State<DiscoverSection> {
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    // Load initial media data when the widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDiscoverMedia();
    });
  }

  void _loadDiscoverMedia({bool loadMore = false}) {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 1;
    }

    context.read<SpotlightCubit>().getMyMedia(
          page: _currentPage,
          limit: _limit,
          forceRefresh: !loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.discover_title.tr(),
            textScaler: TextScaler.noScaling,
            style: Styles.headerText(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: BlocConsumer<SpotlightCubit, SpotLightState>(
            listener: (context, state) {
              if (state is SpotlightError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to load media: ${state.failureMessage?.toString() ?? 'Unknown error'}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SpotlightMediaLoading && _currentPage == 1) {
                return _buildLoadingGrid();
              }

              if (state is SpotlightMediaLoaded) {
                final allMedia = state.allMedia;

                if (allMedia.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: allMedia.length,
                      itemBuilder: (context, index) {
                        final media = allMedia[index];
                        return _buildReelCard(context, media, index);
                      },
                    ),

                    // Load more section
                    if (state.mediaResponse.hasNextPage && !state.isLoadingMore)
                      Padding(
                        padding: EdgeInsets.all(16.h),
                        child: ElevatedButton(
                          onPressed: () => _loadDiscoverMedia(loadMore: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            minimumSize: Size(200.w, 44.h),
                          ),
                          child: Text(
                            'Load More',
                            style: Styles.mediumText(color: Colors.white),
                          ),
                        ),
                      ),

                    // Loading more indicator
                    if (state.isLoadingMore)
                      Padding(
                        padding: EdgeInsets.all(16.h),
                        child: const CustomCircularProgressIndicator(),
                      ),

                    // No more data indicator
                    if (!state.mediaResponse.hasNextPage && allMedia.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(16.h),
                        child: Text(
                          'No more media to load',
                          style: Styles.smallText(color: Colors.grey),
                        ),
                      ),
                  ],
                );
              }

              if (state is SpotlightError) {
                return _buildErrorState();
              }

              // Initial loading state
              return _buildLoadingGrid();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 0.6,
        ),
        itemCount: 12, // Show 12 skeleton items like original
        itemBuilder: (context, index) => _buildSkeletonCard(),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          // Skeleton image
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
          ),

          // Skeleton overlay content
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Skeleton profile avatar
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const Sizer(),

                // Skeleton text lines
                Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 80.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelCard(BuildContext context, dynamic media, int index) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        _showMediaDetails(context, media);
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Media image from API (keep your existing image loading logic)
            _buildMediaImage(media),

            // Overlay content matching the original style
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // User profile avatar (matching original design)
                  ClickableWidget(
                    onTap: () => _navigateToUserProfile(context, media.userId),
                    child: CircleAvatar(
                      radius: 32.w,
                      backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
                      // TODO: Replace with actual user profile image from API
                      backgroundImage: AssetImage(Assets.personalImage),
                      // child: Icon(
                      //   Icons.person,
                      //   color: Colors.white,
                      //   size: 24.w,
                      // ),
                    ),
                  ),
                  const Sizer(),

                  // User info and date (matching original RichText style)
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${_getUserDisplayName(media)}\n',
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 32),
                      ),
                      TextSpan(
                        text: _formatDateLikeOriginal(media.createdAt),
                        style:
                            Styles.smallText(color: Colors.white, fontSize: 24),
                      ),
                    ]),
                  ),
                ],
              ),
            ),

            // Media type indicator (top right)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: _buildMediaTypeIndicator(media.type),
            ),

            // Media status indicator (if not completed, top left)
            if (media.status.toString() != 'MediaStatus.completed')
              Positioned(
                top: 8.h,
                left: 8.w,
                child: _buildStatusIndicator(media.status),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaImage(dynamic media) {
    final imageUrl = media.thumbnailUrl ?? media.mediaUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    // Use the same placeholder image as the original design
    return Image.asset(
      Assets.spotlight_profile,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }

  Widget _buildMediaTypeIndicator(dynamic type) {
    IconData icon;
    Color color = Colors.white;

    switch (type.toString()) {
      case 'MediaType.video':
        icon = Icons.play_circle_fill;
        break;
      case 'MediaType.story':
        icon = Icons.auto_stories;
        break;
      default:
        icon = Icons.image;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16.w,
      ),
    );
  }

  Widget _buildStatusIndicator(dynamic status) {
    String text;
    Color color;

    switch (status.toString()) {
      case 'MediaStatus.pending':
        text = 'Pending';
        color = Colors.orange;
        break;
      case 'MediaStatus.uploading':
        text = 'Uploading';
        color = Colors.blue;
        break;
      case 'MediaStatus.failed':
        text = 'Failed';
        color = Colors.red;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: Styles.smallText(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64.w,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'No media found',
              style: Styles.mediumText(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Upload your first photo or video to get started',
              style: Styles.smallText(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: _loadDiscoverMedia,
              child: Text(LocaleKeys.refresh.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: Colors.red,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load media',
              style: Styles.mediumText(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please check your connection and try again',
              style: Styles.smallText(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: _loadDiscoverMedia,
              child: Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  void _showMediaDetails(BuildContext context, dynamic media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Media Details',
                        style: Styles.headerText(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.h),

                      // Media image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          height: 200.h,
                          width: double.infinity,
                          child: _buildMediaImage(media),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Details
                      _buildDetailRow(
                          'Type', media.type.toString().split('.').last),
                      _buildDetailRow(
                          'Status', media.status.toString().split('.').last),
                      if (media.caption != null && media.caption!.isNotEmpty)
                        _buildDetailRow('Caption', media.caption!),
                      _buildDetailRow('Likes', media.likesCount.toString()),
                      _buildDetailRow(
                          'Comments', media.commentsCount.toString()),
                      _buildDetailRow(
                          'Created',
                          DateFormat('MMM dd, yyyy - HH:mm')
                              .format(media.createdAt)),
                      _buildDetailRow(
                          'Updated',
                          DateFormat('MMM dd, yyyy - HH:mm')
                              .format(media.updatedAt)),

                      SizedBox(height: 24.h),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _toggleLike(context, media);
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                media.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: media.isLiked ? Colors.red : null,
                              ),
                              label: Text(media.isLiked ? 'Unlike' : 'Like'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: media.isLiked
                                    ? Colors.red.withOpacity(0.1)
                                    : AppColors.PRIMARY_COLOR,
                                foregroundColor:
                                    media.isLiked ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: Styles.smallText(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Styles.smallText(),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLike(BuildContext context, dynamic media) {
    final cubit = context.read<SpotlightCubit>();
    if (media.isLiked) {
      cubit.unlikeMedia(media.id);
    } else {
      cubit.likeMedia(media.id);
    }
  }

  void _navigateToUserProfile(BuildContext context, String userId) {
    // Get user profile data first, then navigate
    context.read<SpotlightCubit>().getUserProfile(userId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SpotlightCubit>(),
          child: const SpotLightOtherProfileScreen(),
        ),
      ),
    );
  }

  String _getUserDisplayName(dynamic media) {
    // TODO: Get actual user name from API/profile data
    // For now, return a placeholder name like the original
    return 'User Name'; // You'll replace this with actual user data
  }

  String _formatDateLikeOriginal(DateTime createdAt) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime mediaDate =
        DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (mediaDate.isAtSameMomentAs(today)) {
      return context.isArabic ? 'اليوم' : 'Today';
    } else if (mediaDate.isAtSameMomentAs(yesterday)) {
      return context.isArabic ? 'امس' : 'Yesterday';
    } else {
      // For older dates, show formatted date
      return context.locale.languageCode == 'ar'
          ? DateFormat('yyyy/MM/dd', 'ar').format(createdAt)
          : DateFormat('dd/MM/yyyy', 'en').format(createdAt);
    }
  }
}
