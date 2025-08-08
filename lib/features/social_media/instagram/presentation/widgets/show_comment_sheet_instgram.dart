import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/instagram_cubit.dart';
import '../../../reels/presentation/widgets/comments.dart';
import '../../../reels/presentation/widgets/comments/no_scale_text.dart';
import '../../../social_posts/domain/entities/comment_entity.dart';
import '../../../../../helpers/manage_vibration.dart';

class CommentsBottomSheet extends StatefulWidget {
  final CommentEntity comment;
  final String commentCount;

  const CommentsBottomSheet(
      {super.key, required this.comment, required this.commentCount});

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? replyToUser;
  final bool isReplying = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    focusNode.requestFocus();
    context.read<InstagramCubit>().loadComments(context, widget.comment.id);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      context.read<InstagramCubit>().getPostComments(
          context: context, postId: widget.comment.post, page: 1);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController.removeListener(_onScroll);
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var instagramCubit = context.read<InstagramCubit>();
    bool isDark = context.isDarkMode;

    return BlocProvider.value(
      value: instagramCubit,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
      ManageVibration.vibrate();
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
              _buildHandleIndicator(),
              _buildCommentsHeader(widget.comment, widget.commentCount),
              // _buildCommentsList(
              //   scrollController,
              // ),
              // CommentInputFieldInsta(
              //   focusNode: focusNode,
              //   comment: widget.comment,
              //   isReplying: isReplying,
              //   commentController: _commentController,
              //   scrollController: scrollController,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleIndicator() {
    return Container(
      width: 50,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[700] : Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCommentsHeader(CommentEntity comment, String commentsCount) {
    return Center(
      child: NoScaleText(
        '$commentsCount ${LocaleKeys.comments_header.localize}',
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 30.sp,
        ),
      ),
    );
  }

// Widget _buildCommentsList(ScrollController scrollController) {
//   return Expanded(
//     child: BlocBuilder<InstagramCubit, InstagramState>(
//       builder: (context, state) {
//         if (state.isFetchingComments &&state.postComments!.isEmpty) {
//           return const Center(
//             child: CustomCircularProgressIndicator(color: AppColors.SECONDARY_COLOR,),
//           );
//         }
//         final comments = state.postComments;
//         if (comments!.isNotEmpty) {
//           return ListView.builder(
//             controller: scrollController,
//             shrinkWrap: true,
//             // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             itemCount: comments.length,
//             itemBuilder: (context, index) {
//               return CommentWidget(
//                 commentData: comments[index],
//                 index: index,
//                 commentController: _commentController,
//                 //for reply
//                 replyingTo: replyToUser,
//                 focusNode: focusNode,
//               );
//             },
//           );
//         }
//         // if(state.)
//
//         return Center(
//           child: Label(text: LocaleKeys.noComments.localize),
//         );
//       },
//     ),
//   );
// }
}

Future<void> showCommentsBottomSheetInstagram(BuildContext context,
    {required CommentEntity comment, required String commentCount}) async {
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
        comment: comment,
        commentCount: commentCount,
      ); // Use the new CommentsBottomSheet widget
    },
  );
}