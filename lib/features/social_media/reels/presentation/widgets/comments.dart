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

class CommentWidget extends StatefulWidget {
  final CommentData commentData;
  final int index;
  final FocusNode focusNode;
  String? replyingTo;
  final TextEditingController commentController;
  CommentWidget(
      {super.key,
      required this.commentData,
      required this.focusNode,
      required this.index,
      this.replyingTo,
      required this.commentController});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isRepliesVisible = false;
  int _displayedRepliesCount = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(
              widget.commentData.comment, widget.commentData.createdAt, false),
          SizedBox(height: 0.h),
          if (widget.commentData.replies.isNotEmpty)
            _buildToggleRepliesButton(),
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

  Widget _buildCommentRow(String comment, DateTime createdAt, bool reply,
      {String? replyId}) {
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
                  _buildLikeButton(reply, replyId: replyId),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyRow(String comment, DateTime createdAt, bool reply,
      {String? replyId, bool? isLike, int? replyCount}) {
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
                  _buildReplyLikeButton(reply,
                      replyId: replyId, isLike: isLike, likeCount: replyCount),
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
      widget.replyingTo = userName;
      if (userName != null) {
        widget.commentController.text = '@$userName ';
        widget.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.commentController.text.length),
        );
        widget.focusNode.requestFocus();
      } else {
        widget.commentController.clear();
        widget.focusNode.unfocus();
      }
    });
  }

  Widget _buildReplyButton() {
    return InkWell(
      onTap: () {
        _toggleReplyMode(
            '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}');
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
      return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildLikeButton(bool reply, {String? replyId}) {
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
            _handleLikeComment(widget.commentData.id, reply, replyId: replyId);
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

  Widget _buildReplyLikeButton(bool reply,
      {String? replyId, bool? isLike, int? likeCount}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: isLike == true
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.GREY_NORMAL_COLOR,
          ),
          onPressed: () {
            _handleLikeComment(widget.commentData.id, reply, replyId: replyId);
          },
        ),
        NoScaleText(
          likeCount.toString(),
          style: TextStyle(
            color: context.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  void _handleLikeComment(String commentId, bool isReply, {String? replyId}) {
    print('isReply : $isReply');
    context
        .read<ReelsCubit>()
        .toggleCommentLike(commentId, isReply, replyId: replyId)
        .then((_) {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_isRepliesVisible && remainingReplies > 0) {
              _displayedRepliesCount += 3;
            } else {
              _isRepliesVisible = !_isRepliesVisible;
              if (!_isRepliesVisible) {
                _displayedRepliesCount = 3;
              }
            }
          });
        },
        child: Row(
          children: [
            Text(
              buttonText,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600),
            ),
            _isRepliesVisible
                ? const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesList() {
    final repliesToShow =
        widget.commentData.replies.take(_displayedRepliesCount).toList();
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
      child: ListView(
        shrinkWrap: true,
        controller: context.read<ReelsCubit>().replyScrollController,
        children: repliesToShow
            .map((reply) => _buildReplyRow(reply.comment, reply.createdAt, true,
                replyId: reply.id,
                isLike: reply.isLiked,
                replyCount: reply.likeCount))
            .toList(),
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
