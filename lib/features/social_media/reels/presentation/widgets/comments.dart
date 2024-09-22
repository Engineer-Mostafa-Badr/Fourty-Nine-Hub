// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
// // import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// // import 'package:fourtyninehub/features/social_media/reels/data/repositories/reels_repository_impl.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// //
// // void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
// //   showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => BlocProvider.value(
// //             value: serviceLocator<ReelsCubit>()..getComments(reel.id),
// //             child: GestureDetector(
// //               // onTap: () => Navigator.of(context).pop(),
// //               // Dismiss the bottom sheet
// //               child: Stack(
// //                 children: [
// //                   GestureDetector(
// //                     onTap: () {
// //                       Navigator.of(context)
// //                           .pop(); // Dismiss the bottom sheet if tapping outside
// //                     },
// //                     child: Container(
// //                       color: Colors
// //                           .transparent, // Transparent container to detect taps outside the bottom sheet
// //                     ),
// //                   ),
// //                   DraggableScrollableSheet(
// //                     initialChildSize: 0.6,
// //                     minChildSize: 0.4,
// //                     maxChildSize: 0.9,
// //                     builder: (context, scrollController) {
// //                       return Container(
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey[900],
// //                           borderRadius: const BorderRadius.only(
// //                             topLeft: Radius.circular(20),
// //                             topRight: Radius.circular(20),
// //                           ),
// //                         ),
// //                         child: Column(
// //                           children: <Widget>[
// //                             Container(
// //                               width: 50,
// //                               height: 5.h,
// //                               margin: EdgeInsets.symmetric(vertical: 10.h),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.grey[700],
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                             const Center(
// //                               child: Text(
// //                                 "Comments",
// //                                 style: TextStyle(color: Colors.white),
// //                               ),
// //                             ),
// //                             const Divider(
// //                               height: 1.h,
// //                               thickness: 0.2,
// //                             ),
// //                             SizedBox(
// //                               height: 4.h,
// //                             ),
// //                             Expanded(
// //                               child: Builder(builder: (context) {
// //                                 if (context
// //                                             .watch<ReelsCubit>()
// //                                             .state
// //                                             .fetchedComments !=
// //                                         null &&
// //                                     context
// //                                             .watch<ReelsCubit>()
// //                                             .state
// //                                             .fetchedComments
// //                                             ?.data !=
// //                                         null) {
// //                                   return ListView.builder(
// //                                     controller: scrollController,
// //                                     itemCount: context
// //                                             .watch<ReelsCubit>()
// //                                             .state
// //                                             .fetchedComments
// //                                             ?.data
// //                                             .length ??
// //                                         0,
// //                                     itemBuilder: (context, index) {
// //                                       return CommentWidget(
// //                                         commentData: context
// //                                             .watch<ReelsCubit>()
// //                                             .state
// //                                             .fetchedComments!
// //                                             .data
// //                                             .reversed
// //                                             .toList()[index],
// //                                       );
// //                                     },
// //                                   );
// //                                 }
// //                                 return const CupertinoActivityIndicator(
// //                                   radius: 15,
// //                                 );
// //                               }),
// //                             ),
// //                             Divider(color: Colors.grey[800]),
// //                             CommentInputField(
// //                                 reel: reel, scrollController: scrollController),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ));
// // }
// //
// // class CommentInputField extends StatefulWidget {
// //   final Reel reel;
// //
// //   final ScrollController
// //       scrollController; // Assuming Reel is a model class you have
// //
// //   const CommentInputField(
// //       {Key? key, required this.reel, required this.scrollController})
// //       : super(key: key);
// //
// //   @override
// //   _CommentInputFieldState createState() => _CommentInputFieldState();
// // }
// //
// // class _CommentInputFieldState extends State<CommentInputField> {
// //   // Declare the TextEditingController
// //   final TextEditingController _commentController = TextEditingController();
// //
// //   @override
// //   void dispose() {
// //     // Dispose the controller when the widget is removed from the widget tree
// //     _commentController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
// //       child: Row(
// //         children: [
// //           // Uncomment and use if you want to display the user's avatar
// //           // Padding(
// //           //   padding: EdgeInsets.all(8.0),
// //           //   child: CircleAvatar(
// //           //     backgroundImage: NetworkImage(
// //           //       'https://example.com/your_avatar.png', // Replace with user's avatar URL
// //           //     ),
// //           //     radius: 20,
// //           //   ),
// //           // ),
// //           Expanded(
// //             child: Padding(
// //               padding: EdgeInsets.all(8.0),
// //               child: Stack(
// //                 alignment: Alignment.centerRight,
// //                 children: [
// //                   TextField(
// //                     controller: _commentController, // Attach the controller
// //                     style: const TextStyle(color: Colors.white),
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.grey[800],
// //                       hintText: "Add a comment...",
// //                       hintStyle: const TextStyle(color: Colors.grey),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                       contentPadding: EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 10.h),
// //                     ),
// //                   ),
// //                   Positioned(
// //                     right: 10,
// //                     child: IconButton(
// //                       icon: const Icon(Icons.send, color: Colors.blue),
// //                       onPressed: () {
// //                         // Handle sending the comment
// //                         context
// //                             .read<ReelsCubit>()
// //                             .addComment(widget.reel.id, _commentController.text)
// //                             .then((value) => context
// //                                     .read<ReelsCubit>()
// //                                     .getComments(widget.reel.id)
// //                                     .then((value) {
// //                                   widget.scrollController.animateTo(
// //                                     widget.scrollController.position
// //                                         .maxScrollExtent,
// //                                     duration: const Duration(milliseconds: 500),
// //                                     curve: Curves.easeOut,
// //                                   );
// //                                 }));
// //
// //                         _commentController
// //                             .clear(); // Clear the text field after sending the comment
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class CommentWidget extends StatelessWidget {
// //   final CommentData commentData;
// //
// //   CommentWidget({required this.commentData});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.all(8.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           CircleAvatar(
// //             backgroundImage:
// //                 NetworkImage(commentData.user.profilePictureSignedUrl),
// //           ),
// //           SizedBox(width: 10),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   capitalizeAndSplit(
// //                       '${commentData.user.firstName} ${commentData.user.lastName}'),
// //                   textScaler: const TextScaler.linear(1.3),
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 SizedBox(height: 5.h),
// //                 Text(
// //                   commentData.comment,
// //                   textScaler: const TextScaler.linear(1.1),
// //                   style:
// //                       const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
// //                 ),
// //                 Row(
// //                   children: [
// //                     IconButton(
// //                       icon: Icon(
// //                         Icons.favorite,
// //                         color: commentData.isLiked
// //                             ? AppColors.PRIMARY_COLOR_DARK
// //                             : AppColors.UNSELECTED_DARK_GRAY_COLOR,
// //                       ),
// //                       onPressed: () {
// //                         // Handle like action
// //                       },
// //                     ),
// //                     Text(
// //                       commentData.likeCount.toString(),
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                     SizedBox(width: 10),
// //                     const Spacer(),
// //                     IconButton(
// //                       icon: const FaIcon(FontAwesomeIcons.reply,
// //                           color: Colors.white),
// //                       onPressed: () {
// //                         // Handle reply action
// //                       },
// //                     ),
// //                     const Spacer(),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../tinder/presentation/pages/user_profile.dart';
//
// // void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
// //   showModalBottomSheet(
// //     context: context,
// //     isScrollControlled: true,
// //     backgroundColor: Colors.transparent,
// //     builder: (context) => BlocProvider.value(
// //       value: serviceLocator<ReelsCubit>()..getComments(reel.id),
// //       child: GestureDetector(
// //         // onTap: () => Navigator.of(context).pop(),
// //         // Dismiss the bottom sheet
// //         child: Stack(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 Navigator.of(context).pop(); // Dismiss the bottom sheet if tapping outside
// //               },
// //               child: Container(
// //                 color: Colors.transparent, // Transparent container to detect taps outside the bottom sheet
// //               ),
// //             ),
// //             DraggableScrollableSheet(
// //               initialChildSize: 0.6,
// //               minChildSize: 0.4,
// //               maxChildSize: 0.9,
// //               builder: (context, scrollController) {
// //                 return Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[900],
// //                     borderRadius: const BorderRadius.only(
// //                       topLeft: Radius.circular(20),
// //                       topRight: Radius.circular(20),
// //                     ),
// //                   ),
// //                   child: Column(
// //                     children: <Widget>[
// //                       Container(
// //                         width: 50,
// //                         height: 5.h,
// //                         margin: EdgeInsets.symmetric(vertical: 10.h),
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey[700],
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                       const Center(
// //                         child: Text(
// //                           "Comments",
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                       const Divider(
// //                         height: 1.h,
// //                         thickness: 0.2,
// //                       ),
// //                       SizedBox(
// //                         height: 4.h,
// //                       ),
// //                       Expanded(
// //                         child: Builder(builder: (context) {
// //                           final comments = context.watch<ReelsCubit>().state.fetchedComments;
// //                           if (comments != null && comments.data.isNotEmpty) {
// //                             return ListView.builder(
// //                               controller: scrollController,
// //                               itemCount: comments.data.length,
// //                               itemBuilder: (context, index) {
// //                                 return CommentWidget(
// //                                   commentData: comments.data.reversed.toList()[index],
// //                                 );
// //                               },
// //                             );
// //                           }
// //                           return const CupertinoActivityIndicator(
// //                             radius: 15,
// //                           );
// //                         }),
// //                       ),
// //                       Divider(color: Colors.grey[800]),
// //                       CommentInputField(
// //                         reel: reel,
// //                         scrollController: scrollController,
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }
// class CommentsBottomSheet extends StatefulWidget {
//   final Reel reel;
//
//   const CommentsBottomSheet({Key? key, required this.reel}) : super(key: key);
//
//   @override
//   _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
// }
//
// class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
//   late ReelsCubit reelsCubit;
//
//   @override
//   void initState() {
//     super.initState();
//     reelsCubit = serviceLocator<ReelsCubit>();
//     reelsCubit.getComments(widget
//         .reel.id); // Fetch comments only once when the widget is initialized
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: reelsCubit,
//       child: GestureDetector(
//         // onTap: () => Navigator.of(context).pop(),
//         // Dismiss the bottom sheet
//         child: Stack(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pop(); // Dismiss the bottom sheet if tapping outside
//               },
//               child: Container(
//                 color: Colors
//                     .transparent, // Transparent container to detect taps outside the bottom sheet
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
//                         height: 5.h,
//                         margin: EdgeInsets.symmetric(vertical: 10.h),
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
//                         height: 1.h,
//                         thickness: 0.2,
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Expanded(
//                         child: Builder(builder: (context) {
//                           final comments =
//                               context.watch<ReelsCubit>().state.fetchedComments;
//                           if (comments != null && comments.data.isNotEmpty) {
//                             return ListView.builder(
//                               controller: scrollController,
//                               itemCount: comments.data.length,
//                               itemBuilder: (context, index) {
//                                 return CommentWidget(
//                                   commentData:
//                                       comments.data.reversed.toList()[index],
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
//                         reel: widget.reel,
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
//     );
//   }
// }
//
// void showCommentsBottomSheet(BuildContext context, {required Reel reel}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return CommentsBottomSheet(
//           reel: reel); // Use the new CommentsBottomSheet widget
//     },
//   );
// }
//
// class CommentInputField extends StatefulWidget {
//   final Reel reel;
//   final ScrollController scrollController;
//
//   const CommentInputField({
//     super.key,
//     required this.reel,
//     required this.scrollController,
//   });
//
//   @override
//   CommentInputFieldState createState() => CommentInputFieldState();
// }
//
// class CommentInputFieldState extends State<CommentInputField> {
//   final TextEditingController _commentController = TextEditingController();
//
//   @override
//   void dispose() {
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
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Stack(
//                 alignment: Alignment.centerRight,
//                 children: [
//                   TextField(
//                     controller: _commentController,
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
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10.h),
//                     ),
//                   ),
//                   Positioned(
//                     right: 10,
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.blue),
//                       onPressed: () async {
//                         final reelsCubit = context.read<ReelsCubit>();
//                         await reelsCubit
//                             .addComment(widget.reel.id, _commentController.text)
//                             .then((value) {
//                           ++widget.reel.commentCount;
//                         });
//                         await reelsCubit.getComments(widget.reel.id);
//                         widget.scrollController.animateTo(
//                           widget.scrollController.position.maxScrollExtent,
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.easeOut,
//                         );
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
// class CommentWidget extends StatefulWidget {
//   final CommentData commentData;
//
//   const CommentWidget({super.key, required this.commentData});
//
//   @override
//   _CommentWidgetState createState() => _CommentWidgetState();
// }
//
// class _CommentWidgetState extends State<CommentWidget> {
//   bool _isRepliesVisible = false;
//   final TextEditingController _replyController = TextEditingController();
//   final FocusNode _replyFocusNode = FocusNode();
//
//   @override
//   void dispose() {
//     _replyController.dispose();
//     _replyFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildCommentRow(),
//           SizedBox(height: 10.h),
//           _buildToggleRepliesButton(),
//           if (_isRepliesVisible) ...[
//             _buildRepliesList(),
//             _buildReplyInputField(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommentRow() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           backgroundImage: NetworkImage(widget.commentData.user.profilePictureSignedUrl),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildUserName(),
//               SizedBox(height: 5.h),
//               _buildCommentText(),
//               _buildLikeAndReplyButtons(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUserName() {
//     return Text(
//       capitalizeAndSplit('${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
//       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//     );
//   }
//
//   Widget _buildCommentText() {
//     return Text(
//       widget.commentData.comment,
//       style: const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
//     );
//   }
//
//   Widget _buildLikeAndReplyButtons() {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(
//             Icons.favorite,
//             color: widget.commentData.isLiked ? AppColors.PRIMARY_COLOR_DARK : AppColors.UNSELECTED_DARK_GRAY_COLOR,
//           ),
//           onPressed: () => _handleLikeComment(widget.commentData.id),
//         ),
//         Text(
//           widget.commentData.likeCount.toString(),
//           style: const TextStyle(color: Colors.white),
//         ),
//         const Spacer(),
//         IconButton(
//           icon: const FaIcon(FontAwesomeIcons.reply, color: Colors.white),
//           onPressed: () => _showReplyInput(),
//         ),
//       ],
//     );
//   }
//
//   void _handleLikeComment(String commentId) {
//     context.read<ReelsCubit>().toggleCommentLike(commentId).then((_) {
//       FocusScope.of(context).unfocus();
//       context.read<ReelsCubit>().getComments(widget.commentData.reelId);
//     }).catchError((error) {
//       _showErrorSnackBar('Failed to send like. Please try again.');
//     });
//   }
//
//   Widget _buildToggleRepliesButton() {
//     if (widget.commentData.replies.isEmpty) return SizedBox.shrink();
//
//     return GestureDetector(
//       onTap: () => setState(() => _isRepliesVisible = !_isRepliesVisible),
//       child: Text(
//         _isRepliesVisible ? 'Hide Replies' : 'View Replies',
//         style: const TextStyle(color: Colors.blue),
//       ),
//     );
//   }
//
//   Widget _buildRepliesList() {
//     return Padding(
//       padding: EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.commentData.replies.map(_buildSingleReply).toList(),
//       ),
//     );
//   }
//
//   Widget _buildSingleReply(CommentData replay) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5.h),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(replay.user.profilePictureSignedUrl),
//                 radius: 16,
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${replay.user.firstName} ${replay.user.lastName} @ ${replay.receiverComment?.firstName ?? ''} ${replay.receiverComment?.lastName ?? ''}',
//                       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     SizedBox(height: 5.h),
//                     Text(
//                       replay.comment,
//                       style: const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.favorite,
//                   color: replay.isLiked ? AppColors.PRIMARY_COLOR_DARK : AppColors.UNSELECTED_DARK_GRAY_COLOR,
//                 ),
//                 onPressed: () => _handleLikeComment(replay.id),
//               ),
//               Text(
//                 replay.likeCount.toString(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const FaIcon(FontAwesomeIcons.reply, color: Colors.white),
//                 onPressed: () => _showReplyInput(replay.reelId, replay.id, replay.user.id),
//               ),
//             ],
//           ),
//           const Divider(thickness: 0.1),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReplyInputField() {
//     return Padding(
//       padding: EdgeInsets.only(left: 40.0, top: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _replyController,
//               focusNode: _replyFocusNode,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Write a reply...',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.black,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.blue),
//             onPressed: _handleSendReply,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showReplyInput([String? reelId, String? parentCommentId, String? receiverCommentId]) {
//     setState(() {
//       _isRepliesVisible = true;
//       _replyFocusNode.requestFocus();
//     });
//   }
//
//   void _handleSendReply() {
//     final replyText = _replyController.text.trim();
//     if (replyText.isNotEmpty) {
//       context
//           .read<ReelsCubit>()
//           .addReplayComment(widget.commentData.reelId, replyText,
//           parentCommentId: widget.commentData.id,
//           receiverComment: widget.commentData.user.id)
//           .then((_) {
//         _replyController.clear();
//         FocusScope.of(context).unfocus();
//         context.read<ReelsCubit>().getComments(widget.commentData.reelId);
//       }).catchError((error) {
//         _showErrorSnackBar('Failed to send reply. Please try again.');
//       });
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }
//
// //
// // class CommentWidget extends StatefulWidget {
// //   final CommentData commentData;
// //
// //   const CommentWidget({super.key, required this.commentData});
// //
// //   @override
// //   _CommentWidgetState createState() => _CommentWidgetState();
// // }
// //
// // class _CommentWidgetState extends State<CommentWidget> {
// //   bool _isRepliesVisible = false;
// //   final TextEditingController _replyController = TextEditingController();
// //   final FocusNode _replyFocusNode = FocusNode();
// //
// //   @override
// //   void dispose() {
// //     _replyController.dispose();
// //     _replyFocusNode.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.all(8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildCommentRow(context),
// //           SizedBox(height: 10.h),
// //           _buildToggleRepliesButton(),
// //           if (_isRepliesVisible) ...[
// //             _buildRepliesList(),
// //             _buildReplyInputField(context),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCommentRow(BuildContext context) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         CircleAvatar(
// //           backgroundImage:
// //               NetworkImage(widget.commentData.user.profilePictureSignedUrl),
// //         ),
// //         SizedBox(width: 10),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 capitalizeAndSplit(
// //                     '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               SizedBox(height: 5.h),
// //               Text(
// //                 widget.commentData.comment,
// //                 style: const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
// //               ),
// //               Row(
// //                 children: [
// //                   IconButton(
// //                     icon: Icon(
// //                       Icons.favorite,
// //                       color: widget.commentData.isLiked
// //                           ? AppColors.PRIMARY_COLOR_DARK
// //                           : AppColors.UNSELECTED_DARK_GRAY_COLOR,
// //                     ),
// //                     onPressed: () {
// //                       context
// //                           .read<ReelsCubit>()
// //                           .toggleCommentLike(widget.commentData.id)
// //                           .then((_) {
// //                         FocusScope.of(context).unfocus();
// //                         context
// //                             .read<ReelsCubit>()
// //                             .getComments(widget.commentData.reelId);
// //                       }).catchError((error) {
// //                         // Handle error (e.g., show a snackbar)
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                               content: Text(
// //                                   'Failed to send like. Please try again.')),
// //                         );
// //                       });
// //                     },
// //                   ),
// //                   Text(
// //                     widget.commentData.likeCount.toString(),
// //                     style: const TextStyle(color: Colors.white),
// //                   ),
// //                   const Spacer(),
// //                   IconButton(
// //                     icon: const FaIcon(FontAwesomeIcons.reply,
// //                         color: Colors.white),
// //                     onPressed: () {
// //                       setState(() {
// //                         _isRepliesVisible = true;
// //                       });
// //                       _replyFocusNode.requestFocus();
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildToggleRepliesButton() {
// //     if (widget.commentData.replies.isEmpty) return SizedBox.shrink();
// //
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _isRepliesVisible = !_isRepliesVisible;
// //         });
// //       },
// //       child: Text(
// //         _isRepliesVisible ? 'Hide Replies' : 'View Replies',
// //         style: const TextStyle(color: Colors.blue),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRepliesList() {
// //     return Padding(
// //       padding: EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: widget.commentData.replies.map((replay) {
// //           return Padding(
// //             padding: EdgeInsets.symmetric(vertical: 5.h),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     CircleAvatar(
// //                       backgroundImage:
// //                           NetworkImage(replay.user.profilePictureSignedUrl),
// //                       radius: 16,
// //                     ),
// //                     SizedBox(width: 10),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             capitalizeAndSplit(
// //                                 '${replay.user.firstName} ${replay.user.lastName} @ ${replay.receiverComment?.firstName} ${replay.receiverComment?.lastName}'),
// //                             style: const TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           Text(
// //                             replay.comment,
// //                             style: const TextStyle(
// //                                 color: AppColors.UNSELECTED_GRAY_COLOR),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   children: [
// //                     IconButton(
// //                       icon: Icon(
// //                         Icons.favorite,
// //                         color: replay.isLiked
// //                             ? AppColors.PRIMARY_COLOR_DARK
// //                             : AppColors.UNSELECTED_DARK_GRAY_COLOR,
// //                       ),
// //                       onPressed: () {
// //                         context
// //                             .read<ReelsCubit>()
// //                             .toggleCommentLike(replay.id)
// //                             .then((_) {
// //                           FocusScope.of(context).unfocus();
// //                           context.read<ReelsCubit>().getComments(replay.reelId);
// //                         }).catchError((error) {
// //                           // Handle error (e.g., show a snackbar)
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content: Text(
// //                                     'Failed to send like. Please try again.')),
// //                           );
// //                         });
// //                       },
// //                     ),
// //                     Text(
// //                       replay.likeCount.toString(),
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                     const Spacer(),
// //                     IconButton(
// //                       icon: const FaIcon(FontAwesomeIcons.reply,
// //                           color: Colors.white),
// //                       onPressed: () {
// //                         setState(() {
// //                           _isRepliesVisible = true;
// //                         });
// //                         _replyFocusNode.requestFocus();
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 const Divider(thickness: 0.1),
// //               ],
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildReplyInputField(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.only(left: 40.0, top: 10),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: _replyController,
// //               focusNode: _replyFocusNode,
// //               style: const TextStyle(color: Colors.white),
// //               decoration: InputDecoration(
// //                 hintText: 'Write a reply...',
// //                 hintStyle: const TextStyle(color: Colors.white70),
// //                 filled: true,
// //                 fillColor: Colors.black,
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(20),
// //                   borderSide: BorderSide.none,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.send, color: Colors.blue),
// //             onPressed: _handleSendReply,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _handleSendReply() {
// //     final replyText = _replyController.text.trim();
// //     if (replyText.isNotEmpty) {
// //       context
// //           .read<ReelsCubit>()
// //           .addReplayComment(widget.commentData.reelId, replyText,
// //               parentCommentId: widget.commentData.id,
// //               receiverComment: widget.commentData.user.id)
// //           .then((_) {
// //         _replyController.clear();
// //         FocusScope.of(context).unfocus();
// //         context.read<ReelsCubit>().getComments(widget.commentData.reelId);
// //       }).catchError((error) {
// //         // Handle error (e.g., show a snackbar)
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //               content: Text('Failed to send reply. Please try again.')),
// //         );
// //       });
// //     }
// //   }
// // }
//
// class ShimmerCommentWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Shimmer.fromColors(
//             baseColor: Colors.white12,
//             highlightColor: Colors.white12,
//             child: const CircleAvatar(
//               backgroundColor: Colors.white12,
//               radius: 20,
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Shimmer.fromColors(
//                   baseColor: Colors.white12,
//                   highlightColor: Colors.white12,
//                   child: Container(
//                     width: 100,
//                     height: 16.h,
//                     color: Colors.white12,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Shimmer.fromColors(
//                   baseColor: Colors.white12,
//                   highlightColor: Colors.white12,
//                   child: Container(
//                     width: double.infinity,
//                     height: 12.h,
//                     color: Colors.white12,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   children: [
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: const Icon(Icons.favorite, color: Colors.white12),
//                     ),
//                     SizedBox(width: 5),
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: Container(
//                         width: 20,
//                         height: 12.h,
//                         color: Colors.white12,
//                       ),
//                     ),
//                     const Spacer(),
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: const Icon(FontAwesomeIcons.reply,
//                           color: Colors.white12),
//                     ),
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
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import 'dart:ui';

bool isDarkTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

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
    reelsCubit
        .getComments(widget.reel.id); // Fetch comments once when initialized
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: reelsCubit,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Dismiss if tapped outside
        },
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            // Transparent background to detect taps
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkTheme(context) ? Colors.grey[900] : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildHandleIndicator(),
                      _buildCommentsHeader(),
                      _buildCommentsList(scrollController),
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

  Widget _buildHandleIndicator() {
    return Container(
      width: 50,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isDarkTheme(context) ? Colors.grey[700] : Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Center(
      child: Text(
        LocaleKeys.comments_header.localize,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: isDarkTheme(context) ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 40.sp),
      ),
    );
  }

  Widget _buildCommentsList(ScrollController scrollController) {
    return Expanded(
      child: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          final comments = state.fetchedComments;

          if (comments != null && comments.data.isNotEmpty) {
            return ListView.builder(
              controller: scrollController,
              itemCount: comments.data.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  commentData: comments.data.reversed.toList()[index],
                );
              },
            );
          }

          return const CupertinoActivityIndicator(radius: 15);
        },
      ),
    );
  }
}

class CommentInputField extends StatefulWidget {
  final Reel reel;
  final ScrollController scrollController;

  const CommentInputField({
    Key? key,
    required this.reel,
    required this.scrollController,
  }) : super(key: key);

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
      padding: MediaQuery.of(context).viewInsets,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: isDarkTheme(context)
                            ? Colors.white
                            : Colors.black87,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkTheme(context)
                            ? Colors.grey[800]
                            : Colors.black12,
                        hintText: LocaleKeys.add_comment_hint.localize,
                        hintStyle: TextStyle(
                            color: isDarkTheme(context)
                                ? Colors.grey
                                : Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10.h),
                      ),
                    ),
                  ),
                  // Positioned.directional(
                  //   end: 10,
                  //   textDirection: context.isArabic
                  //       ? TextDirection.rtl
                  //       : TextDirection.ltr,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.send, color: Colors.blue),
                  //     onPressed: () async {
                  //       final reelsCubit = context.read<ReelsCubit>();
                  //       await reelsCubit.addComment(
                  //           widget.reel.id, _commentController.text);
                  //       await reelsCubit.getComments(widget.reel.id);
                  //
                  //       widget.scrollController.animateTo(
                  //         widget.scrollController.position.maxScrollExtent,
                  //         duration: const Duration(milliseconds: 500),
                  //         curve: Curves.easeOut,
                  //       );
                  //
                  //       _commentController.clear();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,
                color: isDarkTheme(context)
                    ? AppColors.LIGHT_BLUE
                    : AppColors.PRIMARY_COLOR),
            onPressed: () async {
              final reelsCubit = context.read<ReelsCubit>();
              await reelsCubit.addComment(
                  widget.reel.id, _commentController.text);
              await reelsCubit.getComments(widget.reel.id);

              widget.scrollController.animateTo(
                widget.scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );

              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatefulWidget {
  final CommentData commentData;

  const CommentWidget({Key? key, required this.commentData}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(),
          SizedBox(height: 10.h),
          _buildToggleRepliesButton(),
          if (_isRepliesVisible) ...[
            _buildRepliesList(),
            _buildReplyInputField(),
          ],
        ],
      ),
    );
  }

  Widget _buildRepliesList() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.commentData.replies.map(_buildSingleReply).toList(),
      ),
    );
  }

  Widget _buildSingleReply(CommentData replay) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(replay.user.profilePictureSignedUrl),
                radius: 16,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeAndSplit(
                          '${replay.user.firstName} ${replay.user.lastName}'),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme(context)
                              ? Colors.white
                              : Colors.black87),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      replay.comment,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: isDarkTheme(context)
                              ? Colors.white70
                              : Colors.black87,
                          fontSize: 35.sp),
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
                  color: replay.isLiked
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.GREY_NORMAL_COLOR,
                ),
                onPressed: () => _handleLikeComment(replay.id),
              ),
              Text(
                replay.likeCount.toString(), textScaleFactor: 1.0,
                // Disable font scaling

                style: TextStyle(
                    color:
                        isDarkTheme(context) ? Colors.white70 : Colors.black87,
                    fontSize: 35.sp),
              ),
              const Spacer(),
              IconButton(
                icon: FaIcon(Icons.reply,
                    color:
                        isDarkTheme(context) ? Colors.white70 : Colors.black87),
                onPressed: () =>
                    _showReplyInput(replay.reelId, replay.id, replay.user.id),
              ),
            ],
          ),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }

  Widget _buildCommentRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage:
              NetworkImage(widget.commentData.user.profilePictureSignedUrl),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserName(),
              SizedBox(height: 5.h),
              _buildCommentText(),
              _buildLikeAndReplyButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return Text(
      capitalizeAndSplit(
          '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
      textScaleFactor: 1.0,
      style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
          color: isDarkTheme(context) ? Colors.white : Colors.black87),
    );
  }

  Widget _buildCommentText() {
    return Text(
      widget.commentData.comment,
      textScaleFactor: 1.0,
      style: TextStyle(
          color: isDarkTheme(context) ? Colors.white70 : Colors.black87,
          fontSize: 35.sp),
    );
  }

  void _handleLikeComment(String commentId) {
    // Handle like functionality for the comment
    context.read<ReelsCubit>().toggleCommentLike(commentId).then((_) {
      FocusScope.of(context).unfocus(); // Remove focus from the text field
      context.read<ReelsCubit>().getComments(
          widget.commentData.reelId); // Refresh comments after liking
    }).catchError((error) {
      _showErrorSnackBar('Failed to send like. Please try again.');
    });
  }

  Widget _buildLikeAndReplyButtons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: widget.commentData.isLiked
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.GREY_NORMAL_COLOR,
          ),
          onPressed: () => _handleLikeComment(widget.commentData.id),
        ),
        Text(
          widget.commentData.likeCount.toString(),
          textScaleFactor: 1.0,
          style: TextStyle(
              color: isDarkTheme(context) ? Colors.white70 : Colors.black87,
              fontSize: 35.sp),
        ),
        const Spacer(),
        IconButton(
          icon: FaIcon(Icons.reply,
              color: isDarkTheme(context) ? Colors.white70 : Colors.black87),
          onPressed: _showReplyInput,
        ),
      ],
    );
  }

  void _showReplyInput(
      [String? reelId, String? parentCommentId, String? receiverCommentId]) {
    setState(() {
      _isRepliesVisible = true;
      _replyFocusNode.requestFocus(); // Focus on the reply input field
    });
  }

  Widget _buildToggleRepliesButton() {
    if (widget.commentData.replies.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => _isRepliesVisible = !_isRepliesVisible),
      child: Text(
        _isRepliesVisible
            ? LocaleKeys.hide_replies.localize
            : LocaleKeys.view_replies.localize,
        textScaleFactor: 1.0,
        style: TextStyle(color: AppColors.LIGHT_BLUE, fontSize: 30.sp),
      ),
    );
  }

  Widget _buildReplyInputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 10),
      child: Row(
        children: [
          Expanded(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: TextField(
                controller: _replyController,
                focusNode: _replyFocusNode,
                style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black87,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDarkTheme(context) ? Colors.grey[800] : Colors.black12,
                  hintStyle: TextStyle(
                      color:
                          isDarkTheme(context) ? Colors.grey : Colors.black54),
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
                color: isDarkTheme(context)
                    ? AppColors.LIGHT_BLUE
                    : AppColors.PRIMARY_COLOR),
            onPressed: _handleSendReply,
          ),
        ],
      ),
    );
  }

  void _handleSendReply() {
    final replyText = _replyController.text.trim();
    if (replyText.isNotEmpty) {
      context
          .read<ReelsCubit>()
          .addReplayComment(
            widget.commentData.reelId,
            replyText,
            parentCommentId: widget.commentData.id,
            receiverComment: widget.commentData.user.id,
          )
          .then((_) {
        _replyController.clear();
        FocusScope.of(context).unfocus();
        context.read<ReelsCubit>().getComments(widget.commentData.reelId);
      }).catchError((error) {
        _showErrorSnackBar(LocaleKeys.failed_send_reply.localize);
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// The main bottom sheet widget to display comments-----------------------------------------before localize
// class CommentsBottomSheet extends StatefulWidget {
//   final Reel reel;
//
//   const CommentsBottomSheet({Key? key, required this.reel}) : super(key: key);
//
//   @override
//   _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
// }
//
// class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
//   late ReelsCubit reelsCubit;
//
//   @override
//   void initState() {
//     super.initState();
//     reelsCubit = serviceLocator<ReelsCubit>();
//     reelsCubit
//         .getComments(widget.reel.id); // Fetch comments once when initialized
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: reelsCubit,
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).pop(); // Dismiss if tapped outside
//         },
//         child: Stack(
//           children: [
//             Container(
//                 color: Colors
//                     .transparent), // Transparent background to detect taps
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
//                       _buildHandleIndicator(),
//                       _buildCommentsHeader(),
//                       _buildCommentsList(scrollController),
//                       Divider(color: Colors.grey[800]),
//                       CommentInputField(
//                         reel: widget.reel,
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
//     );
//   }
//
//   Widget _buildHandleIndicator() {
//     return Container(
//       width: 50,
//       height: 5.h,
//       margin: EdgeInsets.symmetric(vertical: 10.h),
//       decoration: BoxDecoration(
//         color: Colors.grey[700],
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
//
//   Widget _buildCommentsHeader() {
//     return const Center(
//       child: Text(
//         "Comments", textScaleFactor: 1.0, // Disable font scaling
//
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildCommentsList(ScrollController scrollController) {
//     return Expanded(
//       child: BlocBuilder<ReelsCubit, ReelsState>(
//         builder: (context, state) {
//           final comments = state.fetchedComments;
//
//           if (comments != null && comments.data.isNotEmpty) {
//             return ListView.builder(
//               controller: scrollController,
//               itemCount: comments.data.length,
//               itemBuilder: (context, index) {
//                 return CommentWidget(
//                   commentData: comments.data.reversed.toList()[index],
//                 );
//               },
//             );
//           }
//
//           return const CupertinoActivityIndicator(radius: 15);
//         },
//       ),
//     );
//   }
// }
//
// // The comment input field located at the bottom of the comment section
// class CommentInputField extends StatefulWidget {
//   final Reel reel;
//   final ScrollController scrollController;
//
//   const CommentInputField({
//     Key? key,
//     required this.reel,
//     required this.scrollController,
//   }) : super(key: key);
//
//   @override
//   CommentInputFieldState createState() => CommentInputFieldState();
// }
//
// class CommentInputFieldState extends State<CommentInputField> {
//   final TextEditingController _commentController = TextEditingController();
//
//   @override
//   void dispose() {
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
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Stack(
//                 alignment: Alignment.centerRight,
//                 children: [
//                   MediaQuery(
//                     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                     // Disable scaling
//
//                     child: TextField(
//                       controller: _commentController,
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[800],
//                         hintText: "Add a comment...",
//                         hintStyle: const TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10.h),
//                       ),
//                     ),
//                   ),
//                   Positioned.directional(
//                     textDirection: context.isArabic
//                         ? TextDirection.rtl
//                         : TextDirection.ltr,
//                     end: 10,
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.blue),
//                       onPressed: () async {
//                         // Send the comment
//                         final reelsCubit = context.read<ReelsCubit>();
//                         await reelsCubit.addComment(
//                             widget.reel.id, _commentController.text);
//                         await reelsCubit.getComments(widget.reel.id);
//
//                         widget.scrollController.animateTo(
//                           widget.scrollController.position.maxScrollExtent,
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.easeOut,
//                         );
//
//                         _commentController
//                             .clear(); // Clear input field after sending
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
// // Widget to display individual comments and their replies
// class CommentWidget extends StatefulWidget {
//   final CommentData commentData;
//
//   const CommentWidget({Key? key, required this.commentData}) : super(key: key);
//
//   @override
//   _CommentWidgetState createState() => _CommentWidgetState();
// }
//
// class _CommentWidgetState extends State<CommentWidget> {
//   bool _isRepliesVisible = false;
//   final TextEditingController _replyController = TextEditingController();
//   final FocusNode _replyFocusNode = FocusNode();
//
//   @override
//   void dispose() {
//     _replyController.dispose();
//     _replyFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildCommentRow(),
//           SizedBox(height: 10.h),
//           _buildToggleRepliesButton(),
//           if (_isRepliesVisible) ...[
//             _buildRepliesList(),
//             _buildReplyInputField(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommentRow() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           backgroundImage:
//               NetworkImage(widget.commentData.user.profilePictureSignedUrl),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildUserName(),
//               SizedBox(height: 5.h),
//               _buildCommentText(),
//               _buildLikeAndReplyButtons(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUserName() {
//     return Text(
//       capitalizeAndSplit(
//           '${widget.commentData.user.firstName} ${widget.commentData.user.lastName}'),
//       textScaleFactor: 1.0,
//       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//     );
//   }
//
//   Widget _buildCommentText() {
//     return Text(
//       widget.commentData.comment,
//       textScaleFactor: 1.0,
//       style: const TextStyle(color: AppColors.UNSELECTED_GRAY_COLOR),
//     );
//   }
//
//   Widget _buildLikeAndReplyButtons() {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(
//             Icons.favorite,
//             color: widget.commentData.isLiked
//                 ? AppColors.PRIMARY_COLOR_DARK
//                 : AppColors.UNSELECTED_DARK_GRAY_COLOR,
//           ),
//           onPressed: () => _handleLikeComment(widget.commentData.id),
//         ),
//         Text(
//           widget.commentData.likeCount.toString(),
//           textScaleFactor: 1.0,
//           style: const TextStyle(color: Colors.white),
//         ),
//         const Spacer(),
//         IconButton(
//           icon: const FaIcon(FontAwesomeIcons.reply, color: Colors.white),
//           onPressed: _showReplyInput,
//         ),
//       ],
//     );
//   }
//
//   void _handleLikeComment(String commentId) {
//     // Handle like functionality for the comment
//     context.read<ReelsCubit>().toggleCommentLike(commentId).then((_) {
//       FocusScope.of(context).unfocus(); // Remove focus from the text field
//       context.read<ReelsCubit>().getComments(
//           widget.commentData.reelId); // Refresh comments after liking
//     }).catchError((error) {
//       _showErrorSnackBar('Failed to send like. Please try again.');
//     });
//   }
//
//   Widget _buildToggleRepliesButton() {
//     if (widget.commentData.replies.isEmpty) return SizedBox.shrink();
//
//     return GestureDetector(
//       onTap: () => setState(() => _isRepliesVisible = !_isRepliesVisible),
//       child: Text(
//         _isRepliesVisible ? 'Hide Replies' : 'View Replies',
//         textScaleFactor: 1.0,
//         style: const TextStyle(color: Colors.blue),
//       ),
//     );
//   }
//
//   Widget _buildRepliesList() {
//     return Padding(
//       padding: EdgeInsets.only(left: 40.0, bottom: 8, top: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.commentData.replies.map(_buildSingleReply).toList(),
//       ),
//     );
//   }
//
//   Widget _buildSingleReply(CommentData replay) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5.h),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundImage:
//                     NetworkImage(replay.user.profilePictureSignedUrl),
//                 radius: 16,
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       capitalizeAndSplit(
//                           '${replay.user.firstName} ${replay.user.lastName ?? ''}'),
//                       textScaleFactor: 1.0,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     SizedBox(height: 5.h),
//                     Text(
//                       replay.comment,
//                       textScaleFactor: 1.0,
//                       style: const TextStyle(
//                           color: AppColors.UNSELECTED_GRAY_COLOR),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.favorite,
//                   color: replay.isLiked
//                       ? AppColors.PRIMARY_COLOR_DARK
//                       : AppColors.UNSELECTED_DARK_GRAY_COLOR,
//                 ),
//                 onPressed: () => _handleLikeComment(replay.id),
//               ),
//               Text(
//                 replay.likeCount.toString(), textScaleFactor: 1.0,
//                 // Disable font scaling
//
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const FaIcon(FontAwesomeIcons.reply, color: Colors.white),
//                 onPressed: () =>
//                     _showReplyInput(replay.reelId, replay.id, replay.user.id),
//               ),
//             ],
//           ),
//           const Divider(thickness: 0.1),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReplyInputField() {
//     return Padding(
//       padding: EdgeInsets.only(left: 40.0, top: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: MediaQuery(
//               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//               // Disable scaling
//               child: TextField(
//                 controller: _replyController,
//                 focusNode: _replyFocusNode,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[800],
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 20, vertical: 10.h),
//                   hintText: 'Write a reply...',
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.blue),
//             onPressed: _handleSendReply,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showReplyInput(
//       [String? reelId, String? parentCommentId, String? receiverCommentId]) {
//     setState(() {
//       _isRepliesVisible = true;
//       _replyFocusNode.requestFocus(); // Focus on the reply input field
//     });
//   }
//
//   void _handleSendReply() {
//     final replyText = _replyController.text.trim();
//     if (replyText.isNotEmpty) {
//       context
//           .read<ReelsCubit>()
//           .addReplayComment(
//             widget.commentData.reelId,
//             replyText,
//             parentCommentId: widget.commentData.id,
//             receiverComment: widget.commentData.user.id,
//           )
//           .then((_) {
//         _replyController.clear();
//         FocusScope.of(context).unfocus();
//         context.read<ReelsCubit>().getComments(
//             widget.commentData.reelId); // Refresh comments after replying
//       }).catchError((error) {
//         _showErrorSnackBar('Failed to send reply. Please try again.');
//       });
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }
//------------------------------------------------------------------------
// Shimmer effect for loading state of comments
// class ShimmerCommentWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Shimmer.fromColors(
//             baseColor: Colors.white12,
//             highlightColor: Colors.white12,
//             child: const CircleAvatar(
//               backgroundColor: Colors.white12,
//               radius: 20,
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Shimmer.fromColors(
//                   baseColor: Colors.white12,
//                   highlightColor: Colors.white12,
//                   child: Container(
//                     width: 100,
//                     height: 16.h,
//                     color: Colors.white12,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Shimmer.fromColors(
//                   baseColor: Colors.white12,
//                   highlightColor: Colors.white12,
//                   child: Container(
//                     width: double.infinity,
//                     height: 12.h,
//                     color: Colors.white12,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   children: [
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: const Icon(Icons.favorite, color: Colors.white12),
//                     ),
//                     SizedBox(width: 5),
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: Container(
//                         width: 20,
//                         height: 12.h,
//                         color: Colors.white12,
//                       ),
//                     ),
//                     const Spacer(),
//                     Shimmer.fromColors(
//                       baseColor: Colors.white12,
//                       highlightColor: Colors.white12,
//                       child: const Icon(FontAwesomeIcons.reply,
//                           color: Colors.white12),
//                     ),
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

// Function to show comments bottom sheet
Future<void> showCommentsBottomSheet(BuildContext context,
    {required Reel reel}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommentsBottomSheet(
          reel: reel); // Use the new CommentsBottomSheet widget
    },
  );
}
