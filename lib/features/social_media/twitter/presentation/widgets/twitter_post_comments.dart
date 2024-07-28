import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterPostComments extends StatefulWidget {
  final List<TwitterPostCommentEntity> comments;
  final String postId;
  final Function(PostCommentParams) onAddComment;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(String,TwitterPostCommentEntity) onGetReplies;
  final Function(TwitterCommentReactParams ) onCommentReact;
  const TwitterPostComments(
      {super.key,
      required this.postId,
      required this.comments,
      required this.onAddComment,
      required this.onCommentReact, required this.onAddReply, required this.onGetReplies});

  @override
  State<TwitterPostComments> createState() => _TwitterPostCommentsState();
}

class _TwitterPostCommentsState extends State<TwitterPostComments> {
  final commentTextController = TextEditingController();
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool showReplies = false;
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
      body: BlocProvider<TwitterCubit>(
        create: (_)=>serviceLocator(),
        child: BlocBuilder<TwitterCubit,TwitterState>(
          builder: (context,state) {
            final controller = context.read<TwitterCubit>();
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => _buildCommentCard(
                          comment: widget.comments[index], showReplies: showReplies, onShowReplies:()async{
                          widget.comments[index].showReplies = true;

                          await widget.onGetReplies(widget.comments[index].id,widget.comments[index]);
                          widget.comments[index].replies?.addAll(controller.replies);
                          print('length123 = ${controller.replies.length}');
                          print('length11 = ${widget.comments[index].replies?.length}');
                          print('length = ${state.commentReplies?.length}');
                          // print("shown ${comment.showReplies}");
                          // print("shown ${comment.re}");
                          setState(() {

                          });

                      }),
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
            );
          }
        ),
      ),
    );
  }

  void onCommentAdded() async {
    await widget.onAddComment(
      PostCommentParams(
          postId: widget.postId, content: commentTextController.text),
    );
    widget.comments.insert(
        0,
        TwitterPostCommentModel(
            id: 'id',
            content: commentTextController.text,
            post: widget.postId,
            createdAt: DateTime.now(),
            adminIgnore: false,
            user: '',
            // image: '',
            love: []));
    commentTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard(
      {required TwitterPostCommentEntity comment, required bool showReplies,required Function onShowReplies}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterCommentCard(
          comment: comment,

          onCommentReact: (){
            widget.onCommentReact(
              TwitterCommentReactParams(commentId: comment.id, react: 'love')
            );
          },
          onCommentReply: () {
             widget.onGetReplies(comment.id,comment);

            print(comment.showReplies);
          },
        ),
      ],
    );
  }
}
