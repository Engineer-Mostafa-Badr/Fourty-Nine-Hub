import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class InstagramReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;
  const InstagramReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<InstagramReplyCard> createState() => _InstagramReplyCardState();
}

class _InstagramReplyCardState extends State<InstagramReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator(),
      child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        final user = context.read<UserCubit>().state.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileImage(
                  accountId: 0,
                  withBorder: false,
                  userId: '',
                  imageURL: widget.reply.user.image.isNotEmpty
                      ? widget.reply.user.image
                      : null,
                ),
                const Sizer(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: widget.reply.user.firstName,
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: widget.textColor)),
                    Label(
                        text: widget.reply.sinceTime,
                        style: Styles.mediumText(color: widget.textColor)),
                  ],
                )),
                IconButton(
                    onPressed: () {
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: widget.reply.id,
                            categoryId: '66a3583454e6e337915514db',
                          ));
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: widget.textColor,
                    )),
                if (user?.id == widget.reply.user.id) ...[
                  // const Sizer(),
                  GestureDetector(
                      onTap: () {
                        widget.reply.edit = !widget.reply.edit!;
                        editTextController.text = widget.reply.content;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.edit,
                        color: widget.textColor,
                        size: 20,
                      )),
                  const Sizer()
                ],
                GestureDetector(
                    onTap: () {
                      widget.onDeleteReply(widget.reply.id);
                    },
                    child: Icon(
                      Icons.close,
                      color: widget.textColor,
                      size: 20,
                    ))
              ],
            ),
            const Sizer(),
            Label(
              textAlign: TextAlign.start,
              text: widget.reply.content,
              style: Styles.mediumText(color: widget.textColor),
            ),
            if (widget.reply.edit == true)
              Row(
                children: [
                  Expanded(
                      child: FormTextField(
                          hint: 'Type your reply ....',
                          action: (v) {
                            setState(() {});
                          },
                          controller: editTextController)),
                  const Sizer(),
                  if (editTextController.text.isNotEmpty)
                    IconAppButton(
                        icon: Icons.send,
                        isCircle: true,
                        onPressed: () async {
                          var result = await widget.onEditComment(
                              PostCommentParams(
                                  postId: widget.reply.id,
                                  content: editTextController.text));
                          if (result == true) {
                            widget.reply.content = editTextController.text;
                            widget.reply.edit = false;
                          }
                          setState(() {});
                        })
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    if (widget.reply.isLove == true) {
                      var result = await controller.onCommentReact(
                          params: PostReactParams(
                              postId: widget.reply.id, react: 'love'));
                      if (result == true) {
                        widget.reply.isLove = false;
                        widget.reply.loveCount = (widget.reply.loveCount! - 1);
                        setState(() {});
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                            state.failure!,
                            context,
                          ),
                        );
                      }
                    } else {
                      var result = await controller.onCommentReact(
                          params: PostReactParams(
                              postId: widget.reply.id, react: 'love'));
                      if (result == true) {
                        widget.reply.isLove = true;
                        widget.reply.loveCount = (widget.reply.loveCount! + 1);
                        setState(() {});
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                            state.failure!,
                            context,
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    widget.reply.isLove == false
                        ? Icons.favorite_border
                        : Icons.favorite,
                    color:
                        widget.reply.isLove == false ? Colors.grey : Colors.red,
                  ),
                ),
                Label(text: '${widget.reply.loveCount}'),
              ],
            ),
          ],
        );
      }),
    );
  }
}
