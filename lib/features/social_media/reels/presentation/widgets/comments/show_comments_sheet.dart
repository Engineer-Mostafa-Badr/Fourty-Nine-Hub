import 'package:flutter/material.dart';
import '../../../data/models/new_reels_model.dart';
import 'comment_bottom_sheet.dart';

Future<void> showCommentsBottomSheet(BuildContext context,{required Reel reel}) async {
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
      return CommentsBottomSheet(reel: reel,); // Use the new CommentsBottomSheet widget
    },
  );
}
