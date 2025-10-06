import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../domain/entity/comment_entity.dart';

class ReplyModal {
  static void show({
    required BuildContext context,
    required CommentEntity parentComment,
    required Function(String) onReply,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ReplyModalContent(
        parentComment: parentComment,
        onReply: onReply,
      ),
    );
  }
}

class _ReplyModalContent extends StatefulWidget {
  final CommentEntity parentComment;
  final Function(String) onReply;

  const _ReplyModalContent({
    required this.parentComment,
    required this.onReply,
  });

  @override
  State<_ReplyModalContent> createState() => _ReplyModalContentState();
}

class _ReplyModalContentState extends State<_ReplyModalContent> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(context),
            _buildOriginalComment(),
            Divider(),
            _buildReplyInput(context),
          ],
        ),
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
            'Reply to Comment',
            style: TextStyle(
              fontSize: 18,
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

  Widget _buildOriginalComment() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.parentComment.profileImage.isNotEmpty
                ? CachedNetworkImageProvider(widget.parentComment.profileImage)
                : null,
            child: widget.parentComment.profileImage.isEmpty
                ? Icon(Icons.person, size: 14, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 8),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.parentComment.username,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  widget.parentComment.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // User Avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 18, color: Colors.grey),
            ),
            SizedBox(width: 12),

            // Reply Input Field
            Expanded(
              child: TextField(
                controller: _replyController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _submitReply(),
              ),
            ),

            // Send Button
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.blue,
              ),
              onPressed: () {
                ManageVibration.vibrate();
                _submitReply();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitReply() {
    final text = _replyController.text.trim();
    if (text.isNotEmpty) {
      widget.onReply(text);
      Navigator.pop(context);
    }
  }
}
