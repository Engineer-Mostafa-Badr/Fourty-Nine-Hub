import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/reply_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import '../facebook_widgets/build_reactions_buttons.dart';
import '../facebook_widgets/user_image.dart';
import 'comment_replies.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    final bool hasReplies = widget.comment.replies != null && widget.comment.replies!.isNotEmpty;
    final bool hasMoreReplies = (widget.comment.repliesCount ?? 0) > (widget.comment.replies?.length ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Stack(
        children: [
          // Main vertical thread line
          if (hasReplies || hasMoreReplies)
            PositionedDirectional(
              start: 36.w, // Align with center of profile image
              top: 60.h, // Start below profile image
              bottom: hasMoreReplies ? 60.h : 0, // Extend to "Show replies" button if exists
              child: Container(
                width: 2.w,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1.r),
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
                      size: 20,
                      accountId: 0,
                      withBorder: false,
                      imageURL: widget.comment.user.image.isNotEmpty
                          ? widget.comment.user.image
                          : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s',
                      userId: widget.comment.user.id,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Comment Bubble
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? AppColors.QUANTITY_COLOR.withOpacity(0.8)
                                : const Color(0xFFF0F2F5),
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
                                      widget.comment.user.firstName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF1C1E21),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.comment.sinceTime,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: context.isDarkMode
                                          ? Colors.white60
                                          : const Color(0xFF65676B),
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
                                  color: context.isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : const Color(0xFF1C1E21),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Action buttons
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Row(
                            children: [
                              BuildReactionsButtons(
                                post: widget.comment,
                                from: 'comments',
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
                                    color: context.isDarkMode
                                        ? Colors.white60
                                        : const Color(0xFF65676B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit comment input
                        if (widget.comment.edit == true)
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h, left: 52.w),
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
                                      var result = await widget.onEditComment(
                                          PostCommentParams(
                                              postId: widget.comment.id,
                                              content: editTextController.text));
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
                            margin: EdgeInsets.only(bottom: 16.h, left: 52.w),
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
                                      var result = await widget.onAddReply(
                                          ReplyOnCommentParams(
                                              postId: widget.comment.post,
                                              commentId: widget.comment.id,
                                              content: replyController.text));
                                      if (result != null) {
                                        replyController.clear();
                                        widget.comment.repliesCount = (widget.comment.repliesCount ?? 0) + 1;
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
                  SizedBox(width: 8.w),
                  // More options button
                  GestureDetector(
                    onTap: () {
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
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: context.isDarkMode
                            ? Colors.white60
                            : const Color(0xFF65676B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              // Replies section
              if (hasReplies)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 48.w, top: 8.h),
                  child: Column(
                    children: [
                      for (int i = 0; i < (widget.comment.replies?.length ?? 0); i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Stack(
                            children: [
                              // Horizontal connector line
                              PositionedDirectional(
                                start: -24.w,
                                top: 24.h,
                                child: Container(
                                  width: 24.w,
                                  height: 2.h,
                                  color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                                ),
                              ),
                              ReplyCard(
                                onDeleteReply: (String id) async {
                                  bool result = await widget.onDeleteReply(id);
                                  if (result) {
                                    widget.comment.replies?.removeWhere((e) => e.id == id);
                                    setState(() {});
                                  }
                                },
                                onEditComment: (PostCommentParams params) =>
                                    widget.onEditComment(params),
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
                Container(
                  margin: EdgeInsets.only(top: 12.h, left: 52.w),
                  child: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      context.read<SocialPostsCubit>().getCommentReplies(
                          context: context,
                          commentId: widget.comment.id,
                          comment: widget.comment);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            context.isArabic ? Icons.subdirectory_arrow_left : Icons.subdirectory_arrow_right,
                            size: 16,
                            color: context.isDarkMode
                                ? AppColors.SECONDARY_COLOR
                                : AppColors.PRIMARY_COLOR,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${LocaleKeys.show.localize} ${(widget.comment.repliesCount ?? 0) - (widget.comment.replies?.length ?? 0)} ${LocaleKeys.replies.localize}',
                            style: TextStyle(
                              color: context.isDarkMode
                                  ? AppColors.SECONDARY_COLOR
                                  : AppColors.PRIMARY_COLOR,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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