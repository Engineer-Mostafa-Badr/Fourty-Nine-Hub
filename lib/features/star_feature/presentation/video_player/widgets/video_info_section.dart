import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../data/model/comment_model.dart';
import '../../../data/model/tube_video_models.dart';
import '../../presentation_exports.dart';

class VideoInfoSection extends StatefulWidget {
  final StarEntity talent;
  final StarCubit starCubit;
  final CommentCubit commentCubit;
  final VoidCallback onProfileTap;
  final VoidCallback onCommentsTap;

  const VideoInfoSection({
    super.key,
    required this.talent,
    required this.starCubit,
    required this.commentCubit,
    required this.onProfileTap,
    required this.onCommentsTap,
  });

  @override
  State<VideoInfoSection> createState() => _VideoInfoSectionState();
}

class _VideoInfoSectionState extends State<VideoInfoSection> {
  bool _showFullDescription = false;
  late ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    // Get ProfileCubit instance
    _profileCubit = context.read<ProfileCubit>();
    // Load profile info using Profile/Channel ID (ownerId)
    final profileId = widget.talent.ownerId ?? widget.talent.user.id;
    print('🔍 Loading profile with Profile ID: $profileId');
    _profileCubit.getProfileById(profileId, showLoading: false);
  }

  String _formatViewCount(num views) {
    final viewCount = views.toInt();
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return context.isArabic
          ? 'منذ $years ${years == 1 ? "سنة" : "سنوات"}'
          : '$years ${years == 1 ? "year" : "years"} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return context.isArabic
          ? 'منذ $months ${months == 1 ? "شهر" : "شهور"}'
          : '$months ${months == 1 ? "month" : "months"} ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return context.isArabic
          ? 'منذ $weeks ${weeks == 1 ? "أسبوع" : "أسابيع"}'
          : '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else if (difference.inDays > 0) {
      return context.isArabic
          ? 'منذ ${difference.inDays} ${difference.inDays == 1 ? "يوم" : "أيام"}'
          : '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
    } else if (difference.inHours > 0) {
      return context.isArabic
          ? 'منذ ${difference.inHours} ${difference.inHours == 1 ? "ساعة" : "ساعات"}'
          : '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
    } else if (difference.inMinutes > 0) {
      return context.isArabic
          ? 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? "دقيقة" : "دقائق"}'
          : '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
    } else {
      return context.isArabic ? 'الآن' : 'Just now';
    }
  }

  Widget _buildCommentPreview(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          ImageFromInternet(
            image: comment.owner.channelPicture?.mediaKey ?? '',
            width: 32,
            height: 32,
            isCircle: true,
            isMale: comment.owner.gender?.toLowerCase() != 'female',
            defaultLogo:
                (comment.owner.channelPicture?.mediaKey.isEmpty ?? true),
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              comment.content,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(StarCubit starCubit) {
    return StreamBuilder<String>(
      stream: starCubit.videoUpdates,
      builder: (context, snapshot) {
        final isRated = widget.talent.isRate;
        final averageRating = widget.talent.averageRating;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isRated)
                // Show rating stars if not rated
                ...List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      starCubit.rateVideo(
                          widget.talent.id, (index + 1).toDouble());
                    },
                    child: Icon(
                      Icons.star_border,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              else
                // Show average rating if rated
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1).toArabicNumbers(context),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  bool _isLiked(StarCubit starCubit) {
    final video = starCubit.getVideoById(widget.talent.id);
    return video?.isLike ?? false;
  }

  bool _isDisliked(StarCubit starCubit) {
    final video = starCubit.getVideoById(widget.talent.id);
    return video?.isDislike ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.commentCubit,
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, commentState) {
          return BlocBuilder<StarCubit, StarState>(
            builder: (context, starState) {
              final starCubit = widget.starCubit;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.talent.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Views and time
                    Row(
                      children: [
                        Text(
                          '${_formatViewCount(widget.talent.totalViews).toArabicNumbers(context)} ${context.isArabic ? 'مشاهدة' : 'views'}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          ' · ',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          _formatTimeAgo(
                                  widget.talent.createdAt ?? DateTime.now())
                              .toArabicNumbers(context),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const Spacer(),
                        // Star rating
                        // Row(
                        //   children: List.generate(
                        //     5,
                        //     (index) => GestureDetector(
                        //       onTap: () {
                        //         starCubit.updateRating(
                        //             widget.talent.id, index + 1);
                        //       },
                        //       child: Icon(
                        //         index < widget.talent.averageRating
                        //             ? Icons.star
                        //             : Icons.star_outline,
                        //         size: 20,
                        //         color: index < widget.talent.averageRating
                        //             ? Colors.amber[600]
                        //             : Colors.grey[400],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // Description
                    if (widget.talent.description.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.talent.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: _showFullDescription ? null : 2,
                              overflow: _showFullDescription
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (widget.talent.description.length > 100)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFullDescription =
                                        !_showFullDescription;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _showFullDescription
                                        ? (context.isArabic
                                            ? 'إظهار أقل'
                                            : 'Show less')
                                        : (context.isArabic
                                            ? 'إظهار المزيد'
                                            : 'Show more'),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Channel info and subscribe
                    Row(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: ImageFromInternet(
                            image: widget.talent.user.image,
                            width: 40,
                            height: 40,
                            isCircle: true,
                            isMale: widget.talent.user.gender.toLowerCase() !=
                                'female',
                            defaultLogo: widget.talent.user.image.isEmpty,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Channel name and subscribers
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onProfileTap,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.talent.user.firstName} ${widget.talent.user.lastName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${_formatViewCount(widget.talent.user.viewNumber).toArabicNumbers(context)} ${context.isArabic ? 'مشترك' : 'subscribers'}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Subscribe button with bell
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, profileState) {
                            final isSubscribed =
                                profileState.profile?.isSubscribed ?? false;

                            // Check if current user is viewing their own video
                            String? videoOwnerId;
                            if (widget.talent is TubeVideoModel) {
                              videoOwnerId =
                                  (widget.talent as TubeVideoModel).userId;
                            }
                            videoOwnerId ??= widget.talent.user.id;

                            final currentUserId = UserCubit.to.state.data?.id;
                            final isOwnVideo = currentUserId != null &&
                                currentUserId == videoOwnerId;

                            // Hide subscribe button if viewing own video
                            if (isOwnVideo) {
                              return SizedBox.shrink();
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    isSubscribed ? Colors.grey : Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      ManageVibration.vibrate();
                                      // Use userId for subscribe/unsubscribe
                                      String? subscribeId;
                                      if (widget.talent is TubeVideoModel) {
                                        subscribeId =
                                            (widget.talent as TubeVideoModel)
                                                .userId;
                                      }
                                      subscribeId ??= widget.talent.user.id;

                                      print(
                                          '🔔 Toggling subscription with User ID: $subscribeId');
                                      await _profileCubit
                                          .toggleSubscription(subscribeId);
                                    },
                                    child: Text(
                                      isSubscribed
                                          ? (context.isArabic
                                              ? 'مشترك'
                                              : 'Subscribed')
                                          : (context.isArabic
                                              ? 'اشتراك'
                                              : 'Subscribe'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  if (!isSubscribed) ...[
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        // Like/Dislike button container
                        StreamBuilder<String>(
                          stream: starCubit.videoUpdates,
                          builder: (context, snapshot) {
                            final video =
                                starCubit.getVideoById(widget.talent.id);
                            final isLiked =
                                video?.isLike ?? _isLiked(starCubit);
                            final isDisliked =
                                video?.isDislike ?? _isDisliked(starCubit);
                            final likes = video?.likes ?? widget.talent.likes;
                            final dislikes =
                                video?.dislikes ?? widget.talent.dislikes;

                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Like button
                                  IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                      size: 20,
                                      color: isLiked
                                          ? Colors.blue
                                          : Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      ManageVibration.vibrate();
                                      starCubit
                                          .ensureVideoInState(widget.talent);
                                      starCubit.likeTubeVideo(widget.talent.id);
                                    },
                                  ),

                                  // Likes count
                                  Text(
                                    likes.toString().toArabicNumbers(context),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),

                                  // Divider
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.grey[400],
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),

                                  // Dislike button
                                  IconButton(
                                    icon: Icon(
                                      isDisliked
                                          ? Icons.thumb_down
                                          : Icons.thumb_down_outlined,
                                      size: 20,
                                      color: isDisliked
                                          ? Colors.red
                                          : Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      ManageVibration.vibrate();
                                      starCubit
                                          .ensureVideoInState(widget.talent);
                                      starCubit
                                          .dislikeTubeVideo(widget.talent.id);
                                    },
                                  ),

                                  // Dislikes count
                                  Text(
                                    dislikes
                                        .toString()
                                        .toArabicNumbers(context),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 12),

                        // Rating section
                        _buildRatingSection(starCubit),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Comments section header
                    GestureDetector(
                      onTap: widget.onCommentsTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.isArabic ? 'التعليقات' : 'Comments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Label(
                                  text: commentState.totalComments
                                      .toString()
                                      .toArabicNumbers(context),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                              ],
                            ),
                            // Show loading or first comment preview
                            if (commentState.isLoading)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            else if (commentState.comments.isNotEmpty)
                              _buildCommentPreview(commentState.comments.first)
                            // else
                            //   // No comments yet
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 8),
                            //     child: Text(
                            //       context.isArabic
                            //           ? 'لا توجد تعليقات'
                            //           : 'No comments yet',
                            //       style: TextStyle(
                            //         color: Colors.grey[600],
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
