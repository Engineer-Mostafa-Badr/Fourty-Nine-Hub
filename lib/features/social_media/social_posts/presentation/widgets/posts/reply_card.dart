import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../facebook_widgets/build_reactions_buttons.dart';
import '../facebook_widgets/user_image.dart';
import '../../../../twitter/domain/usecases/twitter_report_usecase.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';

class ReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity comment;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;

  const ReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.comment,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  final editTextController = TextEditingController();

  void handleCommentReact(CommentEntity comment, String newReaction) {
    String? currentReaction;
    if (comment.isLikes == true) currentReaction = 'like';
    else if (comment.isWow == true) currentReaction = 'wow';
    else if (comment.isHaha == true) currentReaction = 'haha';
    else if (comment.isLove == true) currentReaction = 'love';
    else if (comment.isSad == true) currentReaction = 'sad';
    else if (comment.isAngry == true) currentReaction = 'angry';
    if (currentReaction == newReaction) {
      _decrementReactionCount(comment, newReaction);
      return;
    }
    if (currentReaction != null) {
      _decrementReactionCount(comment, currentReaction);
    }
    _incrementReactionCount(comment, newReaction);
  }

  void _incrementReactionCount(CommentEntity comment, String reaction) {
    switch (reaction) {
      case 'like':
      case 'likes':
        comment.likesCount = (comment.likesCount ?? 0) + 1;
        break;
      case 'wow':
        comment.wowCount = (comment.wowCount ?? 0) + 1;
        break;
      case 'haha':
        comment.hahaCount = (comment.hahaCount ?? 0) + 1;
        break;
      case 'love':
        comment.loveCount = (comment.loveCount ?? 0) + 1;
        break;
      case 'sad':
        comment.sadCount = (comment.sadCount ?? 0) + 1;
        break;
      case 'angry':
        comment.angryCount = (comment.angryCount ?? 0) + 1;
        break;
    }
  }

  void _decrementReactionCount(CommentEntity comment, String reaction) {
    switch (reaction) {
      case 'like':
      case 'likes':
        comment.likesCount = (comment.likesCount ?? 0) - 1;
        break;
      case 'wow':
        comment.wowCount = (comment.wowCount ?? 0) - 1;
        break;
      case 'haha':
        comment.hahaCount = (comment.hahaCount ?? 0) - 1;
        break;
      case 'love':
        comment.loveCount = (comment.loveCount ?? 0) - 1;
        break;
      case 'sad':
        comment.sadCount = (comment.sadCount ?? 0) - 1;
        break;
      case 'angry':
        comment.angryCount = (comment.angryCount ?? 0) - 1;
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    print("widget.reply.commentOwnerId ${widget.reply.commentOwnerId}  ==>  ${widget.reply.user.id}");
    final user = context.read<UserCubit>().state.data;
    // Keep sizes synced with CommentCard so the connector lines align visually
    final double mainAvatarSize = 36.w;
    final double replyAvatarSize = 28.w;
    final double avatarContentGap = 12.w;
    num totalReactions = (widget.reply.likesCount??0) + (widget.reply.hahaCount??0) + (widget.reply.loveCount??0) + (widget.reply.wowCount??0) + (widget.reply.sadCount??0) +(widget.reply.angryCount??0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      margin: EdgeInsets.only(left: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with smaller size for replies
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: UserProfileImage(
                  accountId: 0,
                  size: replyAvatarSize,
                  withBorder: false,
                  imageURL: widget.reply.user?.image.isNotEmpty
                      ? widget.reply.user?.image
                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s',
                  userId: widget.reply.user.id,
                ),
              ),
              SizedBox(width: avatarContentGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reply Bubble - smaller and more subtle than main comments
                    ClickableWidget(
                      onLongPress: (){
                        ManageVibration.vibrate();
                        bottomSheet(
                          context: context,
                          widget: _buildPostOptions(
                            isMyComment: widget.reply.user.id == user?.id,
                            post: widget.reply,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.QUANTITY_COLOR.withOpacity(0.6)
                              : const Color(0xFFF0F2F5).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User name and time row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${widget.reply.user.firstName} ${widget.reply.user.lastName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF1C1E21),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if((widget.reply.commentOwnerId?.isNotEmpty??false)&&((widget.reply.commentOwnerId??'')!=(widget.reply.user.id)))...[
                              SizedBox(height: 3.h),
                            // Reply content
                            Text(
                              "${widget.reply.commentOwnerFirstName} ${widget.reply.commentOwnerLastName}",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.3,
                                color: AppColors.LIGHT_BLUE),
                              ),

                            ],
                            SizedBox(height: 3.h),
                            // Reply content
                            Text(
                              widget.reply.content,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.3,
                                color: context.isDarkMode
                                    ? Colors.white.withOpacity(0.9)
                                    : const Color(0xFF1C1E21),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Action buttons row - smaller and more subtle
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 14.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  widget.reply.sinceTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.isDarkMode
                                        ? Colors.white60
                                        : const Color(0xFF65676B),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                BuildReactionsButtons(
                                  post: widget.reply,
                                  from: 'comments',
                                  showTitle: true,
                                  showIcon: false,
                                  handleReaction: (reaction){
                                    handleCommentReact(widget.reply, reaction);
                                    setState(() {

                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if(totalReactions>0)Text('$totalReactions',style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode ? Colors.white60 : const Color(0xFF65676B),
                          ),),
                          if((widget.reply.angryCount??0)>0)Image.asset(
                            Assets.angry,
                            width: 20,
                            height: 20,
                          ),
                          if((widget.reply.sadCount??0)>0)Image.asset(
                            Assets.sad,
                            width: 20,
                            height: 20,
                          ),
                          if((widget.reply.wowCount??0)>0)Image.asset(
                            Assets.wow,
                            width: 20,
                            height: 20,
                          ),
                          if((widget.reply.loveCount??0)>0)Image.asset(
                            Assets.heart,
                            width: 20,
                            height: 20,
                          ),
                          if((widget.reply.hahaCount??0)>0)Image.asset(
                            Assets.haha,
                            width: 20,
                            height: 20,
                          ),
                          if((widget.reply.likesCount??0)>0)Image.asset(
                            Assets.like,
                            width: 20,
                            height: 20,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Edit reply input
          if (widget.reply.edit == true)
            Container(
              margin: EdgeInsetsDirectional.only(
                bottom: 4.h,
                top: 4.h,
                start: mainAvatarSize + avatarContentGap + 4.w,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),              child: Row(
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
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      controller: editTextController,
                      onChanged: (v) {
                        setState(() {});
                      },
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: context.isArabic ? 'تعديل الرد...' : 'Edit reply...',
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
                        var result = await widget.onEditComment(
                            PostCommentParams(
                                postId: widget.reply.id,
                                content: editTextController.text));
                        if (result == true) {
                          widget.reply.content = editTextController.text;
                          widget.reply.edit = false;
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
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF242526) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
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
              title: LocaleKeys.reportReply.localize,
              subTitle: LocaleKeys.youWillReportReply.localize,
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
              title: LocaleKeys.deleteReply.localize,
              subTitle: LocaleKeys.youWillDeleteReply.localize,
              onTap: () {
                ManageVibration.vibrate();
                widget.onDeleteReply(widget.reply.id);
              },
            ),
          if (isMyComment)
            _buildOptionTile(
              icon: Icons.edit_outlined,
              iconColor: context.isDarkMode ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
              title: LocaleKeys.editReply.localize,
              subTitle: LocaleKeys.youWillEditReply.localize,
              onTap: () {
                ManageVibration.vibrate();
                widget.reply.edit = !widget.reply.edit!;
                editTextController.text = widget.reply.content;
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