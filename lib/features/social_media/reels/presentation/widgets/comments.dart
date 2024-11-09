import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../tinder/data/shared/shared.dart';
import 'dart:ui';

// Custom Text widget to avoid repeating textScaleFactor: 1.0
class NoScaleText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const NoScaleText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textScaler: const TextScaler.linear(1),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

// Main function to show comments bottom sheet
Future<void> showCommentsBottomSheet(BuildContext context,
    {required Reel reel}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    // constraints: BoxConstraints(
    //   maxHeight: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
    //   minHeight: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
    // ),
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommentsBottomSheet(
          reel: reel); // Use the new CommentsBottomSheet widget
    },
  );
}

bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}

// CommentsBottomSheet widget
class CommentsBottomSheet extends StatefulWidget {
  final Reel reel;

  const CommentsBottomSheet({super.key, required this.reel});

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Row(
    //   children: [
    //     Expanded(
    //       child: Padding(
    //  ();
    context
        .read<ReelsCubit>()
        .getComments(widget.reel.id); // Fetch comments once when initialized
  }

  @override
  Widget build(BuildContext context) {
    var reelsCubit = context.read<ReelsCubit>();
    bool isDark = context.isDarkMode;

    return BlocProvider.value(
      value: reelsCubit,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
            minHeight: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          ),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              _buildHandleIndicator(isDark),
              _buildCommentsHeader(isDark, widget.reel),
              _buildCommentsList(scrollController),
              // Divider(color: Colors.grey[800]),
              CommentInputField(
                reel: widget.reel,
                scrollController: scrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleIndicator(bool isDark) {
    return Container(
      width: 50,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCommentsHeader(bool isDark, Reel reel) {
    return Center(
      child: NoScaleText(
        '${reel.commentCount} ${LocaleKeys.comments_header.localize}',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 30.sp,
        ),
      ),
    );
  }

  Widget _buildCommentsList(ScrollController scrollController) {
    return Expanded(
      child: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          if (state.isFetchingComments) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final comments = state.fetchedComments;
          if (comments != null && comments.data.isNotEmpty) {
            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: comments.data.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  commentData: comments.data.toList()[index],
                );
              },
            );
          }
          // if(state.)

          return Center(
            child: Label(text: LocaleKeys.noComments.localize),
          );
        },
      ),
    );
  }
}

// CommentInputField widget
class CommentInputField extends StatefulWidget {
  final Reel reel;
  final ScrollController scrollController;

  const CommentInputField({
    super.key,
    required this.reel,
    required this.scrollController,
  });

  @override
  CommentInputFieldState createState() => CommentInputFieldState();
}

class CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.requestFocus(); // Set the initial focus to the FocusNode.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(8.0)
              .add(EdgeInsetsDirectional.only(end: 20.w, bottom: 10.h)),
          child: Row(children: [
            ImageFromInternet(
              width: 50,
              height: 50,
              isCircle: true,
              image: widget.reel.user.profilePictureSignedUrl!.isEmpty
                  ? UIConst.profilePlaceHolder
                  : widget.reel.user.profilePictureSignedUrl!,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _commentController,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: _commentController.text.isNotEmpty
                      ? Container(
                          margin: EdgeInsetsDirectional.only(
                              end: 10.w, top: 10, bottom: 10),
                          padding: const EdgeInsets.all(3)
                              .add(EdgeInsets.symmetric(horizontal: 10.w)),
                          decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final reelsCubit = context.read<ReelsCubit>();
                              await reelsCubit.addComment(context,
                                  widget.reel.id, _commentController.text);
                              // await reelsCubit.getComments(widget.reel.id);
                              widget.scrollController.animateTo(
                                widget
                                    .scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                              _commentController.clear();
                              _focusNode.unfocus();

                              setState(() {});
                            },
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 30.h,
                            ),
                          ),
                        )
                      : null,
                  fillColor:
                      context.isDarkMode ? Colors.grey[800] : Colors.black12,
                  hintText: LocaleKeys.add_comment_hint.localize,
                  hintStyle: TextStyle(
                    color: context.isDarkMode ? Colors.grey : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
            )
          ]),
        ));
  }
}

// CommentWidget to display individual comments and replies
class CommentWidget extends StatefulWidget {
  final CommentData commentData;

  const CommentWidget({super.key, required this.commentData});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isRepliesVisible = false;
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.isDarkMode;
    final TextStyle userNameStyle = TextStyle(
      fontSize: 40.sp,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black87,
    );

    final TextStyle commentTextStyle = TextStyle(
      color: isDark ? Colors.white70 : Colors.black87,
      fontSize: 35.sp,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(isDark, userNameStyle, commentTextStyle),
          SizedBox(height: 10.h),
          _buildToggleRepliesButton(isDark),
          if (_isRepliesVisible) ...[
            _buildRepliesList(isDark, userNameStyle, commentTextStyle),
            _buildReplyInputField(isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentRow(
      bool isDark, TextStyle userNameStyle, TextStyle commentTextStyle) {
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
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              NoScaleText(
                widget.commentData.comment,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 35.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  NoScaleText(
                    formatDateTime(widget.commentData.createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  _buildReplyButton(),
                  const Spacer(),
                  _buildLikeButton(isDark),
                ],
              ),

              // _buildLikeAndReplyButtons(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyButton() {
    return InkWell(
      onTap: () {
        print('tapped');
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

  Widget _buildLikeButton(bool isDark) {
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
            color: isDark ? Colors.white70 : Colors.black87,
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
      context.read<ReelsCubit>().getComments(widget.commentData.reelId);
    }).catchError((error) {
      _showErrorSnackBar('Failed to send like. Please try again.');
    });
  }

  Widget _buildToggleRepliesButton(bool isDark) {
    if (widget.commentData.replies.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => _isRepliesVisible = !_isRepliesVisible),
      child: NoScaleText(
        _isRepliesVisible
            ? LocaleKeys.hide_replies.localize
            : LocaleKeys.view_replies.localize,
        style: TextStyle(color: AppColors.LIGHT_BLUE, fontSize: 30.sp),
      ),
    );
  }

  Widget _buildRepliesList(
      bool isDark, TextStyle userNameStyle, TextStyle commentTextStyle) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.commentData.replies
            .map((reply) => _buildSingleReply(
                reply, isDark, userNameStyle, commentTextStyle))
            .toList(),
      ),
    );
  }

  Widget _buildSingleReply(CommentData reply, bool isDark,
      TextStyle userNameStyle, TextStyle commentTextStyle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(reply.user.profilePictureSignedUrl),
                radius: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NoScaleText(
                      '${reply.user.firstName} ${reply.user.lastName}',
                      style: userNameStyle,
                    ),
                    SizedBox(height: 5.h),
                    NoScaleText(
                      reply.comment,
                      style: commentTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: reply.isLiked
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.GREY_NORMAL_COLOR,
                ),
                onPressed: () => _handleLikeComment(reply.id),
              ),
              NoScaleText(
                reply.likeCount.toString(),
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 35.sp,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.reply,
                    color: isDark ? Colors.white70 : Colors.black87),
                onPressed: () =>
                    _showReplyInput(reply.reelId, reply.id, reply.user.id),
              ),
            ],
          ),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }

  Widget _buildReplyInputField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 10),
      child: Row(
        children: [
          Expanded(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: TextField(
                controller: _replyController,
                focusNode: _replyFocusNode,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.black12,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10.h),
                  hintText: LocaleKeys.write_reply_hint.localize,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,
                color: isDark ? AppColors.LIGHT_BLUE : AppColors.PRIMARY_COLOR),
            onPressed: _handleSendReply,
          ),
        ],
      ),
    );
  }

  void _showReplyInput(
      [String? reelId, String? parentCommentId, String? receiverCommentId]) {
    setState(() {
      _isRepliesVisible = true;
      _replyFocusNode.requestFocus(); // Focus on the reply input field
    });
  }

  void _handleSendReply() async {
    final replyText = _replyController.text.trim();
    if (replyText.isNotEmpty) {
      await context.read<ReelsCubit>().addReplayComment(
            widget.commentData.reelId,
            replyText,
            parentCommentId: widget.commentData.id,
            receiverComment: widget.commentData.user.id,
          );

      print('Reply sent successfully ${widget.commentData.id}');
      _replyController.clear();
      FocusScope.of(context).unfocus();
      context.read<ReelsCubit>().getComments(widget.commentData.reelId);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
