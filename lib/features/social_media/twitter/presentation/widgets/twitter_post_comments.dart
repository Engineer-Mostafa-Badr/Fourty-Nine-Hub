import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../service_locator/service_locator.dart';

import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../data/models/twitter_post_comment_model.dart';
import '../../data/models/twitter_user_model.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';
import 'twitter_comment_replied.dart';
import '../../../../../helpers/manage_vibration.dart';

// =================== TwitterPostComments ===================

class TwitterPostComments extends StatefulWidget {
  final List<TwitterPostCommentEntity> comments;
  final String postId;

  final Function(TwitterPostCommentParams) onAddComment;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(TwitterPostCommentParams) onEditComment;
  final Future<bool> Function(String) onDeleteComment;
  final Function(String, TwitterPostCommentEntity) onGetReplies;
  final Function(TwitterCommentReactParams) onCommentReact;
  final Function(TwitterReportParams) onReport;

  final TwitterState state;
  final String newCommentId;
  final dynamic user;

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
    return BlocBuilder<TwitterCubit, TwitterState>(
      builder: (context, state) {

        final user = context.read<UserCubit>().state.data;
        final cubit = context.read<TwitterCubit>();
        final paging = cubit.commentsPagingController;

        return CustomScaffold(
          appBar: AppBar(
            toolbarHeight: 100.h,
            elevation: 0,
            title: Text(
              '${paging.itemList?.length ?? 0} ${LocaleKeys.comments.localize}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.clear),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: PagedListView<int, TwitterPostCommentEntity>(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  pagingController: paging,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  builderDelegate: PagedChildBuilderDelegate<TwitterPostCommentEntity>(
                    firstPageProgressIndicatorBuilder: (_) => Container(
                      margin: const EdgeInsets.only(top: 150),
                      child: const CupertinoActivityIndicator(),
                    ),
                    newPageProgressIndicatorBuilder: (_) => const CupertinoActivityIndicator(),
                    noItemsFoundIndicatorBuilder: (_) => Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Center(
                        child: Text(
                          LocaleKeys.noComments.localize,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    itemBuilder: (context, comment, index) {
                      return CommentCard(
                        comment: comment,
                        onReact: () {
                          // ✅ react using the comment id
                          widget.onCommentReact(
                            TwitterCommentReactParams(
                              commentId: comment.post,
                              react: 'love',
                            ),
                          );
                          // optimistic toggle
                          comment.isReact = !(comment.isReact ?? false);
                          // optionally bump loveCount
                          final current = comment.loveCount ?? 0;
                          comment.loveCount = (comment.isReact ?? false) ? current + 1 : (current > 0 ? current - 1 : 0);
                          setState(() {});
                        },
                        onReply: () {
                          widget.onGetReplies(comment.id, comment);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => BlocProvider.value(
                              value: serviceLocator<TwitterCubit>()..loadReplies(context, comment.id),
                              child: TwitterCommentReplies(
                                replies: const [],
                                commentId: comment.id,       // parent comment id
                                postId: comment.post,        // parent post id
                                onAddReply: (params) async => await widget.onAddReply(params),
                                onReplyReact: (id) => cubit.onCommentReact(
                                  params: TwitterCommentReactParams(commentId: id, react: 'love'),
                                ),
                                onReport: (p) => widget.onReport(p),
                                onEditReply: (params) => widget.onEditComment(params),
                                onDeleteReply: (id) => widget.onDeleteComment(id),
                              ),
                            ),
                          );
                        },
                        onReport: (p) => widget.onReport(p),
                        onEdit: (params) => widget.onEditComment(params),
                        onDelete: () async {
                          final ok = await widget.onDeleteComment(comment.id);
                          if (ok) {
                            cubit.commentsPagingController.itemList?.removeWhere((e) => e.id == comment.id);
                            setState(() {});
                            showSuccessMessage(context, LocaleKeys.deleteReply.localize);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              // ========== Composer ==========
              Container(
                height: kToolbarHeight,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
                ),
                child: Row(
                  children: [
                    // avatar
                    _SmallAvatar(url: user?.profilePicture ?? ''),
                    SizedBox(width: 10.w),
                    // input
                    Expanded(
                      child: TextFormField(
                        controller: commentTextController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '${LocaleKeys.typeYourComment.localize} …',
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (commentTextController.text.trim().isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          ManageVibration.vibrate();
                          final created = await widget.onAddComment(
                            TwitterPostCommentParams(
                              postId: widget.postId,
                              content: commentTextController.text.trim(),
                            ),
                          );

                          final u = context.read<UserCubit>().state.data;
                          cubit.commentsPagingController.itemList?.insert(
                            0,
                            TwitterPostCommentModel(
                              id: created.id,
                              content: commentTextController.text.trim(),
                              post: widget.postId,
                              createdAt: created.createdAt,
                              adminIgnore: created.adminIgnore,
                              love: created.love,
                              loveCount: created.loveCount,
                              isReact: created.isReact,
                              user: TwitterUserModel(
                                id: u?.id ?? '',
                                firstName: u?.firstName ?? '',
                                lastName: u?.lastName ?? '',
                                email: u?.email ?? '',
                                image: u?.profilePicture ?? '',
                                isDocumented: false,
                                createdAt: DateTime.now(),
                                hasStory: false,
                              ),
                            ),
                          );
                          commentTextController.clear();
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =================== Comment Card (TwitterPostCard-style) ===================

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    required this.onReact,
    required this.onReply,
    required this.onReport,
    required this.onEdit,
    required this.onDelete,
  });

  final TwitterPostCommentEntity comment;
  final VoidCallback onReact;
  final VoidCallback onReply;
  final Function(TwitterReportParams) onReport;
  final Function(TwitterPostCommentParams) onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final createdAt = comment.createdAt;



    String formatSince(DateTime? createdAt, {String locale = 'en'}) {
      if (createdAt == null) return '';

      // dd: يوم | MMM: شهر مختصر | yyyy: سنة | hh:mm: ساعة/دقيقة | a: AM/PM
      final formatter = DateFormat('dd MMM yyyy hh:mm a', locale);

      return formatter.format(createdAt);
    }
    final sinceEn = createdAt != null ? formatSince(createdAt, locale: 'en') : '';
    final sinceAr = createdAt != null ? formatSince(createdAt, locale: 'ar') : '';


    final u = comment.user;
    String displayName = '';
    String handle = '';
    String? avatar;
    bool verified = false;

    try {
      if (u is TwitterUserModel) {
        displayName = '${u.firstName ?? ''} ${u.lastName ?? ''}'.trim();
        handle = (u.handle).toString();
        avatar = u.image ?? u.avatarUrl;
        verified = u.isDocumented ?? false;
      } else if (u is Map) {
        final first = (u['firstName'] ?? '').toString();
        final last = (u['lastName'] ?? '').toString();
        displayName = '$first $last'.trim();
        final userName = (u['userName'] ?? u['username'] ?? '').toString();
        if (userName.isNotEmpty) {
          handle = userName;
        } else {
          final email = (u['email'] ?? '').toString();
          handle = email.contains('@') ? email.split('@').first : (u['_id'] ?? '').toString();
        }
        final imageUrl = (u['image'] ?? u['profilePictureUrl'] ?? '').toString();
        if (imageUrl.isNotEmpty) {
          avatar = imageUrl;
        } else {
          final up = (u['USER_PROFILE'] ?? {}) as Map?;
          final ppk = (up?['profilePictureUrl'] ?? {}) as Map?;
          final mediaKey = (ppk?['mediaKey'] ?? '').toString();
          if (mediaKey.isNotEmpty) {
            avatar = mediaKey.startsWith('http')
                ? mediaKey
                : 'https://d3j5umpuujp1ej.cloudfront.net/$mediaKey';
          }
        }
        verified = u['twitter_documentation'] == true || u['isAccountVerified'] == true;
      }
    } catch (_) {}

    final isReact = comment.isReact ?? false;
    final loveCount = comment.loveCount ?? (comment.love.length ?? 0);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 6)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (avatar + names + date + menu)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SmallAvatar(url: avatar ?? ''),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        displayName.isNotEmpty ? displayName : handle,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                       ),
                      const SizedBox(width: 6),
                      if (verified) const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                  ),
                  if (handle.isNotEmpty)
                    Text('@$handle', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
                onSelected: (v) async {
                  if (v == 'edit') {
                    onEdit(TwitterPostCommentParams(
                      postId: comment.post,
                      content: comment.content ?? '',
                     ));
                  } else if (v == 'delete') {
                    await onDelete();
                  } else if (v == 'report') {
                   }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(LocaleKeys.edit.localize)),
                  PopupMenuItem(value: 'delete', child: Text(LocaleKeys.delete.localize)),
                  PopupMenuItem(value: 'report', child: Text(LocaleKeys.report.localize)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Content
          if ((comment.content ?? '').trim().isNotEmpty)
            Text(comment.content!, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 8),
          Text(
            Localizations.localeOf(context).languageCode == 'ar' ? sinceAr : sinceEn,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
           Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 2),
            child: Row(
              children: [
                Expanded(
                  child: _miniStatItem(
                    icon: Icons.mode_comment_outlined,
                    label: LocaleKeys.reply.localize,
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: _miniStatItem(
                    icon: isReact ? Icons.favorite : Icons.favorite_outline,
                    label: '${loveCount}',
                    iconColor: isReact ? Colors.red : Colors.grey,
                    onTap: onReact,
                  ),
                ),
                // Keep the grid feel with two empty slots (like retweet/share on posts)
                Expanded(
                  child: _miniStatItem(
                    icon: FontAwesomeIcons.retweet,
                    label: '',
                    onTap: () {

                    },
                  ),
                ),
                Expanded(
                  child: _miniStatItem(
                    icon: Icons.share_outlined,
                    label: '',
                    onTap: () {

                    },
                  ),
                ),
               ],
            ),
          )

        ],
      ),
    );
  }
  Widget _miniStatItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: iconColor ?? Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  String _month(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return (m >= 1 && m <= 12) ? names[m - 1] : '';
  }
}

// =================== Small Pieces reused ===================

class _SmallAvatar extends StatelessWidget {
  const _SmallAvatar({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 36, height: 36,
        child: url.trim().isEmpty
            ? const Icon(Icons.person_outline, size: 22, color: Colors.grey)
            : Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person_outline, size: 22, color: Colors.grey),
        ),
      ),
    );
  }
}

