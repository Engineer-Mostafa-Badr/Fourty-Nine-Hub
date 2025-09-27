import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_personal_profile.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../../core/error/failure.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/messages/messages.dart';
import '../../../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../service_locator/service_locator.dart';
import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../custom_page/presentation/page/widget/edit_page.dart';
import '../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../data/models/profile_model.dart';
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
import '../../../widgets/post_meta_panal.dart';
import '../../../widgets/report_view.dart';
import '../../../widgets/twitter_post_comments.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

 class Twitter11Hosted extends StatelessWidget {
  const Twitter11Hosted({super.key});
  @override
  Widget build(BuildContext context) {
    return const _TwitterScaffold();
  }
}

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

 class _TwitterScaffold extends StatefulWidget {
  const _TwitterScaffold();
  @override
  State<_TwitterScaffold> createState() => _TwitterScaffoldState();
}

class _TwitterScaffoldState extends State<_TwitterScaffold> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<TwitterCubit>();
      cubit.loadGlobalData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwitterCubit>();

    final PagingController<int, TwitterPostEntity> controller =
        cubit.globalPostsPagingController;

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
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => cubit.globalPostsPagingController.refresh(),
                child: CustomScrollView(
                  slivers: [
                     SliverToBoxAdapter(
                      child: const BuildTwitterDocumentCard(),
                    ),

                     const SliverToBoxAdapter(child: SizedBox(height: 8)),

                     PagedSliverList<int, TwitterPostEntity>(
                       shrinkWrapFirstPageIndicators: true,
                      pagingController: cubit.globalPostsPagingController,
                      builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
                         firstPageProgressIndicatorBuilder: (_) =>
                        const Center(child: CustomCircularProgressIndicator()),

                        newPageProgressIndicatorBuilder: (_) =>
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CustomCircularProgressIndicator()),
                        ),

                        noItemsFoundIndicatorBuilder: (_) => Padding(
                          padding: const EdgeInsets.only(top: 120),
                          child: Center(
                            child: Text(
                              LocaleKeys.noPosts.localize,
                              style: Styles.mediumText(),
                            ),
                          ),
                        ),

                         noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),

                        itemBuilder: (context, post, index) {
                          final user = context.read<UserCubit>().state.data;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TwitterPostDetails(postId: post.thread!.id),
                                ),
                              );
                            },
                            child: TwitterPostCard(
                              onRepost: () => cubit.onRepost(postId: post.id),
                              isDetailed: false,
                              post: post,
                              shareSuccess: shareSuccess,
                              onReact: () async {
                                final ok = await cubit.onReact(
                                  params: TwitterPostReactParams(postId: post.id, react: 'love'),
                                );
                                if (ok == true) {
                                  final list = cubit.globalPostsPagingController.itemList;
                                  if (list != null && index < list.length) {
                                    final p = list[index];
                                    final wasLiked = p.isLiked ?? false;
                                    p.isLiked = !wasLiked;
                                    final current = p.loveCount ?? 0;
                                    p.loveCount = wasLiked ? (current > 0 ? current - 1 : 0) : current + 1;
                                    cubit.globalPostsPagingController.notifyListeners();
                                  }
                                }
                              },
                              onShare: () {
                                final idToShare =
                                (post.isShared == true && post.mainPost != null) ? post.mainPost!.id : post.id;
                                cubit.onShare(postId: idToShare);
                                if (cubit.state.shareSuccess == true) {
                                  showSuccessMessage(
                                    context,
                                    LocaleKeys.postSharedSuccessfully.localize,
                                  );
                                }
                              },
                              showPostComments: (_) {
                                bottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  widget: BlocProvider<TwitterCubit>(
                                    create: (_) => serviceLocator<TwitterCubit>()..loadComments(context, post.id),
                                    child: TwitterPostComments(
                                      comments: const [],
                                      postId: post.id,
                                      user: user,
                                      onAddComment: (params) => cubit.onPostComment(params: params),
                                      onAddReply: (params) async => cubit.onCommentReply(params: params),
                                      onCommentReact: (params) => cubit.onCommentReact(params: params),
                                      onGetReplies: (id, c) async {},
                                      newCommentId: '',
                                      state: cubit.state,
                                      onReport: (params) => cubit.onReport(params),
                                      onEditComment: (params) async => cubit.editComment(params: params),
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
                              onReport: (params) => cubit.onReport(params),
                              deletePost: (id) => cubit.deletePost(context: context, postId: id),
                              hidePost: (id) => cubit.hidePost(context: context, postId: id),
                              onDeleteComment: (id) async => cubit.deleteComment(
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

                    // Optional bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              )
,              PositionedDirectional(
                bottom: 10,
                end: 10,
                child: CustomElevatedButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    if (context.read<UserCubit>().isLoggedIn) {
                      context.push(Routes.CREATEPOSTTWITTER, extra: 'twitter');
                    } else {
                     // return pleaseLoginDialog(context);

                       context.push(Routes.LOGIN);
                    }
                  },
                  backgoundColor: AppColors.getButtonPrimaryColor(context),
                  child: Text(
                    LocaleKeys.createPost.localize,
                    style: Styles.smallText(color: AppColors.getReversedTextColor(context)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 class TwitterPostCard extends StatefulWidget {
  bool isLiked;
  bool isDetailed;
  bool? fromProfile;
  final TwitterPostEntity post;
  final Future<bool> Function(String)? onDeleteAsync;

  final Function onReact;
  final Function getPost;
  final Function onShare;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final Function(String) showPostComments;
  final Function(String) onDeleteComment;
  final Function(TwitterPostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;
  final Function onRepost;

  bool? shareSuccess;

  TwitterPostCard({
    super.key,
    this.isLiked = false,
    this.shareSuccess = false,
    this.fromProfile = false,
    required this.post,
    this.onDeleteAsync,

    required this.onReact,
    required this.showPostComments,
    required this.onShare,
    required this.getPost,
    required this.onReport,
    required this.deletePost,
    required this.hidePost,
    required this.onDeleteComment,
    required this.onEditComment,
    required this.isDetailed,
    required this.onRepost,
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
  Future<void> _optimisticDelete(TwitterPostEntity entity) async {
    final cubit = context.read<TwitterCubit>();
    final controller = cubit.globalPostsPagingController;

    final list = controller.itemList;
    if (list == null) return;

    final index = list.indexWhere((e) => e.id == entity.id);
    if (index < 0) return;

    // Keep a copy for rollback
    final removed = list.removeAt(index);
    controller.notifyListeners();

    bool ok = true;
    try {
      if (widget.onDeleteAsync != null) {
        ok = await widget.onDeleteAsync!(entity.id);
      } else {
        // Fallback to existing void callback (no status) + assume success
        // If you want rollback on failure, wire onDeleteAsync from the parent.
        widget.deletePost(entity.id);
        ok = true;
      }
    } catch (_) {
      ok = false;
    }

    if (!ok) {
      // Roll back
      list.insert(index, removed);
      controller.notifyListeners();

      // Optional: toast/snackbar
      showErrorMessage(
        context,
        (context.mounted && context.isArabic)
            ? 'فشل حذف المنشور. تمت إعادة العرض.'
            : 'Failed to delete post. Restored.',
      );
    } else {
      // Optional: success toast
      showSuccessMessage(
        context,
        (context.mounted && context.isArabic)
            ? 'تم حذف المنشور بنجاح'
            : 'Post deleted successfully',
      );
    }
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
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6)
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: EdgeInsets.all(isShared ? 10 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isShared) _accountRow(post, since, sharedHeader: true),
          SizedBox(height: 8  ,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: isShared ? Border.all(color: Colors.grey.shade300) : null,
              borderRadius: BorderRadius.circular(12),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _accountRow(show, since),
                const SizedBox(height: 10),
                _content(show, images),
                const SizedBox(height: 6),
                if (!isShared) _stats(show),
              ],
            ),
          ),
          if (isShared) _stats(post),

            const SizedBox(height: 8),
            widget.isDetailed
               ? PostMetaPanel(
             createdAt: show.createdAt,
             views: show.comments.length,
             retweets: (show.love?.length ?? 0).toInt(),
             quotes: 10,
             likes: (show.loveCount ?? 0).toInt(),
             bookmarks: (show.comments.length).toInt(),
             isArabic: Directionality.of(context) == TextDirection.RTL,
           )
               : Container(),
          ],

      ),
    );
  }

  bool isVerified(dynamic u) {
    if (u is TwitterUserModel) return u.isDocumented ?? false;
    if (u is Map) {
      return u['twitter_documentation'] == true ||
          u['isAccountVerified'] == true;
    }
    return false;
  }
  TwitterProfileEntity _profileFromAnyUser(dynamic u) {
    String id = '';
    String first = '';
    String last  = '';
    String userName = '';
    String? avatar;
    String? cover;
    bool isVerified = false;
    DateTime joinedAt = DateTime.now();

    String? gender;
    int? profileViews;

    try {
      if (u is TwitterUserModel) {
        id        = (u.id ?? '').toString();
        first     = u.firstName ?? '';
        last      = u.lastName ?? '';
        userName  = (u.handle).toString();
        avatar    = u.image ?? u.avatarUrl;
        cover     = u.image;
        isVerified = (u.isDocumented ?? false);
        joinedAt  = u.createdAt ?? DateTime.now();
        gender    = u.gender;
        profileViews = u.profileViews;
      } else if (u is Map) {
         final src = (u['originalPost']?['owner'] is Map)
            ? u['originalPost']['owner'] as Map
            : (u['owner'] is Map ? u['owner'] as Map : u);

        id       = (src['_id'] ?? src['id'] ?? '').toString();
        first    = (src['firstName'] ?? '').toString();
        last     = (src['lastName'] ?? '').toString();

        final un = (src['userName'] ?? src['username'] ?? '').toString();
        if (un.isNotEmpty) {
          userName = un;
        } else {
          final email = (src['email'] ?? '').toString();
          userName = email.contains('@') ? email.split('@').first : id;
        }

        avatar = (src['image'] ?? src['profilePictureUrl'] ?? '').toString();
        cover  = (src['coverUrl'] ?? src['coverImage'] ?? '').toString();

        isVerified = (src['twitter_documentation'] == true) ||
            (src['isAccountVerified'] == true) ||
            (src['verifiedBadge'] == true);

        final createdRaw = (src['joinedAt'] ?? src['createdAt'] ?? '').toString();
        final parsed = DateTime.tryParse(createdRaw);
        if (parsed != null) joinedAt = parsed;

        gender = (src['gender'] ?? '').toString().trim().isEmpty
            ? null
            : src['gender'].toString();

        final pv = src['profileViews'];
        if (pv is int) profileViews = pv;
        else if (pv is String) profileViews = int.tryParse(pv);
        else if (pv is num) profileViews = pv.toInt();
      }
    } catch (e, st) {
      debugPrint('⚠️ _profileFromAnyUser error: $e\n$st');
    }

    return TwitterProfileEntity(
      id: id,
      firstName: first,
      lastName: last,
      userName: userName,
      bio: null,
      avatarUrl: avatar,
      coverUrl: cover,
      joinedAt: joinedAt,
      isVerified: isVerified,
      isMe: false,
      isFollowing: false,
      followersCount: 0,
      followingCount: 0,
      gender: gender,
      profileViews: profileViews,
    );
  }

  Widget _accountRow(TwitterPostEntity entity, String date, {bool sharedHeader = false}) {
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
        final last  = (u['lastName'] ?? '').toString();
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
      }
    } catch (_) {}

    // ✅ safe fallbacks
    final safeAvatar = (avatar ?? '').trim();
    final baseForLetter = displayName.isNotEmpty
        ? displayName
        : (handle.isNotEmpty ? handle : '?');
    final String firstChar =
    baseForLetter.trim().isNotEmpty ? baseForLetter.trim()[0].toUpperCase() : '?';

    // If you want to auto-mark svg:
    final bool isSvg = safeAvatar.toLowerCase().endsWith('.svg');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 👇 use your widget here (no null-asserts)
        ClipOval(
          child: SizedBox(
            width: 40,
            height: 40,
            child: ImageFromInternet(
              image: safeAvatar.isEmpty ? 'about:blank' : safeAvatar, // invalid url triggers errorWidget
              width: 40,
              height: 40,
              isCircle: true,
              fit: BoxFit.cover,
              isSvg: isSvg,
              // If the image fails, your widget shows gender icon + a small circle with this char
              // (you can set isMale based on your user object if needed)
              isMale: true,
              firstChar: firstChar,
              charPadding: 5,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  displayName.isNotEmpty ? displayName : handle,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 6),
                if (isVerified(u)) const Icon(Icons.verified, color: Colors.blue, size: 16),
              ],
            ),
            if (handle.isNotEmpty)
              const SizedBox(height: 2),
            if (handle.isNotEmpty)
              Text('@$handle', style: const TextStyle(color: Colors.grey)),
          ],
        ),

        const Spacer(),

        IconAppButton(
          icon: Icons.more_vert,
          size: 40.w,
          onPressed: () {
            ManageVibration.vibrate();
            _showPostOptions(context, entity);
          },
        ),
      ],
    );
  }



  bool _isMine(TwitterPostEntity entity) {
    String log(String msg) {
      if (kDebugMode) debugPrint('[isMine] $msg');
      return msg;
    }

    try {
      final me = context.read<UserCubit>().state.data;
      final myId = (me?.id ?? '').toString().trim();
      log('--- CHECK START ---');
      log('myId="$myId"  isShared=${entity.isShared}  post.id=${entity.id}');

      if (myId.isEmpty) {
        log('⛔ myId empty -> return false');
        return false;
      }

      String? pickId(Map m, {String label = 'map'}) {
        final candidates = ['userId', '_id', 'id'];
        for (final k in candidates) {
          final v = m[k];
          if (v != null && v.toString().trim().isNotEmpty) {
            log('✔ pickId($label): found key "$k" -> ${v.toString().trim()}');
            return v.toString().trim();
          }
        }
        log('✖ pickId($label): no id key found in ${m.keys}');
        return null;
      }

      String? idFromDynamicUser(dynamic u, {String label = 'user'}) {
        if (u == null) {
          log('idFromDynamicUser($label): null');
          return null;
        }

        if (u is TwitterUserModel) {
          final v = (u.id ?? '').toString().trim();
          log('idFromDynamicUser($label): TwitterUserModel id="$v"');
          return v.isNotEmpty ? v : null;
        }

        if (u is Map) {
          log('idFromDynamicUser($label): Map keys=${u.keys}');
          // 1) direct
          final direct = pickId(u, label: '$label.direct');
          if (direct != null) return direct;

          // 2) owner
          final owner = u['owner'];
          if (owner is Map) {
            log('idFromDynamicUser($label): has owner Map');
            final v = pickId(owner, label: '$label.owner');
            if (v != null) return v;
          }

          // 3) originalPost.owner
          final originalPost = u['originalPost'];
          if (originalPost is Map) {
            log('idFromDynamicUser($label): has originalPost Map');
            final o = originalPost['owner'];
            if (o is Map) {
              final v = pickId(o, label: '$label.originalPost.owner');
              if (v != null) return v;
            } else {
              log('idFromDynamicUser($label): originalPost.owner not Map ($o)');
            }
          }
        } else {
          log('idFromDynamicUser($label): unsupported type ${u.runtimeType}');
        }
        return null;
      }

      // 1) if shared, prefer main/original post owner
      if (entity.isShared == true) {
        log('Shared post detected -> checking mainPost');
        if (entity.mainPost is TwitterPostEntity) {
          final mp = entity.mainPost as TwitterPostEntity;
          final id = idFromDynamicUser(mp.user, label: 'mainPost.user');
          log('mainPost.user ownerId="$id" vs myId="$myId"');
          if (id != null) {
            final eq = id == myId;
            log(eq ? '✅ MATCH (mainPost.user)' : '❌ NOT MATCH (mainPost.user)');
            return eq;
          }
        } else if (entity.mainPost is Map) {
          final mp = entity.mainPost as Map;
          log('mainPost is Map, keys=${mp.keys}');
          final id = idFromDynamicUser(mp['user'] ?? mp['owner'] ?? mp, label: 'mainPost.map');
          log('mainPost.map ownerId="$id" vs myId="$myId"');
          if (id != null) {
            final eq = id == myId;
            log(eq ? '✅ MATCH (mainPost.map)' : '❌ NOT MATCH (mainPost.map)');
            return eq;
          }
        } else {
          log('mainPost type=${entity.mainPost.runtimeType}');
        }
      }

      // 2) fallback to this post's user/owner
      final id = idFromDynamicUser(entity.user, label: 'entity.user');
      log('entity.user ownerId="$id" vs myId="$myId"');
      if (id != null) {
        final eq = id == myId;
        log(eq ? '✅ MATCH (entity.user)' : '❌ NOT MATCH (entity.user)');
        return eq;
      }

      // 3) last resort: try loose "owner" on the entity (if any dynamic backing)
      try {
        final dyn = entity as dynamic;
        final owner = dyn.owner;
        if (owner is Map) {
          final v = pickId(owner, label: 'entity.owner');
          log('entity.owner ownerId="$v" vs myId="$myId"');
          if (v != null) {
            final eq = v == myId;
            log(eq ? '✅ MATCH (entity.owner)' : '❌ NOT MATCH (entity.owner)');
            return eq;
          }
        } else {
          log('entity.owner not Map (${owner.runtimeType})');
        }
      } catch (e) {
        log('entity.owner access failed: $e');
      }

      log('➡️ result: false (no owner matched)');
      return false;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[isMine] EXCEPTION: $e');
        debugPrint('[isMine] STACK    : $st');
      }
      return false;
    } finally {
      if (kDebugMode) debugPrint('[isMine] --- CHECK END ---');
    }
  }

  void _showPostOptions(BuildContext context, TwitterPostEntity entity) async {
    final isMine = _isMine(entity);
print("///////////////////////////");
print(isMine);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bool isArabic = context.isArabic;

        return SafeArea(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hide
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(isArabic ? 'إخفاء المنشور' : 'Hide post'),
              onTap: () {
                Navigator.pop(ctx);
                ManageVibration.vibrate();

                widget.hidePost(entity.id);
              },
            ),

            // Delete (only for owner)
            if (isMine)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  isArabic ? 'حذف المنشور' : 'Delete post',
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  ManageVibration.vibrate();
                  Navigator.pop(ctx);

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      title: Text(isArabic ? 'هل تريد حذف المنشور؟' : 'Delete post?'),
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
                    await _optimisticDelete(entity);
                  }
                },
              ),

            // Report
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(isArabic ? 'الإبلاغ' : 'Report'),
              onTap: () {
                ManageVibration.vibrate();

                Navigator.pop(ctx);
                bottomSheet(
                    context: context,
                    widget: ReportView(
                      id: entity.mainPost.id,
                      categoryId: "66a3583454e6e337915514db",
                    ));

               },
            ),
          ],
        )
        );
      },
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

  String toArabicDigitsInt(int n) {
    const eastern = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final code = s.codeUnitAt(i);
      if (code >= 48 && code <= 57) { // '0'..'9'
        b.write(eastern[code - 48]);
      } else {
        b.writeCharCode(code);
      }
    }
    return b.toString();
  }
  Widget _stats(TwitterPostEntity t) {
    final replies = (t.commentsCount ?? 0).toInt();
    final reposts = (t.repostCount ?? 0).toInt();
    final likes   = ((t.loveCount ?? t.love?.length ?? 0) as num).toInt();
    final shares  = (t.sharesCount ?? 0).toInt();

    final isReact = t.isLiked ?? false;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              icon: Icons.mode_comment_outlined,
              label: toArabicDigitsInt(replies),     // <<<<<< HERE
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
              label: toArabicDigitsInt(likes),       // <<<<<< HERE
              onTap: () {
                if (!canInteract) return;
                widget.onReact();
              },
            ),
          ),
          Expanded(
            child: _statItem(
              icon: FontAwesomeIcons.retweet,
              iconColor: t.yourReposted == true ? AppColors.PRIMARY_COLOR : Colors.grey,
              label: toArabicDigitsInt(reposts),     // <<<<<< HERE
              onTap: () {
                if (!canInteract) return;
                widget.onRepost();
              },
            ),
          ),
          Expanded(
            child: _statItem(
              icon: Icons.share_outlined,
              label: toArabicDigitsInt(shares),      // <<<<<< HERE
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
          Text(label, style:   TextStyle(color:iconColor ?? Colors.grey)),
        ],
      ),
    );
  }
}

  class _PostImageGrid extends StatelessWidget {
  const _PostImageGrid({
    required this.images,
    required this.onTap,
  });

  final List<String> images;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

     if (images.length == 1) {
      return _ImageTile(
        url: images.first,
        borderRadius: BorderRadius.circular(10),
        fit: BoxFit.cover,
        onTap: () => onTap(0),
        aspectRatio: 16 / 9,
      );
    }

     final count = images.length.clamp(2, 4);
    return GridView.builder(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        return _ImageTile(
          url: images[i],
          borderRadius: BorderRadius.circular(10),
          fit: BoxFit.cover,
          onTap: () => onTap(i),
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.url,
    this.onTap,
    this.borderRadius,
    this.fit,
    this.aspectRatio,
  });

  final String url;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: aspectRatio != null
          ? AspectRatio(
              aspectRatio: aspectRatio!,
              child: _netImage(url, fit: fit ?? BoxFit.cover),
            )
          : _netImage(url, fit: fit ?? BoxFit.cover),
    );

    if (onTap == null) return child;
    return InkWell(onTap: onTap, child: child);
  }

  Widget _netImage(String url, {BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      fit: fit,
       loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(color: Color(0x11000000));
      },
       errorBuilder: (ctx, error, stack) {
        return Container();
      },
    );
  }
}

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

// create_thread_result.dart
class CreateThreadResult {
  final bool status;
  final String message;
  final String? threadId;
  final String? postId;
  final Map<String, dynamic>? postJson; // optional

  const CreateThreadResult({
    required this.status,
    required this.message,
    this.threadId,
    this.postId,
    this.postJson,
  });

  factory CreateThreadResult.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>();
    // Handle several common shapes
    String? _readId(dynamic v) => v?.toString();

    return CreateThreadResult(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
      threadId: _readId(data?['threadId'] ?? data?['thread']?['id'] ?? json['threadId']),
      postId: _readId(data?['postId'] ?? data?['post']?['id'] ?? json['postId']),
      postJson: (data?['post'] is Map) ? (data!['post'] as Map).cast<String, dynamic>() : null,
    );
  }
}
