import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TwitterReplyCard extends StatefulWidget {
  final Color textColor;
  final TwitterCommentReplyEntity reply;
  final Function(String) onReplyReact;
  final Function(TwitterReportParams) onReport;
  final Function(TwitterPostCommentParams) onEditReply;
  final Function(String) onDeleteReply;

  const TwitterReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onEditReply,
    required this.onDeleteReply,
  });

  @override
  State<TwitterReplyCard> createState() => _TwitterReplyCardState();
}

class _TwitterReplyCardState extends State<TwitterReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            widget.reply.user.image == ''
                ? const ProfileImage(
                    accountId: 0,
                    withBorder: false,
                    userId: '',
                  )
                : ProfileImage(
                    accountId: 0,
                    imageURL: widget.reply.user.image,
                    userId: '',
                  ),
            Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: widget.reply.user.firstName,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: widget.textColor)),
                Label(
                    text: widget.reply.sinceTime,
                    style: Styles.mediumText(color: widget.textColor)),
              ],
            )),
            GestureDetector(
              onTap: () {
                bottomSheet(
                  context: context,
                  widget: _buildPostOptions(
                    isMyComment: widget.reply.user.id == user?.id,
                    post: widget.reply,
                  ),
                );
              },
              child: Icon(
                Icons.more_horiz_outlined,
                color: widget.textColor,
                size: 20,
              ),
            ),
          ],
        ),
        Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: widget.reply.content ?? '',
          style: Styles.mediumText(color: widget.textColor),
        ),
        if (widget.reply.edit == true)
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                maxLines: null,
                controller: editTextController,
                onChanged: (v) {
                  setState(() {});
                },
                style: Styles.headerText(fontSize: 26.sp),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Type your reply ....',
                  hintStyle: Styles.mediumText(),
                ),
              )),
              Sizer(),
              if (editTextController.text.isNotEmpty)
                IconAppButton(
                    icon: Icons.send,
                    isCircle: true,
                    onPressed: () async {
                      var result = await widget.onEditReply(
                          TwitterPostCommentParams(
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
        Sizer(height: 5.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (widget.reply.isReact == true) {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! - 1);
                  setState(() {});
                } else {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! + 1);
                  setState(() {});
                }
              },
              child: Icon(
                widget.reply.isReact == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: widget.reply.isReact == false ? Colors.grey : Colors.red,
              ),
            ),
            Label(
              text: "${widget.reply.loveCount}",
              style: Styles.mediumText(
                color: widget.textColor,
              ),
            ),
          ],
        ),
        Sizer(height: 5.h,),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required TwitterCommentReplyEntity post}) {
    return SizedBox(
      height: isMyComment ? 150 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: 'Report post',
                subTitle: 'Your well reports this post.',
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
                title: 'Delete Post',
                subTitle:
                'Your comment will be deleted, and you cannot get it again',
                onTap: () {
                  widget.onDeleteReply(widget.reply.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.visibility_off,
                title: 'Edit Comment',
                subTitle: 'Your Will Edit Your Comment.',
                onTap: () {
                  widget.reply.edit = !widget.reply.edit!;
                  editTextController.text = widget.reply.content??'';
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
