import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/comment_input_field.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/no_scale_text.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Reel reel;

  const CommentsBottomSheet({super.key, required this.reel});

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context
        .read<ReelsCubit>()
        .getComments(widget.reel.id); // Fetch comments once when initialized
  }
@override
  void dispose() {
    scrollController.dispose();
    _commentController.dispose();
    super.dispose();
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
                commentController: _commentController,
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