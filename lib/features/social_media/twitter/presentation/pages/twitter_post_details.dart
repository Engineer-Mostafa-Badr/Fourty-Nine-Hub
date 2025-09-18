import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../service_locator/service_locator.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../widgets/twitter_post_comments.dart';

import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/entities/twitter_post_entity.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';

import '../bloc/twitter_bloc.dart';

import '../twitter/presentation/pages/twitter_view.dart' show TwitterPostCard;

class TwitterPostDetails extends StatefulWidget {
  const TwitterPostDetails({
    super.key,
    required this.postId,
    this.post,
    this.onReact,
    this.onShare,
    this.showPostComments,
    this.onReport,
  });

  final String postId;
  final TwitterPostEntity? post;
  final Function? onReact;
  final Function? onShare;
  final Function(String)? showPostComments;
  final Function(TwitterReportParams)? onReport;

  @override
  State<TwitterPostDetails> createState() => _TwitterPostDetailsState();
}

class _TwitterPostDetailsState extends State<TwitterPostDetails> {
  late final TwitterCubit _cubit;

  final List<TwitterPostCommentEntity> _inlineComments = [];
  int _commentsPage = 1;
  bool _hasMoreComments = true;
  String? _commentsForPostId;

  Future<void> _fetchHeaderOnly() async {
    await _cubit.getTwitterPost(context, widget.postId, '');
    _commentsForPostId =
        _cubit.state.postDetails?.id ?? widget.post?.id ?? widget.postId;
  }

  Future<void> _loadFirstCommentsPage() async {
    if (_commentsForPostId == null) return;
    _commentsPage = 1;
    _inlineComments.clear();

    await _cubit.getPostComments(
      context: context,
      postId: _commentsForPostId!,
      page: _commentsPage,
    );

    final page =
        _cubit.state.postComments ?? const <TwitterPostCommentEntity>[];
    _inlineComments.addAll(page);
    _hasMoreComments = page.length >= _cubit.pageSize;
    setState(() {});
  }

  Future<void> _loadMoreComments() async {
    if (!_hasMoreComments || _commentsForPostId == null) return;
    _commentsPage += 1;

    await _cubit.getPostComments(
      context: context,
      postId: _commentsForPostId!,
      page: _commentsPage,
    );

    final page =
        _cubit.state.postComments ?? const <TwitterPostCommentEntity>[];
    if (page.isEmpty) {
      _hasMoreComments = false;
    } else {
      _inlineComments.addAll(page);
      if (page.length < _cubit.pageSize) _hasMoreComments = false;
    }
    setState(() {});
  }

  Future<void> _refreshAll() async {
    await _fetchHeaderOnly();
    _cubit.threadPostsPagingController.refresh();
    await _loadFirstCommentsPage();
  }

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<TwitterCubit>();
    _cubit.loadThread(widget.postId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchHeaderOnly();
      await _loadFirstCommentsPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;

    return CustomScaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Text(LocaleKeys.post.localize),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<TwitterCubit, TwitterState>(
          listenWhen: (p, n) => p.status != n.status,
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
            final shareSuccess = cubit.state.shareSuccess == true;

            if (state.status == StateStatus.loading &&
                state.postDetails == null) {
              return const Center(child: CustomCircularProgressIndicator());
            }

            if (state.status == StateStatus.error &&
                state.postDetails == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 40),
                      SizedBox(height: 12.h),
                      Text(LocaleKeys.somethingWentWrong.localize,
                          textAlign: TextAlign.center),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _refreshAll,
                        child: Text(LocaleKeys.retry.localize),
                      ),
                    ],
                  ),
                ),
              );
            }

            final post = state.postDetails ?? widget.post;
            if (post == null) {
              return const Center(child: CustomCircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _refreshAll,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TwitterPostCard(
                      onRepost: () => cubit.onRepost(postId: post.id),
                      isDetailed: true,
                      post: post,
                      shareSuccess: shareSuccess,
                      onReact: () async {
                        print(post.id);
                        final ok = await cubit.onReact(
                          params: TwitterPostReactParams(
                              postId: post.id, react: 'love'),
                        );
                        if (ok == true) {
                          final wasLiked = post.isLiked ?? false;
                          post.isLiked = !wasLiked;
                          final current = post.loveCount ?? 0;
                          post.loveCount = wasLiked
                              ? (current > 0 ? current - 1 : 0)
                              : current + 1;
                          setState(() {});
                        }
                      },
                      onShare: () {
                        final idToShare =
                            (post.isShared == true && post.mainPost != null)
                                ? post.mainPost!.id
                                : post.id;
                        cubit.onShare(postId: idToShare);
                        if (cubit.state.shareSuccess == true) {
                          showSuccessMessage(context,
                              LocaleKeys.postSharedSuccessfully.localize);
                        }
                      },
                      showPostComments: (String _) {
                        bottomSheet(
                          context: context,
                          isScrollControlled: true,
                          widget: BlocProvider.value(
                            value: serviceLocator<TwitterCubit>()
                              ..loadComments(context, post.id),
                            child: TwitterPostComments(
                              comments: const [],
                              postId: post.id,
                              user: user,
                              onAddComment: (TwitterPostCommentParams params) =>
                                  cubit.onPostComment(params: params),
                              onAddReply:
                                  (TwitterCommentReplyParams params) async =>
                                      cubit.onCommentReply(params: params),
                              onCommentReact:
                                  (TwitterCommentReactParams params) =>
                                      cubit.onCommentReact(params: params),
                              onGetReplies: (String id,
                                  TwitterPostCommentEntity comment) async {},
                              newCommentId: '',
                              state: cubit.state,
                              onReport: (TwitterReportParams params) =>
                                  cubit.onReport(params),
                              onEditComment:
                                  (TwitterPostCommentParams params) async =>
                                      cubit.editComment(params: params),
                              onDeleteComment: (id) async =>
                                  cubit.deleteComment(
                                context: context,
                                commentId: id,
                                postId: post.id,
                                from: 'details',
                              ),
                            ),
                          ),
                        );
                      },
                      getPost: () {},
                      onReport: (TwitterReportParams params) =>
                          cubit.onReport(params),
                      deletePost: (String id) =>
                          cubit.deletePost(context: context, postId: id),
                      hidePost: (String id) =>
                          cubit.hidePost(context: context, postId: id),
                      onDeleteComment: (String id) async => cubit.deleteComment(
                        context: context,
                        commentId: id,
                        postId: post.id,
                        from: 'details',
                      ),
                      onEditComment: (params) async =>
                          cubit.editComment(params: params),
                    ),
                    if (_inlineComments.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Text(
                        LocaleKeys.comments.localize,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8.h),

                      // First comment
                      CommentCard(
                        comment: _inlineComments.first,
                        onReact: () {
                          cubit.onCommentReact(
                            params: TwitterCommentReactParams(
                                commentId: _inlineComments.first.id,
                                react: 'love'),
                          );
                        },
                        onReply: () => _openReplyDialog(context, cubit,
                            postId: post.id,
                            commentId: _inlineComments.first.id),
                        onReport: (TwitterReportParams) {},
                        onDelete: () async {
                          showSuccessMessage(
                              context, LocaleKeys.deleteReply.localize);
                        },
                        onEdit: (TwitterPostCommentParams) {},
                      ),

                      if (_inlineComments.length > 1)
                        ..._inlineComments.skip(1).map(
                              (c) => CommentCard(
                                comment: _inlineComments.first,
                                onReact: () {
                                  cubit.onCommentReact(
                                    params: TwitterCommentReactParams(
                                        commentId: _inlineComments.first.id,
                                        react: 'love'),
                                  );
                                },
                                onReply: () => _openReplyDialog(context, cubit,
                                    postId: post.id,
                                    commentId: _inlineComments.first.id),
                                onReport: (TwitterReportParams) {},
                                onDelete: () async {
                                  showSuccessMessage(
                                      context, LocaleKeys.deleteReply.localize);
                                },
                                onEdit: (TwitterPostCommentParams) {},
                              ),
                            ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed:
                              _hasMoreComments ? _loadMoreComments : null,
                          child: Text(
                            _hasMoreComments
                                ? LocaleKeys.showMore.localize
                                : LocaleKeys.noComments.localize,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16.h),
                    Text(
                      LocaleKeys.more.localize,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8.h),
                    PagedListView<int, TwitterPostEntity>.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      pagingController: cubit.threadPostsPagingController,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      builderDelegate:
                          PagedChildBuilderDelegate<TwitterPostEntity>(
                        itemBuilder: (_, item, index) {
                          final controller = cubit.threadPostsPagingController;
                          return TwitterPostCard(
                            onRepost: () => cubit.onRepost(postId: post.id),
                            isDetailed: false,
                            post: item,
                            shareSuccess: cubit.state.shareSuccess == true,
                            onReact: () async {
                              final ok = await cubit.onReact(
                                params: TwitterPostReactParams(
                                    postId: item.id, react: 'love'),
                              );
                              if (ok == true) {
                                final list = controller.itemList;
                                if (list != null && index < list.length) {
                                  final p = list[index];
                                  final wasLiked = p.isLiked ?? false;
                                  p.isLiked = !wasLiked;
                                  final current = p.loveCount ?? 0;
                                  p.loveCount = wasLiked
                                      ? (current > 0 ? current - 1 : 0)
                                      : current + 1;
                                  controller.notifyListeners();
                                }
                              }
                            },
                            onShare: () {
                              final idToShare = (item.isShared == true &&
                                      item.mainPost != null)
                                  ? item.mainPost!.id
                                  : item.id;
                              cubit.onShare(postId: idToShare);
                              if (cubit.state.shareSuccess == true) {
                                showSuccessMessage(
                                  context,
                                  LocaleKeys.postSharedSuccessfully.localize,
                                );
                              }
                            },
                            showPostComments: (String _) {
                              bottomSheet(
                                context: context,
                                isScrollControlled: true,
                                widget: BlocProvider.value(
                                  value: serviceLocator<TwitterCubit>()
                                    ..loadComments(context, item.id),
                                  child: TwitterPostComments(
                                    comments: const [],
                                    postId: item.id,
                                    user: user,
                                    onAddComment:
                                        (TwitterPostCommentParams params) =>
                                            cubit.onPostComment(params: params),
                                    onAddReply: (TwitterCommentReplyParams
                                            params) async =>
                                        cubit.onCommentReply(params: params),
                                    onCommentReact:
                                        (TwitterCommentReactParams params) =>
                                            cubit.onCommentReact(
                                                params: params),
                                    onGetReplies: (String id,
                                        TwitterPostCommentEntity
                                            comment) async {},
                                    newCommentId: '',
                                    state: cubit.state,
                                    onReport: (TwitterReportParams params) =>
                                        cubit.onReport(params),
                                    onEditComment: (TwitterPostCommentParams
                                            params) async =>
                                        cubit.editComment(params: params),
                                    onDeleteComment: (id) async =>
                                        cubit.deleteComment(
                                      context: context,
                                      commentId: id,
                                      postId: item.id,
                                      from: 'posts',
                                    ),
                                  ),
                                ),
                              );
                            },
                            getPost: () {},
                            onReport: (TwitterReportParams params) =>
                                cubit.onReport(params),
                            deletePost: (String id) =>
                                cubit.deletePost(context: context, postId: id),
                            hidePost: (String id) =>
                                cubit.hidePost(context: context, postId: id),
                            onDeleteComment: (String id) async =>
                                cubit.deleteComment(
                              context: context,
                              commentId: id,
                              postId: item.id,
                              from: 'details',
                            ),
                            onEditComment: (params) async =>
                                cubit.editComment(params: params),
                          );
                        },
                        firstPageProgressIndicatorBuilder: (_) => const Center(
                            child: CustomCircularProgressIndicator()),
                        newPageProgressIndicatorBuilder: (_) => const Center(
                            child: CustomCircularProgressIndicator()),
                        noItemsFoundIndicatorBuilder: (_) =>
                            const SizedBox.shrink(),
                        firstPageErrorIndicatorBuilder: (_) =>
                            const SizedBox.shrink(),
                        newPageErrorIndicatorBuilder: (_) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openReplyDialog(
    BuildContext context,
    TwitterCubit cubit, {
    required String postId,
    required String commentId,
  }) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleKeys.reply.localize),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration:
              InputDecoration(hintText: LocaleKeys.writeComments.localize),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.cancel.localize),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              await cubit.onCommentReply(
                params: TwitterCommentReplyParams(
                  postId: postId,
                  reply: commentId,
                  content: text,
                ),
              );
              if (mounted) Navigator.pop(context);
            },
            child: Text(LocaleKeys.reply.localize),
          ),
        ],
      ),
    );
  }
}
