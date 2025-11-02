import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../domain/entities/reel_entity.dart';

class ReelWidget extends StatefulWidget {
  final ReelEntity reel;
  final bool isPlaying;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;
  final VoidCallback onFollow;
  final VideoPlayerController? videoController;
  final ChewieController? chewieController;

  const ReelWidget({
    super.key,
    required this.reel,
    required this.isPlaying,
    required this.onLike,
    required this.onShare,
    required this.onComment,
    required this.onFollow,
    this.videoController,
    this.chewieController,
  });

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          _buildVideoPlayer(),

          // Gradient overlay for better text visibility
          _buildGradientOverlay(),

          // Content overlay
          _buildContentOverlay(),

          // Action buttons
          _buildActionButtons(),

          // Bottom info
          _buildBottomInfo(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    try {
      if (widget.chewieController != null) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Chewie(controller: widget.chewieController!),
        );
      }

      // Fallback if no controller is provided
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 64.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error building video player: $e');
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Error loading video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.reel.title != null && widget.reel.title!.isNotEmpty) ...[
              Text(
                widget.reel.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
            ],
            if (widget.reel.description != null &&
                widget.reel.description!.isNotEmpty) ...[
              Text(
                widget.reel.description!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14.sp,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      right: 16.w,
      bottom: 120.h,
      child: Column(
        children: [
          // Profile/Avatar
          _buildActionButton(
            icon: widget.reel.authorAvatar != null &&
                    widget.reel.authorAvatar!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.reel.authorAvatar!),
                    radius: 20.r,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 20.r,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
            onTap: widget.onFollow,
            label: 'Follow',
          ),
          SizedBox(height: 16.h),

          // Like button
          _buildActionButton(
            icon: Icon(
              widget.reel.isLiked ? Icons.favorite : Icons.favorite_border,
              color: widget.reel.isLiked ? Colors.red : Colors.white,
              size: 28.sp,
            ),
            onTap: widget.onLike,
            label: _formatCount(widget.reel.likes),
          ),
          SizedBox(height: 16.h),

          // Comment button
          _buildActionButton(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 28.sp,
            ),
            onTap: widget.onComment,
            label: _formatCount(widget.reel.comments),
          ),
          SizedBox(height: 16.h),

          // Share button
          _buildActionButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
              size: 28.sp,
            ),
            onTap: widget.onShare,
            label: _formatCount(widget.reel.shares),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required Widget icon,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        try {
          onTap();
        } catch (e) {
          print('Error in action button tap: $e');
        }
      },
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            if (widget.reel.authorName != null &&
                widget.reel.authorName!.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    '@${widget.reel.authorName!.toLowerCase().replaceAll(' ', '')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (!widget.reel.isFollowing)
                    GestureDetector(
                      onTap: () {
                        try {
                          widget.onFollow();
                        } catch (e) {
                          print('Error in follow tap: $e');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            // Video duration
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white.withOpacity(0.7),
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDuration(widget.reel.duration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withOpacity(0.7),
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDate(widget.reel.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    try {
      if (count >= 1000000) {
        return '${(count / 1000000).toStringAsFixed(1)}M';
      } else if (count >= 1000) {
        return '${(count / 1000).toStringAsFixed(1)}K';
      }
      return count.toString();
    } catch (e) {
      print('Error formatting count: $e');
      return count.toString();
    }
  }

  String _formatDuration(Duration duration) {
    try {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    } catch (e) {
      print('Error formatting duration: $e');
      return "00:00";
    }
  }

  String _formatDate(DateTime date) {
    try {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Just now';
    }
  }
}
