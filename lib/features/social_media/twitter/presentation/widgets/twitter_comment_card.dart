import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TwitterCommentCard extends StatefulWidget {
  final Color textColor;
  final TwitterPostCommentEntity comment;
  final Function onCommentReact;
  final Function onCommentReply;
  final Function(TwitterPostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final bool? fromProfile;
  final Function(TwitterReportParams) onReport;
  const TwitterCommentCard(
      {super.key,
      this.textColor = Colors.black,
      required this.comment,
      required this.onCommentReact,
      required this.onCommentReply,
      required this.onReport,
      this.fromProfile = false,
      required this.onEditComment,
      required this.onDeleteComment});

  @override
  State<TwitterCommentCard> createState() => _TwitterCommentCardState();
}

class _TwitterCommentCardState extends State<TwitterCommentCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            widget.comment.user.image == ''
                ? UserProfileImage(
                    accountId: 0,
                    withBorder: false,
                    fromProfile: widget.fromProfile,
                    userId: widget.comment.user.id,
                  )
                : UserProfileImage(
                    accountId: 0,
                    imageURL: widget.comment.user.image,
                    fromProfile: widget.fromProfile,
                    userId: widget.comment.user.id,
                  ),
            Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: widget.comment.user.firstName,
                    style: Styles.mediumText(fontWeight: FontWeight.bold)),
                Label(
                    text: widget.comment.sinceTime, style: Styles.mediumText()),
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
                color: widget.textColor,
                size: 20,
              ),
            ),
          ],
        ),
        Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: widget.comment.content ?? '',
          style: Styles.mediumText(),
        ),
        if (widget.comment.edit == true)
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                Expanded(
                    child:
                TextFormField(
                maxLines: null,
                controller: editTextController,
                onChanged: (v) {
                setState(() {});
                },
                style: Styles.headerText(fontSize: 26.sp),
                decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Type your comment ....',
                hintStyle: Styles.mediumText(),
                ),
                )
                    ),
                Sizer(),
                if (editTextController.text.isNotEmpty)
                  IconAppButton(
                      icon: Icons.send,
                      isCircle: true,
                      size: 20,
                      onPressed: () async {
                        var result = await widget.onEditComment(
                            TwitterPostCommentParams(
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
        Sizer(height: 5.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (widget.comment.isReact == true) {
                  widget.onCommentReact();
                  widget.comment.loveCount = (widget.comment.loveCount! - 1);
                  setState(() {});
                } else {
                  widget.onCommentReact();
                  widget.comment.loveCount = widget.comment.loveCount! + 1;
                  setState(() {});
                }
              },
              child: Icon(
                widget.comment.isReact == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color:
                    widget.comment.isReact == false ? Colors.grey : Colors.red,
              ),
            ),
            Label(
                text: widget.comment.loveCount.toString(),
                style: Styles.mediumText(color: widget.textColor)),
            Sizer(),
            TextAppButton(
                style: Styles.mediumText(),
                label: 'Reply',
                onPressed: widget.onCommentReply)
          ],
        ),
        Sizer(height: 5.h,),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required TwitterPostCommentEntity post}) {
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
                  widget.onDeleteComment(widget.comment.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.visibility_off,
                title: 'Edit Comment',
                subTitle: 'Your Will Edit Your Comment.',
                onTap: () {
                  widget.comment.edit = !widget.comment.edit!;
                  editTextController.text = widget.comment.content??'';
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
