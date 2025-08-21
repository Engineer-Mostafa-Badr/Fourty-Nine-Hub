// lib/features/social_media/twitter/presentation/pages/twitter_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_personal_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../../core/error/failure.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/loading/custom_loading.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/messages/messages.dart';
import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../service_locator/service_locator.dart';
import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../custom_page/presentation/page/widget/edit_page.dart';
import '../../../../data/models/twitter_user_model.dart';
import '../../../../domain/entities/twitter_post_comment_entity.dart';
import '../../../../domain/entities/twitter_post_entity.dart';
import '../../../../domain/usecases/comment_react_usecase.dart';
import '../../../../domain/usecases/comment_reply_usecase.dart';
import '../../../../domain/usecases/post_comment_usecase.dart';
import '../../../../domain/usecases/post_react_usecase.dart';
import '../../../../domain/usecases/twitter_report_usecase.dart';
import '../../../bloc/twitter_bloc.dart';
import '../../../pages/twitter_post_details.dart';
import '../../../widgets/build_twitter_document_card.dart';
import '../../../widgets/twitter_post_card.dart';
import '../../../widgets/twitter_post_comments.dart';

/// ===== User model helpers =====
extension TwitterUserCompat on TwitterUserModel {
  String get handle {
    final u = (userName ?? '').trim();
    if (u.isNotEmpty) return u;

    final mail = (email ?? '').trim();
    if (mail.contains('@')) return mail.split('@').first;

    return id;
  }

  String? get avatarUrl {
    final img = (image ?? '').trim();
    if (img.isNotEmpty) return img;

    try {
      final self = this as dynamic;
      final dynamic profile =
      (self.USER_PROFILE != null) ? self.USER_PROFILE : self.userProfile;
      final String? rawKey =
      (profile?.profilePictureKey?.mediaKey as String?)?.trim();
      if (rawKey == null || rawKey.isEmpty) return null;
      return rawKey.startsWith('http')
          ? rawKey
          : 'https://d3j5umpuujp1ej.cloudfront.net/$rawKey';
    } catch (_) {
      return null;
    }
  }
}

/// ===== Safe image with fallback =====
class SafeNetImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final String? heroTag;

  const SafeNetImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.borderRadius,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      url,
      fit: fit,
      height: height,
      width: width,
      errorBuilder: (_, __, ___) => Image.asset(
        Assets.twitterAppBarIcon,
        fit: fit,
        height: height,
        width: width,
      ),
    );
    Widget content = img;
    final br = borderRadius;
    if (br != null) content = ClipRRect(borderRadius: br, child: img);
    if (heroTag != null) return Hero(tag: heroTag!, child: content);
    return content;
  }
}

/// =======================================================
/// Entry – use this when Cubit already exists up the tree
/// =======================================================
class Twitter11Hosted extends StatelessWidget {
  const Twitter11Hosted({super.key});
  @override
  Widget build(BuildContext context) {
    return const _TwitterScaffold();
  }
}

/// =======================================================
/// Entry – screen creates the Cubit itself (via DI)
/// =======================================================
class Twitter11 extends StatelessWidget {
  const Twitter11({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator<TwitterCubit>(),
      child: const _TwitterScaffold(),
    );
  }
}

/// =======================================================
/// Scaffold (no tabs) – picks feed by login status
/// =======================================================
class _TwitterScaffold extends StatefulWidget {
  const _TwitterScaffold();
  @override
  State<_TwitterScaffold> createState() => _TwitterScaffoldState();
}

class _TwitterScaffoldState extends State<_TwitterScaffold> {
  @override
  void initState() {
    super.initState();
    // trigger loading after first build to ensure providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<TwitterCubit>();
      final isLoggedIn = context.read<UserCubit>().isLoggedIn;
      if (isLoggedIn) {
        cubit.loadData();        // personalized
      } else {
        cubit.loadGlobalData();  // public/global
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwitterCubit>();
    final bool isLoggedIn = context.watch<UserCubit>().isLoggedIn;

    final PagingController<int, TwitterPostEntity> controller = isLoggedIn
        ? cubit.postsPagingController
        : cubit.globalPostsPagingController;

    Future<void> _onRefresh() async {
      if (isLoggedIn) {
        cubit.onRefresh();
      } else {
        cubit.onGlobalRefresh();
      }
      // give the refresh indicator time to stop gracefully
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const BuildTwitterDocumentCard(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: _PagedFeed(
                      controller: controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              bottom: 10,
              end: 10,
              child: CustomElevatedButton(
                onPressed: () {
                  ManageVibration.vibrate();
                  if (context.read<UserCubit>().isLoggedIn) {
                    context.push(Routes.CREATEPOST, extra: 'twitter');
                  } else {
                    pleaseLoginDialog(context);
                  }
                },
                backgoundColor: AppColors.getButtonPrimaryColor(context),
                child: Text(
                  LocaleKeys.createPost.localize,
                  style: Styles.smallText(
                    color: AppColors.getReversedTextColor(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// Paged feed (uses provided controller, no nested providers)
/// =======================================================
class _PagedFeed extends StatelessWidget {
  final PagingController<int, TwitterPostEntity> controller;
  final ScrollPhysics? physics;
  const _PagedFeed({required this.controller, this.physics});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwitterCubit>();
    final shareSuccess =
    context.select<TwitterCubit, bool?>((c) => c.state.shareSuccess);

    return BlocListener<TwitterCubit, TwitterState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(state.failure ?? UnknownFailure(''), context),
          );
        }
      },
      child: PagedListView<int, TwitterPostEntity>(
        pagingController: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
          firstPageProgressIndicatorBuilder: (_) => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CustomLoading()),
          ),
          newPageProgressIndicatorBuilder: (_) => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CustomLoading()),
          ),
          firstPageErrorIndicatorBuilder: (_) =>
          const Center(child: Text('Failed to load feed')),
          newPageErrorIndicatorBuilder: (_) =>
          const Center(child: Text('Failed to load more')),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Text(LocaleKeys.noPosts.localize, style: Styles.mediumText()),
          ),
          itemBuilder: (context, post, index) {
            final user = context.read<UserCubit>().state.data;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TwitterPostDetails(post: post, postId: post.id),
                  ),
                );
              },
              child: TwitterPostCard(
                post: post,
                shareSuccess: shareSuccess,
                onReact: () async {
                  final ok = await cubit.onReact(
                    params:
                    TwitterPostReactParams(postId: post.id, react: 'love'),
                  );
                  if (ok == true) {
                    // optimistic toggle for smoother UX
                    final list = controller.itemList;
                    if (list != null && index < list.length) {
                      final p = list[index];
                      p.isReact = !(p.isReact ?? false);
                      final loved = (p.isReact ?? false);
                      final current = p.loveCount ?? 0;
                      p.loveCount = loved ? current + 1 : (current > 0 ? current - 1 : 0);
                      controller.notifyListeners();
                    }
                  }
                },
                onShare: () {
                  final idToShare =
                  (post.isShared == true && post.mainPost != null)
                      ? post.mainPost!.id
                      : post.id;
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
                        ..loadComments(context, post.id),
                      child: TwitterPostComments(
                        comments: const [],
                        postId: post.id,
                        user: user,
                        onAddComment: (TwitterPostCommentParams params) =>
                            cubit.onPostComment(params: params),
                        onAddReply: (TwitterCommentReplyParams params) async =>
                            cubit.onCommentReply(params: params),
                        onCommentReact: (TwitterCommentReactParams params) =>
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
                        onDeleteComment: (id) async => cubit.deleteComment(
                          context: context,
                          commentId: id,
                          postId: post.id,
                          from: 'posts',
                        ),
                      ),
                    ),
                  );
                },
                getPost: () {},
                onReport: (TwitterReportParams params) => cubit.onReport(params),
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
                onEditComment: (params) async => cubit.editComment(params: params),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// =======================================================
/// Post Card – uses the entity given by the feed
/// =======================================================
class TwitterPostCard extends StatefulWidget {
  bool isLiked;
  bool? fromProfile;
  final TwitterPostEntity post;

  final Function onReact;
  final Function getPost;
  final Function onShare;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final Function(String) showPostComments;
  final Function(String) onDeleteComment;
  final Function(TwitterPostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;
  bool? shareSuccess;

  TwitterPostCard({
    super.key,
    this.isLiked = false,
    this.shareSuccess = false,
    this.fromProfile = false,
    required this.post,
    required this.onReact,
    required this.showPostComments,
    required this.onShare,
    required this.getPost,
    required this.onReport,
    required this.deletePost,
    required this.hidePost,
    required this.onDeleteComment,
    required this.onEditComment,
  });

  @override
  State<TwitterPostCard> createState() => _TwitterPostCardState();
}

class _TwitterPostCardState extends State<TwitterPostCard> {
  bool get canInteract => true;

  void _openGallery(int startIdx, List<String> imgs) {
    if (imgs.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GalleryViewer(images: imgs, initialIndex: startIdx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isShared = post.isShared ?? false;
    final TwitterPostEntity show =
    (isShared && post.mainPost is TwitterPostEntity)
        ? post.mainPost as TwitterPostEntity
        : post;

    final createdAt = show.createdAt;
    final since = DateFormat('d MMM').format(createdAt);

    final images = (show.images ?? const [])
        .where((e) => e.toString().trim().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: EdgeInsets.all(isShared ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isShared) _accountRow(post, since, sharedHeader: true),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: isShared ? Border.all(color: Colors.grey.shade300) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _accountRow(show, since),
                const SizedBox(height: 8),
                _content(show, images),
                const SizedBox(height: 6),
                if (!isShared) _stats(show),
              ],
            ),
          ),
          if (isShared) _stats(post),
        ],
      ),
    );
  }

  Widget _accountRow(TwitterPostEntity entity, String date,
      {bool sharedHeader = false}) {
    final u = entity.user;
    String handle = '';
    String displayName = '';
    String? avatar;

    try {
      if (u is TwitterUserModel) {
        handle = u.handle;
        displayName = '${u.firstName ?? ''} ${u.lastName ?? ''}'.trim();
        avatar = u.avatarUrl;
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
        final imageUrl = (u['image'] ?? '').toString();
        if (imageUrl.isNotEmpty) {
          avatar = imageUrl;
        } else {
          final up = (u['USER_PROFILE'] ?? {}) as Map?;
          final ppk = (up?['profilePictureKey'] ?? {}) as Map?;
          final mediaKey = (ppk?['mediaKey'] ?? '').toString();
          if (mediaKey.isNotEmpty) {
            avatar = mediaKey.startsWith('http')
                ? mediaKey
                : 'https://d3j5umpuujp1ej.cloudfront.net/$mediaKey';
          }
        }
      }
    } catch (_) {}

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>   TwitterPersonalProfile(isPersonal: true),
              ),
            );
          },
          child: ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: (avatar ?? '').isEmpty
                  ? Image.asset(Assets.addImage, fit: BoxFit.cover)
                  : Image.network(
                avatar!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.asset(Assets.addImage, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const []),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      displayName.isNotEmpty ? displayName : handle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if ((u is TwitterUserModel && (u.isDocumented ?? false)) ||
                      (u is Map && (u['twitter_documentation'] == true)))
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                ],
              ),
              if (handle.isNotEmpty)
                Text('@$handle', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(date, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 5),
        const Icon(Icons.more_vert, color: Colors.grey, size: 18),
      ],
    );
  }

  Widget _content(TwitterPostEntity show, List<String> images) {
    final text = show.content ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text.trim().isNotEmpty) ...[
          Text(text, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
        ],
        if (images.isNotEmpty)
          _PostImageGrid(
            images: images,
            onTap: (i) => _openGallery(i, images),
          ),
      ],
    );
  }

  Widget _stats(TwitterPostEntity t) {
    final replies = (t.commentsCount ?? 0);
    final shares = (t.sharesCount ?? 0);
    final likes = (t.loveCount ?? t.love?.length ?? 0);
    final isReact = t.isReact ?? false;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              icon: Icons.mode_comment_outlined,
              label: '$replies',
              onTap: () {
                if (!canInteract) return;
                widget.showPostComments(t.id);
              },
            ),
          ),
          Expanded(
            child: _statItem(
              icon: isReact ? Icons.favorite : Icons.favorite_outline,
              iconColor: isReact ? Colors.red : Colors.grey,
              label: '$likes',
              onTap: () {
                if (!canInteract) return;
                widget.onReact();
              },
            ),
          ),
          Expanded(
            child: _statItem(
              icon: FontAwesomeIcons.retweet,
              label: '$shares',
              onTap: () {
                if (!canInteract) return;
                widget.onShare();
              },
            ),
          ),
          Expanded(
            child: _statItem(
              icon: Icons.share_outlined,
              label: '',
              onTap: () {
                if (!canInteract) return;
                widget.onShare();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String label,
    Color? iconColor,
    required VoidCallback onTap,
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
}

/// =======================================================
/// Image grid (+N overlay for 5+)
/// =======================================================
class _PostImageGrid extends StatelessWidget {
  final List<String> images;
  final void Function(int index) onTap;
  final double gap;
  final double twoHeight;

  const _PostImageGrid({
    required this.images,
    required this.onTap,
    this.gap = 4,
    this.twoHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return GestureDetector(
        onTap: () => onTap(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(Assets.twitterAppBarIcon),
          ),
        ),
      );
    }

    if (images.length == 2) {
      return Row(
        children: images.asMap().entries.map((e) {
          final i = e.key, url = e.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(gap / 2),
              child: GestureDetector(
                onTap: () => onTap(i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    url,
                    height: twoHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(Assets.twitterAppBarIcon),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    final showPlus = images.length >= 5;
    final count = showPlus ? 4 : images.length.clamp(0, 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (_, index) {
        final url = images[index];
        final isLast = showPlus && index == 3;
        final remain = images.length - 4;

        if (!isLast) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.asset(Assets.twitterAppBarIcon),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => onTap(index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset(Assets.twitterAppBarIcon),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Center(
                child: Text(
                  '+$remain',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/// =======================================================
/// Full-screen gallery
/// =======================================================
class GalleryViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const GalleryViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPage(String url, int index) {
    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4.0,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(Assets.twitterAppBarIcon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('${_current + 1} / $total'),
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _current = i),
        itemCount: widget.images.length,
        itemBuilder: (_, i) => _buildPage(widget.images[i], i),
      ),
    );
  }
}
