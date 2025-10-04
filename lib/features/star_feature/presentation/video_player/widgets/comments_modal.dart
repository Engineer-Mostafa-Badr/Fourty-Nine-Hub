import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';

import '../../../data/model/comment_model.dart';
import '../../presentation_exports.dart';

// Updated Comments Modal
class CommentsModal extends StatefulWidget {
  final String videoId;
  final Function(String) onAddComment;

  const CommentsModal({
    super.key,
    required this.videoId,
    required this.onAddComment,
  });

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more comments when reached bottom
      context.read<CommentCubit>().loadMoreComments(widget.videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          return Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text:
                          '${context.isArabic ? 'التعليقات' : 'Comments'} (${state.totalComments.toString().toArabicNumbers(context)})', // تأكد إن العدد يظهر هنا
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Comments list
              Expanded(
                child: state.comments.isEmpty && !state.isLoading
                    ? _buildEmptyCommentsState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.comments.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.comments.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final comment = state.comments[index];
                          return _buildCommentItem(comment, context);
                        },
                      ),
              ),

              // Add comment section
              _buildAddCommentSection(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCommentsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: comment.owner.channelPicture?.mediaKey.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: comment.owner.channelPicture!.mediaKey,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.owner.channelName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo.toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CommentCubit>().likeComment(comment.id);
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 16,
                            color: comment.isLiked
                                ? Colors.blue
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Label(
                            text: comment.likes
                                .toString()
                                .toArabicNumbers(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<CommentCubit>().dislikeComment(comment.id);
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            size: 16,
                            color: comment.isDisliked
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Label(
                            text: comment.dislikes
                                .toString()
                                .toArabicNumbers(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
            onPressed: () => _showCommentOptions(comment),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection(CommentState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 +
            MediaQuery.of(context).viewInsets.bottom, // إضافة مهمة للكيبورد
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onSubmitted: (value) => _submitComment(state),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _commentController.text.isNotEmpty
                    ? Colors.blue
                    : Colors.grey[400],
              ),
              onPressed:
                  state.isCreatingComment ? null : () => _submitComment(state),
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment(CommentState state) {
    if (_commentController.text.isNotEmpty && !state.isCreatingComment) {
      widget.onAddComment(_commentController.text);
      _commentController.clear();
    }
  }

  void _showCommentOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Comment info header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: comment
                                  .owner.channelPicture?.mediaKey.isNotEmpty ==
                              true
                          ? CachedNetworkImage(
                              imageUrl: comment.owner.channelPicture!.mediaKey,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person, color: Colors.grey, size: 16),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.owner.channelName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          comment.content,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Options list
            Column(
              children: [
                // Edit option (only for user's own comments)
                if (_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'تعديل التعليق' : 'Edit Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditCommentDialog(comment);
                    },
                  ),

                // Delete option (only for user's own comments)
                if (_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'حذف التعليق' : 'Delete Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteCommentDialog(comment);
                    },
                  ),

                // Reply option (for all comments)
                if (!comment.isReply)
                  ListTile(
                    leading: Icon(
                      Icons.reply,
                      color: Colors.green,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'رد على التعليق' : 'Reply to Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showReplyDialog(comment);
                    },
                  ),

                // Report option (for other users' comments)
                if (!_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.flag,
                      color: Colors.orange,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic
                          ? 'الإبلاغ عن التعليق'
                          : 'Report Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDialog(comment);
                    },
                  ),

                // Cancel option
                ListTile(
                  leading: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  title: Text(
                    context.isArabic ? 'إلغاء' : 'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

// Check if comment belongs to current user
  bool _isUserComment(CommentModel comment) {
    // هنا تحط الـ logic بتاع التحقق من إن التعليق للمستخدم الحالي
    // ممكن تقارن الـ user ID أو channel name
    return comment.owner.channelName == '@Me'; // مؤقت للتجربة
  }

// Edit comment dialog
  void _showEditCommentDialog(CommentModel comment) {
    final TextEditingController editController =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'تعديل التعليق' : 'Edit Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText:
                context.isArabic ? 'اكتب تعليقك...' : 'Write your comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // Call update comment API
                context.read<CommentCubit>().updateComment(
                      comment.id,
                      editController.text.trim(),
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic ? 'تم تحديث التعليق' : 'Comment updated',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }

// Delete comment dialog
  void _showDeleteCommentDialog(CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'حذف التعليق' : 'Delete Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.isArabic
              ? 'هل أنت متأكد من حذف هذا التعليق؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'Are you sure you want to delete this comment? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call delete comment API
              context.read<CommentCubit>().deleteComment(comment.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic ? 'تم حذف التعليق' : 'Comment deleted',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

// Reply dialog
  void _showReplyDialog(CommentModel comment) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'رد على التعليق' : 'Reply to Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original comment
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${comment.content}"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Reply field
            TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText:
                    context.isArabic ? 'اكتب ردك...' : 'Write your reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // Call reply API
                // context.read<CommentCubit>().replyToComment(
                //       comment.id,
                //       replyController.text.trim(),
                //     );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic ? 'تم إضافة الرد' : 'Reply added',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'رد' : 'Reply'),
          ),
        ],
      ),
    );
  }

// Report dialog
  void _showReportDialog(CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'الإبلاغ عن التعليق' : 'Report Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.isArabic
              ? 'هل تريد الإبلاغ عن هذا التعليق لانتهاكه قواعد المجتمع؟'
              : 'Do you want to report this comment for violating community guidelines?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call report API here

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'تم الإبلاغ عن التعليق'
                        : 'Comment reported',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'إبلاغ' : 'Report'),
          ),
        ],
      ),
    );
  }
}
