import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_failure_widget.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../chat/chat_view/presentation/widgets/chat_stories.dart';
import '../cubit/posts_instagram_cubit/posts_instagram_cubit.dart';
import '../cubit/reel_instagram_cubit/reel_instagram_cubit.dart';
import '../cubit/suggest_follow_cubit/suggest_follow_cubit.dart';
import 'post_instagram_widget.dart';
import 'suggest_followers_section.dart';
import 'suggest_reels_instagram_section.dart';

class InstagramViewBody extends StatefulWidget {
  const InstagramViewBody({super.key});

  @override
  State<InstagramViewBody> createState() => _InstagramViewBodyState();
}

// مدير لكل مشغلات الفيديو في التطبيق
class VideoControllerManager {
  static final VideoControllerManager _instance =
      VideoControllerManager._internal();

  // تخزين مشغل الفيديو النشط حالياً
  VideoPlayerController? _activeController;

  // معرّف آخر مشغل فيديو ظاهر
  String? _lastVisibleVideoId;

  // نسبة الظهور المطلوبة لتشغيل الفيديو (50%)
  final double _visibilityThreshold = 0.5;

  // تخزين حالة مشغلات الفيديو وتفاصيل الرؤية
  final Map<String, _VideoState> _videoStates = {};

  factory VideoControllerManager() => _instance;

  VideoControllerManager._internal();

  // استخدامها عند التخلص من الصفحة
  void disposeAll() {
    _videoStates.forEach((_, state) {
      state.controller.dispose();
    });
    _videoStates.clear();
    _activeController = null;
    _lastVisibleVideoId = null;
  }

  // استخدامها عند الخروج من القائمة أو الصفحة
  void pauseAllVideos() {
    _videoStates.forEach((_, state) {
      if (state.controller.value.isPlaying) {
        state.controller.pause();
      }
    });
    _activeController = null;
    _lastVisibleVideoId = null;
  }

  // إضافة أو تحديث مشغل فيديو
  void registerController(String videoId, VideoPlayerController controller) {
    _videoStates[videoId] = _VideoState(controller: controller);
  }

  // وضع علامة على الفيديو بأنه تم إيقافه يدويًا
  void setPausedManually(String videoId, bool paused) {
    if (!_videoStates.containsKey(videoId)) return;
    _videoStates[videoId]!.pausedManually = paused;

    // إذا تم إلغاء الإيقاف اليدوي وكان الفيديو ظاهرًا بشكل كافٍ، قم بتشغيله
    if (!paused &&
        _videoStates[videoId]!.visibilityFraction >= _visibilityThreshold) {
      _lastVisibleVideoId = videoId;
      _playMostVisibleVideo();
    }
  }

  // إزالة مشغل فيديو
  void unregisterController(String videoId) {
    _videoStates.remove(videoId);
  }

  // تحديث نسبة ظهور الفيديو
  void updateVisibility(String videoId, double visibilityFraction) {
    if (!_videoStates.containsKey(videoId)) return;

    _videoStates[videoId]!.visibilityFraction = visibilityFraction;

    // لا نقوم بتشغيل الفيديو تلقائيًا إذا تم إيقافه يدويًا
    if (_videoStates[videoId]!.pausedManually) return;

    // إذا كان الفيديو ظاهر بدرجة كافية وليس هناك فيديو نشط آخر
    if (visibilityFraction >= _visibilityThreshold) {
      _lastVisibleVideoId = videoId;
      _playMostVisibleVideo();
    } else if (_lastVisibleVideoId == videoId &&
        visibilityFraction < _visibilityThreshold) {
      // إذا كان هذا الفيديو هو النشط وخرج من مجال الرؤية
      _pauseCurrentVideo();
      _lastVisibleVideoId = _findMostVisibleVideo();
      _playMostVisibleVideo();
    }
  }

  // العثور على الفيديو الأكثر ظهوراً
  String? _findMostVisibleVideo() {
    String? mostVisibleId;
    double maxVisibility = 0;

    _videoStates.forEach((id, state) {
      if (state.visibilityFraction > maxVisibility &&
          state.visibilityFraction >= _visibilityThreshold &&
          !state.pausedManually) {
        maxVisibility = state.visibilityFraction;
        mostVisibleId = id;
      }
    });

    return mostVisibleId;
  }

  // إيقاف الفيديو النشط حالياً
  void _pauseCurrentVideo() {
    if (_activeController != null && _activeController!.value.isPlaying) {
      _activeController!.pause();
    }
    _activeController = null;
  }

  // تشغيل الفيديو الأكثر ظهوراً
  void _playMostVisibleVideo() {
    if (_lastVisibleVideoId == null) return;

    final videoState = _videoStates[_lastVisibleVideoId!];
    if (videoState == null || videoState.pausedManually) return;

    // إذا كان نفس المشغل الحالي، لا داعي للتغيير
    if (_activeController == videoState.controller) return;

    // إيقاف الفيديو السابق
    _pauseCurrentVideo();

    // تشغيل الفيديو الجديد
    _activeController = videoState.controller;
    if (_activeController!.value.isInitialized) {
      _activeController!.play();
    } else {
      // إذا لم يكن المشغل جاهزاً بعد، انتظر تهيئته ثم شغله
      _activeController!.initialize().then((_) {
        // تحقق إذا كان لا يزال هو النشط بعد التهيئة
        if (_activeController == videoState.controller &&
            !videoState.pausedManually) {
          _activeController!.play();
          _activeController!.setLooping(true);
        }
      });
    }
  }
}

class _InstagramViewBodyState extends State<InstagramViewBody> {
  final bool _isLoading = false;

  // للتحكم بالتمرير
  // final ScrollController _scrollController = ScrollController();
  final VideoControllerManager _videoManager = VideoControllerManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsInstagramCubit, PostsInstagramState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const CustomLoading();
        }
        if (state.errMessage == "Unauthorized") {
          return CustomFailureWidget(
            title: 'Please login',
            buttonTitle: "Login",
            onPressed: () {
              ManageVibration.vibrate();
              pleaseLoginDialog(context);
            },
          );
        }
        if (state.status.isFailure) {
          log(state.errMessage.toString());
          return CustomFailureWidget(
            title: state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
            onPressed: () {
              ManageVibration.vibrate();
              context.read<PostsInstagramCubit>().loadPosts(
                    context,
                    refresh: true,
                  );
            },
          );
        }

        return Column(
          // controller: _scrollController,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(context),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 82,
              child: ChatStories(),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: OlxPaginationWidget(
                scrollController: ScrollController(),
                itemsPerPage: 10,
                items: List.generate(
                    state.posts.length + (state.hasMorePosts ? 1 : 0), (index) {
                  // 1. عنصر التحميل الإضافي (عند نهاية القائمة)
                  if (index == state.posts.length) {
                    return _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomLoading(),
                          )
                        : const SizedBox();
                  }

                  // 2. عرض "مقاطع مقترحة" كل 4 منشورات (حتى 5 مرات)
                  if ((index + 1) % 4 == 0 && index ~/ 4 < 5) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _buildSuggestedReels(context),
                    );
                  }

                  // 3. عرض "متابعات مقترحة" كل 6 منشورات (حتى 3 مرات)
                  if ((index + 1) % 6 == 0 && index ~/ 6 < 3) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _buildSuggestedFollowers(context),
                    );
                  }

                  // 4. المنشور العادي
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PostInstagramWidget(
                      key: ValueKey('post_${state.posts[index].id}'),
                      posts: state.posts,
                      currentIndex: index,
                      instagramPostEntity: state.posts[index],
                    ),
                  );
                }),
                banners: bannersList,
                loadPage: context.read<PostsInstagramCubit>().state.hasMorePosts
                    ? (page) =>
                        context.read<PostsInstagramCubit>().loadPosts(context)
                    : (page) async {},
              ),
            ),
            /* SliverList.separated(
              itemCount: state.posts.length + (state.hasMorePosts ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                // 1. عنصر التحميل الإضافي (عند نهاية القائمة)
                if (index == state.posts.length) {
                  return _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomLoading(),
                        )
                      : const SizedBox();
                }

                // 2. عرض "مقاطع مقترحة" كل 4 منشورات (حتى 5 مرات)
                if ((index + 1) % 4 == 0 && index ~/ 4 < 5) {
                  return _buildSuggestedReels(context);
                }

                // 3. عرض "متابعات مقترحة" كل 6 منشورات (حتى 3 مرات)
                if ((index + 1) % 6 == 0 && index ~/ 6 < 3) {
                  return _buildSuggestedFollowers(context);
                }

                // 4. المنشور العادي
                return PostInstagramWidget(
                  key: ValueKey('post_${state.posts[index].id}'),
                  posts: state.posts,
                  currentIndex: index,
                  instagramPostEntity: state.posts[index],
                );
              },
            ),*/
            // SliverList.separated(
            //   itemCount: state.posts.length + (state.hasMorePosts ? 1 : 0),
            //   separatorBuilder: (context, index) => const SizedBox(
            //     height: 10,
            //   ),
            //   itemBuilder: (context, index) {
            //     if (index == state.posts.length) {
            //       return _isLoading
            //           ? const Padding(
            //               padding: EdgeInsets.all(8.0),
            //               child: CustomLoading(),
            //             )
            //           : const SizedBox();
            //     }
            //     if ((index + 1) % 4 == 0 && index ~/ 4 < 6) {
            //       // Show item from another list
            //       return BlocBuilder<ReelInstagramCubit, ReelInstagramState>(
            //         builder: (context, state) {
            //           if (state.status.isLoading) {
            //             return Shimmer.fromColors(
            //               baseColor: Colors.grey[300]!,
            //               highlightColor: Colors.grey[100]!,
            //               child: ListView.builder(
            //                 itemCount: 5,
            //                 itemBuilder: (context, index) {
            //                   return Container(
            //                     height: 340,
            //                     width: 222,
            //                     color: Colors.grey,
            //                   );
            //                 },
            //               ),
            //             );
            //           } else if (state.status.isSuccess) {
            //             return SuggestReelsInstagramSection(
            //               reels: state.reels!,
            //             );
            //           }
            //           return Container(
            //             height: 100,
            //             width: 100,
            //             color: Colors.red,
            //           );
            //         },
            //       );
            //     } else {
            //       // Show regular product
            //       // return ProductItem(item: mainProductList[index]);

            //       return PostInstagramWidget(
            //         key: ValueKey('post_${state.posts[index].id}'),
            //         instagramPostEntity: state.posts[index],
            //         // isVisible: _visibleVideos[state.posts[index].id] ?? false,
            //       );
            //     }
            //   },
            // ),
          ],
        );
      },
    );
  }

  // List _posts = [];

  // void _visibilityListener() {
  //   _posts = context.read<PostsInstagramCubit>().state.posts;
  //   // حساب المنشور المرئي حاليًا بناءً على موضع التمرير
  //   double scrollPosition = _scrollController.position.pixels;
  //   double viewportHeight = _scrollController.position.viewportDimension;

  //   for (int i = 0; i < _posts.length; i++) {
  //     // حساب موضع المنشور (تقريبي)
  //     double postTopPosition = i * (viewportHeight * 1.2); // تقدير مبسط
  //     double postBottomPosition = postTopPosition + viewportHeight;

  //     bool isVisible = (postTopPosition <= scrollPosition + viewportHeight) &&
  //         (postBottomPosition >= scrollPosition);

  //     // تحديث حالة رؤية الفيديو
  //     if (_posts[i].isVideo) {
  //       setState(() {
  //         _visibleVideos[_posts[i].id] = isVisible;
  //       });
  //     }
  //   }
  // }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
  //       !_isLoading) {
  //     context.read<PostsInstagramCubit>().loadPosts(context);
  //   }
  // }

  @override
  void dispose() {
    _videoManager.disposeAll();
    // _scrollController.dispose();
    super.dispose();
  }

  // للتتبع آخر موضع تمرير
  // double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    // _loadMoreItems();

    // إضافة مراقب للتمرير لتحميل المزيد من العناصر عند الوصول للأسفل
    // _scrollController.addListener(() {
    //   // تحميل المزيد من المنشورات عند الوصول للأسفل
    //   if (_scrollController.position.pixels >=
    //           _scrollController.position.maxScrollExtent - 200 &&
    //       !_isLoading &&
    //       context.read<PostsInstagramCubit>().state.hasMorePosts) {
    //     context.read<PostsInstagramCubit>().loadPosts(context);
    //   }

    //   // للتحكم في تشغيل الفيديوهات عند التمرير السريع
    //   if ((_scrollController.position.pixels - _lastScrollPosition).abs() >
    //       50) {
    //     // إذا كان التمرير سريعًا، قم بإيقاف جميع الفيديوهات
    //     // if (_videoManager.currentlyPlayingVideoId != null) {
    //     //   _videoManager.setCurrentlyPlayingVideo(null);
    //     // }
    //   }

    //   _lastScrollPosition = _scrollController.position.pixels;
    // });
    /* _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          context.read<PostsInstagramCubit>().state.hasMorePosts) {
        context.read<PostsInstagramCubit>().loadPosts(context);
      }
    });*/
    // _scrollController.addListener(
    //   () {
    //     if (_scrollController.position.pixels >=
    //             _scrollController.position.maxScrollExtent - 200 &&
    //         !_isLoading &&
    //         context.read<PostsInstagramCubit>().state.hasMorePosts) {
    //       context.read<PostsInstagramCubit>().loadPosts(context);
    //     }
    //     // _visibilityListener();
    //   },
    // );
  }

  // دالة لعرض خطأ (لتسهيل التصحيح)
  Widget _buildErrorWidget() {
    return Container(
      height: 100,
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text('حدث خطأ', style: TextStyle(color: Colors.white)),
    );
  }

// دالة لتحميل Shimmer (تأثير التحميل)
  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }

// دالة مساعدة لبناء قسم المتابعات المقترحة
  Widget _buildSuggestedFollowers(BuildContext context) {
    return BlocBuilder<SuggestFollowCubit, SuggestFollowState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildShimmerLoader();
        } else if (state.isSuccess) {
          if (state.suggestFollowsData!.suggestions.isEmpty) {
            return Container();
          }
          return SuggestFollowersSection(
              suggestions: state.suggestFollowsData!.suggestions);
        }
        return _buildErrorWidget();
      },
    );
  }

// دالة مساعدة لبناء قسم المقاطع المقترحة
  Widget _buildSuggestedReels(BuildContext context) {
    return BlocBuilder<ReelInstagramCubit, ReelInstagramState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return _buildShimmerLoader();
        } else if (state.status.isSuccess) {
          return SuggestReelsInstagramSection(reels: state.reels!);
        }
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    // final user = context.read<UserCubit>().state.data;
    List<Map<String, String>> icons = [
      {LocaleKeys.home.localize: Assets.homeIcon},
      {LocaleKeys.create.localize: Assets.createIcon},
      {LocaleKeys.profile.localize: Assets.profile2Icon}
    ];
    int selectedIndex = 0;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            icons.length,
            (index) {
              return Expanded(
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 18),
                  // width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      // يقوم بنقلك لصفحة انشاء منشور او ريلز للانستقرام
                      if (index == 1) {
                        context.go(
                          Routes.CREATEPOSTINSTAGRAM,
                        );
                      }
                      // يقوم بتحويلك لصفحة الملف الشخصي
                      if (index == 2) {
                        context.push(
                          Routes.INSTAGRAMPROFILE,
                          extra: UserCubit.to.state.data?.id ?? '',
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BlocProvider(
                        //       create: (context) =>
                        //           serviceLocator<ProfileInstagramCubit>(),
                        //       child: const ProfileInstagramView(),
                        //     ),
                        //   ),
                        // );
                      }
                      // setState(() {});
                      log(selectedIndex.toString());
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              icons[index].values.first.toString(),
                              colorFilter: ColorFilter.mode(
                                  selectedIndex == index
                                      ? (context.isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0B1035))
                                      : (!context.isDarkMode
                                          ? const Color(0xff333333)
                                          : const Color(0xffD9D9D9)),
                                  BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Label(
                                text: icons[index].keys.first.toString(),
                                style: Styles.headerText(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: selectedIndex == index
                                      ? (context.isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0B1035))
                                      : (!context.isDarkMode
                                          ? const Color(0xff333333)
                                          : const Color(0xffD9D9D9)),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        if (selectedIndex == index)
                          Container(
                            width: double.infinity,
                            height: 2,
                            color: context.isDarkMode
                                ? Colors.white
                                : const Color(0xFF0B1035),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: List.generate(
      //     3,
      //     (i) => GestureDetector(
      //       onTap: () {
      //         if (i == 1) {
      //           print(context.read<UserCubit>().token);
      //           !context.read<UserCubit>().isTokenAttached
      //               ? context.push(Routes.LOGIN)
      //               : context.push(Routes.INSTAGRAMPROFILE, extra: user?.id);
      //         }
      //       },
      //       child: Container(
      //         decoration: i == 0
      //             ? const BoxDecoration(
      //                 border: Border(
      //                   bottom: BorderSide(
      //                       color: AppColors.PRIMARY_COLOR_DARK, width: 2),
      //                 ),
      //               )
      //             : null,
      //         child: Row(
      //           children: [
      //             Icon(
      //               i == 0 ? Icons.home : Icons.person_pin,
      //               color: i == 0
      //                   ? context.isDarkMode
      //                       ? AppColors.PRIMARY_COLOR_DARK
      //                       : AppColors.PRIMARY_COLOR
      //                   : Colors.grey,
      //               size: 40.w,
      //             ),
      //             SizedBox(
      //               width: 8.w,
      //             ),
      //             Label(
      //               text: i == 0
      //                   ? LocaleKeys.home.localize
      //                   : LocaleKeys.profile.localize,
      //               style: Styles.headerText(
      //                   color: i == 0
      //                       ? context.isDarkMode
      //                           ? AppColors.PRIMARY_COLOR_DARK
      //                           : AppColors.PRIMARY_COLOR
      //                       : Colors.grey,
      //                   fontSize: 30),
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

// كلاس لتخزين حالة كل فيديو
class _VideoState {
  final VideoPlayerController controller;
  double visibilityFraction = 0.0;
  bool pausedManually = false;

  _VideoState({required this.controller});
}
