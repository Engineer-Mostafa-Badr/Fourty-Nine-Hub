import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/comment_replies.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/comment_entity.dart';

class CommentCard extends StatelessWidget {
  final Color textColor;
  final String from;
  final CommentEntity comment;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;

  const CommentCard(
      {super.key, this.textColor = Colors.black, required this.comment, required this.onAddReply, required this.onDeleteComment, required this.onDeleteReply, required this.from});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImage(
              accountId: 0,
              withBorder: false,
              imageURL: comment.user.image.isNotEmpty?comment.user.image:null,
            ),
            const Sizer(),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: comment.user.firstName,
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold, color: textColor)),
                    Label(
                        text: comment.sinceTime,
                        style: Styles.mediumText(color: textColor)),
                  ],
                )),
            GestureDetector(
                onTap: () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: comment.id,
                        categoryId: '66a3583454e6e337915514db',
                      ));
                },
                child: Icon(
                  Icons.more_vert,
                  color: textColor,
                )),
            const Sizer(),
            GestureDetector(
                onTap: (){
                  onDeleteComment(comment.id);
                },
                child: Icon(
                  Icons.close,
                  color: textColor,
                  size: 20,
                )),
          ],
        ),
        const Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: comment.content,
          style: Styles.mediumText(color: textColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BuildReactionsButtons(
              post: comment,
              from: 'comments',
            ),
            // if(comment.isLikes==true||comment.isSad==true||comment.isWow==true||comment.isAngry==true||comment.isLove==true)Label(
            //     text: "${
            //         comment.isLikes==true?comment.likesCount
            //         :comment.isSad==true?comment.sadCount
            //         :comment.isWow==true?comment.wowCount
            //         :comment.isAngry==true?comment.angryCount
            //         :comment.isLove==true?comment.loveCount
            //             :0
            //     }",
            //     style: Styles.mediumText(color: textColor)),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(),
                label: 'Reply',
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: BlocProvider.value(
                        value: serviceLocator<SocialPostsCubit>()..loadReplies(context,comment.id),
                        child: CommentReplies(
                          replies: const [],
                          postId: comment.post, commentId: comment.id,
                          onAddReply: (ReplyOnCommentParams params) =>onAddReply(params), onDeleteReply: (String id)=>onDeleteReply(id), from: from,
                        ),
                      ));
                })
          ],
        ),
      ],
    );
  }
}
