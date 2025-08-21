// lib/features/social_media/twitter/presentation/pages/twitter_post_details_notify.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';

import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../data/models/twitter_comment_reply_model.dart';
import '../../data/models/twitter_post_comment_model.dart';
import '../../domain/entities/twitter_comment_reply_entity.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';
import '../widgets/twitter_comment_replied.dart';
import '../widgets/twitter_post_card.dart';
import '../widgets/twitter_post_comments.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TwitterPostDetailsNotify extends StatefulWidget {
  /// Explicit, typed inputs (safe)
  final String? postId;
  final bool isReply;
  final TwitterPostCommentEntity? comment;
  final TwitterCommentReplyEntity? reply;

  const TwitterPostDetailsNotify({
    super.key,
    this.postId,
    this.isReply = false,
    this.comment,
    this.reply,
  });

  /// Factory when you only have a `payload` that may be null/String/Map.
  /// Keeps your current calling style working without crashes.
  factory TwitterPostDetailsNotify.fromPayload({Key? key, dynamic payload}) {
    String? postId;
    bool isReply = false;
    TwitterPostCommentEntity? comment;
    TwitterCommentReplyEntity? reply;

    try {
      // String payload => treat as postId
      if (payload is String) {
        postId = payload;
      }
      // Map payload
      else if (payload is Map) {
        if (payload['postId'] is String) postId = payload['postId'] as String;

        if (payload['isReply'] is bool) {
          isReply = payload['isReply'] as bool;
        }

        if (payload['comment'] != null) {
          // If isReply == false => it's a Comment
          if (isReply == false) {
            try {
              comment = TwitterPostCommentModel.fromJson(payload['comment']);
            } catch (_) {}
          } else {
            // If isReply == true => it's a Reply
            try {
              reply = TwitterCommentReplyModel.fromJson(payload['comment']);
            } catch (_) {}
          }
        }
      }
      // anything else: keep defaults (won't crash)
    } catch (_) {
      // swallow errors safely
    }

    return TwitterPostDetailsNotify(
      key: key,
      postId: postId,
      isReply: isReply,
      comment: comment,
      reply: reply,
    );
  }

  /// Convenience: build from Navigator RouteSettings.arguments
  factory TwitterPostDetailsNotify.fromRoute(BuildContext context, {Key? key}) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return TwitterPostDetailsNotify.fromPayload(key: key, payload: args);
  }

  @override
  State<TwitterPostDetailsNotify> createState() =>
      _TwitterPostDetailsNotifyState();
}

class _TwitterPostDetailsNotifyState extends State<TwitterPostDetailsNotify> {
  @override
  void initState() {
    super.initState();

    // Guard: only call when we have a postId
    final id = widget.postId ?? '';
    if (id.isNotEmpty) {
      context.read<TwitterCubit>().getTwitterPost(context, id, '');
    }

    // Open comments/replies after a small delay (UI has time to build)
    if (widget.isReply) {
      Future.delayed(const Duration(milliseconds: 400), showReplies);
    } else if (widget.comment != null) {
      Future.delayed(const Duration(milliseconds: 400), showComments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(toolbarHeight: 140.h),
      body: BlocConsumer<TwitterCubit, TwitterState>(
        // correct order: (previous, current)
        buildWhen: (previous, current) =>
        previous.status != current.status || current.postDetails != null,
        listener: (context, state) {
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(state.failure ?? UnknownFailure(''), context),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<TwitterCubit>();
          final post = state.postDetails;

          if (state.status != StateStatus.success || post == null) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          return TwitterPostCard(
            post: post,
            onReact: () async {
              if (!context.read<UserCubit>().isLoggedIn) {
                return pleaseLoginDialog(context);
              }
              final ok = await cubit.onReact(
                params: TwitterPostReactParams(
                  postId: post.id,
                  react: 'love',
                ),
              );
              if (ok) {
                // local optimistic toggle
                setState(() {
                  post.isReact = !(post.isReact ?? false);
                  final current = post.loveCount ?? 0;
                  post.loveCount = (post.isReact ?? false) ? current + 1 : (current - 1).clamp(0, 1 << 31);
                });
              }
            },
            showPostComments: (_) => _openCommentsSheet(context, post.id),
            onShare: () {
              if (!context.read<UserCubit>().isLoggedIn) {
                return pleaseLoginDialog(context);
              }
              cubit.onShare(postId: post.id);
            },
            getPost: () {},
            onReport: (TwitterReportParams params) async {
              await cubit.onReport(params);
              showSuccessMessage(
                  context, LocaleKeys.reportSentSuccessfully.localize);
              context.pop();
            },
            deletePost: (String id) {
              cubit.deletePost(context: context, postId: id);
              context.pop();
            },
            hidePost: (String id) {
              cubit.hidePost(context: context, postId: id);
              context.pop();
            },
            onDeleteComment: (String id) async {
              final res = await cubit.deleteComment(
                context: context,
                commentId: id,
                postId: post.id,
                from: 'details',
              );
              if (res) {
                setState(() {
                  post.commentsCount = (post.commentsCount ?? 1) - 1;
                });
              }
              return res;
            },
            onEditComment: (TwitterPostCommentParams params) async =>
            await cubit.editComment(params: params),
          );
        },
      ),
    );
  }

  // ---------- Helpers ----------

  void _openCommentsSheet(BuildContext context, String postId) {
    if (!context.read<UserCubit>().isLoggedIn) {
      pleaseLoginDialog(context);
      return;
    }
    final user = context.read<UserCubit>().state.data;

    bottomSheet(
      context: context,
      isScrollControlled: true,
      widget: BlocProvider.value(
        value: serviceLocator<TwitterCubit>()..loadComments(context, postId),
        child: TwitterPostComments(
          comments: const [],
          postId: postId,
          user: user,
          onAddComment: (TwitterPostCommentParams params) async {
            final result =
            await context.read<TwitterCubit>().onPostComment(params: params);
            setState(() {}); // allow quick visual refresh
            return result;
          },
          onAddReply: (TwitterCommentReplyParams params) async {
            final result = await context
                .read<TwitterCubit>()
                .onCommentReply(params: params);
            final pd = context.read<TwitterCubit>().state.postDetails;
            if (pd != null) {
              setState(() => pd.commentsCount = (pd.commentsCount ?? 0) + 1);
            }
            return result;
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
          onEditComment: (TwitterPostCommentParams params) async =>
          await context.read<TwitterCubit>().editComment(params: params),
          onDeleteComment: (id) async => await context
              .read<TwitterCubit>()
              .deleteComment(
              context: context, commentId: id, postId: postId, from: 'posts'),
        ),
      ),
    );
  }

  Future<void> showComments() async {
    final id = widget.postId ?? '';
    if (id.isEmpty) return;
    _openCommentsSheet(context, id);
  }

  Future<void> showReplies() async {
    if (widget.reply == null) return;

    final replyId = widget.reply!.reply ?? '';
    if (replyId.isEmpty) return;

    bottomSheet(
      context: context,
      isScrollControlled: true,
      widget: BlocProvider.value(
        value: serviceLocator<TwitterCubit>()
          ..loadReplies(context, replyId, reply: widget.reply),
        child: TwitterCommentReplies(
          replies: const [],
          onAddReply: (TwitterCommentReplyParams params) async {
            final result =
            await context.read<TwitterCubit>().onCommentReply(params: params);
            final pd = context.read<TwitterCubit>().state.postDetails;
            if (pd != null) {
              setState(() => pd.commentsCount = (pd.commentsCount ?? 0) + 1);
            }
            return result;
          },
          commentId: replyId,
          postId: widget.postId ?? '',
          onReplyReact: (String id) {
            context.read<TwitterCubit>().onCommentReact(
              params: TwitterCommentReactParams(commentId: id, react: 'love'),
            );
          },
          onReport: (TwitterReportParams params) {
            context.read<TwitterCubit>().onReport(params);
          },
          onEditReply: (TwitterPostCommentParams params) async =>
          await context.read<TwitterCubit>().editComment(params: params),
          onDeleteReply: (id) async {
            final res = await context.read<TwitterCubit>().deleteComment(
              context: context,
              commentId: id,
              postId: context.read<TwitterCubit>().state.postDetails?.id ?? '',
              from: 'details',
            );
            final pd = context.read<TwitterCubit>().state.postDetails;
            if (res && pd != null) {
              setState(() => pd.commentsCount = (pd.commentsCount ?? 1) - 1);
            }
            return res;
          },
        ),
      ),
    );
  }
}
