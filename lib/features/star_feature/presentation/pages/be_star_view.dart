import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../ads/native_ad_card.dart';
// import '../../../../common/widgets/stateful/banners/back_appbar.dart';
// import '../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/numbers_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/custom_show_dialog.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../ads_feature/create_company_ad/presentation/pages/widgets/image_details.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/star_entity.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import 'all_winner_view.dart';
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
    _scrollController = ScrollController()..addListener(_onScroll2);
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
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showButtons) {
          setState(() {
            _showButtons = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showButtons) {
          setState(() {
            _showButtons = true;
          });
        }
      }
    });
  }

  // void _onScroll() {
  //   _onScroll2();
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     // _cubit.getAllTalent();
  //   }
  // }

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
            return const CustomLoadingSearchWidget();
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
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                // controller: _controller,
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
                          ManageVibration.vibrate();
                          showAnimatedDialog(
                            context,
                            AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              content: Stack(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image.asset(
                                      Assets.talentGIF,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  PositionedDirectional(
                                    top: 10,
                                    start: 10,
                                    child: InkWell(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        context.pop();
                                      },
                                      child: Image.asset(
                                        Assets.close,
                                        height: 24,
                                        width: 24,
                                      ),
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
                    scrollController: _controller,
                    isMyTalent: false,
                  ),
                ],
              ),
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
    _scrollController.removeListener(_onScroll2);
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildHeaderInfo(StarEntity star) => Row(
        children: [
          InkWell(
            onTap: () {
              ManageVibration.vibrate();
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
                  ManageVibration.vibrate();
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
                        ManageVibration.vibrate();
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
                ManageVibration.vibrate();
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
              ManageVibration.vibrate();
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
              ManageVibration.vibrate();
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
