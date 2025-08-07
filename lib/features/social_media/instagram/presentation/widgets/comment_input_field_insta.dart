import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../helpers/manage_vibration.dart';

class CommentInputFieldInsta extends StatefulWidget {
  final TextEditingController commentController;
  final bool isReplying;
  final String postId;
  final Function() onAddComment;
  final controller;
  final FocusNode focusNode;
  const CommentInputFieldInsta({
    super.key,
    required this.commentController,
    required this.isReplying,
    required this.controller,
    required this.onAddComment,
    required this.postId,
    required this.focusNode,
  });

  @override
  CommentInputFieldState createState() => CommentInputFieldState();
}

class CommentInputFieldState extends State<CommentInputFieldInsta> {
  String? replyTo;
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
              image: context.read<UserCubit>().state.data!.profilePicture ??
                  UIConst.profilePlaceHolder,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
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
                            onTap: () {
      ManageVibration.vibrate();
                              widget.onAddComment();
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
                  hintText: replyTo != null
                      ? "Replying to @$replyTo"
                      : "Add a comment...",
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