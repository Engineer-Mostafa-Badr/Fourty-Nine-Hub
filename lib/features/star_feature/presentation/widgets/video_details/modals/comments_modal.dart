import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../domain/entity/comment_entity.dart';
import 'reply_modal.dart';

class CommentsModal {
  static void show({
    required BuildContext context,
    required List<CommentEntity> comments,
    required Function(String) onAddComment,
    required Function(String) onLikeComment,
    Function(String)? onDislikeComment, // New parameter
    required Function(String, String) onReplyToComment,
    Function(String, String)? onUpdateComment, // New parameter
    Function(String)? onDeleteComment, // New parameter
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CommentsModalContent(
        comments: comments,
        onAddComment: onAddComment,
        onLikeComment: onLikeComment,
        onDislikeComment: onDislikeComment,
        onReplyToComment: onReplyToComment,
        onUpdateComment: onUpdateComment,
        onDeleteComment: onDeleteComment,
      ),
    );
  }
}

class _CommentsModalContent extends StatefulWidget {
  final List<CommentEntity> comments;
  final Function(String) onAddComment;
  final Function(String) onLikeComment;
  final Function(String)? onDislikeComment;
  final Function(String, String) onReplyToComment;
  final Function(String, String)? onUpdateComment;
  final Function(String)? onDeleteComment;

  const _CommentsModalContent({
    required this.comments,
    required this.onAddComment,
    required this.onLikeComment,
    this.onDislikeComment,
    required this.onReplyToComment,
    this.onUpdateComment,
    this.onDeleteComment,
  });

  @override
  State<_CommentsModalContent> createState() => _CommentsModalContentState();
}

class _CommentsModalContentState extends State<_CommentsModalContent> {
  final TextEditingController _commentController = TextEditingController();
  String? _editingCommentId;
  final TextEditingController _editController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: AppColors.c0B1035,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(context),
          Divider(),
          _buildCommentsList(),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.only(top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              ManageVibration.vibrate();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (widget.comments.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.comment_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No comments yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          final comment = widget.comments[index];
          return _buildCommentItem(comment);
        },
      ),
    );
  }

  Widget _buildCommentItem(CommentEntity comment) {
    final isEditing = _editingCommentId == comment.id;

    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        left: comment.isReply ? 40 : 0, // Indent replies
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: comment.isReply ? 16 : 18,
            backgroundColor: Colors.grey[300],
            backgroundImage: comment.profileImage.isNotEmpty
                ? CachedNetworkImageProvider(comment.profileImage)
                : null,
            child: comment.profileImage.isEmpty
                ? Icon(
                    Icons.person,
                    size: comment.isReply ? 16 : 20,
                    color: Colors.grey,
                  )
                : null,
          ),
          SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and time
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '• ${comment.timeAgo}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    Spacer(),
                    // More options menu
                    if (comment.username ==
                        '@Me') // Only show for user's own comments
                      _buildMoreOptionsMenu(comment),
                  ],
                ),
                SizedBox(height: 4),

                // Comment text or edit field
                if (isEditing)
                  _buildEditField(comment)
                else
                  Text(
                    comment.content,
                    style: TextStyle(fontSize: 14),
                  ),
                SizedBox(height: 8),

                // Action buttons
                if (!isEditing) _buildCommentActions(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsMenu(CommentEntity comment) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _startEditing(comment);
            break;
          case 'delete':
            _showDeleteConfirmation(comment);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditField(CommentEntity comment) {
    return Column(
      children: [
        TextField(
          controller: _editController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          maxLines: null,
          autofocus: true,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _cancelEditing,
              child: Text('Cancel'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _saveEdit(comment),
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentActions(CommentEntity comment) {
    return Row(
      children: [
        // Like button
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            widget.onLikeComment(comment.id);
          },
          child: Row(
            children: [
              Icon(
                comment.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16,
                color: comment.isLiked ? Colors.blue : Colors.grey[600],
              ),
              SizedBox(width: 4),
              Text(
                '${comment.likes}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),

        // Dislike button
        if (widget.onDislikeComment != null)
          GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              widget.onDislikeComment!(comment.id);
            },
            child: Row(
              children: [
                Icon(
                  comment.isDisliked
                      ? Icons.thumb_down
                      : Icons.thumb_down_outlined,
                  size: 16,
                  color: comment.isDisliked ? Colors.red : Colors.grey[600],
                ),
                if (comment.dislikes > 0) ...[
                  SizedBox(width: 4),
                  Text(
                    '${comment.dislikes}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          )
        else
          Icon(
            Icons.thumb_down_outlined,
            size: 16,
            color: Colors.grey[600],
          ),
        SizedBox(width: 16),

        // Reply button (only for main comments)
        if (!comment.isReply)
          GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              _showReplyModal(comment);
            },
            child: Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4),
                Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 18, color: Colors.grey),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (value) => _submitComment(),
                maxLines: null,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.blue,
              ),
              onPressed: () {
                ManageVibration.vibrate();
                _submitComment();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      widget.onAddComment(text);
      _commentController.clear();
    }
  }

  void _showReplyModal(CommentEntity comment) {
    ReplyModal.show(
      context: context,
      parentComment: comment,
      onReply: (replyText) {
        widget.onReplyToComment(comment.id, replyText);
      },
    );
  }

  void _startEditing(CommentEntity comment) {
    setState(() {
      _editingCommentId = comment.id;
      _editController.text = comment.content;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingCommentId = null;
      _editController.clear();
    });
  }

  void _saveEdit(CommentEntity comment) {
    final newContent = _editController.text.trim();
    if (newContent.isNotEmpty && widget.onUpdateComment != null) {
      widget.onUpdateComment!(comment.id, newContent);
      _cancelEditing();
    }
  }

  void _showDeleteConfirmation(CommentEntity comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onDeleteComment != null) {
                widget.onDeleteComment!(comment.id);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
