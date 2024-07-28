import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_reply_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterCommentReplies extends StatefulWidget {
  final List<TwitterCommentReplyEntity> replies;
  final String commentId;
  final String postId;
  final GestureTapCallback? onReplyReact;
  final Function(TwitterCommentReplyParams) onAddReply;
  const TwitterCommentReplies(
      {super.key, required this.replies, this.onReplyReact, required this.onAddReply, required this.commentId, required this.postId,
      });

  @override
  State<TwitterCommentReplies> createState() => _TwitterCommentRepliesState();
}

class _TwitterCommentRepliesState extends State<TwitterCommentReplies> {
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(
            text: '${widget.replies.length} Replies',
            style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: BlocProvider<TwitterCubit>(
        create: (_)=>serviceLocator(),
        child: BlocBuilder<TwitterCubit,TwitterState>(
          builder: (context,state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => _buildCommentCard(
                          reply: widget.replies[index],
                          ),
                      separatorBuilder: (context, index) => const Sizer(),
                      itemCount: widget.replies.length),
                ),
                Container(
                    height: kToolbarHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ProfileImage(accountId: 0),
                        const Sizer(),
                        Expanded(
                            child: FormTextField(
                                hint: 'Type your reply ....',
                                height: kToolbarHeight * .7,
                                action: (v) {
                                  setState(() {});
                                },
                                controller: replyTextController)),
                        const Sizer(),
                        if (replyTextController.text.isNotEmpty)
                          IconAppButton(
                              icon: Icons.send,
                              isCircle: true,
                              onPressed: () => onReplyAdded(),
                          )
                      ],
                    )),
              ],
            );
          }
        ),
      ),
    );
  }

  void onReplyAdded() async {
    await widget.onAddReply(
      TwitterCommentReplyParams(postId: widget.postId,reply: widget.commentId,content: replyTextController.text),
    );
    replyTextController.clear();
    setState(() {

    });
    replyTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard(
      {required TwitterCommentReplyEntity reply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterReplyCard(reply: reply,),
       ],
    );
  }
}
