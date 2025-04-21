import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/comment_bottom_sheet.dart';

Future<void> showCommentsBottomSheet(BuildContext context) async {
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
      return CommentsBottomSheet(); // Use the new CommentsBottomSheet widget
    },
  );
}
