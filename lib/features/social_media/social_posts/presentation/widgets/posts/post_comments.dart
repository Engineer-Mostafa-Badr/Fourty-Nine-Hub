import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../reels/presentation/widgets/add_comment.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import 'comment_card.dart';

class PostComments extends StatelessWidget {
  final List<CommentEntity> comments;
  final Function(PostCommentParams) onAddComment;
  const PostComments({super.key , required this.comments, 
  required this.onAddComment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(text: '${comments.length} Comments', style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => _buildCommentCard(comment: comments[index]),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: comments.length),
      bottomSheet: const AddComment(),
    );
  }

  Widget _buildCommentCard({
    required CommentEntity comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(comment: comment,),
        Container(
            margin: const EdgeInsets.only(left: 30),
            child: TextAppButton(label: 'show ${comment.repliesCount} replies', onPressed: () {})
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
