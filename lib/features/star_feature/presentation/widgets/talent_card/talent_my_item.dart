import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../data/model/tube_video_models.dart';
import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../pages/my_video_details_view.dart';

class TalentMyItem extends StatefulWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final int index;
  final Function(StarEntity, String)? onVideoTap;

  const TalentMyItem({
    super.key,
    required this.talent,
    required this.cubit,
    required this.index,
    this.onVideoTap,
  });

  @override
  State<TalentMyItem> createState() => _TalentMyItemState();
}

class _TalentMyItemState extends State<TalentMyItem>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaUrl =
        widget.talent.mediaUrl.isNotEmpty ? widget.talent.mediaUrl.first.mediaKey : '';
    final createdAt = widget.talent.createdAt ?? DateTime.now();

    // Check if it's a TubeVideo to get additional info
    final tubeVideo =
        widget.talent is TubeVideoModel ? widget.talent as TubeVideoModel : null;
    final thumbnailUrl = tubeVideo?.thumbnail;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, _slideAnimation.value)
            ..rotateZ(_rotationAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                if (widget.onVideoTap != null) {
                  widget.onVideoTap!(widget.talent, mediaUrl);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetailsView(
                        talent: widget.talent,
                        mediaUrl: mediaUrl,
                        cubit: widget.cubit,
                      ),
                    ),
                  );
                }
              },
              child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (context.isDarkMode ? Colors.black : Colors.grey)
                  .withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail section
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: context.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              child: Stack(
                children: [
                  // Background thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.video_library,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.video_library,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),

                  // Play button overlay
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Duration badge
                  if (tubeVideo != null && tubeVideo.duration > 0)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(tubeVideo.duration)
                              .toArabicNumbers(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Video info section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: widget.talent.user.image.isNotEmpty
                      ? NetworkImage(widget.talent.user.image)
                      : null,
                  child: widget.talent.user.image.isEmpty
                      ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                      : null,
                ),
                SizedBox(width: 12),

                // Title and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.talent.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.talent.user.firstName} ${widget.talent.user.lastName}",
                        style: TextStyle(
                          fontSize: 13,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Stats row
                      Row(
                        children: [
                          Icon(Icons.visibility,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            "${widget.talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("•", style: TextStyle(color: Colors.grey[600])),
                          SizedBox(width: 8),
                          Text(
                            timeago
                                .format(createdAt,
                                    locale: context.locale.languageCode)
                                .toArabicNumbers(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // // More options button
                // IconButton(
                //   onPressed: () => _showVideoOptions(context),
                //   icon: Icon(
                //     Icons.more_vert,
                //     color: Colors.grey[600],
                //     size: 20,
                //   ),
                //   padding: EdgeInsets.zero,
                //   constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                // ),
              ],
            ),

            // Stats row for tube videos
            if (tubeVideo != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  if (tubeVideo.likes > 0) ...[
                    Icon(Icons.thumb_up_outlined, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      tubeVideo.likes.toShortScale.toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  if (tubeVideo.dislikes > 0) ...[
                    Icon(Icons.thumb_down_outlined,
                        size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      tubeVideo.dislikes.toShortScale.toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  if (widget.talent.averageRating > 0) ...[
                    RatingBarIndicator(
                      rating: widget.talent.averageRating.toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 14.0,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${widget.talent.averageRating}".toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    if (duration.inHours > 0) {
      return "${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
    } else {
      return "${duration.inMinutes}:${twoDigits(duration.inSeconds.remainder(60))}";
    }
  }

  // void _showVideoOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: context.isDarkMode ? Colors.grey[900] : Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) => Container(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: 40,
  //             height: 4,
  //             decoration: BoxDecoration(
  //               color: context.isDarkMode ? Colors.grey[600] : Colors.grey[300],
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //           SizedBox(height: 16),
  //           // Only show delete option
  //           ListTile(
  //             leading: Icon(
  //               Icons.delete_outline,
  //               color: Colors.red[600],
  //               size: 24,
  //             ),
  //             title: Text(
  //               context.isArabic ? 'حذف الفيديو' : 'Delete Video',
  //               style: TextStyle(
  //                 color: Colors.red[600],
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             subtitle: Text(
  //               context.isArabic
  //                   ? 'لا يمكن التراجع عن هذا الإجراء'
  //                   : 'This action cannot be undone',
  //               style: TextStyle(
  //                 color: Colors.grey[500],
  //                 fontSize: 12,
  //               ),
  //             ),
  //             onTap: () {
  //               ManageVibration.vibrate();
  //               Navigator.pop(context);
  //               // _showDeleteDialog(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<bool> _showDeleteDialog() async {
    return await showAnimatedDialog(
      context,
      AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titlePadding: const EdgeInsets.only(top: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          context.isArabic ? "تنبيه" : "Alert",
          style: Styles.headerText(
              color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: context.isArabic
                  ? "هل تريد حذف الفيديو؟"
                  : "Do you want to delete the video?",
              style: Styles.mediumText(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: buildButton(
                    context,
                    label: LocaleKeys.yes.localize,
                    color: AppColors.SECONDARY_COLOR,
                    onTap: () {
                      ManageVibration.vibrate();
                      Navigator.of(context).pop(true);
                      widget.cubit.deleteMyTubeVideo(widget.talent.id);
                    },
                  ),
                ),
                Expanded(
                  child: buildButton(
                    context,
                    label: LocaleKeys.no.localize,
                    onTap: () {
                      ManageVibration.vibrate();
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) ?? false;
  }
}
