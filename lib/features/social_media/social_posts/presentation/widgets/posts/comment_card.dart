import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/comment_replies.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/comment_entity.dart';

class CommentCard extends StatefulWidget {
  final Color textColor;
  final String from;
  final CommentEntity comment;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;

  final Function(String) onDeleteReply;

  const CommentCard(
      {super.key,
      this.textColor = Colors.black,
      required this.comment,
      required this.onAddReply,
      required this.onDeleteComment,
      required this.onDeleteReply,
      required this.from,
      required this.onEditComment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileImage(
              size: 40.sp,
              accountId: 0,
              withBorder: false,
              imageURL: widget.comment.user.image.isNotEmpty
                  ? widget.comment.user.image
                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s',
              userId: widget.comment.user.id,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: widget.comment.user.firstName,
                        style: Styles.mediumText(fontWeight: FontWeight.bold)),
                    const Sizer(),
                    Label(
                        text: widget.comment.sinceTime,
                        style: Styles.mediumText(
                            color: AppColors.GREY_NORMAL_COLOR)),
                  ],
                ),
                Text(
                  widget.comment.content ?? '',
                  textAlign: TextAlign.start,
                  style: Styles.mediumText(fontSize: 65.sp),
                ),
              ],
            )),
            const Sizer(),
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
                color: Theme.of(context).primaryColor,
                size: 50.sp,
              ),
            ),
          ],
        ),
        // const Sizer(),
        // Text(
        //   widget.comment.content,
        //   style: Styles.mediumText(color: Theme.of(context).primaryColor,),
        // ),
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
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(5),
                    hintText: '${LocaleKeys.typeYourComment.localize} ....',
                    hintStyle: Styles.mediumText(),
                  ),
                )),
                const Sizer(),
                if (editTextController.text.isNotEmpty)
                  IconAppButton(
                      icon: Icons.send,
                      isCircle: true,
                      size: 20,
                      onPressed: () async {
                        var result = await widget.onEditComment(
                            PostCommentParams(
                                postId: widget.comment.id,
                                content: editTextController.text));
                        if (result == true) {
                          widget.comment.content = editTextController.text;
                          widget.comment.edit = false;
                        }
                        setState(() {});
                      })
              ],
            ),
          ),
        const Sizer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildReactionsButtons(
              post: widget.comment,
              from: 'comments',
            ),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(),
                label: LocaleKeys.reply.localize,
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: BlocProvider.value(
                        value: serviceLocator<SocialPostsCubit>()
                          ..loadReplies(context, widget.comment.id),
                        child: CommentReplies(
                          replies: const [],
                          postId: widget.comment.post,
                          commentId: widget.comment.id,
                          onAddReply: (ReplyOnCommentParams params) =>
                              widget.onAddReply(params),
                          onDeleteReply: (String id) =>
                              widget.onDeleteReply(id),
                          from: widget.from,
                          onEditComment: (PostCommentParams params) =>
                              widget.onEditComment(params),
                        ),
                      ));
                })
          ],
        ),
        const Sizer(),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return SizedBox(
      height: isMyComment ? 160 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: LocaleKeys.typeYourComment.localize,
                subTitle: LocaleKeys.youWillReportComment.localize,
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
                iconColor: Theme.of(context).primaryColor,
                title: LocaleKeys.deleteComment.localize,
                subTitle: LocaleKeys.youWillDeleteComment.localize,
                onTap: () {
                  widget.onDeleteComment(widget.comment.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.visibility_off,
                iconColor: Theme.of(context).primaryColor,
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
        color: iconColor ?? Theme.of(context).primaryColor,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }
}
