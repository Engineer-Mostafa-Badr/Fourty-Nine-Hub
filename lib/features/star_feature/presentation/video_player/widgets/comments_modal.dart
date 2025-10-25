import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../data/model/comment_model.dart';
import '../../presentation_exports.dart';

// Extension to translate timeAgo to Arabic
extension TimeAgoExtension on String {
  String toArabicTimeAgo(BuildContext context) {
    if (!context.isArabic) return this;

    // Extract number and unit from English string
    final parts = trim().split(' ');
    if (parts.length < 2) return this;

    final number = parts[0];
    final unit = parts[1].toLowerCase();

    // Translate "Just now"
    if (contains('Just now') || contains('just now')) {
      return 'الآن';
    }

    // Translate time units
    String arabicUnit = '';
    if (unit.contains('year')) {
      arabicUnit = int.parse(number) == 1 ? 'سنة' : 'سنوات';
    } else if (unit.contains('month')) {
      arabicUnit = int.parse(number) == 1 ? 'شهر' : 'أشهر';
    } else if (unit.contains('day')) {
      arabicUnit = int.parse(number) == 1 ? 'يوم' : 'أيام';
    } else if (unit.contains('hour')) {
      arabicUnit = int.parse(number) == 1 ? 'ساعة' : 'ساعات';
    } else if (unit.contains('minute')) {
      arabicUnit = int.parse(number) == 1 ? 'دقيقة' : 'دقائق';
    } else {
      return this; // Unknown unit, return as is
    }

    return 'منذ $number $arabicUnit';
  }
}

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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _commentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _commentController.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more comments when reached bottom
      context.read<CommentCubit>().loadMoreComments(widget.videoId);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        // color: Colors.white,
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
            context.isArabic ? 'لا توجد تعليقات' : 'No comments yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            context.isArabic
                ? 'بدء التعليقات من هنا'
                : 'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment, BuildContext context,
      {bool isReply = false}) {
    final mediaKey = comment.owner.channelPicture?.mediaKey;
    final hasAvatar = mediaKey != null && mediaKey.trim().isNotEmpty;
    Widget avatar = hasAvatar
        ? ImageFromInternet(
            image: mediaKey,
            width: 36,
            height: 36,
            isCircle: true,
            fit: BoxFit.cover,
          )
        : Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          );
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        // Find the updated comment from state (search in both comments and replies)
        final updatedComment =
            state.comments.expand((c) => [c, ...c.replies]).firstWhere(
                  (c) => c.id == comment.id,
                  orElse: () => comment,
                );

        return Container(
          margin: EdgeInsets.only(bottom: 20, left: isReply ? 48 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar,
              const SizedBox(width: 12),

              // Comment content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            updatedComment.owner.channelName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          updatedComment.timeAgo
                              .toArabicTimeAgo(context)
                              .toArabicNumbers(context),
                          style: TextStyle(
                            fontSize: 12,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      updatedComment.content,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<CommentCubit>()
                                .likeComment(updatedComment.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                updatedComment.isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                size: 16,
                                color: updatedComment.isLiked
                                    ? Colors.blue
                                    : context.isDarkMode
                                        ? Colors.white
                                        : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Label(
                                text: updatedComment.likes
                                    .toString()
                                    .toArabicNumbers(context),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<CommentCubit>()
                                .dislikeComment(updatedComment.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                updatedComment.isDisliked
                                    ? Icons.thumb_down
                                    : Icons.thumb_down_outlined,
                                size: 16,
                                color: updatedComment.isDisliked
                                    ? Colors.red
                                    : context.isDarkMode
                                        ? Colors.white
                                        : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Label(
                                text: updatedComment.dislikes
                                    .toString()
                                    .toArabicNumbers(context),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isReply) ...[
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => _showReplyDialog(updatedComment),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.reply,
                                  size: 16,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.isArabic ? 'رد' : 'Reply',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Show replies if they exist
                    if (updatedComment.replies.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...updatedComment.replies.map((reply) =>
                          _buildCommentItem(reply, context, isReply: true)),
                    ],
                  ],
                ),
              ),

              // More options
              IconButton(
                icon: Icon(Icons.more_vert,
                    size: 18,
                    color:
                        context.isDarkMode ? Colors.white : Colors.grey[600]),
                onPressed: () => _showCommentOptions(updatedComment),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
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
        // color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Avatar
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
                  hintText:
                      context.isArabic ? 'اكتب تعليقك...' : 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onSubmitted: (value) => _submitComment(state),
                enabled: !state.isCreatingComment,
              ),
            ),
            const SizedBox(width: 8),
            state.isCreatingComment
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.send,
                      color: _hasText ? Colors.blue : Colors.grey[400],
                    ),
                    onPressed: _hasText ? () => _submitComment(state) : null,
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
      // backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          // color: Colors.white,
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
                color: context.isDarkMode ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Comment info header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  comment.owner.channelPicture?.mediaKey.isNotEmpty == true
                      ? ImageFromInternet(
                          image: comment.owner.channelPicture!.mediaKey,
                          width: 32,
                          height: 32,
                          isCircle: true,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.grey,
                              size: 16),
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
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.grey[600],
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
                      color: AppColors.PRIMARY_COLOR,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'تعديل التعليق' : 'Edit Comment',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.PRIMARY_COLOR,
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
                      color: AppColors.red_Color_DARK,
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
    final currentUserId = UserCubit.to.state.data?.id;
    return currentUserId != null && comment.userId == currentUserId;
  }

// Edit comment dialog
  void _showEditCommentDialog(CommentModel comment) {
    final TextEditingController editController =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                final commentId = comment.id;
                final content = editController.text.trim();
                final videoId = widget.videoId;
                final isArabic = context.isArabic;

                // Close dialog first
                Navigator.pop(dialogContext);

                // Call update comment API
                context.read<CommentCubit>().updateComment(
                      commentId,
                      content,
                      videoId,
                    );

                // Show message
                showSuccessMessage(
                  context,
                  isArabic ? 'جاري تحديث التعليق...' : 'Updating comment...',
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
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final commentId = comment.id;
              final videoId = widget.videoId;
              final isArabic = context.isArabic;

              // Close dialog first
              Navigator.pop(dialogContext);

              // Call delete comment API
              context.read<CommentCubit>().deleteComment(commentId, videoId);

              // Show message
              showSuccessMessage(
                context,
                isArabic ? 'جاري حذف التعليق...' : 'Deleting comment...',
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
    showDialog(
      context: context,
      builder: (context) => _ReplyDialog(
        comment: comment,
        videoId: widget.videoId,
      ),
    );
  }

  // Report dialog - استخدام ReportView
  void _showReportDialog(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,
      builder: (context) => ReportView(
        id: comment.userId,
        categoryId: comment.id, // استخدام comment ID كـ categoryId
      ),
    );
  }
}

// Reply Dialog as separate StatefulWidget
class _ReplyDialog extends StatefulWidget {
  final CommentModel comment;
  final String videoId;

  const _ReplyDialog({
    required this.comment,
    required this.videoId,
  });

  @override
  State<_ReplyDialog> createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<_ReplyDialog> {
  late final TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.isArabic
            ? 'الرد على ${widget.comment.owner.channelName}'
            : 'Reply to ${widget.comment.owner.channelName}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: _replyController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: context.isArabic ? 'اكتب ردك...' : 'Write your reply...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
            final replyText = _replyController.text.trim();
            if (replyText.isNotEmpty) {
              final videoId = widget.videoId;
              final parentCommentId = widget.comment.id;
              final isArabic = context.isArabic;

              // Close dialog first
              Navigator.pop(context);

              // Call reply API
              context.read<CommentCubit>().replyToComment(
                    videoId: videoId,
                    parentCommentId: parentCommentId,
                    content: replyText,
                  );

              // Show message
              showSuccessMessage(
                context,
                isArabic ? 'جاري إضافة الرد...' : 'Adding reply...',
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(context.isArabic ? 'إرسال' : 'Send'),
        ),
      ],
    );
  }
}
