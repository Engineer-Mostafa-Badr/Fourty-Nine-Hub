import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../data/models/get_comments_model.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import 'comments/no_scale_text.dart';
import 'reply_widget.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../res/assets/assets.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import 'Icon_and_text_widget.dart';
import 'components/social_widget.dart';
import 'send_to_bottom_sheet.dart';
import '../../../../../helpers/manage_vibration.dart';

class CommentWidget extends StatefulWidget {
  final CommentData commentData;
  final int index;
  final FocusNode focusNode;
  String? replyingTo;
  final TextEditingController commentController;
  CommentWidget(
      {super.key,
      required this.commentData,
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
                backgroundColor:
                    context.isDarkMode ? Colors.grey[900] : Colors.white,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
              context.isArabic ? 'احمد' : 'Ahmed',
              DateTime.now(),
              false,
            ),
          ),
          SizedBox(height: 10.h),
          _buildToggleRepliesButton(),
          if (_isRepliesVisible) ...[
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isRepliesVisible
                  ? InkWell(
                      onLongPress: () {
                        showModalBottomSheet(
                          backgroundColor: context.isDarkMode
                              ? Colors.grey[900]
                              : Colors.white,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            side: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          builder: (context) {
                            return const CopyBottomSheet();
                          },
                        );
                      },
                      onTap: () {
      ManageVibration.vibrate();
                        showModalBottomSheet(
                          backgroundColor: context.isDarkMode
                              ? Colors.grey[900]
                              : Colors.white,
                          isDismissible: false,
                          enableDrag: false,
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: const ReplyWidget(),
                            );
                          },
                        );
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

  Widget _buildCommentRow(String comment, DateTime createdAt, bool reply) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageFromInternet(
            width: 40,
            height: 40,
            isCircle: true,
            image:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLlsHCzHU2GndYsMJQscyixYSlDVggHDzbXtXSuEmLAc309Z-6e1TUhHJFCLCw40Kicw0",
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
                  capitalizeAndSplit(
                      '${context.isArabic ? 'احمد' : "Ahmed "} ${context.isArabic ? 'محمد' : 'Mohamed'}'),
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 5.h),
                NoScaleText(
                  context.isArabic ? 'كيف حالك' : 'how are you?',
                  // comment,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    NoScaleText(
                      '1d',
                      //        formatDateTime(createdAt),
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        showModalBottomSheet(
                          backgroundColor: context.isDarkMode
                              ? Colors.grey[900]
                              : Colors.white,
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          builder: (BuildContext context) {
                            return const ReplyWidget();
                          },
                        );
                      },
                      child: _buildReplyButton(),
                    ),
                    const Spacer(),
                    LoveButtonComment()
                    //      LoveDislikeButtons()
                    //       _buildLikeButton(reply, replyId: replyId),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyRow(String comment, DateTime createdAt, bool reply,
      {String? replyId, bool? isLike, int? replyCount}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageFromInternet(
          width: 30,
          height: 30,
          isCircle: true,
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLlsHCzHU2GndYsMJQscyixYSlDVggHDzbXtXSuEmLAc309Z-6e1TUhHJFCLCw40Kicw0",
          // ? UIConst.profilePlaceHolder
          // : widget.commentData.user.profilePictureSignedUrl,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoScaleText(
                capitalizeAndSplit(context.isArabic
                    ? 'احمد'
                    : '${'ahmed'} ${context.isArabic ? 'محمد' : 'mohamed'}'),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 5.h),
              NoScaleText(
                comment,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 25.sp,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    context.isArabic ? '5 h' : '5h',
                    style: TextStyle(
                      color:
                          context.isDarkMode ? Colors.white : Colors.grey[500],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  // NoScaleText(
                  //   formatDateTime(createdAt),
                  //   style: TextStyle(
                  //     color:
                  //         context.isDarkMode ? Colors.white : Colors.grey[500],
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
      ManageVibration.vibrate();
                      showModalBottomSheet(
                        backgroundColor: context.isDarkMode
                            ? Colors.grey[900]
                            : Colors.white,
                        isDismissible: false,
                        enableDrag: false,
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        builder: (BuildContext context) {
                          return const ReplyWidget();
                        },
                      );
                    },
                    child: _buildReplyButton(),
                  ),
                  const Spacer(),
                  LoveButtonComment()
                  // _buildReplyLikeButton(reply,
                  //     replyId: replyId, isLike: isLike, likeCount: replyCount),
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
      ManageVibration.vibrate();
        _toggleReplyMode('${'Ahmed'} ${'yousef'}');
      },
      child: GestureDetector(
        onTap: () {
      ManageVibration.vibrate();
          showModalBottomSheet(
            backgroundColor:
                context.isDarkMode ? Colors.grey[900] : Colors.white,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.zero, // هنا بتخلي الزوايا صفر يعني مربع
            ),
            builder: (BuildContext context) {
              return const ReplyWidget();
            },
          );
        },
        child: NoScaleText(
          context.isArabic ? 'رد' : 'Replay',
          style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold),
        ),
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
      ManageVibration.vibrate();
            _handleLikeComment('5', reply, replyId: replyId);
          },
        ),
        NoScaleText(
          '24',
          style: TextStyle(
            color: context.isDarkMode ? Colors.white : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
        SizedBox(width: 48.w),
        SvgPicture.asset(
          Assets.disLikeIcon,
          color: context.isDarkMode ? Colors.white : Colors.black,
        ),
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
      ManageVibration.vibrate();
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
            ? context.isArabic
                ? "عرض ${remainingReplies > 2 ? 'المزيد' : remainingReplies} الردود"
                : "  View ${remainingReplies > 2 ? 'More' : remainingReplies} Replies"
            : context.isArabic
                ? "اخفاء الردود"
                : "Hide Replies")
        : "View ${3} ${1 == 1 ? 'Reply' : 'Replies'}";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 140.0.w),
      child: InkWell(
        onTap: () {
      ManageVibration.vibrate();
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
            Container(
              width: 25,
              color: context.isDarkMode ? Colors.white : Colors.grey,
              height: 2.h,
            ),
            SizedBox(width: 10.w),
            Text(
              buttonText,
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600),
            ),
            _isRepliesVisible
                ? Icon(
                    Icons.keyboard_arrow_up,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
                  )
                : Icon(
                    Icons.keyboard_arrow_down,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
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
              context.isArabic ? 'كيف حالك' : 'how are you ?',
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

class CopyBottomSheet extends StatelessWidget {
  const CopyBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeleteComment(
              icon: Assets.deleteComIcon,
              title: context.isArabic ? 'حذف' : 'Delete'),
          SizedBox(height: 24),
          DeleteComment(
              icon: Assets.copyComIcon,
              title: context.isArabic ? 'نسخ' : 'Copy'),
          SizedBox(height: 24),
          DeleteComment(
              icon: Assets.replyIcon,
              title: context.isArabic ? 'الرد بالفيديو' : 'Reply with video'),
          SizedBox(height: 24),
          DeleteComment(
              icon: Assets.addFavIcon,
              title:
                  context.isArabic ? 'أضف إلى المفضلة' : 'Add to favourites'),
          SizedBox(height: 24.h),
        ],
      ),
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
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              context.isArabic ? 'أرسل إلى' : 'Send to',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 7),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius:
                                  25,
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLlsHCzHU2GndYsMJQscyixYSlDVggHDzbXtXSuEmLAc309Z-6e1TUhHJFCLCw40Kicw0'),
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
                      const SizedBox(height: 5),
                      Text(
                        textAlign: TextAlign.center,
                        context.isArabic ? 'احمد\n محمد' : "AHMED\nMOHAMED",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xffEDEDED),
                          child: GestureDetector(
                            onTap: () {
      ManageVibration.vibrate();
                              showModalBottomSheet(
                                backgroundColor: context.isDarkMode
                                    ? Colors.grey[900]
                                    : Colors.white,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                builder: (context) {
                                  return const SendToBottomSheet();
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              Assets.searchCountBottom,
                            ),
                          )),
                      const SizedBox(
                          height: 5), // غيرناها من 3 لـ 5 عشان تكون زي الأولى
                      Text(
                        context.isArabic ? "المزيد" : "More",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        setState(() {
                          showExtraContainer = !showExtraContainer;
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.shareWithIcon,
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.black,
                          ),
                          SizedBox(width: 8),
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
                      const SizedBox(width: 12),
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
      ManageVibration.vibrate();
                        setState(() {
                          showExtraContainer = !showExtraContainer;
                        });
                      },
                      child: SvgPicture.asset(
                        Assets.arrowIcon,
                        color:
                            context.isDarkMode ? Colors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (showExtraContainer) ...[
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SocialWidget(
                              radius: 22,
                              iconName:
                                  context.isArabic ? 'واتساب' : 'Whatsapp',
                              icon: Assets.whatsIcon,
                              backGroundColor: 0xff25D366,
                            ),
                            SizedBox(width: 23.w),
                            SocialWidget(
                              width: 24,
                              radius: 22,
                              iconName:
                                  context.isArabic ? 'مسانجر' : 'Messenger',
                              icon: Assets.messengerIcon,
                              backGroundColor: 0xffF5F5F5,
                            ),
                            SizedBox(width: 23.w),
                            SocialWidget(
                              radius: 22,
                              iconName:
                                  context.isArabic ? 'فيسبوك' : 'Facebook',
                              icon: Assets.faceIcon,
                              backGroundColor: 0,
                            ),
                            SizedBox(width: 23.w),
                            SocialWidget(
                              radius: 22,
                              iconName:
                                  context.isArabic ? 'انستقرام' : 'Instagram',
                              icon: Assets.instagram,
                              backGroundColor: 0,
                            ),
                            SizedBox(width: 23.w),
                            SocialWidget(
                              radius: 23,
                              iconName:
                                  context.isArabic ? 'نسخ الرابط' : 'Copy Link',
                              icon: Assets.coppyLinkIcon,
                              backGroundColor: 0xff2E75FD,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SocialWidget(
                              radius: 20,
                              iconName:
                                  context.isArabic ? 'تيليجرام' : 'Telegram',
                              icon: Assets.telegramIcon,
                              backGroundColor: 0xff24A1DE,
                            ),
                            SizedBox(width: 40.w),
                            SocialWidget(
                              radius: 23,
                              iconName:
                                  context.isArabic ? 'سنابشات' : 'Snabchat',
                              icon: Assets.snapIcon,
                              backGroundColor: 0xffFFFC00,
                            ),
                            SizedBox(width: 40.w),
                            SocialWidget(
                              radius: 22,
                              iconName:
                                  context.isArabic ? 'رسالة قصيرة' : 'Sms',
                              icon: Assets.smsIcon,
                              backGroundColor: 0xff34C759,
                            ),
                            SizedBox(width: 40.w),
                            SocialWidget(
                              radius: 22,
                              iconName: context.isArabic
                                  ? 'البريد الإلكتروني'
                                  : 'Email',
                              icon: Assets.emailIcon,
                              backGroundColor: 0xff04B7C4,
                            ),
                            SizedBox(width: 60.w),
                            SocialWidget(
                              radius: 22,
                              iconName: context.isArabic ? 'المزيد' : 'More',
                              color: AppColors.whiteColor,
                              icon: Assets.moreIcon,
                              backGroundColor: 0xff078AC9,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          IconAndTextWidget(
            onTap: () {
      ManageVibration.vibrate();
              _showReportBottomSheet(context);
            },
            name: context.isArabic ? 'الإبلاغ' : 'Report',
            icon: Assets.reportComIcon,
          ),
          const SizedBox(height: 20),
          IconAndTextWidget(
            onTap: () {

      ManageVibration.vibrate();
            },
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

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: '5',
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }
}

bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}

// Widget DeleteComment(String Icon, String title) {
//   return ListTile(
//     leading: SvgPicture.asset(Icon),
//     title: Text(
//       title,
//       style: TextStyle(
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//     onTap: () {},
//   );
// }

class DeleteComment extends StatelessWidget {
  final String icon;
  final String title;
  const DeleteComment({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(width: 13.w),
          Text(
            title,
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

class LoveButtonComment extends StatefulWidget {
  final MainAxisAlignment mainAxisAlignment;

  const LoveButtonComment({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  State<LoveButtonComment> createState() => _LoveButtonCommentState();
}

class _LoveButtonCommentState extends State<LoveButtonComment>
    with TickerProviderStateMixin {
  bool isLoved = false;
  bool isDisliked = false;

  late AnimationController _loveController;
  late AnimationController _dislikeController;

  late Animation<double> _loveScaleAnimation;
  late Animation<double> _dislikeScaleAnimation;

  late Animation<Color?> _loveColorAnimation;
  late Animation<Color?> _dislikeColorAnimation;

  @override
  void initState() {
    super.initState();

    _loveController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _dislikeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loveScaleAnimation = _buildScaleAnimation(_loveController);
    _dislikeScaleAnimation = _buildScaleAnimation(_dislikeController);

    _loveColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _loveController,
      curve: Curves.easeIn,
    ));

    _dislikeColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.black,
    ).animate(CurvedAnimation(
      parent: _dislikeController,
      curve: Curves.easeIn,
    ));
  }

  Animation<double> _buildScaleAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.6)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.6, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(controller);
  }

  @override
  void dispose() {
    _loveController.dispose();
    _dislikeController.dispose();
    super.dispose();
  }

  void toggleLove() {
    setState(() {
      isLoved = !isLoved;
      if (isLoved) isDisliked = false;
    });
    _loveController.forward(from: 0);
  }

  void toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      if (isDisliked) isLoved = false;
    });
    _dislikeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.06;

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        GestureDetector(
          onTap: toggleLove,
          child: AnimatedBuilder(
            animation: _loveController,
            builder: (context, child) {
              return Transform.scale(
                scale: _loveScaleAnimation.value,
                child: Icon(
                  Icons.favorite,
                  color: isLoved ? _loveColorAnimation.value : Colors.grey,
                  size: iconSize,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '24',
          style: TextStyle(
            fontSize: 12,
            color: context.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: toggleDislike,
          child: AnimatedBuilder(
            animation: _dislikeController,
            builder: (context, child) {
              return Transform.scale(
                scale: _dislikeScaleAnimation.value,
                child: Icon(
                  Icons.thumb_down,
                  color:
                      isDisliked ? _dislikeColorAnimation.value : Colors.grey,
                  size: iconSize,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}