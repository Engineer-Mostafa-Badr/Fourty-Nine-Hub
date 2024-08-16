import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_replied.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterPostComments extends StatefulWidget {
  final List<TwitterPostCommentEntity> comments;
  final String postId;
  final Function(TwitterPostCommentParams) onAddComment;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(String,TwitterPostCommentEntity) onGetReplies;
  final Function(TwitterCommentReactParams ) onCommentReact;
  final Function(TwitterReportParams ) onReport;
  final TwitterState state;
  final String newCommentId;
  final dynamic user;
  // final UserEntity userData;
  const TwitterPostComments(
      {super.key,
      required this.postId,
      required this.comments,
      required this.onAddComment,
      required this.onCommentReact, required this.onAddReply, required this.onGetReplies, required this.newCommentId, required this.state, this.user, required this.onReport, });

  @override
  State<TwitterPostComments> createState() => _TwitterPostCommentsState();
}

class _TwitterPostCommentsState extends State<TwitterPostComments> {
  final commentTextController = TextEditingController();
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TwitterCubit>(
      create: (_)=>serviceLocator()..loadComments(context, widget.postId),
      child: BlocBuilder<TwitterCubit,TwitterState>(
        builder: (context,state) {
          final controller = context.read<TwitterCubit>();
          return Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.grey),
              title: Label(
                  text: '${controller.commentsPagingController.itemList?.length??0} Comments',
                  style: Styles.mediumText()),
              leading: IconButton(
                  onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: PagedListView<int, TwitterPostCommentEntity>(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    pagingController: controller.commentsPagingController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    builderDelegate: PagedChildBuilderDelegate<TwitterPostCommentEntity>(
                        noItemsFoundIndicatorBuilder: (context) {
                          print(controller.commentsPagingController.itemList?.length);
                          return const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                child: Text(
                                  "No Comments",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ));
                        },
                        itemBuilder: (context, item, index) {

                          return _buildCommentCard(comment: controller.commentsPagingController.itemList![index], onReplyReact: (String id) {
                            controller.onCommentReact(
                                params:
                                TwitterCommentReactParams(commentId: id,react: 'love',),);
                          }, onReport: (TwitterReportParams params) {
                            controller.onReport(params);
                          });
                        },
                        noMoreItemsIndicatorBuilder: (context) => Container(),
                        firstPageProgressIndicatorBuilder: (context) => Container(
                            margin: const EdgeInsets.only(top: 150),
                            child: const CupertinoActivityIndicator()),
                        newPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator()),
                  ),
                ),

                // Expanded(
                //   child: ListView.separated(
                //       itemBuilder: (context, index) => _buildCommentCard(
                //           comment: widget.comments[index], showReplies: showReplies, onShowReplies:()async{
                //           widget.comments[index].showReplies = true;
                //
                //           await widget.onGetReplies(widget.comments[index].id,widget.comments[index]);
                //           // widget.comments[index].replies?.addAll(controller.replies);
                //           setState(() {});
                //       }),
                //       separatorBuilder: (context, index) => const Sizer(),
                //       itemCount: widget.comments.length),
                // ),
                Container(
                    height: kToolbarHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ProfileImage(accountId: 0),
                        const Sizer(),
                        Expanded(
                            child: FormTextField(
                                hint: 'Type your comment ....',
                                height: kToolbarHeight * .7,
                                action: (v) {
                                  setState(() {});
                                },
                                controller: commentTextController)),
                        const Sizer(),
                        if (commentTextController.text.isNotEmpty)
                          IconAppButton(
                              icon: Icons.send,
                              isCircle: true,
                              onPressed: () async{
                                TwitterPostCommentModel data = await widget.onAddComment(
                                  TwitterPostCommentParams(
                                      postId: widget.postId, content: commentTextController.text),
                                );
                                final user = context.read<UserCubit>().state.data;

                                controller.commentsPagingController.itemList?.insert(
                                    0,
                                    TwitterPostCommentModel(
                                        id: data.id,
                                        content: commentTextController.text,
                                        post: widget.postId,
                                        createdAt: data.createdAt,
                                        adminIgnore: data.adminIgnore,
                                        user: TwitterUserModel(
                                          image: user?.profilePicture??'', id: user?.id??'', firstName: user?.firstName??'', lastName: user?.lastName??'', createdAt: DateTime.now(), email: user?.email??'', isDocumented: false,
                                        ),
                                        love: data.love,loveCount: data.loveCount, isReact: data.isReact));
                                commentTextController.clear();
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              })
                      ],
                    )),
              ],
            ),
          );
        }
      ),
    );
  }

  void onCommentAdded(String id,) async {
    await widget.onAddComment(
      TwitterPostCommentParams(
          postId: widget.postId, content: commentTextController.text,),
    );

  }

  Widget _buildCommentCard(
      {required TwitterPostCommentEntity comment,required Function(String) onReplyReact,required Function(TwitterReportParams) onReport}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterCommentCard(
          comment: comment,

          onCommentReact: (){
            widget.onCommentReact(
              TwitterCommentReactParams(commentId: comment.id, react: 'love')
            );
            comment.isReact=!comment.isReact!;
          },
          onCommentReply: () {
             widget.onGetReplies(comment.id,comment);
             bottomSheet(
                       context: context,
                       isScrollControlled: true,
                       widget: TwitterCommentReplies(
                         replies: const [],
                         onAddReply: (TwitterCommentReplyParams params) {
                         },
                         commentId: comment.id,
                         postId: comment.post,
                         onReplyReact: (String id) {
                           onReplyReact(id);
                         },
                         onReport: (TwitterReportParams params) {
                           onReport(params);
                         },
                       ),
                     );
            print(comment.showReplies);
          }, onReport: (TwitterReportParams params) {
            widget.onReport(params);
        },
        ),
      ],
    );
  }
}
