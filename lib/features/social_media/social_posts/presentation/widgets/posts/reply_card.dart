import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
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
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';

class ReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;

  const ReplyCard({
    super.key,
    this.textColor = Colors.black,
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

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      margin: EdgeInsets.only(left: 0.w), // Indent replies to show hierarchy
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
                  size: 14,
                  withBorder: false,
                  imageURL: widget.reply.user.image.isNotEmpty
                      ? widget.reply.user.image
                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s',
                  userId: widget.reply.user.id,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reply Bubble - smaller and more subtle than main comments
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.QUANTITY_COLOR.withOpacity(0.6)
                            : const Color(0xFFF0F2F5).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16.r),
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
                                  widget.reply.user.firstName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF1C1E21),
                                  ),
                                ),
                              ),
                              Text(
                                widget.reply.sinceTime,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.isDarkMode
                                      ? Colors.white60
                                      : const Color(0xFF65676B),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          // Reply content
                          Text(
                            widget.reply.content,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.3,
                              color: context.isDarkMode
                                  ? Colors.white.withOpacity(0.9)
                                  : const Color(0xFF1C1E21),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Action buttons row - smaller and more subtle
                    Padding(
                      padding: EdgeInsets.only(left: 14.w),
                      child: Row(
                        children: [
                          BuildReactionsButtons(
                            post: widget.reply,
                            from: 'comments',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              // More options button - smaller for replies
              GestureDetector(
                onTap: () {
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
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: context.isDarkMode
                        ? Colors.white60
                        : const Color(0xFF65676B),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          // Edit reply input
          if (widget.reply.edit == true)
            Container(
              margin: EdgeInsets.only(top: 12.h, left: 40.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR.withOpacity(0.8)
                    : const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.SECONDARY_COLOR.withOpacity(0.3)
                      : AppColors.PRIMARY_COLOR.withOpacity(0.3),
                  width: 1,
                ),
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
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: context.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF1C1E21),
                      ),
                      decoration: InputDecoration(
                        hintText: context.isArabic ? 'تعديل الرد...' : 'Edit reply...',
                        hintStyle: TextStyle(
                          color: context.isDarkMode
                              ? Colors.white60
                              : const Color(0xFF65676B),
                          fontSize: 13.sp,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 6.h),
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
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.SECONDARY_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                        child: Icon(
                          Icons.send,
                          size: 14.sp,
                          color: Colors.white,
                        ),
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