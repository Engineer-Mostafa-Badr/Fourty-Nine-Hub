import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../data/models/twitter_post_comment_model.dart';
import '../../data/models/twitter_user_model.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';
import 'twitter_comment_card.dart';
import 'twitter_comment_replied.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class TwitterPostComments extends StatefulWidget {
  final List<TwitterPostCommentEntity> comments;
  final String postId;
  final Function(TwitterPostCommentParams) onAddComment;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(TwitterPostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final Function(String, TwitterPostCommentEntity) onGetReplies;
  final Function(TwitterCommentReactParams) onCommentReact;
  final Function(TwitterReportParams) onReport;
  final TwitterState state;
  final String newCommentId;
  final dynamic user;
  // final UserEntity userData;
  const TwitterPostComments({
    super.key,
    required this.postId,
    required this.comments,
    required this.onAddComment,
    required this.onCommentReact,
    required this.onAddReply,
    required this.onGetReplies,
    required this.newCommentId,
    required this.state,
    this.user,
    required this.onReport,
    required this.onEditComment,
    required this.onDeleteComment,
  });

  @override
  State<TwitterPostComments> createState() => _TwitterPostCommentsState();
}

class _TwitterPostCommentsState extends State<TwitterPostComments> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitterCubit, TwitterState>(builder: (context, state) {
      final user = context.read<UserCubit>().state.data;
      final controller = context.read<TwitterCubit>();
      return CustomScaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 200.h,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Label(
              text:
                  '${controller.commentsPagingController.itemList?.length ?? 0} ${LocaleKeys.comments.localize}',
              style: Styles.mediumText()),
          leading: IconButton(
              onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PagedListView<int, TwitterPostCommentEntity>(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                pagingController: controller.commentsPagingController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate<
                        TwitterPostCommentEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(
                          controller.commentsPagingController.itemList?.length);
                      return Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              LocaleKeys.noComments.localize,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ));
                    },
                    itemBuilder: (context, item, index) {
                      return _buildCommentCard(
                          comment: controller
                              .commentsPagingController.itemList![index],
                          onReplyReact: (String id) {
                            controller.onCommentReact(
                              params: TwitterCommentReactParams(
                                commentId: id,
                                react: 'love',
                              ),
                            );
                          },
                          onReport: (TwitterReportParams params) {
                            controller.onReport(params);
                          },
                          onAddReply: (TwitterCommentReplyParams params) async {
                            var result = await widget.onAddReply(params);

                            return result;
                          },
                          onDeleteComment: (String id) async {
                            var result = await widget.onDeleteComment(id);
                            if (result == true) {
                              controller.commentsPagingController.itemList
                                  ?.removeWhere((e) => e.id == id);
                              setState(() {});
                            }
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
            Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  children: [
                    ProfileImage(
                      accountId: 0,
                      userId: '',
                      imageURL: user?.profilePicture,
                    ),
                    const Sizer(),
                    Expanded(
                        child: TextFormField(
                      maxLines: null,
                      controller: commentTextController,
                      onChanged: (v) {
                        setState(() {});
                      },
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        hintText: '${LocaleKeys.typeYourComment.localize} ....',
                        hintStyle: Styles.mediumText(),
                      ),
                    )),
                    const Sizer(),
                    if (commentTextController.text.isNotEmpty)
                      IconAppButton(
                          icon: Icons.send,
                          isCircle: true,
                          size: 20,
                          onPressed: () async {
      ManageVibration.vibrate();
                            TwitterPostCommentModel data =
                                await widget.onAddComment(
                              TwitterPostCommentParams(
                                  postId: widget.postId,
                                  content: commentTextController.text),
                            );
                            final user = context.read<UserCubit>().state.data;

                            controller.commentsPagingController.itemList
                                ?.insert(
                                    0,
                                    TwitterPostCommentModel(
                                        id: data.id,
                                        content: commentTextController.text,
                                        post: widget.postId,
                                        createdAt: data.createdAt,
                                        adminIgnore: data.adminIgnore,
                                        user: TwitterUserModel(
                                          image: user?.profilePicture ?? '',
                                          id: user?.id ?? '',
                                          firstName: user?.firstName ?? '',
                                          lastName: user?.lastName ?? '',
                                          createdAt: DateTime.now(),
                                          email: user?.email ?? '',
                                          isDocumented: false, hasStory: false,
                                        ),
                                        love: data.love,
                                        loveCount: data.loveCount,
                                        isReact: data.isReact));
                            commentTextController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          })
                  ],
                )),
          ],
        ),
      );
    });
  }

  void onCommentAdded(
    String id,
  ) async {
    await widget.onAddComment(
      TwitterPostCommentParams(
        postId: widget.postId,
        content: commentTextController.text,
      ),
    );
  }

  Widget _buildCommentCard(
      {required TwitterPostCommentEntity comment,
      required Function(String) onReplyReact,
      required Function(TwitterReportParams) onReport,
      required Function(TwitterCommentReplyParams) onAddReply,
      required Function(String) onDeleteComment}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TwitterCommentCard(
            comment: comment,
            onCommentReact: () {
              widget.onCommentReact(TwitterCommentReactParams(
                  commentId: comment.id, react: 'love'));
              comment.isReact = !comment.isReact!;
            },
            onCommentReply: () {
              widget.onGetReplies(comment.id, comment);
              bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: BlocProvider.value(
                  value: serviceLocator<TwitterCubit>()
                    ..loadReplies(context, comment.id),
                  child: TwitterCommentReplies(
                    replies: const [],
                    onAddReply: (TwitterCommentReplyParams params) async =>
                        await onAddReply(params),
                    commentId: comment.id,
                    postId: comment.post,
                    onReplyReact: (String id) {
                      onReplyReact(id);
                    },
                    onReport: (TwitterReportParams params) {
                      onReport(params);
                    },
                    onEditReply: (TwitterPostCommentParams params) =>
                        widget.onEditComment(params),
                    onDeleteReply: (id) => widget.onDeleteComment(id),
                  ),
                ),
              );
              print(comment.showReplies);
            },
            onReport: (TwitterReportParams params) {
              widget.onReport(params);
            },
            onEditComment: (TwitterPostCommentParams params) =>
                widget.onEditComment(params),
            onDeleteComment: (id) => onDeleteComment(id),
          ),
        ],
      ),
    );
  }
}