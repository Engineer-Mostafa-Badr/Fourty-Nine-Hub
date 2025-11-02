import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/messages/messages.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../data/model/tube_video_models.dart';
import '../../../presentation_exports.dart';
import '../playlist_bottom_sheet.dart';
import '../play_next_queue_manager.dart';

class VideoCardWidget extends StatefulWidget {
  final TubeVideoModel video;
  final int index;
  final bool isHorizontal;
  final VoidCallback? onTap;
  final StarCubit? starCubit;

  const VideoCardWidget({
    super.key,
    required this.video,
    required this.index,
    this.isHorizontal = false,
    this.onTap,
    this.starCubit,
  });

  @override
  State<VideoCardWidget> createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  int? _selectedRating;
  bool _isAnimating = false;
  bool _shouldFadeOut = false;
  bool _showFinalRating = false;

  void _onStarTap(int rating) async {
    if (_isAnimating) return;

    setState(() {
      _selectedRating = rating;
      _isAnimating = true;
      _shouldFadeOut = false;
    });

    ManageVibration.vibrate();

    // Wait for 300ms to show the selected stars
    await Future.delayed(Duration(milliseconds: 300));

    if (mounted) {
      // Start fade out animation
      setState(() {
        _shouldFadeOut = true;
      });

      // Wait for fade out to complete (600ms)
      await Future.delayed(Duration(milliseconds: 600));

      if (mounted) {
        // Update the rating and show snack bar
        context.read<StarCubit>().updateRating(widget.video.id, rating);

        // Show final rating display
        setState(() {
          _showFinalRating = true;
          _isAnimating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null
          ? () => _navigateToVideo(context)
          : () {
              ManageVibration.vibrate();
              widget.onTap?.call();
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // إضافة هذا
        children: [
          // Video Thumbnail
          Flexible(
            // تغيير من عادي إلى Flexible
            child: _buildThumbnail(context),
          ),
          SizedBox(height: _getResponsiveSpacing(context, 12)),
          // Video Info
          _buildVideoInfo(context),
        ],
      ),
    );
  }

  String _formatDuration(StarEntity video) {
    Duration duration;

    if (video is TubeVideoModel) {
      duration = Duration(seconds: video.duration);
    } else if (video.mediaUrl.isNotEmpty) {
      duration = video.mediaUrl.first.duration ?? Duration.zero;
    } else {
      duration = Duration.zero;
    }

    if (duration == Duration.zero) return '0:00';

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:${minutes.padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }

  Widget _buildThumbnail(context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(_getResponsiveBorderRadius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main thumbnail
            ThumbnailWidget(
              imageUrl: widget.video.thumbnail?.isNotEmpty == true
                  ? widget.video.thumbnail
                  : null,
              width: double.infinity,
              height: double.infinity,
              duration: _formatDuration(widget.video),
              showVolumeIcon: true,
              onTap: () {
                ManageVibration.vibrate();
                _navigateToVideo(context);
              },
            ),

            // Favorite icon overlay
            Positioned(
              top: _getResponsiveSpacing(context, 10),
              left: _getResponsiveSpacing(context, 10),
              child: _buildFavoriteButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        final isFavorite =
            context.read<StarCubit>().isFavorite(widget.video.id);

        return GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            context.read<StarCubit>().toggleFavorite(widget.video.id);
          },
          child: Container(
            padding: EdgeInsets.all(_getResponsiveSpacing(context, 6)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey[600],
              size: _getResponsiveIconSize(context, 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: _getResponsiveSpacing(context, 4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          _buildProfilePicture(context),
          SizedBox(width: _getResponsiveSpacing(context, 12)),

          // Video Details
          Expanded(
            child: _buildVideoDetails(context),
          ),

          // Options and Rating
          _buildOptionsAndRating(context),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    // Get gender from video owner
    final isMale = (widget.video).user.gender.toLowerCase() != 'female';

    return GestureDetector(
      onTap: () => ManageVibration.vibrate(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: ImageFromInternet(
          image: widget.video.user.image,
          width: 40,
          height: 40,
          isCircle: true,
          isMale: isMale,
          defaultLogo: widget.video.user.image.isEmpty,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.video.title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getResponsiveSpacing(context, 6)),

        // Author
        Text(
          "${widget.video.user.firstName} ${widget.video.user.lastName}",
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 13),
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getResponsiveSpacing(context, 4)),

        // Views and Date
        Row(
          children: [
            Icon(
              Icons.visibility,
              size: _getResponsiveIconSize(context, 14),
              color: Colors.grey[600],
            ),
            SizedBox(width: _getResponsiveSpacing(context, 4)),
            Expanded(
              child: Text(
                "${widget.video.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(widget.video.createdAt ?? DateTime.now(), locale: context.locale.languageCode).toArabicNumbers(context)}",
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 12),
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsAndRating(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // More Options Button
        Container(
          padding: EdgeInsets.all(2),
          child: IconButton(
            onPressed: () {
              ManageVibration.vibrate();
              _showVideoOptions(context);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
              size: _getResponsiveIconSize(context, 22),
            ),
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ),
        SizedBox(height: _getResponsiveSpacing(context, 4)),

        // Star Rating
        _buildStarRating(context),
      ],
    );
  }

  Widget _buildStarRating(BuildContext context) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        // Show average rating if video has been rated (isRate == true)
        if (widget.video.isRate) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.video.averageRating
                    .toStringAsFixed(1)
                    .toArabicNumbers(context),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
            ],
          );
        }

        // Check if video has been rated
        final isVideoRated =
            context.read<StarCubit>().isVideoRated(widget.video.id);

        // Show rating stars only if video hasn't been rated and not animating
        if (!isVideoRated && !_isAnimating) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (starIndex) => GestureDetector(
                onTap: () => _onStarTap(starIndex + 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveSpacing(context, 1),
                  ),
                  child: Icon(
                    starIndex < widget.video.averageRating
                        ? Icons.star
                        : Icons.star_border,
                    color: starIndex < widget.video.averageRating
                        ? Colors.amber[600]
                        : Colors.grey[400],
                    size: _getResponsiveIconSize(context, 18),
                  ),
                ),
              ),
            ),
          );
        }

        // Animated stars during rating selection
        if (_selectedRating != null && _isAnimating) {
          return AnimatedOpacity(
            opacity: _shouldFadeOut ? 0.0 : 1.0,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (starIndex) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveSpacing(context, 1),
                  ),
                  child: Icon(
                    starIndex < _selectedRating!
                        ? Icons.star
                        : Icons.star_border,
                    color: starIndex < _selectedRating!
                        ? Colors.amber[600]
                        : Colors.grey[400],
                    size: _getResponsiveIconSize(context, 18),
                  ),
                ),
              ),
            ),
          );
        }

        // Final rating display - show single star with rating number
        if (_showFinalRating && _selectedRating != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedRating.toString().toArabicNumbers(context),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.star,
                color: Colors.amber[600],
                size: _getResponsiveIconSize(context, 18),
              ),
            ],
          );
        }

        // Default case - show current rating as read-only
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (starIndex) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSpacing(context, 1),
              ),
              child: Icon(
                starIndex < widget.video.averageRating
                    ? Icons.star
                    : Icons.star_border,
                color: starIndex < widget.video.averageRating
                    ? Colors.amber[600]
                    : Colors.grey[400],
                size: _getResponsiveIconSize(context, 18),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToVideo(BuildContext context) {
    // Check if video is approved/available
    if (!widget.video.isApproved) {
      // Show message that video is not available yet
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       context.isArabic
      //           ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
      //           : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.',
      //     ),
      //     duration: Duration(seconds: 4),
      //     backgroundColor: Colors.orange[700],
      //   ),
      // );
      showSuccessMessage(
        context,
        context.isArabic
            ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
            : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.',
      );
      return;
    }

    final mediaUrl = widget.video.mediaUrl.isNotEmpty
        ? widget.video.mediaUrl.first.mediaKey
        : '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<StarCubit>.value(
              value: widget.starCubit ?? context.read<StarCubit>(),
            ),
            BlocProvider<CommentCubit>(
              create: (context) => serviceLocator<CommentCubit>(),
            ),
          ],
          child: TalentVideoPlayer(
            videoUrl: mediaUrl,
            talent: widget.video,
          ),
        ),
      ),
    );
  }

  // void _showVideoOptions(BuildContext context) {
  //   final cubit = context.read<StarCubit>();

  //   OptionsBottomSheet.showOptions(
  //     context: context,
  //     options: [
  //       OptionItem(
  //         icon: Icons.playlist_add,
  //         title: context.isArabic ? 'إنشاء قائمة' : 'Play next in queue',
  //         onTap: () => Navigator.pop(context),
  //       ),
  //       OptionItem(
  //         icon: Icons.block,
  //         title: context.isArabic ? 'غير مهتم' : 'Not interested',
  //         onTap: () => Navigator.pop(context),
  //       ),
  //       OptionItem(
  //         icon: cubit.isFavorite(video.id)
  //             ? Icons.favorite
  //             : Icons.favorite_border,
  //         title: cubit.isFavorite(video.id)
  //             ? (context.isArabic
  //                 ? 'إزالة من المفضلة'
  //                 : 'Remove from favorites')
  //             : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
  //         onTap: () {
  //           Navigator.pop(context);
  //           cubit.toggleFavorite(video.id);
  //         },
  //       ),
  //       OptionItem(
  //         icon: Icons.flag,
  //         title: context.isArabic ? 'إبلاغ' : 'Report',
  //         iconColor: Colors.red,
  //         textColor: Colors.red,
  //         onTap: () => Navigator.pop(context),
  //       ),
  //     ],
  //   );
  // }

  void _showVideoOptions(BuildContext context) {
    final cubit = context.read<StarCubit>();

    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'إضافة إلى قائمة تشغيل' : 'Add to playlist',
          onTap: () {
            Navigator.pop(context);
            _showPlaylistBottomSheet(context, widget.video);
          },
        ),
        OptionItem(
          icon: Icons.playlist_play,
          title: context.isArabic ? 'تشغيل التالي' : 'Play next in queue',
          onTap: () {
            Navigator.pop(context);
            PlayNextQueueManager().addToPlayNext(widget.video);
            showSuccessMessage(
              context,
              context.isArabic
                  ? 'تمت إضافة الفيديو لقائمة التشغيل التالي'
                  : 'Video added to play next queue',
            );
          },
        ),
        // OptionItem(
        //   icon: Icons.block,
        //   title: context.isArabic ? 'غير مهتم' : 'Not interested',
        //   onTap: () => Navigator.pop(context),
        // ),
        OptionItem(
          icon: cubit.isFavorite(widget.video.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(widget.video.id)
              ? (context.isArabic
                  ? 'إزالة من المفضلة'
                  : 'Remove from favorites')
              : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite(widget.video.id);
          },
        ),
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'إبلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

// Add this helper method to video_card_widget.dart:
  void _showPlaylistBottomSheet(BuildContext context, StarEntity video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: PlaylistBottomSheet(video: video),
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }

  double _getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8;
    }
    return baseRadius;
  }
}
