import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/reply_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class CommentReplies extends StatefulWidget {
  final List<CommentEntity> replies;
  final String commentId;
  final String postId;
  final Function(ReplyOnCommentParams) onAddReply;
  const CommentReplies({
    super.key,
    required this.replies,
    required this.commentId,
    required this.postId, required this.onAddReply,
  });

  @override
  State<CommentReplies> createState() => _CommentRepliesState();
}

class _CommentRepliesState extends State<CommentReplies> {
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
      body: BlocProvider<SocialPostsCubit>(
        create: (_) => serviceLocator(),
        child:
            BlocBuilder<SocialPostsCubit, SocialPostsState>(builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
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
                            CommentEntity data = await controller.replyOnComment(
                              params:ReplyOnCommentParams(
                                  postId: widget.postId, content: replyTextController.text,commentId: widget.commentId),
                            );
                            final user = context.read<UserCubit>().state.data;
                            print("add");
                            widget.replies.add(
                              CommentModel(
                                id: data.id,
                                content: replyTextController.text,
                                post: widget.postId,
                                createdAt: DateTime.now(),
                                loveCount: data.loveCount,
                                angryCount: data.angryCount,
                                likesCount: data.likesCount,
                                repliesCount: data.repliesCount,
                                sadCount: data.sadCount,
                                wowCount: data.wowCount,
                                totalCount: data.totalCount,
                                isAngry: false,
                                isLikes: false,
                                isLove: false,
                                isSad: false,
                                isWow: false,
                                user: TwitterUserEntity(
                                  id: user!.id,
                                  firstName: user.firstName,
                                  lastName: user.lastName,
                                  createdAt: DateTime.now(),
                                  image: user.profilePicture ?? '',
                                  email: user.email ?? '',
                                  isDocumented: false,
                                ),
                              ),
                            );
                            print("add");
                            replyTextController.clear();
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
    CommentModel data = await widget.onAddReply(
      ReplyOnCommentParams(
          postId: widget.postId, content: replyTextController.text,commentId: widget.commentId),
    );
    final user = context.read<UserCubit>().state.data;

    widget.replies.add(
      CommentModel(
        id: data.id,
        content: replyTextController.text,
        post: widget.postId,
        createdAt: DateTime.now(),
        loveCount: data.loveCount,
        angryCount: data.angryCount,
        likesCount: data.likesCount,
        repliesCount: data.repliesCount,
        sadCount: data.sadCount,
        wowCount: data.wowCount,
        isAngry: false,
        isLikes: false,
        isLove: false,
        isSad: false,
        isWow: false,
        user: TwitterUserEntity(
          id: user!.id,
          firstName: user.firstName,
          lastName: user.lastName,
          createdAt: DateTime.now(),
          image: user.profilePicture ?? '',
          email: user.email ?? '',
          isDocumented: false,
        ),
      ),
    );
    replyTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard({required CommentEntity reply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReplyCard(
          reply: reply,
          onReplyReact: (String id) {
            // widget.onReplyReact(id);
            // reply.isReact = !reply.isReact!;
          },
          onReport: (TwitterReportParams params) {
            // widget.onReport(params);
          },
        ),
      ],
    );
  }
}
