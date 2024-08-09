import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_comment_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';

class InstagramPostComments extends StatefulWidget {
  final List<CommentEntity> comments;
  final String postId;
  final Function(PostCommentParams) onAddComment;
  const InstagramPostComments(
      {super.key,
      required this.postId,
      required this.comments,
      required this.onAddComment,
       });

  @override
  State<InstagramPostComments> createState() => _InstagramPostCommentsState();
}

class _InstagramPostCommentsState extends State<InstagramPostComments> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(
            text: '${widget.comments.length} Comments',
            style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: BlocProvider<InstagramCubit>(
        create: (_)=>serviceLocator(),
        child: BlocBuilder<InstagramCubit,InstagramState>(
            builder: (context,state) {
              final controller = context.read<InstagramCubit>();
              return Column(
                children: [
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
                              onPressed: () async{
                                CommentEntity data = await controller.onPostComment(
                                  params:PostCommentParams(
                                      postId: widget.postId, content: commentTextController.text),
                                );
                                final user = context.read<UserCubit>().state.data;

                                widget.comments.insert(
                                  0,
                                  CommentModel(
                                    id: data.id,
                                    content: commentTextController.text,
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
                                commentTextController.clear();
                                setState(() {});
                              },),
                        ],
                      )),
                ],
              );
            }
        ),
      ),

    );
  }

  void onCommentAdded() async {
    CommentModel data = await widget.onAddComment(
      PostCommentParams(
          postId: widget.postId, content: commentTextController.text),
    );
    final user = context.read<UserCubit>().state.data;

    widget.comments.add(
      CommentModel(
        id: data.id,
        content: commentTextController.text,
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
    commentTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard({
    required CommentEntity comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstagramCommentCard(
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

