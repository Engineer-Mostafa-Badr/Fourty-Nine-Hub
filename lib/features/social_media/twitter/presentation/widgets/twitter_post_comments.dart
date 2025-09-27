import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../service_locator/service_locator.dart';

import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../data/models/twitter_post_comment_model.dart';
import '../../data/models/twitter_user_model.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';
import '../twitter/presentation/pages/create_reply_screen.dart';
import 'twitter_comment_replied.dart';
import '../../../../../helpers/manage_vibration.dart';


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
  void _openFullReplyComposer() {
    final cubit = context.read<TwitterCubit>();
    final paging = cubit.commentsPagingController;
print("////////////////////////");
print(widget.user);
     String ownerName = '';
    String ownerHandle = 'user';

    String _nameFrom(dynamic u) {
      if (u == null) return '';
      try {
        if (u is TwitterUserModel) {
          final first = (u.firstName ?? '').trim();
          final last  = (u.lastName ?? '').trim();
          final name  = '$first $last'.trim();
          if (name.isNotEmpty) return name;
          return (u.userName ?? u.email ?? u.id ?? '').toString();
        } else if (u is Map) {
          final first = (u['firstName'] ?? '').toString().trim();
          final last  = (u['lastName'] ?? '').toString().trim();
          final name  = '$first $last'.trim();
          if (name.isNotEmpty) return name;
          return (u['userName'] ?? u['username'] ?? u['email'] ?? u['_id'] ?? u['id'] ?? '').toString();
        }
      } catch (_) {}
      return '';
    }

    String _handleFrom(dynamic u) {
      if (u == null) return 'user';
      try {
        if (u is TwitterUserModel) {
          final h = (u.userName ?? '').trim();
          if (h.isNotEmpty) return h;
          final mail = (u.email ?? '').trim();
          if (mail.contains('@')) return mail.split('@').first;
          return (u.id ?? 'user').toString();
        } else if (u is Map) {
          final h = (u['userName'] ?? u['username'] ?? '').toString().trim();
          if (h.isNotEmpty) return h;
          final mail = (u['email'] ?? '').toString().trim();
          if (mail.contains('@')) return mail.split('@').first;
          return (u['_id'] ?? u['id'] ?? 'user').toString();
        }
      } catch (_) {}
      return 'user';
    }

    // Prefer the post owner if your cubit keeps it
    dynamic postOwner = widget.user; // <-- if you have it; else null
    if (postOwner == null && (paging.itemList?.isNotEmpty ?? false)) {
      // Fall back to the first comment's user to at least show something like the UI screenshot
      postOwner = paging.itemList!.first.user;
    }
    if (postOwner == null) {
      final me = context.read<UserCubit>().state.data;
      postOwner = {
        'firstName': me?.firstName ?? '',
        'lastName' : me?.lastName ?? '',
        'userName' : '',
        'email'    : me?.email ?? '',
        'id'       : me?.id ?? '',
      };
    }

    ownerName   = _nameFrom(postOwner);
    ownerHandle = _handleFrom(postOwner);
print("/////////////" );
print(ownerName );
print(ownerHandle );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TwitterCubit>(), // reuse same cubit
          child: CreateReplyTwitter(
            postId: widget.postId,
            // If you want to reply to the POST (not a specific comment) pass null.
            // If you want to reply to a particular comment, pass its id.
             ownerName: ownerName,
            ownerHandle: ownerHandle,
            onReplied: (_) {
             },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitterCubit, TwitterState>(
      builder: (context, state) {
        final user = context.read<UserCubit>().state.data;
        final cubit = context.read<TwitterCubit>();
        final paging = cubit.commentsPagingController;

        return
          CustomScaffold(
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
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  pagingController: paging,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  builderDelegate:
                      PagedChildBuilderDelegate<TwitterPostCommentEntity>(
                    firstPageProgressIndicatorBuilder: (_) => Container(
                      margin: const EdgeInsets.only(top: 150),
                      child: const CupertinoActivityIndicator(),
                    ),
                    newPageProgressIndicatorBuilder: (_) =>
                        const CupertinoActivityIndicator(),
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
                          comment.loveCount = (comment.isReact ?? false)
                              ? current + 1
                              : (current > 0 ? current - 1 : 0);
                          setState(() {});
                        },
                        onReply: () {
                          widget.onGetReplies(comment.id, comment);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => BlocProvider.value(
                              value: serviceLocator<TwitterCubit>()
                                ..loadReplies(context, comment.id),
                              child: TwitterCommentReplies(
                                replies: const [],
                                commentId: comment.id, // parent comment id
                                postId: comment.post, // parent post id
                                onAddReply: (params) async =>
                                    await widget.onAddReply(params),
                                onReplyReact: (id) => cubit.onCommentReact(
                                  params: TwitterCommentReactParams(
                                      commentId: id, react: 'love'),
                                ),
                                onReport: (p) => widget.onReport(p),
                                onEditReply: (params) =>
                                    widget.onEditComment(params),
                                onDeleteReply: (id) =>
                                    widget.onDeleteComment(id),
                              ),
                            ),
                          );
                        },
                        onReport: (p) => widget.onReport(p),
                        onEdit: (params) => widget.onEditComment(params),
                        onDelete: () async {
                          final ok = await widget.onDeleteComment(comment.id);
                          if (ok) {
                            cubit.commentsPagingController.itemList
                                ?.removeWhere((e) => e.id == comment.id);
                            setState(() {});
                            showSuccessMessage(
                                context, LocaleKeys.deleteReply.localize);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              // ========== Composer ==========
              InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                   _openFullReplyComposer();
                },                child: Container(
                  height: kToolbarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.2))),
                  ),
                  child: Row(
                    children: [
                      // avatar
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: ImageFromInternet(
                          image: user?.profilePicture ?? '',
                          isCircle: true,
                          fit: BoxFit.cover,
                          // nice fallbacks:
                          defaultLogo: false,
                          isMale: (user?.gender ?? '').toLowerCase() != 'female',
                          firstChar: (user?.firstName ?? 'U').characters.first.toUpperCase(),
                          charPadding: 5,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // input
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            ManageVibration.vibrate();
                            _openFullReplyComposer();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF1E1E1E)
                                  : const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).dividerColor.withOpacity(0.25),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${LocaleKeys.typeYourComment.localize} …',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                          ),
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
                                 ), yourReposted: false,
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

    final sinceEn =
        createdAt != null ? formatSince(createdAt, locale: 'en') : '';
    final sinceAr =
        createdAt != null ? formatSince(createdAt, locale: 'ar') : '';

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
          handle = email.contains('@')
              ? email.split('@').first
              : (u['_id'] ?? '').toString();
        }
        final imageUrl =
            (u['image'] ?? u['profilePictureUrl'] ?? '').toString();
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
        verified = u['twitter_documentation'] == true ||
            u['isAccountVerified'] == true;
      }
    } catch (_) {}

    final isReact = comment.isReact ?? false;
    final loveCount = comment.loveCount ?? (comment.love.length ?? 0);
    final cubit = context.read<TwitterCubit>();
    final bool isArabic = context.isArabic;
    bool _isMyComment(BuildContext context, TwitterPostCommentEntity c) {
      final meId = context.read<UserCubit>().state.data?.id?.toString() ?? '';
      if (meId.isEmpty) return false;

      // Prefer typed ownerData if present
      final ownerIdFromOwnerData = c.ownerData?.id?.toString();
      if (ownerIdFromOwnerData != null && ownerIdFromOwnerData.isNotEmpty) {
        return ownerIdFromOwnerData == meId;
      }

      // Fallback to `user` dynamic
      final u = c.user;
      if (u is TwitterUserModel) {
        return (u.id ?? '').toString() == meId;
      } else if (u is Map) {
        final ownerId = (u['userId'] ?? u['_id'] ?? u['id'] ?? '').toString();
        return ownerId == meId;
      }

      return false;
    }
     final bool mine = _isMyComment(context, comment);
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 6)
        ],
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
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(width: 6),
                      if (verified)
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 16),
                    ],
                  ),
                  if (handle.isNotEmpty)
                    Text('@$handle',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Spacer(),

    PopupMenuButton<String>(
      color: Colors.grey.shade200,
      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
      onSelected: (v) async {
        // block edit/delete for non-owners
        if ((v == 'edit' || v == 'delete') && !mine) {
          showErrorMessage(
            context,
            isArabic
                ? 'لا يمكنك تعديل أو حذف تعليق ليس لك'
                : 'You can only edit or delete your own comment',
          );
          return;
        }

        if (v == 'edit') {
          final edited = await _showEditCommentDialog(
            context,
            initial: comment.content ?? '',
          );
          if (edited != null && edited.trim().isNotEmpty) {
            await onEdit(
              TwitterPostCommentParams(
                postId: comment.post,
                // commentId: comment.id, // add if your API needs it
                content: edited.trim(),
              ),
            );
            comment.content = edited.trim(); // optimistic
            (context as Element).markNeedsBuild();
            showSuccessMessage(
              context,
              isArabic ? 'تم تعديل التعليق بنجاح' : 'Comment edited successfully',
            );
          }
        } else if (v == 'delete') {
          // optional confirm
          final confirm = await showDialog<bool>(
            context: context,
            builder: (dCtx) => AlertDialog(
              title: Text(isArabic ? 'حذف التعليق؟' : 'Delete comment?'),
              content: Text(isArabic
                  ? 'لا يمكن التراجع عن هذه العملية.'
                  : 'This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx, false),
                  child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dCtx, true),
                  child: Text(isArabic ? 'حذف' : 'Delete',
                      style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm == true) {
            // optimistic remove from the paging list
            final cubit = context.read<TwitterCubit>();
            final list = cubit.commentsPagingController.itemList;
            final idx = list?.indexWhere((e) => e.id == comment.id) ?? -1;
            TwitterPostCommentEntity? backup;
            if (idx >= 0 && list != null) {
              backup = list[idx];
              list.removeAt(idx);
              cubit.commentsPagingController.notifyListeners();
            }
print(comment.id);
print("==========");
print(comment.post);
            final ok = await cubit.deleteComment( context: context,
              commentId: comment.post,
              postId: comment.post,
              from: 'details',);
            if (ok) {
              showSuccessMessage(
                context,
                isArabic ? 'تم حذف التعليق' : 'Comment deleted',
              );
            } else {
               if (idx >= 0 && backup != null && list != null) {
                list.insert(idx, backup);
                cubit.commentsPagingController.notifyListeners();
              }
              showErrorMessage(
                context,
                isArabic ? 'فشل حذف التعليق' : 'Failed to delete comment',
              );
            }
          }
        } else if (v == 'report') {
          ManageVibration.vibrate();
          bottomSheet(
            context: context,
            widget: ReportView(
              id: comment.id,
              categoryId: "66a3583454e6e337915514db",
            ),
          );
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        if (mine) {
          items.addAll([
            PopupMenuItem(
              value: 'edit',
              child: Text(LocaleKeys.edit.localize),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(LocaleKeys.deleteReply.localize),
            ),
          ]);
        }

        items.add(
          PopupMenuItem(
            value: 'report',
            child: Text(LocaleKeys.report.localize),
          ),
        );

        return items;
      },
    ),
            ],
          ),

          const SizedBox(height: 8),

          // Content
          if ((comment.content ?? '').trim().isNotEmpty)
            Text(comment.content!, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 8),
          Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? sinceAr
                : sinceEn,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 2),
            child: Row(
              children: [
                 Expanded(
                  child: _miniStatItem(
                    icon: isReact ? Icons.favorite : Icons.favorite_outline,
                    label: '${loveCount}',
                    iconColor: isReact ? Colors.red : Colors.grey,
                    onTap: onReact,
                  ),
                ),

                Expanded(
                  child: _miniStatItem(
                    icon: FontAwesomeIcons.retweet,
                    label: '', // keep compact
                    onTap: () {
                      ManageVibration.vibrate();
                       cubit.onRepost(postId: comment.post);

                    },
                  ),
                ),
/*
                Expanded(
                  child: _miniStatItem(
                    icon: Icons.share_outlined,
                    label: '',
                    onTap: () {
                      ManageVibration.vibrate();
                      final idToShare = comment.post; // share the parent post
                      cubit.onShare(postId: idToShare);
                      if (cubit.state.shareSuccess == true) {
                        showSuccessMessage(
                          context,
                          LocaleKeys.postSharedSuccessfully.localize,
                        );
                      }
                    },
                  ),
                ),
*/
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<String?> _showEditCommentDialog(
      BuildContext context, {
        required String initial,
      }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final ctrl = TextEditingController(text: initial);
    String current = initial;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, // keyboard safe
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              final changed = ctrl.text.trim() != initial.trim();
              final canSave = changed && ctrl.text.trim().isNotEmpty;
              final maxLen = 500; // tweak if you need

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.editComment.localize,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        // Cancel
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(LocaleKeys.cancel.localize),
                        ),
                        // Save
                        TextButton(
                          onPressed: canSave
                              ? () => Navigator.pop(ctx, ctrl.text.trim())
                              : null,
                          child: Text(LocaleKeys.save.localize),
                        ),
                      ],
                    ),
                  ),

                  // Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: ctrl,
                      autofocus: true,
                      maxLines: null,
                      maxLength: maxLen,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.typeYourComment.localize,
                        counterText:
                        '${ctrl.text.characters.length}/$maxLen', // manual counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (v) => setState(() => current = v),
                      textInputAction: TextInputAction.newline,
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      },
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
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
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
        width: 36,
        height: 36,
        child: url.trim().isEmpty
            ? const Icon(Icons.person_outline, size: 22, color: Colors.grey)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person_outline,
                    size: 22, color: Colors.grey),
              ),
      ),
    );
  }
}
