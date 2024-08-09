import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../data/models/comment_model.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../widgets/posts/comment_card.dart';

class PostDetailsPage extends StatefulWidget {
  final List<CommentEntity> comments;
  final PostEntity post;
  final Function(PostCommentParams) onAddComment;
  final Function(PostReactParams) onReact;
  final Function(String) showPostComments;
  final Function(PostEntity) showPostDetails;
  final Function(String) deletePost;
  final Function(String) hidePost;
  const PostDetailsPage({
    super.key,
    required this.post,
    required this.onAddComment,
    required this.onReact,
    required this.showPostComments,
    required this.showPostDetails,
    required this.comments,
    required this.deletePost,
    required this.hidePost,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(text: 'Post', style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FacebookPostCard(
              post: widget.post,
              onReact: widget.onReact,
              deletePost: widget.deletePost,
              hidePost: widget.hidePost,
              showPostDetails: widget.showPostDetails,
              showPostComments: widget.showPostComments,
            onShare: (String id) {
            },
            from: 'details',
            isMyPost: user?.id==widget.post.user.id,
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _buildCommentCard(comment: widget.comments[index]),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: widget.comments.length),
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
                          hint: 'Type your comment ....',
                          height: kToolbarHeight * .7,
                          action: (v) {
                            setState(() {});
                          },
                          controller: commentTextController)),
                  const Sizer(),
                  if (commentTextController.text.isNotEmpty)
                    IconAppButton(
                        icon: Icons.send,
                        isCircle: true,
                        onPressed: () => onCommentAdded())
                ],
              )),
        ],
      ),
    );
  }

  void onCommentAdded() async{
    CommentModel data = await widget.onAddComment(
      PostCommentParams(
          postId: widget.post.id, content: commentTextController.text),
    );
    final user = context.read<UserCubit>().state.data;

    widget.comments.add(
      CommentModel(
        id: data.id,
        content: commentTextController.text,
        post: widget.post.id,
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
        isWow: false, user: data.user,
      ),
    );
    commentTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard({
    required CommentEntity comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(
          comment: comment,
        ),
        if (comment.repliesCount != 0)
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: TextAppButton(
                  label: 'show ${comment.repliesCount} replies',
                  onPressed: () {})
              // : ListView.builder(
              //     itemCount: 3,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) => CommentCard()),
              )
      ],
    );
  }
}
