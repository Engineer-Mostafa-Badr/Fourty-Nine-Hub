import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/image_details.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/all_winner_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

// import '../../../../common/widgets/stateful/banners/back_appbar.dart';
// import '../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controller/cubit/star_cubit.dart';
import 'get_all_talents.dart';
import 'widgets/floating_action_button_star.dart';

class BeStarView extends StatefulWidget {
  const BeStarView({super.key});

  @override
  _BeStarViewState createState() => _BeStarViewState();
}

class _BeStarViewState extends State<BeStarView> {
  late List<VideoPlayerController?> _videoControllers = [];
  late List<bool> _isVideoEnded = [];
  late ScrollController _scrollController;
  late ScrollController _controller;
  late StarCubit _cubit;
  bool isFloatingButtonVisible = true;
  bool showMore = false;
  final AdsManager _adsManager = AdsManager();
  bool _showButtons = true;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _controller = ScrollController()..addListener(_onScroll2);
    _cubit.loadAllTalentsData();
    _adsManager.preloadAds();
  }

  void _onScroll2() {
    // if (_scrollController.position.userScrollDirection ==
    //     ScrollDirection.reverse) {
    //   isFloatingButtonVisible = false;
    // } else {
    //   isFloatingButtonVisible = true;
    // }
    // setState(() {});
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showButtons) {
          setState(() {
            _showButtons = false;
          });
        }
      } else if (_controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showButtons) {
          setState(() {
            _showButtons = true;
          });
        }
      }
    });
  }

  void _onScroll() {
    _onScroll2();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.getAllTalent();
    }
  }

  void _initializeVideoControllers(List<StarEntity> stars) {
    _videoControllers = stars.map((star) {
      return isVideoFile(star.mediaUrl[0].mediaKey)
          ? VideoPlayerController.networkUrl(
              Uri.parse(star.mediaUrl[0].mediaKey))
          : null; // No controller for images
    }).toList();

    _isVideoEnded = List.generate(stars.length, (_) => false);

    for (int i = 0; i < _videoControllers.length; i++) {
      final controller = _videoControllers[i];
      if (controller != null) {
        controller
          ..initialize().then((_) {
            if (mounted) setState(() {});
          })
          ..addListener(() {
            if (controller.value.position == controller.value.duration) {
              setState(() => _isVideoEnded[i] = true);
            }
          });
      }
    }
  }

  bool isVideoFile(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.wmv'];
    return videoExtensions
        .any((extension) => url.toLowerCase().endsWith(extension));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customTalentAppBar(),
      floatingActionButton: context.read<UserCubit>().isLoggedIn
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _showButtons ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showButtons ? 1.0 : 0.0,
                  child: const FloatingActionButtonStar()))
          : null,
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          // if (!context.read<UserCubit>().isLoggedIn) {
          //   return const CustomNotLogged();
          // }
          if (state.status == StarStates.loading) {
            return const CustomLoading();
          }

          final sortedStars = List<StarEntity>.from(state.star ?? [])
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          // Initialize video controllers if not done yet
          if (_videoControllers.isEmpty && sortedStars.isNotEmpty) {
            _initializeVideoControllers(sortedStars);
          }
          // Initialize video controllers if not done yet
          if (_videoControllers.isEmpty) {
            _initializeVideoControllers(sortedStars);
          }

          return RefreshIndicator(
            color: AppColors.getTextColor(context),
            backgroundColor: AppColors.getFindFillColor(context),
            onRefresh: () async =>
                context.read<StarCubit>().getAllTalent(refresh: true),
            child: ListView(
              controller: _controller,
              children: [
                // ImageFromInternet(image: state.banner?.banner ?? ''),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    // image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: NetworkImage(state.banner?.banner ??''),
                    // ),
                  ),
                  child: ImageFromInternet(
                    image: state.banner?.banner ?? '',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const Sizer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      context.isArabic
                          ? convertToArabicNumbers(
                              state.banner?.titleAr ?? '',
                            )
                          : state.banner?.titleEn ?? '',
                      textAlign: TextAlign.center,
                      style: Styles.mediumText(
                        fontSize: 30,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showAnimatedDialog(
                          context,
                          AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.pop();
                                      },
                                      child: Image.asset(
                                        Assets.close,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                const Sizer(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.asset(
                                    Assets.talentGIF,
                                    width: MediaQuery.of(context).size.width *
                                        0.8,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        Assets.idea,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                Text(
                  context.isArabic
                      ? convertToArabicNumbers(state.banner?.subTitleAr ?? '')
                      : state.banner?.subTitleEn ?? '',
                  textAlign: TextAlign.center,
                  style: Styles.mediumText(
                    fontSize: 28,
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                  ),
                ),
                const Sizer(),
                GetAllTalents(
                  scrollController: _scrollController,
                  isMyTalent: false,
                ),
                // ListView with shrinkWrap and no scrolling
                // ListView.separated(
                //     controller: _scrollController,
                //     physics: const NeverScrollableScrollPhysics(),
                //     // Disable scrolling
                //     shrinkWrap: true,
                //     // Allow the ListView to take only the necessary height
                //     itemBuilder: (context, index) {
                //       // Insert ads after every 2 items
                //       // if ((index + 1) % 3 == 0) {
                //       //   return getAdIfNeeded(index, AdsManager());
                //       // }
                //       if (index > nativeAdStart &&
                //           index % adFrequency == adFrequency - 1) {
                //         return getAdIfNeeded(index, _adsManager);
                //       }
                //       if (index >= sortedStars.length) {
                //         return const Center(
                //             child: CustomCircularProgressIndicator());
                //       }
                //       if (index >= sortedStars.length) {
                //         return const Center(
                //             child: CustomCircularProgressIndicator());
                //       }
                //       final videoController = _videoControllers[index];
                //       //final star = sortedStars[index];
                //       // final videoController = _videoControllers[index];
                //       return Column(
                //         children: [
                //           buildHeaderInfo(sortedStars[index]),
                //           SizedBox(height: 10.h),
                //           if (videoController != null)
                //             videoController.value.isInitialized
                //                 ? GestureDetector(
                //                     onTap: () {
                //                       if (_isVideoEnded[index]) {
                //                         videoController
                //                             .seekTo(Duration.zero);
                //                         videoController.play();
                //                         setState(() {
                //                           _isVideoEnded[index] = false;
                //                         });
                //                       } else {
                //                         videoController.value.isPlaying
                //                             ? videoController.pause()
                //                             : videoController.play();
                //                       }
                //                     },
                //                     child: AspectRatio(
                //                       aspectRatio: 1,
                //                       child: Stack(
                //                         children: [
                //                           VideoPlayer(videoController),
                //                           Padding(
                //                             padding: EdgeInsets.all(16.w),
                //                             child: Row(
                //                               children: [
                //                                 Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.end,
                //                                   children: [
                //                                     const Icon(
                //                                       Icons.remove_red_eye,
                //                                       color: AppColors
                //                                           .AUTH_CONTAINER_COLOR,
                //                                     ),
                //                                     Sizer(width: 10.w),
                //                                     Label(
                //                                         text:
                //                                             '${sortedStars[index].totalViews}',
                //                                         color: AppColors
                //                                             .AUTH_CONTAINER_COLOR),
                //                                   ],
                //                                 ),
                //                                 const Spacer(),
                //                                 Label(
                //                                     color: AppColors
                //                                         .AUTH_CONTAINER_COLOR,
                //                                     text:
                //                                         '${LocaleKeys.Rating.localize} ${sortedStars[index].averageRating}'),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   )
                //                 : const CustomCircularProgressIndicator()
                //           else
                //             Stack(
                //               children: [
                //                 GridView.builder(
                //                   shrinkWrap: true,
                //                   physics:
                //                       const NeverScrollableScrollPhysics(),
                //                   gridDelegate:
                //                       SliverGridDelegateWithFixedCrossAxisCount(
                //                     crossAxisCount: state.star![index]
                //                                 .mediaUrl.length ==
                //                             1
                //                         ? 1
                //                         : 2,
                //                   ),
                //                   itemCount:
                //                       state.star![index].mediaUrl.length < 4
                //                           ? state
                //                               .star![index].mediaUrl.length
                //                           : 4,
                //                   itemBuilder: (context, mediaIndex) {
                //                     if (mediaIndex >=
                //                         state
                //                             .star![index].mediaUrl.length) {
                //                       // Skip rendering for out-of-bounds mediaIndex
                //                       return const SizedBox.shrink();
                //                     }
                //                     return GestureDetector(
                //                       onTap: () {
                //                         if (mediaIndex != 3 ||
                //                             (mediaIndex == 3 &&
                //                                 state.star![index].mediaUrl
                //                                         .length ==
                //                                     4)) {
                //                           showDialog(
                //                             context: context,
                //                             builder: (context) =>
                //                                 ImageDetails(
                //                               image: state
                //                                   .star![index]
                //                                   .mediaUrl[mediaIndex]
                //                                   .mediaKey,
                //                               function: () {},
                //                             ),
                //                           );
                //                         } else {
                //                           showDialog(
                //                             context: context,
                //                             builder: (context) => allImage(
                //                               () {},
                //                               state.star![index].mediaUrl
                //                                   .length,
                //                               state
                //                                   .star![index]
                //                                   .mediaUrl[mediaIndex]
                //                                   .mediaKey,
                //                             ),
                //                           );
                //                         }
                //                       },
                //                       child: Stack(
                //                         children: [
                //                           Container(
                // margin:
                //     const EdgeInsetsDirectional
                //         .only(
                //         end: 10, bottom: 10),
                // padding:
                //     const EdgeInsets.all(10),
                //                             decoration: BoxDecoration(
                //                               borderRadius:
                //                                   BorderRadius.circular(15),
                //                               image: DecorationImage(
                //                                 fit: BoxFit.fill,
                //                                 image: NetworkImage(state
                //                                     .star![index]
                //                                     .mediaUrl[mediaIndex]
                //                                     .mediaKey),
                //                               ),
                //                             ),
                //                           ),
                //                           if (mediaIndex == 3 &&
                //                               state.star![index].mediaUrl
                //                                       .length >
                //                                   4)
                //                             Container(
                //                               // margin:
                //                               //     const EdgeInsetsDirectional
                //                               //         .only(
                //                               //         end: 10, bottom: 10),
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                 borderRadius:
                //                                     BorderRadius.circular(
                //                                         15),
                //                                 color: Colors.black
                //                                     .withOpacity(0.5),
                //                               ),
                //                               child: Center(
                //                                 child: Label(
                //                                   text:
                //                                       "+${state.star![index].mediaUrl.length - 4}",
                //                                   style: Styles.headerText(
                //                                       color: Colors.white),
                //                                 ),
                //                               ),
                //                             ),
                //                         ],
                //                       ),
                //                     );
                //                   },
                //                 ),
                //                 Padding(
                //                   padding: EdgeInsets.all(8.w),
                //                   child: Row(
                //                     children: [
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.end,
                //                         children: [
                //                           const Icon(
                //                             Icons.remove_red_eye,
                //                             color: AppColors
                //                                 .AUTH_CONTAINER_COLOR,
                //                           ),
                //                           Sizer(width: 10.w),
                //                           Text(
                //                             '${sortedStars[index].totalViews}',
                //                             style: Styles.mediumText(
                //                               color: AppColors
                //                                   .AUTH_CONTAINER_COLOR,
                //                             ).copyWith(
                //                               shadows: [
                //                                 Shadow(
                //                                   offset: const Offset(
                //                                       2.0, 2.0),
                //                                   // Position of the shadow
                //                                   blurRadius: 3.0,
                //                                   // Blur radius of the shadow
                //                                   color: Colors.white
                //                                       .withOpacity(
                //                                           0.5), // Shadow color
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                       const Spacer(),
                //                       Text(
                //                         '${LocaleKeys.Rating.localize} ${sortedStars[index].averageRating}',
                //                         style: Styles.mediumText(
                //                           color: AppColors
                //                               .AUTH_CONTAINER_COLOR,
                //                         ).copyWith(
                //                           shadows: [
                //                             Shadow(
                //                               offset:
                //                                   const Offset(1.0, 1.0),
                //                               blurRadius: 3.0,
                //                               color: Colors.white
                //                                   .withOpacity(0.5),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           const Sizer(),
                //           Align(
                //             alignment: AlignmentDirectional.topStart,
                //             child: Text(
                //               sortedStars[index].description,
                //               style: Styles.mediumText(),
                //               textAlign: TextAlign.start,
                //               maxLines: showMore ? 100 : 2,
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               setState(() {
                //                 showMore = !showMore;
                //               });
                //             },
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(showMore
                //                     ? Icons.arrow_drop_down_rounded
                //                     : Icons.arrow_drop_up_rounded),
                //                 Label(
                //                   text: showMore
                //                       ? LocaleKeys.showLess.localize
                //                       : LocaleKeys.showMore.localize,
                //                   style: Styles.smallText(
                //                       color:
                //                           Theme.of(context).primaryColor),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           const Sizer(),
                //         ],
                //       );
                //     },
                //     separatorBuilder: (context, index) => Divider(
                //           height: 40.h,
                //           color: AppColors.GREY_NORMAL_COLOR,
                //         ),
                //     itemCount: sortedStars.length // Add extra items for ads
                // itemCount: sortedStars.length,
                //     ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller!.dispose();
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildHeaderInfo(StarEntity star) => Row(
        children: [
          InkWell(
            onTap: () {
              context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
            },
            child: ImageFromInternet(
              image: star.user.image,
              isCircle: true,
              defaultLogo: false,
              width: 50.w,
              height: 50.h,
            ),
          ),
          const Sizer(),
          Expanded(
              child: Row(
            children: [
              InkWell(
                onTap: () {
                  context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAppButton(
                      label: '${star.user.firstName} ${star.user.lastName}',
                      style: Styles.mediumText(
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
                      },
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: star.sinceTime,
                            style: Styles.smallText(
                                color: Colors.grey, fontSize: 50.sp)),
                        WidgetSpan(
                            child: Icon(
                          Icons.group,
                          size: 30.sp,
                          color: Colors.grey,
                        ))
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      );

  Widget allImage(Function function, int length, String image) => Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.DARK_BLUE_COLOR,
        child: ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) => Material(
            // Add Material widget here
            color: Colors.transparent,
            // Ensure the background remains unchanged
            child: InkWell(
              onTap: () {
                print("object");
                showDialog(
                  context: context,
                  builder: (context) =>
                      ImageDetails(image: image, function: function),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 400.h,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.DARK_BLUE_COLOR,
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  AppBar customTalentAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.tube.localize,
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!context.read<UserCubit>().isLoggedIn) {
                pleaseLoginDialog(context);
              } else {
                context.push(
                  Routes.MY_TALENT,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                right: context.locale.languageCode == 'ar' ? 0 : 40,
                left: context.locale.languageCode == 'ar' ? 40 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.getButtonPrimaryWhiteColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.myTalent.localize,
                  style: TextStyle(
                    color: context.isDarkMode
                        ? AppColors.PRIMARY_COLOR
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => serviceLocator<StarCubit>(),
                    child: const AllWinnerView(),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  LocaleKeys.winners.localize,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  Assets.winners,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
