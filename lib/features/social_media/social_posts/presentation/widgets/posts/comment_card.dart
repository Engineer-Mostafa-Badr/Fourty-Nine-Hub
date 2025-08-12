import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/reply_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import '../facebook_widgets/build_reactions_buttons.dart';
import '../facebook_widgets/user_image.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';

import '../../../domain/entities/comment_entity.dart';
import '../../../../../../helpers/manage_vibration.dart';

class CommentCard extends StatefulWidget {
  final Color textColor;
  final String from;
  final CommentEntity comment;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;

  const CommentCard({
    super.key,
    this.textColor = Colors.black,
    required this.comment,
    required this.onAddReply,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.from,
    required this.onEditComment,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final editTextController = TextEditingController();
  final replyController = TextEditingController();
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _lastConnectorKey = GlobalKey();
  final GlobalKey _showRepliesConnectorKey = GlobalKey();
  double? _threadLineHeight;

  void _measureThreadHeight({required double lineTopOffset}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
        RenderBox? markerBox;
        
        // Always try to get the marker from show replies button if it exists, otherwise from replies
        if ((widget.comment.remainingRepliesCount ?? 0) > 0) {
          markerBox = _showRepliesConnectorKey.currentContext?.findRenderObject() as RenderBox?;
        } else if (widget.comment.replies != null && widget.comment.replies!.isNotEmpty) {
          markerBox = _lastConnectorKey.currentContext?.findRenderObject() as RenderBox?;
        }
        
        if (stackBox != null && markerBox != null) {
          final stackTop = stackBox.localToGlobal(Offset.zero).dy;
          final markerTop = markerBox.localToGlobal(Offset.zero).dy;
          final computed = (markerTop - stackTop) - lineTopOffset;
          if (computed > 0 && (_threadLineHeight == null || (computed - _threadLineHeight!).abs() > 1)) {
            setState(() {
              _threadLineHeight = computed;
            });
          }
        }
      } catch (_) {
        // ignore measure errors
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    final bool hasReplies = widget.comment.replies != null && widget.comment.replies!.isNotEmpty;
    final bool hasMoreReplies = (widget.comment.remainingRepliesCount ?? 0) > 0;
    // Sizing tuned to resemble Facebook comments
    final double mainAvatarSize = 36.w;
    final double replyAvatarSize = 28.w; // keep in sync with ReplyCard
    final double avatarContentGap = 12.w;
    final double threadX = mainAvatarSize / 2; // center of avatar
    // Length from the replies' start edge to the vertical thread line
    final double connectorLength = (mainAvatarSize + avatarContentGap) - threadX;
    final double elbowRadius = 10.w;
    final double connectorStroke = 2.w;
    final double replyConnectorTop = 6.h; // align the horizontal elbow near the top of the reply bubble

    if (hasReplies || hasMoreReplies) {
      _measureThreadHeight(lineTopOffset: mainAvatarSize + 8.h);
      
      // Additional measurement for show replies button if no visible replies
      if (!hasReplies && hasMoreReplies) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _measureThreadHeight(lineTopOffset: mainAvatarSize + 8.h);
        });
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Stack(
        key: _stackKey,
        children: [
          // Main vertical thread line
          if (hasReplies || hasMoreReplies)
            PositionedDirectional(
              start: threadX - 5, // align with avatar center
              top: mainAvatarSize + (hasMoreReplies?15:24).h, // start just below avatar
              child: SizedBox(
                height: _threadLineHeight ?? (hasMoreReplies ? 120.h : 0), // Fallback height for show replies button
                child: Container(
                  width: 2.w,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: UserProfileImage(
                      size: mainAvatarSize,
                      accountId: 0,
                      withBorder: false,
                      imageURL: widget.comment.user.image.isNotEmpty
                          ? widget.comment.user.image
                          : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s',
                      userId: widget.comment.user.id,
                    ),
                  ),
                  SizedBox(width: avatarContentGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Comment Bubble
                        ClickableWidget(
                          onLongPress: () {
                            ManageVibration.vibrate();
                            bottomSheet(
                              context: context,
                              widget: _buildPostOptions(
                                isMyComment: widget.comment.user.id == user?.id,
                                post: widget.comment,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: context.isDarkMode ? AppColors.QUANTITY_COLOR.withOpacity(0.8) : const Color(0xFFF0F2F5),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.comment.user.firstName} ${widget.comment.user.lastName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: context.isDarkMode ? Colors.white : const Color(0xFF1C1E21),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.comment.content ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.3,
                                    color: context.isDarkMode ? Colors.white.withOpacity(0.9) : const Color(0xFF1C1E21),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Action buttons
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      widget.comment.sinceTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    BuildReactionsButtons(
                                      post: widget.comment,
                                      from: 'comments',
                                      showTitle: true,
                                      showIcon: false,
                                    ),
                                    SizedBox(width: 20.w),
                                    GestureDetector(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        widget.comment.makeReply = !widget.comment.makeReply!;
                                        if (widget.comment.edit == true) {
                                          widget.comment.edit = false;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        LocaleKeys.reply.localize,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if((widget.comment.angryCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.angryCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.angry,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              if((widget.comment.sadCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.sadCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.sad,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              if((widget.comment.wowCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.wowCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.wow,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              if((widget.comment.loveCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.loveCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.heart,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              if((widget.comment.hahaCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.hahaCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.haha,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              if((widget.comment.likesCount??0)>0)Row(
                                children: [
                                  Text('${widget.comment.likesCount??0}',style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                                  ),),
                                  Image.asset(
                                      Assets.like,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Edit comment input
                        if (widget.comment.edit == true)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 16.h,
                              left: mainAvatarSize + avatarContentGap + 4.w,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ProfileImage(
                                    accountId: 0,
                                    fromProfile: true,
                                    imageURL: user?.profilePicture,
                                    userId: '',
                                    size: 32,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: editTextController,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    style: const TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: context.isArabic ? 'اكتب تعليق...' : 'Edit comment...',
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                      fillColor: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey.shade200,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    ),
                                  ),
                                ),
                                if (editTextController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () async {
                                      ManageVibration.vibrate();
                                      var result = await widget.onEditComment(PostCommentParams(postId: widget.comment.id, content: editTextController.text));
                                      if (result == true) {
                                        widget.comment.content = editTextController.text;
                                        widget.comment.edit = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.send,
                                      size: 18,
                                      color: context.isDarkMode ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        // Reply input
                        if (widget.comment.makeReply == true)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 16.h,
                              left: mainAvatarSize + avatarContentGap + 4.w,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ProfileImage(
                                    accountId: 0,
                                    fromProfile: true,
                                    imageURL: user?.profilePicture,
                                    userId: '',
                                    size: 32,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: replyController,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    style: const TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: context.isArabic ? 'أكتب ردك علي التعليق...' : 'Write a reply...',
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                      fillColor: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey.shade200,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    ),
                                  ),
                                ),
                                if (replyController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () async {
                                      ManageVibration.vibrate();
                                      var data =
                                          await widget.onAddReply(ReplyOnCommentParams(postId: widget.comment.post, commentId: widget.comment.id, content: replyController.text));
                                      if (data != null) {
                                        if (widget.comment.replies?.isNotEmpty ?? false) {
                                          (widget.comment.replies ?? []).insert(
                                            0,
                                            CommentEntity(
                                              id: data.id,
                                              content: replyController.text,
                                              post: widget.comment.post,
                                              createdAt: DateTime.now(),
                                              loveCount: data.loveCount,
                                              angryCount: data.angryCount,
                                              likesCount: data.likesCount,
                                              repliesCount: data.repliesCount,
                                              sadCount: data.sadCount,
                                              wowCount: data.wowCount,
                                              hahaCount: data.hahaCount,
                                              isAngry: false,
                                              isLikes: false,
                                              isLove: false,
                                              isSad: false,
                                              isWow: false,
                                              user: TwitterUserEntity(
                                                id: user!.id,
                                                firstName: user.firstName,
                                                lastName: user.lastName,
                                                createdAt: DateTime.now(),
                                                image: user.profilePicture ?? '',
                                                email: user.email ?? '',
                                                isDocumented: false,
                                                hasStory: false,
                                              ),
                                            ),
                                          );
                                        }
                                        replyController.clear();
                                        if (widget.comment.replies?.isEmpty ?? false) widget.comment.remainingRepliesCount = (widget.comment.remainingRepliesCount ?? 0) + 1;
                                        widget.comment.makeReply = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.send,
                                      size: 18,
                                      color: context.isDarkMode ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Replies section
              if (hasReplies)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: mainAvatarSize + avatarContentGap,
                    top: 8.h,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < (widget.comment.replies?.length ?? 0); i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              PositionedDirectional(
                                start: -connectorLength - 4,
                                top: (replyConnectorTop - elbowRadius) + 15,
                                child: SizedBox(
                                  width: connectorLength,
                                  height: elbowRadius + connectorStroke,
                                  child: CustomPaint(
                                    painter: _ConnectorPainter(
                                      color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR.withOpacity(0.3),
                                      strokeWidth: connectorStroke,
                                      radius: elbowRadius,
                                      isRtl: Directionality.of(context) == TextDirection.rtl,
                                    ),
                                  ),
                                ),
                              ),
                              if (i == ((widget.comment.replies?.length ?? 1) - 1))
                                PositionedDirectional(
                                  start: -connectorLength,
                                  top: replyConnectorTop,
                                  child: SizedBox(key: _lastConnectorKey, width: 1, height: 1),
                                ),
                              ReplyCard(
                                onDeleteReply: (String id) async {
                                  bool result = await widget.onDeleteReply(id);
                                  if (result) {
                                    widget.comment.replies?.removeWhere((e) => e.id == id);
                                    widget.comment.repliesCount = (widget.comment.repliesCount ?? 0) - 1;
                                    setState(() {});
                                  }
                                },
                                onEditComment: (PostCommentParams params) => widget.onEditComment(params),
                                reply: widget.comment.replies![i],
                                onReplyReact: (String id) {},
                                onReport: (TwitterReportParams params) {},
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              // Show replies button
              if (hasMoreReplies)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: mainAvatarSize + avatarContentGap,
                    top: 8.h,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PositionedDirectional(
                        start: -connectorLength - 4,
                        top: (12.h + (28.w / 2) - (elbowRadius + connectorStroke) / 2)+5, // Center of reply avatar height
                        child: SizedBox(
                          width: connectorLength,
                          height: elbowRadius + connectorStroke,
                          child: CustomPaint(
                            painter: _ConnectorPainter(
                              color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR.withOpacity(0.3),
                              strokeWidth: connectorStroke,
                              radius: elbowRadius,
                              isRtl: Directionality.of(context) == TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: -connectorLength,
                        top: 12.h + (28.w / 2), // Center of reply avatar height
                        child: SizedBox(key: _showRepliesConnectorKey, width: 1, height: 1),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        child: GestureDetector(
                          onTap: () {
                            ManageVibration.vibrate();
                            context.read<SocialPostsCubit>().getCommentReplies(context: context, commentId: widget.comment.id, comment: widget.comment);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              '${LocaleKeys.show.localize} ${(widget.comment.remainingRepliesCount ?? 0)} ${LocaleKeys.replies.localize}',
                              style: TextStyle(
                                color: context.isDarkMode ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostOptions({required bool isMyComment, required CommentEntity post}) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF242526) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          if (!isMyComment)
            _buildOptionTile(
              icon: Icons.report_outlined,
              iconColor: Colors.red,
              title: LocaleKeys.typeYourComment.localize,
              subTitle: LocaleKeys.youWillReportComment.localize,
              onTap: () async {
                ManageVibration.vibrate();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: post.id,
                        categoryId: '66a3583454e6e337915514db',
                      ));
                });
              },
            ),
          if (isMyComment)
            _buildOptionTile(
              icon: Icons.delete_outline,
              iconColor: Colors.red,
              title: LocaleKeys.deleteComment.localize,
              subTitle: LocaleKeys.youWillDeleteComment.localize,
              onTap: () {
                ManageVibration.vibrate();
                widget.onDeleteComment(widget.comment.id);
              },
            ),
          if (isMyComment)
            _buildOptionTile(
              icon: Icons.edit_outlined,
              iconColor: context.isDarkMode ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
              title: LocaleKeys.editComment.localize,
              subTitle: LocaleKeys.youWillEditComment.localize,
              onTap: () {
                ManageVibration.vibrate();
                widget.comment.edit = !widget.comment.edit!;
                if (widget.comment.makeReply == true) {
                  widget.comment.makeReply = false;
                }
                editTextController.text = widget.comment.content;
                setState(() {});
              },
            ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subTitle,
    required Function onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.transparent,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: context.isDarkMode ? Colors.white : const Color(0xFF1C1E21),
          ),
        ),
        onTap: () {
          ManageVibration.vibrate();
          onTap();
          context.pop();
        },
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            subTitle,
            style: TextStyle(
              color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final bool isRtl;

  _ConnectorPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();

    if (isRtl) {
      // In RTL, draw from right edge towards left with a rounded elbow
      path.moveTo(size.width, 0);
      path.quadraticBezierTo(size.width, radius, size.width - radius, radius);
      path.lineTo(0, radius);
    } else {
      // LTR: from left vertical line to right
      path.moveTo(0, 0);
      path.quadraticBezierTo(0, radius, radius, radius);
      path.lineTo(size.width, radius);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) {
    return color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth || radius != oldDelegate.radius || isRtl != oldDelegate.isRtl;
  }
}
