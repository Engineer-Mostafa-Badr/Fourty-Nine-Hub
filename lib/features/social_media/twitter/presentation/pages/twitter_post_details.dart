import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TwitterPostDetails extends StatefulWidget {
  const TwitterPostDetails(
      {super.key,
      this.post,
      this.onReact,
      this.onShare,
      this.showPostComments,
      this.onReport,
      required this.postId});
  final TwitterPostEntity? post;
  final Function? onReact;
  final String postId;
  final Function? onShare;
  final Function(String)? showPostComments;
  final Function(TwitterReportParams)? onReport;

  @override
  State<TwitterPostDetails> createState() => _TwitterPostDetailsState();
}

class _TwitterPostDetailsState extends State<TwitterPostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: const Text('Post Details'),
      ),
      body: BlocProvider<TwitterCubit>(
        create: (_) {
          return serviceLocator()
            ..getTwitterPost(
              context,
              widget.postId,
              '',
            );
        },
        child: BlocConsumer<TwitterCubit, TwitterState>(
          buildWhen: (current, previous) =>
              previous.status == StateStatus.success,
          listener: (context, state) {
            if (state.status == StateStatus.error) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure ?? const UnknownFailure(),
                  context,
                ),
              );
            }
          },
          builder: (context, state) {
            final controller = context.read<TwitterCubit>();
            return state.status == StateStatus.success
                ? TwitterPostCard(
                    post: state.postDetails!,
                    onReact: () async {
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
                    },
                    showPostComments: (i) {
                      final user = context.read<UserCubit>().state.data;

                      bottomSheet(
                        context: context,
                        isScrollControlled: true,
                        widget: TwitterPostComments(
                          comments: const [],
                          postId: state.postDetails!.id,
                          user: user,
                          onAddComment:
                              (TwitterPostCommentParams params) async {
                            var result =
                                await controller.onPostComment(params: params);
                            state.postDetails?.commentsCount =
                                (state.postDetails!.commentsCount! + 1);
                            setState(() {});
                            return result;
                          },
                          onAddReply: (TwitterCommentReplyParams params) {
                            controller.onCommentReply(params: params);
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
                          // userData: user,
                        ),
                      );
                    },
                    onShare: () {
                      controller.onShare(postId: state.postDetails!.id);
                    },
                    getPost: () {},
                    onReport: (TwitterReportParams params) async {
                      controller.onReport(params);
                      showSuccessMessage(context, "Report sent successfully");
                      context.pop();
                    },
                    deletePost: (String id) {
                      controller.deletePost(
                          context: context, postId: widget.postId);
                      context.pop();
                    },
                    hidePost: (String id) {
                      controller.deletePost(
                          context: context, postId: widget.postId);
                      context.pop();
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
