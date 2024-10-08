import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'audio_screen.dart';

/// A unified reel item widget that can function as MainReelItem, ReelItemForInstagram, or SpotlightReelItem.

/// Widget to display reel information such as user info, actions, and audio.
class ReelInfo extends StatefulWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const ReelInfo({
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  State<ReelInfo> createState() => _ReelInfoState();
}

class _ReelInfoState extends State<ReelInfo> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
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
        SizedBox(
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
  String get _displayName => capitalizeAndSplit(
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
              "${widget.reel.name}\n${widget.reel.audio.audioName}\nعايز نحط ايه هنا  ",
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

  TextStyle get _nameTextStyle => TextStyle(
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

  TextStyle get _detailsTextStyle => TextStyle(
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

/// Widget to display action buttons like like, comment, share, etc.
///
///

class AdvancedTikTokReactionsColumn extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const AdvancedTikTokReactionsColumn(
      {super.key,
      required this.reel,
      required this.itemType,
      required this.rotationController});

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
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 15),
              ),
            ),
          ],
        ).animate().scale(duration: 200.ms), // Simple scaling animation
        const SizedBox(height: 6),

        // Heart Icon (Like) with Animation
        /*


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

       */
        _buildReactionButton(
          icon: Icons.favorite,
          color: reel.likeCount > 0 ? Colors.pinkAccent : Colors.white,
          count: reel.likeCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleLikeAction(context, reelsCubit);
            }
          },
        ),
        const SizedBox(height: 4),

        // Comment Icon
        _buildReactionButton(
          icon: Icons.chat_bubble,
          color: Colors.white,
          count: reel.commentCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleCommentAction(context, reelsCubit);
            }
          },
        ),
        const SizedBox(height: 4),

        // Bookmark Icon
        _buildReactionButton(
          icon: Icons.bookmark,
          color: reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
          count: reel.saveCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleSaveAction(context, reelsCubit);
            }
          },
        ),
        const SizedBox(height: 4),

        // Share Icon (Note: reversed arrow for "Share")
        _buildReactionButton(
          icon: Icons.reply,
          color: Colors.white,
          count: reel.shareCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleShareAction(context, reel.videoMedia);
            }
          },
        ),
        const SizedBox(height: 4),

        // card_giftcard_outlined Icon (Note: reversed arrow for "Share")
        _buildReactionButton(
          icon: Icons.card_giftcard,
          color: Colors.white,
          count: '0',
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _showGiftBottomSheet(context);
            }
          },
        ),
        const SizedBox(height: 4),

        // report Icon (Note: reversed arrow for "Share")
        _buildReactionButton(
          icon: Icons.report,
          color: Colors.white,
          count: '0',
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _showReportBottomSheet(context);
            }
          },
        ),
        const SizedBox(height: 4),

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
    required IconData icon,
    required VoidCallback onTap,
    required String count,
    required Color color,
    bool isReversed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Icon(
              icon,
              size: 0.1.sw,
              color: color,
              shadows: [
                Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 3))
              ],
            ).animate().scale(duration: 200.ms),
          ),
          const SizedBox(height: 2),
          if (count.isNotEmpty && count != '0')
            Text(
              count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            )
          // else
          //   const Text(
          //     '',
          //     // '1551.5k',
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 13,
          //         fontWeight: FontWeight.w600),
          //   ),
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

  Future<void> _handleCommentAction1(
      BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.getComments(reel.id);
    } catch (e) {
      _showSnackBar(context, 'Error fetching comments: $e');
    }
  }

  Future<void> _handleCommentAction(context, ReelsCubit reelsCubit) async {
    try {
      // await reelsCubit.getComments(reel.id);
      // _togglePlayPause();

      await showCommentsBottomSheet(context, reel: reel);
      // _togglePlayPause();
    } catch (e) {
      // Handle error (e.g., show a snackbar)
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
      backgroundColor: Colors.transparent,
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
    // await bottomSheet(
    //   context: context,
    //   widget: ReportView(
    //     id: reel.user.id,
    //     categoryId: '66684135dbb427ee42aa0141',
    //   ),
    // );
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

  Future<void> _handleCommentAction(
      BuildContext context, ReelsCubit cubit) async {
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
    await bottomSheet(
      context: context,
      widget: ReportView(
        id: reel.user.id,
        categoryId: '66684135dbb427ee42aa0141',
      ),
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

  TextStyle get _countTextStyle => TextStyle(
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
                    builder: (context) => BlocProvider.value(
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
