import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../data/model/comment_model.dart';
import '../../controller/comment_cubit/comment_cubit.dart';

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

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.only(
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
              _buildHeader(state),

              const Divider(),

              // Comments list
              Expanded(
                child: state.comments.isEmpty && !state.isLoading
                    ? _buildEmptyCommentsState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.comments.length + (state.isLoading ? 1 : 0),
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
                          return _buildCommentItem(comment);
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

  Widget _buildHeader(CommentState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.isArabic
                ? 'التعليقات (${state.totalComments})'
                : 'Comments (${state.totalComments})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
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
          const SizedBox(height: 16),
          Text(
            context.isArabic ? 'لا توجد تعليقات بعد' : 'No comments yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.isArabic ? 'كن أول من يعلق!' : 'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
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
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey,
                      ),
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
                      comment.timeAgo,
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
                  style: TextStyle(
                    fontSize: 14,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Like button
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
                    const SizedBox(width: 16),
                    // Dislike button
                    GestureDetector(
                      onTap: () {
                        context.read<CommentCubit>().dislikeComment(comment.id);
                      },
                      child: Icon(
                        comment.isDisliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_outlined,
                        size: 16,
                        color: comment.isDisliked ? Colors.red : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Reply button
                    GestureDetector(
                      onTap: () {
                        // Handle reply
                      },
                      child: Text(
                        context.isArabic ? 'رد' : 'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
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
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[900] : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // User avatar
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

            // Text input
            Expanded(
              child: TextField(
                controller: _commentController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'إضافة تعليق...' : 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send button
            IconButton(
              icon: Icon(
                Icons.send,
                color: _commentController.text.trim().isNotEmpty
                    ? Colors.blue
                    : Colors.grey[400],
              ),
              onPressed: _commentController.text.trim().isNotEmpty
                  ? () => _addComment(state)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _addComment(CommentState state) {
    if (_commentController.text.trim().isNotEmpty) {
      widget.onAddComment(_commentController.text.trim());
      _commentController.clear();
    }
  }

  void _showCommentOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: Text(context.isArabic ? 'الإبلاغ' : 'Report'),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(context.isArabic ? 'حظر المستخدم' : 'Block user'),
              onTap: () {
                Navigator.pop(context);
                // Handle block
              },
            ),
          ],
        ),
      ),
    );
  }
}