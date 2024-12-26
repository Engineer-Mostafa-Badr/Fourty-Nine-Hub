import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_reply_card.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/no_scale_text.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../tinder/data/shared/shared.dart';

class CommentWidgetInsta extends StatefulWidget {
  final CommentEntity commentData;
  final int index;
  final FocusNode focusNode;
  String? replyingTo;
  final TextEditingController commentController;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteReply;
  final Function(String) onDeleteComment;
  final Function() function;
  final Function() onReplyPressed;

  CommentWidgetInsta({
    super.key,
    required this.commentData,
    required this.focusNode,
    required this.index,
    this.replyingTo,
    required this.commentController,
    required this.onEditComment,
    required this.onDeleteReply,
    required this.onAddReply,
    required this.onDeleteComment,
    required this.function,
    required this.onReplyPressed,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidgetInsta> {
  bool _isRepliesVisible = false;
  int _displayedRepliesCount = 3;
  final editTextController = TextEditingController();
  String? replyTo;

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocProvider<InstagramCubit>(
        create: (BuildContext context) =>
            serviceLocator()..loadReplies(context, widget.commentData.id),
        child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (BuildContext context, state) {
            var controller = context.read<InstagramCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentRow(widget.commentData.content,
                    widget.commentData.createdAt, false, () {
                  if (widget.commentData.isLove == true) {
                    // widget.onCommentReact();
                    controller.onCommentReact(
                        params: PostReactParams(
                      postId: widget.commentData.id,
                      react: 'love',
                    ));
                    widget.commentData.isLove = false;
                    widget.commentData.loveCount =
                        (widget.commentData.loveCount! - 1);
                    setState(() {});
                  } else {
                    print("object");
                    // _handleLikeComment(widget.commentData.post, reply,
                    //     replyId: replyId);
                    controller.onCommentReact(
                        params: PostReactParams(
                      postId: widget.commentData.id,
                      react: 'love',
                    ));
                    widget.commentData.isLove = true;
                    widget.commentData.loveCount =
                        widget.commentData.loveCount! + 1;
                    setState(() {});
                  }
                }, user),
                SizedBox(height: 0.h),
                if (controller.repliesPagingController.itemList?.isNotEmpty ??
                    false)
                  _buildToggleRepliesButton(
                      controller.repliesPagingController.itemList?.length ?? 0),
                if (_isRepliesVisible) ...[
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _isRepliesVisible
                        ? Expanded(
                            child: PagedListView<int, CommentEntity>(
                              padding: const EdgeInsets.only(
                                  left: 40.0, bottom: 8, top: 8),
                              pagingController:
                                  controller.repliesPagingController,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              builderDelegate: PagedChildBuilderDelegate<
                                      CommentEntity>(
                                  noItemsFoundIndicatorBuilder: (context) {
                                    print(controller.repliesPagingController
                                        .itemList?.length);
                                    return const SizedBox.shrink();
                                  },
                                  itemBuilder: (context, item, index) {
                                    return _buildRepliesList(
                                      replay: controller.repliesPagingController
                                          .itemList![index],
                                      onDeleteComment: (String id) async {
                                        var result =
                                            await widget.onDeleteReply(id);
                                        if (result == true) {
                                          context
                                              .read<InstagramCubit>()
                                              .commentsPagingController
                                              .itemList
                                              ?.removeWhere((e) => e.id == id);
                                          setState(() {});
                                        }
                                      },
                                      onDeleteReply: (String id) async {
                                        var result =
                                            await widget.onDeleteReply(id);
                                        if (result == true) {
                                          context
                                              .read<InstagramCubit>()
                                              .repliesPagingController
                                              .itemList
                                              ?.removeWhere((e) => e.id == id);
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                  noMoreItemsIndicatorBuilder: (context) =>
                                      Container(),
                                  firstPageProgressIndicatorBuilder:
                                      (context) => Container(
                                          margin:
                                              const EdgeInsets.only(top: 150),
                                          child:
                                              const CupertinoActivityIndicator()),
                                  newPageProgressIndicatorBuilder: (context) =>
                                      const CupertinoActivityIndicator()),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentRow(String comment, DateTime createdAt, bool reply,
      Function() function, user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageFromInternet(
          width: 50,
          height: 50,
          isCircle: true,
          image: widget.commentData.user.image.isEmpty
              ? UIConst.profilePlaceHolder
              : widget.commentData.user.image,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NoScaleText(
                            capitalizeAndSplit(
                                '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
                            style: TextStyle(
                              color: context.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          NoScaleText(
                            formatDateTime(createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 5.h),
                      NoScaleText(
                        comment,
                        style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                          fontSize: 25.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      bottomSheet(
                        context: context,
                        widget: _buildPostOptions(
                          isMyComment: widget.commentData.user.id == user?.id,
                          post: widget.commentData,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.more_horiz_outlined,
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (widget.commentData.edit == true)
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        maxLines: null,
                        controller: editTextController,
                        onChanged: (v) {
                          setState(() {});
                        },
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText:
                              '${LocaleKeys.typeYourComment.localize} ....',
                          hintStyle: Styles.mediumText(),
                        ),
                      )),
                      const Sizer(),
                      if (editTextController.text.isNotEmpty)
                        IconAppButton(
                          icon: Icons.send,
                          size: 20,
                          isCircle: true,
                          onPressed: () async {
                            var result = await widget.onEditComment(
                                PostCommentParams(
                                    postId: widget.commentData.id,
                                    content: editTextController.text));
                            if (result == true) {
                              widget.commentData.content =
                                  editTextController.text;
                              widget.commentData.edit = false;
                            }
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
              Row(
                children: [
                  _buildReplyButton(),
                  const Spacer(),
                  _buildLikeButton(() {
                    function();
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return SizedBox(
      height: isMyComment ? 150 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: LocaleKeys.reportComment.localize,
                subTitle: LocaleKeys.youWillReportReply.localize,
                onTap: () async {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: post.id,
                          categoryId: '66a3583454e6e337915514db',
                        ));
                  });
                }),
          if (isMyComment)
            listTile(
                icon: Icons.delete,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.deleteComment.localize,
                subTitle: LocaleKeys.youWillDeleteComment.localize,
                onTap: () {
                  widget.onDeleteComment(widget.commentData.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.edit,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.editComment.localize,
                subTitle: LocaleKeys.youWillEditComment.localize,
                onTap: () {
                  widget.commentData.edit = !widget.commentData.edit!;
                  editTextController.text = widget.commentData.content;
                  setState(() {});
                }),
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon,
      Color? iconColor,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }
  // void _toggleReplyMode(String? userName) {
  //   setState(() {
  //     context.read<ReelsCubit>().updateParentCommentIdAndReceiverComment(
  //         parentCommentId: widget.commentData.id,
  //         receiverComment: widget.commentData.user.id);
  //     widget.replyingTo = userName;
  //     if (userName != null) {
  //       widget.commentController.text = '@$userName ';
  //       widget.commentController.selection = TextSelection.fromPosition(
  //         TextPosition(offset: widget.commentController.text.length),
  //       );
  //       widget.focusNode.requestFocus();
  //     } else {
  //       widget.commentController.clear();
  //       widget.focusNode.unfocus();
  //     }
  //   });
  // }

  Widget _buildReplyButton() {
    return InkWell(
      onTap: () {
        widget.onReplyPressed();
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

  Widget _buildLikeButton(Function() function) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            function();
          },
          child: Icon(
            widget.commentData.isLove == false
                ? Icons.favorite_border
                : Icons.favorite,
            color:
                widget.commentData.isLove == false ? Colors.grey : Colors.red,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        NoScaleText(
          widget.commentData.loveCount.toString(),
          style: TextStyle(
            color: context.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 25.sp,
          ),
        ),
      ],
    );
  }

  // Widget _buildReplyLikeButton(bool reply,
  //     {String? replyId, bool? isLike, int? likeCount}) {
  //   return Row(
  //     children: [
  //       IconButton(
  //         icon: Icon(
  //           Icons.favorite,
  //           color: isLike == true
  //               ? AppColors.PRIMARY_COLOR_DARK
  //               : AppColors.GREY_NORMAL_COLOR,
  //         ),
  //         onPressed: () {
  //           _handleLikeComment(widget.commentData.id, reply, replyId: replyId);
  //         },
  //       ),
  //       NoScaleText(
  //         likeCount.toString(),
  //         style: TextStyle(
  //           color: context.isDarkMode ? Colors.white70 : Colors.black87,
  //           fontSize: 25.sp,
  //         ),
  //       ),
  //       SizedBox(width: 10.w),
  //     ],
  //   );
  // }

  // void _handleLikeComment(String commentId, bool isReply, {String? replyId}) {
  //   print('isReply : $isReply');
  //   context
  //       .read<InstagramCubit>()
  //       .onReact(
  //         params: PostReactParams(
  //           postId: commentId,
  //           react: 'love',
  //         ),
  //         // commentId,
  //         // isReply,
  //         // replyId: replyId
  //       )
  //       .then((_) {
  //     FocusScope.of(context).unfocus();
  //   }).catchError((error) {
  //     _showErrorSnackBar('Failed to send like. Please try again.');
  //   });
  // }

  Widget _buildToggleRepliesButton(int length) {
    final remainingReplies = length - _displayedRepliesCount;
    final buttonText = _isRepliesVisible
        ? (remainingReplies > 0
            ? "View ${remainingReplies > 3 ? 'More' : remainingReplies} Replies"
            : "Hide Replies")
        : "View $length ${length == 1 ? 'Reply' : 'Replies'}";

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

  Widget _buildRepliesList(
      {required CommentEntity replay,
      required Function(String) onDeleteComment,
      required Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstagramReplyCard(
          reply: replay,
          onDeleteReply: (String id) => onDeleteReply(id),
          onReplyReact: (String id) {},
          onReport: (TwitterReportParams params) {},
          onEditComment: (PostCommentParams params) =>
              widget.onEditComment(params),
          function: widget.function,
        ),
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
    //   child: ListView(
    //     shrinkWrap:true,
    //     controller: context.read<ReelsCubit>().replyScrollController,
    //     children: repliesToShow.map((reply) => _buildReplyRow(reply.comment,reply.createdAt,true,replyId: reply.id,isLike: reply.isLiked,replyCount: reply.likeCount)).toList(),
    //   ),
    // );
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
