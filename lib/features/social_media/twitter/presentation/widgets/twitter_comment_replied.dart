import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_reply_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
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
  final Function(String) onReplyReact;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(TwitterReportParams) onReport;
  final UserEntity userData;
  const TwitterCommentReplies({
    super.key,
    required this.replies,
    required this.onReplyReact,
    required this.onAddReply,
    required this.commentId,
    required this.postId,
    required this.onReport,
    required this.userData,
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
        create: (_) => serviceLocator(),
        child:
            BlocBuilder<TwitterCubit, TwitterState>(builder: (context, state) {
          final controller = context.read<TwitterCubit>();
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
                          onPressed: () async {
                            TwitterCommentReplyEntity data =
                                await controller.onCommentReply(
                              params: TwitterCommentReplyParams(
                                  postId: widget.postId,
                                  reply: widget.commentId,
                                  content: replyTextController.text),
                            );
                            print("state.newReply?.id${state.newReply?.id}");
                            widget.replies.insert(
                                0,
                                TwitterCommentReplyModel(
                                    id: data.id,
                                    content: replyTextController.text,
                                    post: widget.postId,
                                    createdAt: data.createdAt,
                                    user: TwitterUserEntity(
                                        id: widget.userData.id,
                                        firstName: widget.userData.firstName,
                                        lastName: widget.userData.lastName,
                                        createdAt: DateTime.now(),
                                        image: widget.userData.profilePicture ??
                                            '',
                                        email: widget.userData.email ?? '',
                                        isDocumented: false),
                                    love: data.love,
                                    isReact: data.isReact,
                                    image: data.image));
                            replyTextController.clear();
                            print(widget.replies.length);
                            setState(() {});
                          },
                        )
                    ],
                  )),
            ],
          );
        }),
      ),
    );
  }

  void onReplyAdded() async {
    var newReply = await widget.onAddReply(
      TwitterCommentReplyParams(
          postId: widget.postId,
          reply: widget.commentId,
          content: replyTextController.text),
    );
    widget.replies.insert(
        0,
        TwitterCommentReplyEntity(
            id: newReply.id,
            content: replyTextController.text,
            post: widget.postId,
            createdAt: DateTime.now(),
            user: '',
            // image: '',
            love: [],
            isReact: false,
            image: ''));
    replyTextController.clear();
    setState(() {});
    replyTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard({required TwitterCommentReplyEntity reply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterReplyCard(
          reply: reply,
          onReplyReact: (String id) {
            widget.onReplyReact(id);
            reply.isReact = !reply.isReact!;
          },
          onReport: (TwitterReportParams params) {
            widget.onReport(params);
          },
        ),
      ],
    );
  }
}
