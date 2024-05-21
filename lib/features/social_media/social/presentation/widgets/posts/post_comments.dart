import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../reels/presentation/widgets/add_comment.dart';
import 'comment_card.dart';

class PostComments extends StatefulWidget {
  const PostComments({super.key});

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  bool showReplies = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(text: '14 Comments', style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => _buildCommentCard(index: index),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: 10),
      bottomSheet: const AddComment(),
    );
  }

  Widget _buildCommentCard({
    required int index,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       CommentCard(),
        Container(
          margin: const EdgeInsets.only(left: 30),
          child: !showReplies
              ? TextAppButton(
                  label: 'show 3 replies',
                  onPressed: () {
                    showReplies = true;
                    setState(() {});
                  })
              : ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => CommentCard()),
        )
      ],
    );
  }

}
