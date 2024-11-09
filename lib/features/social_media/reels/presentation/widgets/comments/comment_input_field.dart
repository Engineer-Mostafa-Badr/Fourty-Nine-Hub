import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

class CommentInputField extends StatefulWidget {
  final TextEditingController commentController;
  final Reel reel;
  final ScrollController scrollController;

  const CommentInputField({
    super.key,
    required this.reel,
    required this.commentController,
    required this.scrollController,
  });

  @override
  CommentInputFieldState createState() => CommentInputFieldState();
}

class CommentInputFieldState extends State<CommentInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // widget.commentController.dispose();
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
        padding: MediaQuery
            .of(context)
            .viewInsets,
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
                controller: widget.commentController,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: widget.commentController.text.isNotEmpty
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
                            widget.reel.id, widget.commentController.text);
                        // await reelsCubit.getComments(widget.reel.id);
                        widget.scrollController.animateTo(
                          widget
                              .scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                        widget.commentController.clear();
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