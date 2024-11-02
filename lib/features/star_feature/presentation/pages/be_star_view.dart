import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/floating_action_button_star.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/star_winner_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controller/cubit/star_cubit.dart';

class BeStarView extends StatefulWidget {
  const BeStarView({Key? key}) : super(key: key);

  @override
  _BeStarViewState createState() => _BeStarViewState();
}

class _BeStarViewState extends State<BeStarView> {
  late List<VideoPlayerController?> _videoControllers = [];
  late List<bool> _isVideoEnded = [];
  late ScrollController _scrollController;
  late StarCubit _cubit;
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAllStar();
    }
  }

  void _initializeVideoControllers(List<StarEntity> stars) {
    _videoControllers = stars.map((star) {
      return isVideoFile(star.videoUrlVideo)
          ? VideoPlayerController.network(star.videoUrlVideo)
          : null; // No controller for images
    }).toList();

    _isVideoEnded = List.generate(stars.length, (_) => false);

    for (int i = 0; i < _videoControllers.length; i++) {
      final controller = _videoControllers[i];
      if (controller != null) {
        controller
          ..initialize().then((_) {
            if (mounted) setState(() {}); // Update UI after initialization
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
    return videoExtensions.any((extension) => url.toLowerCase().endsWith(extension));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.beAStar.localize,
        actions: [
          TextButton(
            onPressed: () {
              context.push(Routes.BE_STAR_DETAILS);
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const StarWinnerView()));
            },
            child: Text(
              '${LocaleKeys.winners.localize} 🏆',
              style: Styles.mediumText(
                  color: AppColors.SECONDARY_COLOR, fontSize: 60.sp),
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButtonStar(),
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading) {
            return const CustomLoading();
          }

          final sortedStars = List<StarEntity>.from(state.star?? [])
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          // Initialize video controllers if not done yet
          if (_videoControllers.isEmpty && sortedStars.isNotEmpty) {
            _initializeVideoControllers(sortedStars);
          }
          // Initialize video controllers if not done yet
          if (_videoControllers.isEmpty && sortedStars!= null) {
            _initializeVideoControllers(sortedStars);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => context.read<StarCubit>().fetchAllStar(),
              child: SingleChildScrollView( // Keeps the entire content scrollable
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 240.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(Assets.win),
                        ),
                      ),
                    ),
                    const Sizer(),
                    Text(
                      'You have a talent or special unique content!',
                      textAlign: TextAlign.center,
                      style: Styles.mediumText(
                        fontSize: 60.sp,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    const Sizer(),
                    Text(
                      'Share it with the users and win 10000 EGP every month!!!',
                      textAlign: TextAlign.center,
                      style: Styles.mediumText(
                        fontSize: 60.sp,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    const Sizer(),
                    // ListView with shrinkWrap and no scrolling
                    ListView.separated(
                      controller: _scrollController,
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                      shrinkWrap: true, // Allow the ListView to take only the necessary height
                      itemBuilder: (context, index) {
                        if (index >= sortedStars.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (index >= sortedStars.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final videoController = _videoControllers[index];
                        final star = sortedStars[index];
                       // final videoController = _videoControllers[index];

                        return Column(
                          children: [
                            buildHeaderInfo(sortedStars[index]),
                            SizedBox(height: 10.h),
                            if (videoController != null)
                              videoController.value.isInitialized
                                  ? GestureDetector(
                                onTap: () {
                                  if (_isVideoEnded[index]) {
                                    videoController.seekTo(Duration.zero);
                                    videoController.play();
                                    setState(() {
                                      _isVideoEnded[index] = false;
                                    });
                                  } else {
                                    videoController.value.isPlaying
                                        ? videoController.pause()
                                        : videoController.play();
                                  }
                                },
                                child: AspectRatio(
                                  aspectRatio: videoController.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(videoController),
                                      Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Align(
                                          alignment: AlignmentDirectional.topEnd,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Icon(Icons.remove_red_eye),
                                              Sizer(width: 10.w),
                                              Label(text: '${sortedStars[index].totalViews}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child: Label(text: 'Rating: ${sortedStars[index].totalRatings}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : const CircularProgressIndicator()
                            else
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 240.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(sortedStars[index].videoUrlVideo),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Icon(Icons.remove_red_eye),
                                          Sizer(width: 10.w),
                                          Label(text: '${sortedStars[index].totalViews}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Label(text: 'Rating: ${sortedStars[index].totalRatings}'),
                                    ),
                                  ),
                                ],
                              ),
                            Sizer(),
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: List.generate(5, (index) {
                            //     int starIndex = index + 1;
                            //     return IconButton(
                            //       icon: Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //       onPressed: () {
                            //         // _addRating(context, starIndex); // Send rating to the cubit
                            //       },
                            //     );
                            //   }),
                            // ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                sortedStars[index].description,
                                style: Styles.mediumText(),
                                textAlign: TextAlign.start,
                                maxLines: showMore ? 100 : 2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showMore = !showMore;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(showMore ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded),
                                  Label(
                                    text: showMore ? LocaleKeys.showLess.localize : LocaleKeys.showMore.localize,
                                    style: Styles.smallText(color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            const Sizer(),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 40.h,
                        color: AppColors.GREY_NORMAL_COLOR,
                      ),
                      itemCount: sortedStars.length,
                    ),
                  ],
                ),
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
}