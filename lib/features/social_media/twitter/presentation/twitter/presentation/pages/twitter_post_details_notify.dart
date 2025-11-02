import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_reply_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_replied.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TwitterPostDetailsNotify extends StatefulWidget {
  TwitterPostDetailsNotify({
    super.key,
    payload,
  }) {
    if (payload is String) {
      postId = payload;
    } else {
      if (payload["isReply"] != null) {
        isReply = payload["isReply"];
      }
      if (payload['comment'] != null && payload['isReply'] == false) {
        comment = TwitterPostCommentModel.fromJson(payload['comment']);
        print("comment?.toJson${comment?.toJson()}");
      }
      if (payload['comment'] != null && payload['isReply'] == true) {
        reply = TwitterCommentReplyModel.fromJson(payload['comment']);
        print("reply?.toJson${comment?.toJson()}");
      }
      postId = payload['postId'];
    }
  }
  String? postId;
  bool? isReply;
  TwitterPostCommentEntity? comment;
  TwitterCommentReplyEntity? reply;

  @override
  State<TwitterPostDetailsNotify> createState() =>
      _TwitterPostDetailsNotifyState();
}

class _TwitterPostDetailsNotifyState extends State<TwitterPostDetailsNotify> {
  @override
  void initState() {
    context.read<TwitterCubit>().getTwitterPost(
          context,
          widget.postId ?? '',
          '',
        );
    if (widget.isReply != null) {
      if (widget.isReply == true) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          showReplies();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () async {
          showComments();
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140.h,
        // title: const Text('Post Details'),
      ),
      body: BlocConsumer<TwitterCubit, TwitterState>(
        buildWhen: (current, previous) =>
            previous.status == StateStatus.success,
        listener: (context, state) {
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure ?? UnknownFailure(''),
                context,
              ),
            );
          }
        },
        builder: (context, state) {
          final controller = context.read<TwitterCubit>();
          return state.status == StateStatus.success
              ? TwitterPostCard(
                  onRepost: () =>
                      controller.onRepost(postId: state.postDetails!.id),
                  isDetailed: false,
                  post: state.postDetails!,
                  onReact: () async {
                    if (context.read<UserCubit>().isLoggedIn) {
                      var result = await controller.onReact(
                        params: TwitterPostReactParams(
                            react: 'love', postId: state.postDetails!.id),
                      );
                      if (result == true) {
                        if (state.postDetails?.isReact == true) {
                          state.postDetails?.isReact = false;
                          state.postDetails?.loveCount =
                              (state.postDetails!.loveCount! - 1);
                        } else {
                          state.postDetails?.isReact = true;
                          state.postDetails?.loveCount =
                              (state.postDetails!.loveCount! + 1);
                        }
                      }
                    } else {
                      context.push(Routes.LOGIN);
                    }
                  },
                  showPostComments: (i) {
                    if (context.read<UserCubit>().isLoggedIn) {
                      final user = context.read<UserCubit>().state.data;

                      bottomSheet(
                        context: context,
                        isScrollControlled: true,
                        widget: BlocProvider.value(
                          value: serviceLocator<TwitterCubit>()
                            ..loadComments(context, state.postDetails!.id),
                          child: TwitterPostComments(
                            comments: const [],
                            postId: state.postDetails!.id,
                            user: user,
                            onAddComment:
                                (TwitterPostCommentParams params) async {
                              var result = await controller.onPostComment(
                                  params: params);
                              // state.postDetails?.commentsCount =
                              //     (state.postDetails!.commentsCount! + 1);
                              setState(() {});
                              return result;
                            },
                            onAddReply:
                                (TwitterCommentReplyParams params) async {
                              var result = await controller.onCommentReply(
                                  params: params);
                              state.postDetails?.commentsCount =
                                  (state.postDetails!.commentsCount! + 1);
                              setState(() {});
                              return result;
                            },
                            onCommentReact: (TwitterCommentReactParams params) {
                              controller.onCommentReact(params: params);
                            },
                            onGetReplies: (String id,
                                TwitterPostCommentEntity comment) async {
                              // getCommentReplies(
                              //   context: context,
                              //   commentId: id,
                              //   comment: comment,
                              //   postId: postId, userData: userData,
                              // );
                            },
                            newCommentId: '',
                            state: state,
                            onReport: (TwitterReportParams params) {
                              controller.onReport(params);
                            },
                            onEditComment:
                                (TwitterPostCommentParams params) async =>
                                    await controller.editComment(
                                        params: params),
                            onDeleteComment: (id) async {
                              var result = await controller.deleteComment(
                                  context: context,
                                  commentId: id,
                                  postId: state.postDetails!.id,
                                  from: 'details');
                              state.postDetails?.commentsCount =
                                  (state.postDetails!.commentsCount! - 1);
                              setState(() {});
                              return result;
                            },
                            // userData: user,
                          ),
                        ),
                      );
                    } else {
                      context.push(Routes.LOGIN);
                    }
                  },
                  onShare: () {
                    if (context.read<UserCubit>().isLoggedIn) {
                      controller.onShare(postId: state.postDetails!.id);
                    } else {
                      context.push(Routes.LOGIN);
                    }
                  },
                  getPost: () {},
                  onReport: (TwitterReportParams params) async {
                    controller.onReport(params);
                    showSuccessMessage(
                        context, LocaleKeys.reportSentSuccessfully.localize);
                    context.pop();
                  },
                  deletePost: (String id) {
                    controller.deletePost(
                        context: context, postId: widget.postId ?? '');
                    context.pop();
                  },
                  hidePost: (String id) {
                    controller.deletePost(
                        context: context, postId: widget.postId ?? '');
                    context.pop();
                  },
                  onDeleteComment: (String id) async {
                    return await controller.deleteComment(
                        context: context,
                        commentId: id,
                        postId: '',
                        from: 'details');
                  },
                  onEditComment: (TwitterPostCommentParams params) async =>
                      await controller.editComment(params: params),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  showComments() {
    return bottomSheet(
      context: context,
      isScrollControlled: true,
      widget: BlocProvider.value(
        value: serviceLocator<TwitterCubit>()
          ..loadComments(context, widget.postId ?? '', comment: widget.comment),
        child: TwitterPostComments(
          comments: const [],
          postId: widget.postId ?? '',
          user: context.read<UserCubit>().state.data,
          onAddComment: (TwitterPostCommentParams params) =>
              context.read<TwitterCubit>().onPostComment(params: params),
          onAddReply: (TwitterCommentReplyParams params) async {
            return await context
                .read<TwitterCubit>()
                .onCommentReply(params: params);
          },
          onCommentReact: (TwitterCommentReactParams params) {
            context.read<TwitterCubit>().onCommentReact(params: params);
          },
          onGetReplies: (String id, TwitterPostCommentEntity comment) async {},
          newCommentId: '',
          state: const TwitterState(),
          onReport: (TwitterReportParams params) {
            context.read<TwitterCubit>().onReport(params);
          },
          onEditComment: (TwitterPostCommentParams params) async {
            return await context
                .read<TwitterCubit>()
                .editComment(params: params);
          },
          onDeleteComment: (id) async => await context
              .read<TwitterCubit>()
              .deleteComment(
                  context: context,
                  commentId: id,
                  postId: widget.postId ?? '',
                  from: 'posts'),
        ),
      ),
    );
  }

  showReplies() {
    return bottomSheet(
      context: context,
      isScrollControlled: true,
      widget: BlocProvider.value(
        value: serviceLocator<TwitterCubit>()
          ..loadReplies(context, widget.reply?.reply ?? '',
              reply: widget.reply),
        child: TwitterCommentReplies(
          replies: const [],
          onAddReply: (TwitterCommentReplyParams params) async {
            var result = await context
                .read<TwitterCubit>()
                .onCommentReply(params: params);
            context.read<TwitterCubit>().state.postDetails?.commentsCount =
                (context
                        .read<TwitterCubit>()
                        .state
                        .postDetails!
                        .commentsCount! +
                    1);
            setState(() {});
            return result;
          },
          commentId: widget.reply?.reply ?? '',
          postId: widget.postId ?? '',
          onReplyReact: (String id) {
            context.read<TwitterCubit>().onCommentReact(
                  params: TwitterCommentReactParams(
                    commentId: id,
                    react: 'love',
                  ),
                );
          },
          onReport: (TwitterReportParams params) {
            context.read<TwitterCubit>().onReport(params);
          },
          onEditReply: (TwitterPostCommentParams params) async =>
              await context.read<TwitterCubit>().editComment(params: params),
          onDeleteReply: (id) async {
            var result = await context.read<TwitterCubit>().deleteComment(
                context: context,
                commentId: id,
                postId: context.read<TwitterCubit>().state.postDetails!.id,
                from: 'details');
            context.read<TwitterCubit>().state.postDetails?.commentsCount =
                (context
                        .read<TwitterCubit>()
                        .state
                        .postDetails!
                        .commentsCount! -
                    1);
            setState(() {});
            return result;
          },
        ),
      ),
    );
  }
}
