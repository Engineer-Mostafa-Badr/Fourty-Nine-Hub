import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
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
  final Function(TwitterReportParams) onReport;
  const InstagramReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
  });

  @override
  State<InstagramReplyCard> createState() => _InstagramReplyCardState();
}

class _InstagramReplyCardState extends State<InstagramReplyCard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator(),
      child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileImage(
                  accountId: 0,
                  withBorder: false,
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
              ],
            ),
            const Sizer(),
            Label(
              textAlign: TextAlign.start,
              text: widget.reply.content,
              style: Styles.mediumText(color: widget.textColor),
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
