import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/show_comments_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import '../widgets/components/unified_widget_view.dart';
import 'audio_screen.dart';

class ReelActions extends StatefulWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const ReelActions({super.key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  State<ReelActions> createState() => _ReelActionsState();
}

class _ReelActionsState extends State<ReelActions> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery
        .of(context)
        .size
        .height;
    final double width = MediaQuery
        .of(context)
        .size
        .width;

    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            // textDirection: TextDirection.ltr,

            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _UserSection(reel: widget.reel),
                    const SizedBox(height: 4),
                    // _AudioAndButtons(reel: widget.reel, width: width),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: AdvancedTikTokReactionsColumn(
                  reel: widget.reel,
                  itemType: widget.itemType,
                  rotationController: widget.rotationController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display user avatar and information.
class _UserSection extends StatelessWidget {
  final Reel reel;

  const _UserSection({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        _UserInfo(reel: reel),
      ],
    );
  }
}

/// Widget to display the user's avatar.
class _UserAvatar extends StatelessWidget {
  final Reel reel;

  const _UserAvatar({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.h,
      height: 90.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!serviceLocator<UserCubit>().isLoggedIn) {
            context.push(Routes.LOGIN);
          } else {
            context.push(Routes.OTHERSACCOUNT, extra: reel.user.id);
          }
        },
        child: CircleAvatar(
          // radius: reel.user.profilePictureSignedUrl != null
          //     ? 70.h
          //     : 20.h, // Adjust based on item type if needed
          backgroundImage: reel.user.profilePictureSignedUrl != null
              ? CachedNetworkImageProvider(reel.user.profilePictureSignedUrl!)
              : null,
          child: reel.user.profilePictureSignedUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

/// Widget to display the user's name and reel details.
class _UserInfo extends StatefulWidget {
  final Reel reel;

  const _UserInfo({required this.reel});

  @override
  State<_UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<_UserInfo> {
  String get _displayName =>
      capitalizeAndSplit(
          '${widget.reel.user.firstName} ${widget.reel.user.lastName}');

  String get _displayReelName {
    final maxLength = (widget.reel.name.length * 0.75).round();
    return "${widget.reel.name.substring(0, maxLength)}...";
  }

  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
            }
          },
          child: Row(
            children: [
              Text(
                _displayName,
                textScaler: TextScaler.noScaling,
                style: _nameTextStyle,
              ),
              if (widget.reel.user.verified)
                const Icon(
                  Icons.verified,
                  color: AppColors.PRIMARY_COLOR_DARK,
                  size: 25,
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isCollapsed = !_isCollapsed;
            });
          },
          child: SizedBox(
            width: 0.7.sw,
            child: ReadMoreText(
              "${widget.reel.name}\n${widget.reel.audio
                  .audioName}\nعايز نحط ايه هنا  ",
              trimLines: 1,
              colorClickableText: AppColors.PRIMARY_COLOR_DARK,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' See more',
              trimExpandedText: ' Hide',
              // isExpandable: ,
              isCollapsed: ValueNotifier(_isCollapsed),
              textScaler: TextScaler.noScaling,
              lessStyle: Styles.headerText(
                color: AppColors.PRIMARY_COLOR_DARK,
              ),
              moreStyle: Styles.headerText(
                fontSize: 30,
                color: AppColors.PRIMARY_COLOR_DARK,
              ),
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
        ),
        // _ReelDetails(name: _displayReelName, viewCount: reel.viewCount),
      ],
    );
  }

  TextStyle get _nameTextStyle =>
      TextStyle(
        fontSize: 50.sp,
        color: Colors.white,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display reel name and view count.
class _ReelDetails extends StatelessWidget {
  final String name;
  final int viewCount;

  const _ReelDetails({
    required this.name,
    required this.viewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
        const SizedBox(width: 16),
        FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          viewCount.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
      ],
    );
  }

  TextStyle get _detailsTextStyle =>
      TextStyle(
        fontSize: 30.sp,
        color: Colors.white60,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display audio information and associated buttons.
class _AudioAndButtons extends StatelessWidget {
  final Reel reel;
  final double width;

  const _AudioAndButtons({
    required this.reel,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.2),
      child: ScrollingText(text: reel.audio.audioName),
    );
  }
}

class AdvancedTikTokReactionsColumn extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const AdvancedTikTokReactionsColumn({
    super.key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  static double iconSize = 0.1.sw;
  static const TextStyle countTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const List<Shadow> iconShadows = [
    Shadow(
      blurRadius: 10,
      color: Colors.black26,
      offset: Offset(0, 3),
    ),
  ];

  // SVG string for the comment icon
  static const String commentIconSvg = '''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" viewBox="0 0 2048 1926" width="152" height="143" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="10" dy="10" stdDeviation="10" flood-color="black"/>
    </filter>
  </defs>

  <!-- Apply the shadow to the following paths -->
  <path transform="translate(1008,507)" d="m0 0h34l32 2 37 4 33 5 29 6 36 10 35 12 37 15 28 14 28 17 16 10 19 13 11 8 13 10 15 13 7 7 6 5 6 7 8 7 8 9 13 13 11 14 9 11 14 19 14 21 11 19 11 21 11 25 8 20 9 27 7 32 6 32 3 26v48l-3 28-5 29-7 28-12 36-13 31-8 16-11 21-13 21-16 23-13 18-11 14-12 14-22 24-40 40-8 7-16 15-8 7-10 9-14 11-18 14-14 10-16 12-16 11-14 10-15 10-17 11-44 28-29 17-19 11-28 15-21 10-17 5-8-1-8-5-4-5-3-8-2-14-1-17v-74l-1-2-15-2-41-3-27-3-36-6-40-8-40-10-36-12-31-12-18-8-24-12-24-14-20-12-12-8-19-14-15-13-13-12-8-7-29-29-7-8-9-11-14-19-11-17-10-17-8-16-9-19-10-26-10-30-7-30-4-26-3-27-1-22v-13l2-24 7-42 8-34 6-20 8-22 10-23 14-29 15-25 15-22 14-19 14-18 12-13 4-5h2l2-4h2l2-4 17-16 11-10 11-9 18-14 42-28 20-12 18-10 17-9 33-14 38-13 30-8 29-7 30-5 42-5z" fill="#F5F5F5" filter="url(#shadow)"/>

  <path transform="translate(1026,922)" d="m0 0 17 1 15 4 13 7 9 7 6 5 10 13 7 14 4 13 1 5v17l-4 19-9 17-9 11-12 9-12 6-12 4-11 2h-24l-15-4-16-8-11-9-7-8-7-11-5-11-3-11v-21l4-18 6-14 10-13 7-7 15-10 11-5 12-3z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(1281,923)" d="m0 0h24l12 3 13 5 14 9 8 7 9 13 5 10 3 9 3 15v16l-5 18-7 13-11 12-10 9-14 8-13 5-9 2h-22l-15-4-12-6-9-7-8-7-10-13-7-12-5-14-1-6v-15l3-15 8-17 8-11 9-10 13-9 12-5z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(757,923)" d="m0 0h19l14 3 16 8 11 8 14 14 8 14 4 11 2 16-1 14-5 17-9 15-11 13-13 9-12 6-21 5h-23l-12-3-16-8-10-8-9-10-8-14-5-13-2-10v-20l3-14 5-12 6-9 11-12 13-10 11-5 14-4z" fill="#1E1D29" filter="url(#shadow)"/>
</svg>

  ''';

  @override
  Widget build(BuildContext context) {
    final ReelsCubit reelsCubit = context.read<ReelsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Profile Icon with Plus Button (Follow)
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _UserAvatar(reel: reel),
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.red,
            //       borderRadius: BorderRadius.circular(15),
            //       border: Border.all(color: Colors.white, width: 2),
            //     ),
            //     child: const Icon(Icons.add, color: Colors.white, size: 15),
            //   ),
            // ),
          ],
        ).animate().scale(duration: 200.ms),
        const SizedBox(height: 12),

        // Heart Icon (Like)
        _buildReactionButton(
          iconWidget: Icon(
            Icons.favorite,
            size: iconSize,
            color: reel.likeCount > 0 ? Colors.pinkAccent : Colors.white,
            shadows: iconShadows,
          ),
          count: reel.likeCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleLikeAction(context, reelsCubit);
            }
          },
        ),
        // const SizedBox(height: 4),

        // Comment Icon
        _buildReactionButton(
          iconWidget: SizedBox(
            child: SvgPicture.string(
              commentIconSvg,
              width: 0.15.sw,
              height: 0.15.sw,
              fit: BoxFit.contain,
            ),
          ),
          count: reel.commentCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleCommentAction(context, reelsCubit);
            }
          },
        ),
        // const SizedBox(height: 6),

        // Bookmark Icon
        _buildReactionButton(
          iconWidget: Icon(
            Icons.bookmark,
            size: iconSize,
            color: reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
            shadows: iconShadows,
          ),
          count: reel.saveCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleSaveAction(context, reelsCubit);
            }
          },
        ),
        // const SizedBox(height: 6),

        // Share Icon (Reversed)
        _buildReactionButton(
          iconWidget: Icon(
            Icons.reply,
            size: iconSize,
            color: Colors.white,
            shadows: iconShadows,
          ),
          count: reel.shareCount.toString(),
          isReversed: true,
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleShareAction(context, reel.videoMedia);
            }
          },
        ),
        // const SizedBox(height: 6),

        // Gift Icon
        _buildReactionButton(
          iconWidget: Icon(
            Icons.card_giftcard,
            size: iconSize,
            color: Colors.white,
            shadows: iconShadows,
          ),
          count: '',
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _showGiftBottomSheet(context);
            }
          },
        ),
        // const SizedBox(height: 6),

        // Report Icon
        _buildReactionButton(
          iconWidget: Icon(
            Icons.report,
            size: iconSize,
            color: Colors.white,
            shadows: iconShadows,
          ),
          count: '',
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _showReportBottomSheet(context);
            }
          },
        ),
        // const SizedBox(height: 6),

        if (itemType != ReelItemType.instagram)
          RotatingCircularButton(
            reel: reel,
            rotationController: rotationController,
          ),
      ],
    );
  }

  // Helper widget for building reaction buttons with scaling animation
  Widget _buildReactionButton({
    required Widget iconWidget,
    required VoidCallback onTap,
    required String count,
    bool isReversed = false,
  }) {
    final Widget animatedIcon = iconWidget.animate().scale(duration: 200.ms);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          isReversed
              ? Directionality(
            textDirection: TextDirection.rtl,
            child: animatedIcon,
          )
              : animatedIcon,
          Text(
            count,
            style: countTextStyle,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLikeAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.likeReel(reel.id).then((_) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          reel.likeCount++;
        } else if (response?.message == "Reel unlike successfully") {
          if (reel.likeCount > 0) reel.likeCount--;
        }
      });

      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  Future<void> _handleCommentAction(BuildContext context,
      ReelsCubit cubit) async {
    try {
      await showCommentsBottomSheet(context, reel: reel);
    } catch (e) {
      _showSnackBar(context, 'Error showing comments: $e');
    }
  }

  Future<void> _handleShareAction(BuildContext context, String videoUrl) async {
    await Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.saveReel(reel.id);
      final response = cubit.state.reelSaveResponse;
      if (response?.message == "saved successfully") {
        reel.saveCount++;
      } else if (response?.message == "unsaved successfully") {
        if (reel.saveCount > 0) reel.saveCount--;
      }
      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error saving reel: $e');
    }
  }

  Future<void> _showGiftBottomSheet(BuildContext context) async {
    await showGiftBottomSheet(context, receiverId: reel.user.id);
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: reel.user.id,
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const _ActionButtons({
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    final ReelsCubit reelsCubit = context.read<ReelsCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ActionButton(
            icon: reel.likeCount > 0
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart,
            count: reel.likeCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _handleLikeAction(context, reelsCubit);
              }
            },
            iconColor: reel.likeCount == 0 ? Colors.white : Colors.red,
          ),
          _ActionButton(
            icon: FontAwesomeIcons.comment,
            count: reel.commentCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _handleCommentAction(context, reelsCubit);
              }
            },
          ),
          _ActionButton(
            icon: FontAwesomeIcons.paperPlane,
            count: reel.shareCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _handleShareAction(context, reel.videoMedia);
              }
            },
          ),
          _ActionButton(
            icon: reel.saveCount == 0
                ? FontAwesomeIcons.bookmark
                : FontAwesomeIcons.solidBookmark,
            count: reel.saveCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _handleSaveAction(context, reelsCubit);
              }
            },
            iconColor: reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
          ),
          _ActionButton(
            icon: Icons.card_giftcard,
            count: 0,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _showGiftBottomSheet(context);
              }
            },
          ),
          _ActionButton(
            icon: Icons.report_outlined,
            count: 0,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                _showReportBottomSheet(context);
              }
            },
          ),
          if (itemType != ReelItemType.instagram)
            RotatingCircularButton(
              reel: reel,
              rotationController: rotationController,
            ),
        ],
      ),
    );
  }

  Future<void> _handleLikeAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.likeReel(reel.id).then((value) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          (++reel.likeCount);
        } else if (response?.message == "Reel unlike successfully") {
          if (reel.likeCount > 0) --reel.likeCount;
        }
      });

      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  Future<void> _handleCommentAction(BuildContext context,
      ReelsCubit cubit) async {
    try {
      await cubit.getComments(reel.id);
    } catch (e) {
      _showSnackBar(context, 'Error fetching comments: $e');
    }
  }

  Future<void> _handleShareAction(context, String videoUrl) async {
    await Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.saveReel(reel.id);
      final response = cubit.state.reelSaveResponse;
      if (response?.message == "saved successfully") {
        (reel.saveCount++);
      } else if (response?.message == "unsaved successfully") {
        (reel.saveCount--);
      }
      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error saving reel: $e');
    }
  }

  Future<void> _showGiftBottomSheet(BuildContext context) async {
    await showGiftBottomSheet(context, receiverId: reel.user.id);
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: reel.user.id,
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Widget for individual action buttons.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: iconColor ?? Colors.white,
            size: 45.h,
          ),
          SizedBox(height: 4.h),
          Text(
            (count > 0) ? '$count' : '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
            style: _countTextStyle,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  TextStyle get _countTextStyle =>
      TextStyle(
        height: 1.h,
        fontSize: 30.sp,
        color: Colors.white,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(
            offset: Offset(0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// A rotating circular button widget for audio interaction
class RotatingCircularButton extends StatelessWidget {
  final Reel reel;
  final AnimationController rotationController;

  const RotatingCircularButton({
    super.key,
    required this.reel,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: RotationTransition(
        turns: rotationController,
        child: Container(
          width: 65.h,
          height: 65.h,
          decoration: BoxDecoration(
            color: reel.audio.audioPicture.isEmpty
                ? Colors.black
                : Colors.transparent,
            image: reel.audio.audioPicture.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(reel.audio.audioPicture),
              fit: BoxFit.cover,
              onError: (_, __) {},
            )
                : null,
          ),
          child: InkWell(
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BlocProvider.value(
                          value: serviceLocator<ReelsCubit>()
                            ..fetchReelsWithSameAudio(reel.audio.id),
                          child: InstagramAudioScreen(
                            audio: reel.audio,
                            reel: reel,
                          ),
                        ),
                  ),
                );
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Icon(
                    FontAwesomeIcons.music,
                    size: 30.w,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 1.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
