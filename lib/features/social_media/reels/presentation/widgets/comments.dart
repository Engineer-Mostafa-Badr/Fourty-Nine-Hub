import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/no_scale_text.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../tinder/data/shared/shared.dart';

class CommentWidget extends StatefulWidget {
  // final CommentData commentData;
  final int index;
  final FocusNode focusNode;
  String? replyingTo;
  final TextEditingController commentController;
  CommentWidget(
      {super.key,
      //  required this.commentData,
      required this.focusNode,
      required this.index,
      this.replyingTo,
      required this.commentController});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isRepliesVisible = false;
  int _displayedRepliesCount = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  side: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                builder: (context) {
                  return SendBottomSheet();
                },
              );
            },
            child: _buildCommentRow(
              'Ahmed',
              DateTime.now(),
              false,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  side: BorderSide(
                    color: Colors.transparent,
                  ), // حدود زي اللي في الصورة
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DeleteComment(Assets.deleteComIcon,
                            context.isArabic ? 'حذف' : 'Delete'),
                        DeleteComment(Assets.copyComIcon,
                            context.isArabic ? 'نسخ' : 'Copy'),
                        DeleteComment(
                            Assets.replyIcon,
                            context.isArabic
                                ? 'الرد بالفيديو'
                                : 'Reply with video'),
                        DeleteComment(
                            Assets.addFavIcon,
                            context.isArabic
                                ? 'أضف إلى المفضلة'
                                : 'Add to favourites'),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.more_horiz),
          ),
          SizedBox(height: 0.h),
          _buildToggleRepliesButton(),
          if (_isRepliesVisible) ...[
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isRepliesVisible
                  ? InkWell(
                      onTap: () {
                        showTikTokStyleReplySheet(context, 'Ahmed', 50);
                      },
                      child: _buildRepliesList(),
                    )
                  : Container(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentRow(String comment, DateTime createdAt, bool reply,
      {String? replyId}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageFromInternet(
          width: 50,
          height: 50,
          isCircle: true,
          image: "",
          //  widget.commentData.user.profilePictureSignedUrl.isEmpty
          //     ? UIConst.profilePlaceHolder
          //     : widget.commentData.user.profilePictureSignedUrl,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoScaleText(
                capitalizeAndSplit('${"ahmed "} ${'ahmed'}'),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 5.h),
              NoScaleText(
                comment,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 25.sp,
                ),
              ),
              Row(
                children: [
                  NoScaleText(
                    formatDateTime(createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  _buildReplyButton(),
                  const Spacer(),
                  _buildLikeButton(reply, replyId: replyId),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyRow(String comment, DateTime createdAt, bool reply,
      {String? replyId, bool? isLike, int? replyCount}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageFromInternet(
          width: 50,
          height: 50,
          isCircle: true,
          image: '',
          // ? UIConst.profilePlaceHolder
          // : widget.commentData.user.profilePictureSignedUrl,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoScaleText(
                capitalizeAndSplit('${'ahmed'} ${'mohamed'}'),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 5.h),
              NoScaleText(
                comment,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 25.sp,
                ),
              ),
              Row(
                children: [
                  NoScaleText(
                    formatDateTime(createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  _buildReplyButton(),
                  const Spacer(),
                  _buildReplyLikeButton(reply,
                      replyId: replyId, isLike: isLike, likeCount: replyCount),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleReplyMode(String? userName) {
    setState(() {
      context.read<ReelsCubit>().updateParentCommentIdAndReceiverComment(
          parentCommentId: '5', receiverComment: '2');
      widget.replyingTo = userName;
      if (userName != null) {
        widget.commentController.text = '@$userName ';
        widget.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.commentController.text.length),
        );
        widget.focusNode.requestFocus();
      } else {
        widget.commentController.clear();
        widget.focusNode.unfocus();
      }
    });
  }

  Widget _buildReplyButton() {
    return InkWell(
      onTap: () {
        _toggleReplyMode('${'Ahmed'} ${'yousef'}');
      },
      child: NoScaleText(
        LocaleKeys.reply.localize,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildLikeButton(bool reply, {String? replyId}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.favorite, color: AppColors.PRIMARY_COLOR_DARK
              //  AppColors.GREY_NORMAL_COLOR,
              ),
          onPressed: () {
            _handleLikeComment('5', reply, replyId: replyId);
          },
        ),
        NoScaleText(
          '24',
          style: TextStyle(
            color: context.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
        SizedBox(width: 48.w),
        SvgPicture.asset(Assets.disLikeIcon),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _buildReplyLikeButton(bool reply,
      {String? replyId, bool? isLike, int? likeCount}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: isLike == true
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.GREY_NORMAL_COLOR,
          ),
          onPressed: () {
            _handleLikeComment('5', reply, replyId: replyId);
          },
        ),
        NoScaleText(
          likeCount.toString(),
          style: TextStyle(
            color: context.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  void _handleLikeComment(String commentId, bool isReply, {String? replyId}) {
    print('isReply : $isReply');
    context
        .read<ReelsCubit>()
        .toggleCommentLike(commentId, isReply, replyId: replyId)
        .then((_) {
      FocusScope.of(context).unfocus();
    }).catchError((error) {
      _showErrorSnackBar('Failed to send like. Please try again.');
    });
  }

  Widget _buildToggleRepliesButton() {
    final remainingReplies = -_displayedRepliesCount;
    final buttonText = _isRepliesVisible
        ? (remainingReplies > 0
            ? "View ${remainingReplies > 2 ? 'More' : remainingReplies} Replies"
            : "Hide Replies")
        : "View ${3} ${1 == 1 ? 'Reply' : 'Replies'}";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_isRepliesVisible && remainingReplies > 0) {
              _displayedRepliesCount += 3;
            } else {
              _isRepliesVisible = !_isRepliesVisible;
              if (!_isRepliesVisible) {
                _displayedRepliesCount = 3;
              }
            }
          });
        },
        child: Row(
          children: [
            Text(
              buttonText,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600),
            ),
            _isRepliesVisible
                ? const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesList() {
    // final repliesToShow =
    //     widget.commentData.replies.take(_displayedRepliesCount).toList();
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
      child: ListView(
          shrinkWrap: true,
          //     controller: context.read<ReelsCubit>().replyScrollController,
          children: [
            _buildReplyRow(
              'Ahmed',
              DateTime.now(),
              replyCount: 5,
              isLike: true,
              replyId: '5',
              false,
            ),
          ]),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class SendBottomSheet extends StatefulWidget {
  const SendBottomSheet({super.key});

  @override
  State<SendBottomSheet> createState() => _SendBottomSheetState();
}

class _SendBottomSheetState extends State<SendBottomSheet> {
  bool showExtraContainer = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              context.isArabic ? 'أرسل إلى' : 'Send to',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  "https://i.pravatar.cc/150?img=3"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "AHMED",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xffEDEDED),
                        child: Icon(
                          Icons.search,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        context.isArabic ? 'المزيد' : 'More',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 42.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showExtraContainer = !showExtraContainer;
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.shareWithIcon,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            context.isArabic ? 'شارك مع' : 'Share with',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 12),
                    if (!showExtraContainer) ...[
                      CircleAvatar(
                        backgroundColor: Color(0xff25D366),
                        child: SvgPicture.asset(
                          Assets.whatsIcon,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xffF5F5F5),
                        child: Image.asset(
                          Assets.facebookMessenger,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(Assets.faceIcon),
                    ],
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showExtraContainer = !showExtraContainer;
                        });
                      },
                      child: SvgPicture.asset(
                        Assets.arrowIcon,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (showExtraContainer) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SocialWidget(
                              icon: Assets.whatsIcon,
                              backGroundColor: 0xff25D366,
                            ),
                            SocialWidget(
                              icon: Assets.facebookMessenger,
                              backGroundColor: 0xffFFFC00,
                            ),
                            SocialWidget(
                              icon: Assets.faceIcon,
                              backGroundColor: 0,
                            ),
                            SocialWidget(
                              icon: Assets.faceIcon,
                              backGroundColor: 0,
                            ),
                            SocialWidget(
                              icon: Assets.coppyLinkIcon,
                              backGroundColor: 0xff2E75FD,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SocialWidget(
                              icon: Assets.telegramIcon,
                              backGroundColor: 0xff24A1DE,
                            ),
                            SocialWidget(
                              icon: Assets.snapIcon,
                              backGroundColor: 0xffFFFC00,
                            ),
                            SocialWidget(
                              icon: Assets.smsIcon,
                              backGroundColor: 0xff34C759,
                            ),
                            SocialWidget(
                              icon: Assets.emailIcon,
                              backGroundColor: 0xff04B7C4,
                            ),
                            SocialWidget(
                              color: AppColors.whiteColor,
                              icon: Assets.moreIcon,
                              backGroundColor: 0xff078AC9,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 31),
          IconAndTextWidget(
            name: context.isArabic ? 'الإبلاغ' : 'Report',
            icon: Assets.reportComIcon,
          ),
          const SizedBox(height: 20),
          IconAndTextWidget(
            name: context.isArabic ? 'نسخ' : 'Copy',
            icon: Assets.copyComIcon,
          ),
          const SizedBox(height: 20),
          IconAndTextWidget(
            name: context.isArabic ? 'اضافة للمفضلة' : 'Add to favourites',
            icon: Assets.addFavIcon,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SocialWidget extends StatelessWidget {
  final String icon;
  final int backGroundColor;
  final Color? color;
  final void Function()? onTap;
  const SocialWidget({
    super.key,
    required this.icon,
    required this.backGroundColor,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Color(backGroundColor),
        child: SvgPicture.asset(
          color: color,
          icon,
        ),
      ),
    );
  }
}

class IconAndTextWidget extends StatelessWidget {
  final String name;
  final String icon;
  const IconAndTextWidget({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 10.w),
          Text(
            name,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}

void showTikTokStyleReplySheet(
    BuildContext context, String replyingToUser, int totalComments) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar (50 comments)

            // Emojis Row
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("😊", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("🥰", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😂", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😳", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😊", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😅", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("🥺", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.PRIMARY_COLOR_DARK,
                  ),
                  child: Center(
                    child: SvgPicture.asset(Assets.addSoundIcon),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: FormTextField(
                    hintStyle: TextStyle(
                      color: context.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                    hint: context.isArabic
                        ? "الرد على أحمد محم"
                        : "replying to ahmed mohamed",
                    fillColor: context.isDarkMode
                        ? Colors.white
                        : const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.tag_faces_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send, color: Colors.orange),
                )
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

Widget DeleteComment(String Icon, String title) {
  return ListTile(
    leading: SvgPicture.asset(Icon),
    title: Text(title),
    onTap: () {},
  );
}
