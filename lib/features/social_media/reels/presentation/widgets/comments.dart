import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/no_scale_text.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../tinder/data/shared/shared.dart';
import 'dart:ui';

class CommentWidget extends StatefulWidget {
  final CommentData commentData;
  final FocusNode focusNode;
  String? replyingTo;
  final TextEditingController commentController;

  CommentWidget({
    super.key,
    required this.commentData,
    required this.focusNode,
    this.replyingTo,
    required this.commentController,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isRepliesVisible = false;
  int _displayedRepliesCount = 3;

  @override
  void dispose() {
    // _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(
              widget.commentData.comment, widget.commentData.createdAt),
          SizedBox(height: 10.h),
          if (widget.commentData.replies.isNotEmpty) _buildToggleRepliesButton(),
          if (_isRepliesVisible) ...[
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isRepliesVisible ? _buildRepliesList() : Container(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentRow(String comment, DateTime createdAt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageFromInternet(
          width: 50,
          height: 50,
          isCircle: true,
          image: widget.commentData.user.profilePictureSignedUrl.isEmpty
              ? UIConst.profilePlaceHolder
              : widget.commentData.user.profilePictureSignedUrl,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoScaleText(
                capitalizeAndSplit(
                    '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 5.h),
              NoScaleText(
                comment,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 25.sp,
                ),
              ),
              Row(
                children: [
                  NoScaleText(
                    formatDateTime(createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  _buildReplyButton(),
                  const Spacer(),
                  _buildLikeButton(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleReplyMode(String? userName) {
    setState(() {
      context.read<ReelsCubit>().updateParentCommentIdAndReceiverComment(
          parentCommentId: widget.commentData.id,
          receiverComment: widget.commentData.user.id);
      print(context.read<ReelsCubit>().parentCommentId);
      print(context.read<ReelsCubit>().receiverComment);
      widget.replyingTo = userName;
      if (userName != null) {
        // Directly set the text and move the cursor if already focused
        widget.commentController.text = '@$userName ';
        widget.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.commentController.text.length),
        );
        // Ensure focus is on the text field
        widget.focusNode.requestFocus();
      } else {
        // Clear the text if not in reply mode
        widget.commentController.clear();
        // Optionally, you can unfocus here
        widget.focusNode.unfocus();
      }
    });
  }

  Widget _buildReplyButton() {
    return InkWell(
      onTap: () {
        // widget.focusNode.requestFocus();
        _toggleReplyMode(
            '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}');
        print(widget.replyingTo);
      },
      child: NoScaleText(
        LocaleKeys.reply.localize,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      // Format as "MM-dd" for dates older than 24 hours
      return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildLikeButton() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: widget.commentData.isLiked
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.GREY_NORMAL_COLOR,
          ),
          onPressed: () {
            print('Like comment ${widget.commentData.id}');
            _handleLikeComment(widget.commentData.id);
          },
        ),
        NoScaleText(
          widget.commentData.likeCount.toString(),
          style: TextStyle(
            color: context.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  void _handleLikeComment(String commentId) {
    context.read<ReelsCubit>().toggleCommentLike(commentId).then((_) {
      FocusScope.of(context).unfocus();
    }).catchError((error) {
      _showErrorSnackBar('Failed to send like. Please try again.');
    });
  }

  Widget _buildToggleRepliesButton() {

    final remainingReplies =
        widget.commentData.replies.length - _displayedRepliesCount;
    final buttonText = _isRepliesVisible
        ? (remainingReplies > 0
            ? "View ${remainingReplies > 3 ? 'More' : remainingReplies} Replies"
            : "Hide Replies")
        : "View ${widget.commentData.replies.length} ${widget.commentData.replies.length == 1 ? 'Reply' : 'Replies'}";

    return TextButton(
      onPressed: () {
        setState(() {
          if (_isRepliesVisible && remainingReplies > 0) {
            // Show the next batch of replies
            _displayedRepliesCount += 3;
          } else {
            // Toggle visibility
            _isRepliesVisible = !_isRepliesVisible;
            if (!_isRepliesVisible) {
              _displayedRepliesCount = 3; // Reset if hiding replies
            }
          }
        });
      },
      child: Text(buttonText,style: TextStyle(color: Colors.grey,fontSize:25.sp,fontWeight:FontWeight.w600),),
    );
  }

  Widget _buildRepliesList() {
    // Display replies up to the _displayedRepliesCount
    final repliesToShow = widget.commentData.replies.take(_displayedRepliesCount).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: repliesToShow.map((reply) => _buildCommentRow(reply.comment,reply.createdAt)).toList(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}
