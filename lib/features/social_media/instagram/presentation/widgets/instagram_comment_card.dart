import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_comment_replies.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class InstagramCommentCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity comment;
  const InstagramCommentCard(
      {super.key,
      this.textColor = Colors.black,
      required this.comment,
      });

  @override
  State<InstagramCommentCard> createState() => _InstagramCommentCardState();
}

class _InstagramCommentCardState extends State<InstagramCommentCard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator(),
      child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (context, state) {
            // final controller = context.read<InstagramCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfileImage(
                      accountId: 0,
                      withBorder: false,
                      imageURL: widget.comment.user.image.isNotEmpty?widget.comment.user.image:null,
                    ),
                    const Sizer(),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(
                                text: widget.comment.user.firstName,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold, color: widget.textColor)),
                            Label(
                                text: widget.comment.sinceTime,
                                style: Styles.mediumText(color: widget.textColor)),
                          ],
                        )),
                    IconButton(
                        onPressed: () {
                          bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: widget.comment.id,
                                categoryId: '66a3583454e6e337915514db',
                              ));
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: widget.textColor,
                        )),
                  ],
                ),
                const Sizer(),
                Label(
                  textAlign: TextAlign.start,
                  text: widget.comment.content,
                  style: Styles.mediumText(color: widget.textColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.comment.isLove == true) {
                          // widget.onCommentReact();
                          widget.comment.isLove=false;
                          widget.comment.loveCount = (widget.comment.loveCount! - 1);
                          setState(() {});
                        } else {
                          print("object");
                          // widget.onCommentReact();
                          widget.comment.isLove=true;
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
                    Label(text: '${widget.comment.loveCount}'),
                    const Sizer(),
                    TextAppButton(
                        style: Styles.mediumText(),
                        label: 'Reply',
                        onPressed: () {
                          bottomSheet(
                              context: context,
                              isScrollControlled: true,
                              widget: InstagramCommentReplies(
                                postId: widget.comment.post, commentId: widget.comment.id,
                                onAddReply: (ReplyOnCommentParams params) {
                                  // replyOnComment(params: params);
                                },
                              ));
                        })
                  ],
                ),
              ],
            );
          }),
    );
  }
}
