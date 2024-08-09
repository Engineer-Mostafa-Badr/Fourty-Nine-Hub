import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/comment_entity.dart';

class CommentCard extends StatelessWidget {
  final Color textColor;
  final CommentEntity comment;
  const CommentCard(
      {super.key, this.textColor = Colors.black, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialPostsCubit>(
      create: (_) => serviceLocator(),
      child: BlocBuilder<SocialPostsCubit, SocialPostsState>(
          builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
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
                IconButton(
                    onPressed: () {
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: comment.id,
                            categoryId: '66a3583454e6e337915514db',
                          ));
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: textColor,
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
                // Label(
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
                      controller.showPostCommentReplies(
                        context: context,
                        commentId: comment.id,
                        postId: comment.post,
                      );
                    })
              ],
            ),
          ],
        );
      }),
    );
  }
}
