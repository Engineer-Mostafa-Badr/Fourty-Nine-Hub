import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/comment_input_field_insta.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/no_scale_text.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';

class InstagramPostComments extends StatefulWidget {
  final String postId;
  final String commentCount;
  final bool? isShown;
  final Function(PostCommentParams) onAddComment;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final Function(ReplyOnCommentParams) onCommentReply;

  final Function(String) onDeleteReply;

  const InstagramPostComments({
    super.key,
    required this.postId,
    required this.commentCount,
    this.isShown = false,
    required this.onAddComment,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.onCommentReply,
  });

  @override
  State<InstagramPostComments> createState() => _InstagramPostCommentsState();
}

class _InstagramPostCommentsState extends State<InstagramPostComments> {
  final commentTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isReplying = false;

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    scrollController.dispose();
    commentTextController.dispose();
    super.dispose();
  }

  String? replyTo;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: BlocProvider<InstagramCubit>(
            create: (BuildContext context) =>
                serviceLocator()..loadComments(context, widget.postId),
            child: BlocBuilder<InstagramCubit, InstagramState>(
              builder: (BuildContext context, state) {
                final controller = context.read<InstagramCubit>();
                final user = context.read<UserCubit>().state.data;
                return Column(
                  children: [
                    Sizer(
                      height: 100.h,
                    ),
                    _buildHandleIndicator(),
                    _buildCommentsHeader(widget.commentCount),
                    Expanded(
                      child: PagedListView<int, CommentEntity>(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                        pagingController: controller.commentsPagingController,
                        shrinkWrap: true,
                        // physics: const BouncingScrollPhysics(
                        //     parent: AlwaysScrollableScrollPhysics()),
                        builderDelegate: PagedChildBuilderDelegate<
                                CommentEntity>(
                            noItemsFoundIndicatorBuilder: (context) {
                              print(controller
                                  .commentsPagingController.itemList?.length);
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(LocaleKeys.noCommentsYet.localize,
                                        style: Styles.headerText(
                                            fontSize: 100.sp)),
                                    const Sizer(),
                                    Text(LocaleKeys.startConversation.localize,
                                        style: Styles.mediumText(
                                            fontSize: 70.sp,
                                            color:
                                                AppColors.GREY_NORMAL_COLOR)),
                                  ],
                                ),
                              );
                            },
                            itemBuilder: (context, item, index) {
                              return _buildCommentCard(
                                  index: index,
                                  focusNode: focusNode,
                                  comment: controller.commentsPagingController
                                      .itemList![index],
                                  onDeleteComment: (String id) async {
                                    var result =
                                        await widget.onDeleteComment(id);
                                    if (result == true) {
                                      controller
                                          .commentsPagingController.itemList
                                          ?.removeWhere((e) => e.id == id);
                                      setState(() {});
                                    }
                                  },
                                  onDeleteReply: (String id) =>
                                      widget.onDeleteReply(id),
                                  function: () {
                                    controller.replyOnComment(
                                      params: ReplyOnCommentParams(
                                        postId: widget.postId,
                                        commentId: '67448bd9002d41ddb41c0c5c',
                                        content: commentTextController.text,
                                      ),
                                    );
                                  });
                            },
                            noMoreItemsIndicatorBuilder: (context) =>
                                Container(),
                            firstPageProgressIndicatorBuilder: (context) =>
                                Container(
                                    margin: const EdgeInsets.only(top: 150),
                                    child: const CupertinoActivityIndicator()),
                            newPageProgressIndicatorBuilder: (context) =>
                                const CupertinoActivityIndicator()),
                      ),
                    ),
                    // Padding(
                    //     padding: MediaQuery.of(context).viewInsets,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0)
                    //           .add(EdgeInsetsDirectional.only(end: 20.w, bottom: 10.h)),
                    //       child: Row(children: [
                    //         ImageFromInternet(
                    //           width: 50,
                    //           height: 50,
                    //           isCircle: true,
                    //           image: context.read<UserCubit>().state.data!.profilePicture??UIConst.profilePlaceHolder,
                    //         ),
                    //         SizedBox(width: 10.w),
                    //         Expanded(
                    //           child: TextField(
                    //             focusNode: focusNode,
                    //             controller: commentTextController,
                    //             style: TextStyle(
                    //               color: context.isDarkMode ? Colors.white : Colors.black87,
                    //             ),
                    //             maxLines: null,
                    //             onChanged: (value) {
                    //               setState(() {});
                    //             },
                    //             decoration: InputDecoration(
                    //               filled: true,
                    //               suffixIcon: commentTextController.text.isNotEmpty
                    //                   ? Container(
                    //                 margin: EdgeInsetsDirectional.only(
                    //                     end: 10.w, top: 10, bottom: 10),
                    //                 padding: const EdgeInsets.all(3)
                    //                     .add(EdgeInsets.symmetric(horizontal: 10.w)),
                    //                 decoration: BoxDecoration(
                    //                   color: AppColors.SECONDARY_COLOR,
                    //                   borderRadius: BorderRadius.circular(20),
                    //                 ),
                    //                 child: InkWell(
                    //                   onTap: ()async{
                    //                     final content = commentTextController.text.trim();
                    //                     if (content.isEmpty) return;
                    //                  //   widget.onAddComment();
                    //                     if (replyTo != null){
                    //                       widget.onCommentReply(ReplyOnCommentParams(
                    //                           postId: widget.postId,
                    //                           commentId: '674a0a806ad30ae85dc39119',
                    //                           content: commentTextController.text));
                    //                     }else{
                    //                       CommentEntity data = await widget.onAddComment(
                    //                         PostCommentParams(
                    //                           postId: widget.postId,
                    //                           content: commentTextController.text,
                    //                         ),
                    //                       );
                    //                       controller.commentsPagingController.itemList?.insert(
                    //                         0,
                    //                         CommentModel(
                    //                           id: data.id,
                    //                           content: commentTextController.text,
                    //                           post: widget.postId,
                    //                           createdAt: DateTime.now(),
                    //                           loveCount: data.loveCount,
                    //                           angryCount: data.angryCount,
                    //                           likesCount: data.likesCount,
                    //                           repliesCount: data.repliesCount,
                    //                           sadCount: data.sadCount,
                    //                           wowCount: data.wowCount,
                    //                           isAngry: false,
                    //                           isLikes: false,
                    //                           isLove: false,
                    //                           isSad: false,
                    //                           isWow: false,
                    //                           user: TwitterUserEntity(
                    //                             id: user!.id,
                    //                             firstName: user.firstName,
                    //                             lastName: user.lastName,
                    //                             createdAt: DateTime.now(),
                    //                             image: user.profilePicture ?? '',
                    //                             email: user.email ?? '',
                    //                             isDocumented: false,
                    //                           ),
                    //                         ),
                    //                       );
                    //                     }
                    //
                    //                     setState(() {
                    //                       commentTextController.clear();
                    //                       replyTo = null;
                    //                     });
                    //                   },
                    //                   child: Icon(
                    //                     Icons.arrow_upward,
                    //                     color: Colors.white,
                    //                     size: 30.h,
                    //                   ),
                    //                 ),
                    //               )
                    //                   : null,
                    //               fillColor:
                    //               context.isDarkMode ? Colors.grey[800] : Colors.black12,
                    //               hintText: replyTo != null
                    //                   ? "Replying to @$replyTo"
                    //                   : "Add a comment...",
                    //               hintStyle: TextStyle(
                    //                 color: context.isDarkMode ? Colors.grey : Colors.black54,
                    //               ),
                    //               border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(20),
                    //                 borderSide: BorderSide.none,
                    //               ),
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(20),
                    //                 borderSide: BorderSide.none,
                    //               ),
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(20),
                    //                 borderSide: BorderSide.none,
                    //               ),
                    //               contentPadding: const EdgeInsets.all(16),
                    //             ),
                    //             minLines: 1,
                    //             keyboardType: TextInputType.multiline,
                    //           ),
                    //         )
                    //       ]),
                    //     )),
                    CommentInputFieldInsta(
                      commentController: commentTextController,
                      isReplying: isReplying,
                      focusNode: focusNode,
                      controller: controller,
                      onAddComment: () async {
                        final content = commentTextController.text.trim();
                        if (content.isEmpty) return;
                        //   widget.onAddComment();
                        if (replyTo != null) {
                          widget.onCommentReply(ReplyOnCommentParams(
                              postId: widget.postId,
                              commentId: '674a0a806ad30ae85dc39119',
                              content: commentTextController.text));
                        } else {
                          CommentEntity data = await widget.onAddComment(
                            PostCommentParams(
                              postId: widget.postId,
                              content: commentTextController.text,
                            ),
                          );
                          controller.commentsPagingController.itemList?.insert(
                            0,
                            CommentModel(
                              id: data.id,
                              content: commentTextController.text,
                              post: widget.postId,
                              createdAt: DateTime.now(),
                              loveCount: data.loveCount,
                              angryCount: data.angryCount,
                              likesCount: data.likesCount,
                              repliesCount: data.repliesCount,
                              sadCount: data.sadCount,
                              wowCount: data.wowCount,
                              isAngry: false,
                              isLikes: false,
                              isLove: false,
                              isSad: false,
                              isWow: false,
                              user: TwitterUserEntity(
                                id: user!.id,
                                firstName: user.firstName,
                                lastName: user.lastName,
                                createdAt: DateTime.now(),
                                image: user.profilePicture ?? '',
                                email: user.email ?? '',
                                isDocumented: false, hasStory: false,
                              ),
                            ),
                          );
                        }

                        setState(() {
                          commentTextController.clear();
                          replyTo = null;
                        });
                      },
                      postId: widget.postId,
                    ),

                    // if(widget.isShown==false)Container(
                    //     height: kToolbarHeight,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         const ProfileImage(
                    //           accountId: 0,
                    //           userId: '',
                    //         ),
                    //         const Sizer(),
                    //         Expanded(
                    //             child: TextFormField(
                    //           maxLines: null,
                    //           controller: commentTextController,
                    //           onChanged: (v) {
                    //             setState(() {});
                    //           },
                    //           style: Styles.headerText(fontSize: 26),
                    //           decoration: InputDecoration(
                    //             fillColor: Colors.white,
                    //             contentPadding: const EdgeInsets.all(5),
                    //             hintText: '${LocaleKeys.typeYourComment.localize} ....',
                    //             hintStyle: Styles.mediumText(),
                    //           ),
                    //         )),
                    //         const Sizer(),
                    //         if (commentTextController.text.isNotEmpty)
                    //           IconAppButton(
                    //               icon: Icons.send,
                    //               size: 20,
                    //               isCircle: true,
                    //               onPressed: () async {
                    //                 CommentEntity data = await widget.onAddComment(
                    //                   PostCommentParams(
                    //                       postId: widget.postId,
                    //                       content: commentTextController.text),
                    //                 );
                    //                 controller.commentsPagingController.itemList
                    //                     ?.insert(
                    //                   0,
                    //                   CommentModel(
                    //                     id: data.id,
                    //                     content: commentTextController.text,
                    //                     post: widget.postId,
                    //                     createdAt: DateTime.now(),
                    //                     loveCount: data.loveCount,
                    //                     angryCount: data.angryCount,
                    //                     likesCount: data.likesCount,
                    //                     repliesCount: data.repliesCount,
                    //                     sadCount: data.sadCount,
                    //                     wowCount: data.wowCount,
                    //                     isAngry: false,
                    //                     isLikes: false,
                    //                     isLove: false,
                    //                     isSad: false,
                    //                     isWow: false,
                    //                     user: TwitterUserEntity(
                    //                       id: user!.id,
                    //                       firstName: user.firstName,
                    //                       lastName: user.lastName,
                    //                       createdAt: DateTime.now(),
                    //                       image: user.profilePicture ?? '',
                    //                       email: user.email ?? '',
                    //                       isDocumented: false,
                    //                     ),
                    //                   ),
                    //                 );
                    //                 commentTextController.clear();
                    //                 FocusScope.of(context).unfocus();
                    //                 setState(() {});
                    //               })
                    //       ],
                    //     )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentCard({
    required CommentEntity comment,
    required Function(String) onDeleteComment,
    required Function(String) onDeleteReply,
    required FocusNode focusNode,
    required int index,
    required Function() function,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentWidgetInsta(
          commentData: comment,
          focusNode: focusNode,
          index: index,
          commentController: commentTextController,
          onAddReply: (ReplyOnCommentParams params) =>
              widget.onCommentReply(params),
          onEditComment: (PostCommentParams params) =>
              widget.onEditComment(params),
          onDeleteComment: (String id) => onDeleteComment(id),
          onDeleteReply: (String id) => onDeleteReply(id),
          function: function,
          onReplyPressed: () {
            setState(() {
              replyTo = comment.user.firstName; // Or user.username
              commentTextController.text = '@${replyTo!} ';
              commentTextController.selection = TextSelection.fromPosition(
                TextPosition(offset: commentTextController.text.length),
              );
            });
          },
        ),
        // InstagramCommentCard(
        //   comment: comment,
        //   onAddReply: (ReplyOnCommentParams params) =>
        //       widget.onCommentReply(params),
        //   onEditComment: (PostCommentParams params) =>
        //       widget.onEditComment(params),
        //   onDeleteComment: (String id) => onDeleteComment(id),
        //   onDeleteReply: (String id) => onDeleteReply(id),
        // ),
      ],
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

  Widget _buildCommentsHeader(String commentCount) {
    return Center(
      child: NoScaleText(
        '$commentCount ${LocaleKeys.comments_header.localize}',
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 30.sp,
        ),
      ),
    );
  }
}
