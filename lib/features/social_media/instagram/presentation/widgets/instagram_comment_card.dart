import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_comment_replies.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class InstagramCommentCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity comment;
  final Function(ReplyOnCommentParams) onAddReply;

  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;

  final Function(String) onDeleteReply;
  const InstagramCommentCard({
    super.key,
    this.textColor = Colors.black,
    required this.comment,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.onAddReply,
  });

  @override
  State<InstagramCommentCard> createState() => _InstagramCommentCardState();
}

class _InstagramCommentCardState extends State<InstagramCommentCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        Row(
          children: [
            ProfileImage(
              accountId: 0,
              userId: '',
              withBorder: false,
              imageURL: widget.comment.user.image.isNotEmpty
                  ? widget.comment.user.image
                  : null,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: widget.comment.user.firstName,
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode
                          ? AppColors.SECONDARY_COLOR
                          : Colors.black,
                    )),
                Label(
                    text: widget.comment.sinceTime,
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? AppColors.LIGHT_COLOR
                            : Colors.black)),
              ],
            )),
            GestureDetector(
              onTap: () {
                bottomSheet(
                  context: context,
                  widget: _buildPostOptions(
                    isMyComment: widget.comment.user.id == user?.id,
                    post: widget.comment,
                  ),
                );
              },
              child: Icon(
                Icons.more_horiz_outlined,
                color:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
        const Sizer(),
        Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            Label(
              textAlign: TextAlign.start,
              text: widget.comment.content,
              style: Styles.mediumText(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : Colors.black),
            ),
          ],
        ),
        if (widget.comment.edit == true)
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  maxLines: null,
                  controller: editTextController,
                  onChanged: (v) {
                    setState(() {});
                  },
                  style: Styles.headerText(fontSize: 26),
                  decoration: InputDecoration(
                    fillColor:
                        context.isDarkMode ? Colors.transparent : Colors.white,
                    contentPadding: const EdgeInsets.all(5),
                    hintText: '${LocaleKeys.typeYourComment.localize} ....',
                    hintStyle: Styles.mediumText(),
                  ),
                )),
                const Sizer(),
                if (editTextController.text.isNotEmpty)
                  IconAppButton(
                    icon: Icons.send,
                    size: 20,
                    isCircle: true,
                    onPressed: () async {
                      var result = await widget.onEditComment(PostCommentParams(
                          postId: widget.comment.id,
                          content: editTextController.text));
                      if (result == true) {
                        widget.comment.content = editTextController.text;
                        widget.comment.edit = false;
                      }
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        Sizer(
          height: 32.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 32,
            ),
            InkWell(
              onTap: () {
                if (widget.comment.isLove == true) {
                  // widget.onCommentReact();
                  widget.comment.isLove = false;
                  widget.comment.loveCount = (widget.comment.loveCount! - 1);
                  setState(() {});
                } else {
                  print("object");
                  // widget.onCommentReact();
                  widget.comment.isLove = true;
                  widget.comment.loveCount = widget.comment.loveCount! + 1;
                  setState(() {});
                }
              },
              child: Icon(
                widget.comment.isLove == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color:
                    widget.comment.isLove == false ? Colors.grey : Colors.red,
              ),
            ),
            const Sizer(
              width: 4,
            ),
            Label(text: '${widget.comment.loveCount}'),
            const Sizer(
              width: 32,
            ),
            TextAppButton(
                style: Styles.mediumText(),
                label: LocaleKeys.reply.localize,
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: InstagramCommentReplies(
                        postId: widget.comment.post,
                        commentId: widget.comment.id,
                        onAddReply: (ReplyOnCommentParams params) =>
                            widget.onAddReply(params),
                        onEditComment: (PostCommentParams params) =>
                            widget.onEditComment(params),
                        onDeleteReply: (String id) => widget.onDeleteReply(id),
                      ));
                })
          ],
        ),
        Sizer(
          height: 4.h,
        ),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return SizedBox(
      height: isMyComment ? 150 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: LocaleKeys.reportComment.localize,
                subTitle: LocaleKeys.youWillReportReply.localize,
                onTap: () async {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: post.id,
                          categoryId: '66a3583454e6e337915514db',
                        ));
                  });
                }),
          if (isMyComment)
            listTile(
                icon: Icons.delete,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.deleteComment.localize,
                subTitle: LocaleKeys.youWillDeleteComment.localize,
                onTap: () {
                  widget.onDeleteComment(widget.comment.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.edit,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.editComment.localize,
                subTitle: LocaleKeys.youWillEditComment.localize,
                onTap: () {
                  widget.comment.edit = !widget.comment.edit!;
                  editTextController.text = widget.comment.content;
                  setState(() {});
                }),
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon,
      Color? iconColor,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }
}
