import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../domain/entities/twitter_post_entity.dart';
import '../../../../domain/usecases/post_react_usecase.dart';
import '../../../bloc/twitter_bloc.dart';

class TwitterPersonalProfile extends StatefulWidget {
  final TwitterProfileEntity? initialProfile;

  const TwitterPersonalProfile({super.key, this.initialProfile});

  static const String kSubCategoryId = '66a3583454e6e337915514db';

  @override
  State<TwitterPersonalProfile> createState() => _TwitterPersonalProfileState();
}

class _TwitterPersonalProfileState extends State<TwitterPersonalProfile> {
  late final TwitterCubit cubit;

  String? _viewUserId;
  bool _viewingMe = false;
  PagingController<int, TwitterPostEntity>? _activeController;
  bool _wiredPaging = false;

  @override
  void initState() {
    super.initState();
    cubit = context.read<TwitterCubit>();

    // Light status bar over the cover
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final me = context.read<UserCubit>().state.data;
      final myId = me?.id ?? '';

      if (widget.initialProfile != null) {
        // Viewing a specific user
        _viewUserId = widget.initialProfile!.id;
        _viewingMe = (_viewUserId == myId);

        // Show snapshot immediately
        cubit.bootstrapProfile(widget.initialProfile!);

        // Fetch counts in background
        cubit.loadCountsForUser(
          userId: _viewUserId!,
          subCategoryId: TwitterPersonalProfile.kSubCategoryId,
        );
      } else {
        // Viewing myself
        _viewUserId = myId;
        _viewingMe = true;

        // Compose from UserCubit + fetch counts
        cubit.loadMyProfileFromUserCubit(
          context,
          subCategoryId: TwitterPersonalProfile.kSubCategoryId,
        );
      }

      // Freeze the controller ONCE
      _activeController = _viewingMe
          ? cubit.postsPagingController
          : cubit.userTweetsPagingController;

      _wirePagingIfNeeded();

      setState(() {});
    });
  }

  void _wirePagingIfNeeded() {
    if (_wiredPaging || _activeController == null) return;
    _wiredPaging = true;

    if (_viewingMe) {
      // ربط الكنترولر مع تحميل البوستات
      _activeController!.addPageRequestListener(cubit.loadMyPosts);
      // تحميل الصفحة الأولى يدوي
      cubit.loadMyPosts(1);
    } else {
      final uid = _viewUserId ?? '';
      if (uid.isNotEmpty) {
        _activeController!.addPageRequestListener((page) {
          cubit.loadUserPostsPage(uid, page);
        });
        // تحميل الصفحة الأولى يدوي
        cubit.loadUserPostsPage(uid, 1);
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    if (_activeController == null) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    return BlocBuilder<TwitterCubit, TwitterState>(
      builder: (context, state) {
        final headerProfile =
            state.profile ?? widget.initialProfile ?? _fallbackFromUserCubit(context);

        if (headerProfile == null) {
          return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
        }

        final bool countsReady =
            state.followersCount != null && state.followingCount != null;

        final controller = _activeController!;

        // 👇 Debug prints عشان نتاكد ان الكنترولر فيه بيانات
        debugPrint("📌 Controller items length: ${controller.itemList?.length}");
        if (controller.itemList != null) {
          for (var i = 0; i < controller.itemList!.length; i++) {
            debugPrint("   ▶ Post[$i] = ${controller.itemList![i].content}");
          }
        }

        return Scaffold(
          body: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(
                        coverUrl: headerProfile.coverUrl,
                        avatarUrl: headerProfile.avatarUrl,
                        isPersonal: _viewingMe,

                      ),
                      _UserInfo(
                        displayName: _composeDisplayName(context, headerProfile),
                        handle: '@${headerProfile.userName}',
                        isVerified: headerProfile.isVerified == true,
                        isPersonal: _viewingMe,
                         gender: widget.initialProfile!.gender,                 // String?  (e.g. "male"/"female")
                        profileViews: widget.initialProfile!.profileViews,     // int?
                        joinedAt: headerProfile.joinedAt,             // DateTime?
                      ),

                    //  if (!_viewingMe) const _CustomFollowRow(),
                      if (countsReady)
/*
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                '${state.followingCount} ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                LocaleKeys.following.localize,
                                style: const TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${state.followersCount} ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                LocaleKeys.followers.localize,
                                style: const TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
*/
                      const Divider(height: 1),
                      const _PostsSectionTitle(),
                    ],
                  ),
                ),

                if ((controller.itemList?.isEmpty ?? true) &&
                    controller.value.status == PagingStatus.loadingFirstPage)
                  const SliverToBoxAdapter(child: _CenteredLoader()),

                // 👇 هنا هنعرض البوستات
                PagedSliverList<int, TwitterPostEntity>(
                  pagingController: controller,
                  builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
                    firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                    newPageProgressIndicatorBuilder: (_) => const _CenteredLoader(),
                    noItemsFoundIndicatorBuilder: (_) =>
                        _NoItems(text: LocaleKeys.noPosts.localize),
                    noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                    firstPageErrorIndicatorBuilder: (_) =>
                        _NoItems(text: LocaleKeys.noPosts.localize),
                    itemBuilder: (context, post, index) {
                      debugPrint("🎯 Rendering Post[$index]: ${post.content}");
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: TwitterPostCard(
                          onRepost: () => cubit.onRepost(postId: post.id),   // 👈 Repost هنا

                          isDetailed: false,
                          post: post,
                          onReact: () async {
                            final ok = await cubit.onReact(
                              params: TwitterPostReactParams(
                                postId: post.id,
                                react: 'love',
                              ),
                            );
                            if (ok) {
                              final list = controller.itemList;
                              if (list != null && index < list.length) {
                                final p = list[index];
                                final wasLiked = p.isLiked ?? false;
                                p.isLiked = !wasLiked;
                                final cur = p.loveCount ?? 0;
                                p.loveCount =
                                wasLiked ? (cur > 0 ? cur - 1 : 0) : cur + 1;
                                controller.notifyListeners();
                              }
                            }
                          },
                          showPostComments: (_) {},
                          getPost: () {},
                          onReport: (params) => cubit.onReport(params),
                          deletePost: (id) =>
                              cubit.deletePost(context: context, postId: id),
                          hidePost: (id) =>
                              cubit.hidePost(context: context, postId: id),
                          onDeleteComment: (id) {},
                          onEditComment: (params) async =>
                              cubit.editComment(params: params),
                          onShare: () {}, // share removed
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }

  TwitterProfileEntity? _fallbackFromUserCubit(BuildContext context) {
    final u = context.read<UserCubit>().state.data;
    if (u == null) return null;
    return TwitterProfileEntity(
      id: u.id ?? '',
      firstName: u.firstName ?? '',
      lastName: u.lastName ?? '',
      userName: (u.username ?? u.email?.split('@').first ?? '').toString(),
      bio: u.bio,
      avatarUrl: u.profilePicture,
      coverUrl: u.profileCover,
      joinedAt: u.birthday ?? DateTime.now(), // or u.joinedAt if available
      isVerified: (u.isDocument == true) || (u.isAccountVerified == true),
      isMe: true,
      isFollowing: false,
      followersCount: 0,
      followingCount: 0,
      // NEW (null-safe; set if UserCubit exposes them)
      gender: u.gender,                 // String?
      profileViews: u.friendsCount,     // int?
    );
  }

  String _composeDisplayName(BuildContext context, TwitterProfileEntity p) {
    final name = '${p.firstName} ${p.lastName}'.trim();
    if (name.isNotEmpty) return name;

    final u = context.read<UserCubit>().state.data;
    final fn = u?.firstName ?? '';
    final ln = u?.lastName ?? '';
    return '$fn $ln'.trim();
  }
}

// ---------- UI bits ----------

class _Header extends StatelessWidget {
  const _Header({
    required this.coverUrl,
    required this.isPersonal,

    required this.avatarUrl});
  final String? coverUrl;
  final String? avatarUrl;
  final bool isPersonal;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.25;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: h,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (coverUrl?.isNotEmpty == true)
                  ? NetworkImage(coverUrl!)
                  : const NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUPIfiGgUML8G3ZqsNLHfaCnZK3I5g4tJabQ&s'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: h - 40,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 38,
              backgroundImage: (avatarUrl?.isNotEmpty == true)
                  ? NetworkImage(avatarUrl!)
                  : const NetworkImage('https://picsum.photos/200'),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 45,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black45,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
       isPersonal? Positioned(
          right: 16,
          top: 45,
          child:
          OutlinedButton(
            onPressed: () {
              Vibration.vibrate();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
               backgroundColor: Colors.black38
            ),
            child: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تعديل الملف'
                  : 'Edit Profile',
              style:  TextStyle(color: Colors.white),
            ),
          ),
        ):Container(),

      ],
    );
  }
}


class _UserInfo extends StatelessWidget {
  const _UserInfo({
    required this.displayName,
    required this.handle,
    required this.isVerified,
    required this.isPersonal,
    this.gender,
    this.profileViews,
    this.joinedAt,
  });

  final String displayName;
  final String handle;
  final bool isVerified;
  final bool isPersonal;

  // NEW
  final String? gender;        // "male" / "female" / etc
  final int? profileViews;     // e.g. 10
  final DateTime? joinedAt;    // actual join date

  String _formatJoined(BuildContext context, DateTime? dt) {
    if (dt == null) return '';
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final formatted = DateFormat('MMM yyyy').format(dt);
    return isAr ? 'انضم ${formatted}' : 'Joined $formatted';
  }

  IconData _genderIcon(String? g) {
    if (g == null) return Icons.person_outline;
    final s = g.toLowerCase();
    if (s == 'male') return Icons.male;
    if (s == 'female') return Icons.female;
    return Icons.person_outline;
  }

  String _genderText(BuildContext context, String? g) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (g == null) return isAr ? 'أخرى' : 'Other';

    final s = g.toLowerCase();
    if (s == 'male') return isAr ? 'ذكر' : 'Male';
    if (s == 'female') return isAr ? 'أنثى' : 'Female';

    return isAr ? 'أخرى' : 'Other';
  }

  String _viewsText(BuildContext context, int? views) {
    if (views == null || views < 0) return '';
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return isAr ? '$views مشاهدة' : '$views views';
  }

  Widget _chip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    margin: const EdgeInsets.only(right: 8, top: 6),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black87)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final joinedText = _formatJoined(context, joinedAt);
    final genderText = _genderText(context, gender);
    final viewsText = _viewsText(context, profileViews);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + verify + edit
          Row(
            children: [
              Flexible(
                child: Text(
                  displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              if (isVerified)
                const Icon(Icons.verified, color: Colors.blue, size: 18),
              const Spacer(),
             ],
          ),

          // @handle
          Text(handle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),

          // Chips row
          Wrap(
            children: [
              if (joinedText.isNotEmpty)
                _chip(Icons.calendar_month, joinedText),
              if ((gender ?? '').trim().isNotEmpty)
                _chip(_genderIcon(gender), genderText),
              if (viewsText.isNotEmpty)
                _chip(Icons.visibility_outlined, viewsText),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostsSectionTitle extends StatelessWidget {
  const _PostsSectionTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        LocaleKeys.posts.localize,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CustomFollowRow extends StatelessWidget {
  const _CustomFollowRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.black, Colors.red]),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_active_outlined,
                    color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(.7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              gradient: const LinearGradient(colors: [Colors.black, Colors.red]),
            ),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text('Following',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenteredLoader extends StatelessWidget {
  const _CenteredLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}

class _NoItems extends StatelessWidget {
  final String text;
  const _NoItems({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Text(text, style: Styles.mediumText())),
    );
  }
}
