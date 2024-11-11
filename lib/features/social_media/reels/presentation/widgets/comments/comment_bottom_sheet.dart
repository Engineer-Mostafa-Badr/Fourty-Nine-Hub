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
import 'package:fourtyninehub/res/style/app_colors.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Reel reel;

  const CommentsBottomSheet({super.key, required this.reel});

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
    context
        .read<ReelsCubit>()
        .loadInitialComments(widget.reel.id); // Fetch comments once when initialized
  }
  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      context.read<ReelsCubit>().getComments(widget.reel.id);
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
              _buildHandleIndicator(),
              _buildCommentsHeader(widget.reel),
              _buildCommentsList(
                scrollController,
              ),
              CommentInputField(
                focusNode: focusNode,
                reel: widget.reel,
                isReplying: isReplying,
                commentController: _commentController,
                scrollController: scrollController,
              ),
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

  Widget _buildCommentsHeader(Reel reel) {
    return Center(
      child: NoScaleText(
        '${reel.commentCount} ${LocaleKeys.comments_header.localize}',
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black87,
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
          if (state.isFetchingComments && context.read<ReelsCubit>().comments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.SECONDARY_COLOR,),
            );
          }
          final comments = context.read<ReelsCubit>().comments;
          if (comments.isNotEmpty) {
            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  commentData: comments[index],
                  index: index,
                  commentController: _commentController,
                  //for reply
                  replyingTo: replyToUser,
                  focusNode: focusNode,
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
