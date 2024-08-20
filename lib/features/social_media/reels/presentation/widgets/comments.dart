// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/repositories/reels_repository_impl.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => BlocProvider.value(
//             value: serviceLocator<ReelsCubit>()..getComments(reel.id),
//             child: GestureDetector(
//               // onTap: () => Navigator.of(context).pop(),
//               // Dismiss the bottom sheet
//               child: Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context)
//                           .pop(); // Dismiss the bottom sheet if tapping outside
//                     },
//                     child: Container(
//                       color: Colors
//                           .transparent, // Transparent container to detect taps outside the bottom sheet
//                     ),
//                   ),
//                   DraggableScrollableSheet(
//                     initialChildSize: 0.6,
//                     minChildSize: 0.4,
//                     maxChildSize: 0.9,
//                     builder: (context, scrollController) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[900],
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                           ),
//                         ),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               width: 50,
//                               height: 5,
//                               margin: const EdgeInsets.symmetric(vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[700],
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             const Center(
//                               child: Text(
//                                 "Comments",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             const Divider(
//                               height: 1,
//                               thickness: 0.2,
//                             ),
//                             const SizedBox(
//                               height: 4,
//                             ),
//                             Expanded(
//                               child: Builder(builder: (context) {
//                                 if (context
//                                             .watch<ReelsCubit>()
//                                             .state
//                                             .fetchedComments !=
//                                         null &&
//                                     context
//                                             .watch<ReelsCubit>()
//                                             .state
//                                             .fetchedComments
//                                             ?.data !=
//                                         null) {
//                                   return ListView.builder(
//                                     controller: scrollController,
//                                     itemCount: context
//                                             .watch<ReelsCubit>()
//                                             .state
//                                             .fetchedComments
//                                             ?.data
//                                             .length ??
//                                         0,
//                                     itemBuilder: (context, index) {
//                                       return CommentWidget(
//                                         commentData: context
//                                             .watch<ReelsCubit>()
//                                             .state
//                                             .fetchedComments!
//                                             .data
//                                             .reversed
//                                             .toList()[index],
//                                       );
//                                     },
//                                   );
//                                 }
//                                 return const CupertinoActivityIndicator(
//                                   radius: 15,
//                                 );
//                               }),
//                             ),
//                             Divider(color: Colors.grey[800]),
//                             CommentInputField(
//                                 reel: reel, scrollController: scrollController),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ));
// }
//
// class CommentInputField extends StatefulWidget {
//   final Reel reel;
//
//   final ScrollController
//       scrollController; // Assuming Reel is a model class you have
//
//   const CommentInputField(
//       {Key? key, required this.reel, required this.scrollController})
//       : super(key: key);
//
//   @override
//   _CommentInputFieldState createState() => _CommentInputFieldState();
// }
//
// class _CommentInputFieldState extends State<CommentInputField> {
//   // Declare the TextEditingController
//   final TextEditingController _commentController = TextEditingController();
//
//   @override
//   void dispose() {
//     // Dispose the controller when the widget is removed from the widget tree
//     _commentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
//       child: Row(
//         children: [
//           // Uncomment and use if you want to display the user's avatar
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: CircleAvatar(
//           //     backgroundImage: NetworkImage(
//           //       'https://example.com/your_avatar.png', // Replace with user's avatar URL
//           //     ),
//           //     radius: 20,
//           //   ),
//           // ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Stack(
//                 alignment: Alignment.centerRight,
//                 children: [
//                   TextField(
//                     controller: _commentController, // Attach the controller
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[800],
//                       hintText: "Add a comment...",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                     ),
//                   ),
//                   Positioned(
//                     right: 10,
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.blue),
//                       onPressed: () {
//                         // Handle sending the comment
//                         context
//                             .read<ReelsCubit>()
//                             .addComment(widget.reel.id, _commentController.text)
//                             .then((value) => context
//                                     .read<ReelsCubit>()
//                                     .getComments(widget.reel.id)
//                                     .then((value) {
//                                   widget.scrollController.animateTo(
//                                     widget.scrollController.position
//                                         .maxScrollExtent,
//                                     duration: const Duration(milliseconds: 500),
//                                     curve: Curves.easeOut,
//                                   );
//                                 }));
//
//                         _commentController
//                             .clear(); // Clear the text field after sending the comment
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CommentWidget extends StatelessWidget {
//   final CommentData commentData;
//
//   CommentWidget({required this.commentData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundImage:
//                 NetworkImage(commentData.user.profilePictureSignedUrl),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   capitalizeAndSplit(
//                       '${commentData.user.firstName} ${commentData.user.lastName}'),
//                   textScaler: const TextScaler.linear(1.3),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   commentData.comment,
//                   textScaler: const TextScaler.linear(1.1),
//                   style:
//                       const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.favorite,
//                         color: commentData.isLiked
//                             ? AppColors.PRIMARY_COLOR_DARK
//                             : AppColors.UNSELECTED_DARK_GRAY_COLOR,
//                       ),
//                       onPressed: () {
//                         // Handle like action
//                       },
//                     ),
//                     Text(
//                       commentData.likeCount.toString(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     const SizedBox(width: 10),
//                     const Spacer(),
//                     IconButton(
//                       icon: const FaIcon(FontAwesomeIcons.reply,
//                           color: Colors.white),
//                       onPressed: () {
//                         // Handle reply action
//                       },
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../tinder/presentation/pages/user_profile.dart';

// void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => BlocProvider.value(
//       value: serviceLocator<ReelsCubit>()..getComments(reel.id),
//       child: GestureDetector(
//         // onTap: () => Navigator.of(context).pop(),
//         // Dismiss the bottom sheet
//         child: Stack(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop(); // Dismiss the bottom sheet if tapping outside
//               },
//               child: Container(
//                 color: Colors.transparent, // Transparent container to detect taps outside the bottom sheet
//               ),
//             ),
//             DraggableScrollableSheet(
//               initialChildSize: 0.6,
//               minChildSize: 0.4,
//               maxChildSize: 0.9,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         width: 50,
//                         height: 5,
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[700],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       const Center(
//                         child: Text(
//                           "Comments",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       const Divider(
//                         height: 1,
//                         thickness: 0.2,
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       Expanded(
//                         child: Builder(builder: (context) {
//                           final comments = context.watch<ReelsCubit>().state.fetchedComments;
//                           if (comments != null && comments.data.isNotEmpty) {
//                             return ListView.builder(
//                               controller: scrollController,
//                               itemCount: comments.data.length,
//                               itemBuilder: (context, index) {
//                                 return CommentWidget(
//                                   commentData: comments.data.reversed.toList()[index],
//                                 );
//                               },
//                             );
//                           }
//                           return const CupertinoActivityIndicator(
//                             radius: 15,
//                           );
//                         }),
//                       ),
//                       Divider(color: Colors.grey[800]),
//                       CommentInputField(
//                         reel: reel,
//                         scrollController: scrollController,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
class CommentsBottomSheet extends StatefulWidget {
  final Reel reel;

  const CommentsBottomSheet({Key? key, required this.reel}) : super(key: key);

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  late ReelsCubit reelsCubit;

  @override
  void initState() {
    super.initState();
    reelsCubit = serviceLocator<ReelsCubit>();
    reelsCubit.getComments(widget
        .reel.id); // Fetch comments only once when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: reelsCubit,
      child: GestureDetector(
        // onTap: () => Navigator.of(context).pop(),
        // Dismiss the bottom sheet
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pop(); // Dismiss the bottom sheet if tapping outside
              },
              child: Container(
                color: Colors
                    .transparent, // Transparent container to detect taps outside the bottom sheet
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Comments",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.2,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: Builder(builder: (context) {
                          final comments =
                              context.watch<ReelsCubit>().state.fetchedComments;
                          if (comments != null && comments.data.isNotEmpty) {
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: comments.data.length,
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                  commentData:
                                      comments.data.reversed.toList()[index],
                                );
                              },
                            );
                          }
                          return const CupertinoActivityIndicator(
                            radius: 15,
                          );
                        }),
                      ),
                      Divider(color: Colors.grey[800]),
                      CommentInputField(
                        reel: widget.reel,
                        scrollController: scrollController,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommentsBottomSheet(
          reel: reel); // Use the new CommentsBottomSheet widget
    },
  );
}

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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: "Add a comment...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () async {
                        final reelsCubit = context.read<ReelsCubit>();
                        await reelsCubit
                            .addComment(widget.reel.id, _commentController.text)
                            .then((value) {
                          ++widget.reel.commentCount;
                        });
                        await reelsCubit.getComments(widget.reel.id);
                        widget.scrollController.animateTo(
                          widget.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                        _commentController
                            .clear(); // Clear the text field after sending the comment
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final CommentData commentData;

  const CommentWidget({super.key, required this.commentData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(commentData.user.profilePictureSignedUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizeAndSplit2Parts(
                      '${commentData.user.firstName} ${commentData.user.lastName}'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  commentData.comment,
                  style:
                      const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: commentData.isLiked
                            ? AppColors.PRIMARY_COLOR_DARK
                            : AppColors.UNSELECTED_DARK_GRAY_COLOR,
                      ),
                      onPressed: () {
                        // Handle like action
                      },
                    ),
                    Text(
                      commentData.likeCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.reply,
                          color: Colors.white),
                      onPressed: () {
                        // Handle reply action
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
