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
              // Navigation code here if needed
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

          // Initialize video controllers if not done yet
          if (_videoControllers.isEmpty && state.star != null) {
            _initializeVideoControllers(state.star!);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= state.star!.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final videoController = _videoControllers[index];

                      return Column(
                        children: [
                          buildHeaderInfo(state.star![index]),
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
                                    aspectRatio:
                                        videoController.value.aspectRatio,
                                    child: Stack(
                                      children: [
                                        VideoPlayer(videoController),
                                        Padding(
                                          padding: EdgeInsets.all(12.w),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                    Icons.remove_red_eye),
                                                Sizer(width: 10.w),
                                                Label(
                                                    text:
                                                        '${state.star![index].totalViews}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(12.w),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.topStart,
                                            child: Label(
                                                text:
                                                    'Rating: ${state.star![index].totalRatings}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator()
                            else
                            Container(
                              width: double.infinity,
                              height: 240.h,
                              decoration: BoxDecoration(
                               // borderRadius: BorderRadius.circular(20.r),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(state.star![index].videoUrlVideo),
                                ),
                              ),
                            ),
                                // Image.network(
                                //   height: 240.h,
                                // width: double.infinity,
                                // state.star![index].videoUrlVideo,
                                // fit: BoxFit.fill,
                                // ),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              state.star![index].description,
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
                                Icon(showMore
                                    ? Icons.arrow_drop_down_rounded
                                    : Icons.arrow_drop_up_rounded),
                                Label(
                                  text: showMore
                                      ? LocaleKeys.showLess.localize
                                      : LocaleKeys.showMore.localize,
                                  style: Styles.smallText(
                                      color: Theme.of(context).primaryColor),
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
                    itemCount: state.star?.length ?? 0,
                  ),
                ),
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
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/loading/custom_loading.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
// import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/floating_action_button_star.dart';
// import 'package:fourtyninehub/res/assets/assets.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../../common/widgets/stateful/banners/back_appbar.dart';
// import '../../../../common/widgets/stateless/buttons/text_button.dart';
// import '../../../../core/localization/locale_keys.g.dart';
// import '../../../../res/style/app_colors.dart';
// import '../../../../res/style/styles.dart';
// import '../controller/cubit/star_cubit.dart';
//
// class BeStarView extends StatefulWidget {
//   const BeStarView({Key? key}) : super(key: key);
//
//   @override
//   _BeStarViewState createState() => _BeStarViewState();
// }
//
// class _BeStarViewState extends State<BeStarView> {
//   late List<VideoPlayerController> _videoControllers = [];
//   late List<bool> _isVideoEnded = [];
//   late ScrollController _scrollController;
//   late StarCubit _cubit;
//   bool showMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = context.read<StarCubit>();
//     _scrollController = ScrollController()..addListener(_onScroll);
//     _cubit.loadInitialData();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       _cubit.fetchAllStar();
//     }
//   }
//
//   void _initializeVideoControllers(List<StarEntity> stars) {
//     _videoControllers = stars.map((star) {
//       return VideoPlayerController.network(star.videoUrlVideo);
//     }).toList();
//     _isVideoEnded = List.generate(stars.length, (_) => false);
//
//     for (int i = 0; i < _videoControllers.length; i++) {
//       _videoControllers[i]
//         ..initialize().then((_) {
//           if (mounted) {
//             setState(() {}); // Update the UI after initialization
//           }
//         })
//         ..addListener(() {
//           if (_videoControllers[i].value.position ==
//               _videoControllers[i].value.duration) {
//             setState(() {
//               _isVideoEnded[i] = true;
//             });
//           }
//         });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BackAppBar(
//         label: LocaleKeys.beAStar.localize,
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Navigation code here if needed
//             },
//             child: Text(
//               '${LocaleKeys.winners.localize} 🏆',
//               style: Styles.mediumText(
//                   color: AppColors.SECONDARY_COLOR, fontSize: 60.sp),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: const FloatingActionButtonStar(),
//       body: BlocBuilder<StarCubit, StarState>(
//         builder: (BuildContext context, state) {
//           if (state.status == StarStates.loading) {
//             return const CustomLoading();
//           }
//
//           // Initialize video controllers if not done yet
//           if (_videoControllers.isEmpty && state.star != null) {
//             _initializeVideoControllers(state.star!);
//           }
//
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 240.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.r),
//                     image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image: AssetImage(Assets.win),
//                     ),
//                   ),
//                 ),
//                 const Sizer(),
//                 Text(
//                   'You have a talent or special unique content!',
//                   textAlign: TextAlign.center,
//                   style: Styles.mediumText(
//                     fontSize: 60.sp,
//                     color: AppColors.SECONDARY_COLOR,
//                   ),
//                 ),
//                 const Sizer(),
//                 Text(
//                   'Share it with the users and win 10000 EGP every month!!!',
//                   textAlign: TextAlign.center,
//                   style: Styles.mediumText(
//                     fontSize: 60.sp,
//                     color: AppColors.SECONDARY_COLOR,
//                   ),
//                 ),
//                 const Sizer(),
//                 Expanded(
//                   child: ListView.separated(
//                     controller: _scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       if (index >= state.star!.length) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       final videoController = _videoControllers[index];
//
//                       return Column(
//                         children: [
//                           buildHeaderInfo(state.star![index]),
//                           SizedBox(height: 10.h),
//                           videoController.value.isInitialized
//                               ? GestureDetector(
//                                   onTap: () {
//                                     if (_isVideoEnded[index]) {
//                                       videoController.seekTo(Duration.zero);
//                                       videoController.play();
//                                       setState(() {
//                                         _isVideoEnded[index] = false;
//                                       });
//                                     } else {
//                                       videoController.value.isPlaying
//                                           ? videoController.pause()
//                                           : videoController.play();
//                                     }
//                                   },
//                                   child: AspectRatio(
//                                     aspectRatio:
//                                         videoController.value.aspectRatio,
//                                     child: Stack(
//                                       children: [
//                                         VideoPlayer(videoController),
//                                         Padding(
//                                           padding: EdgeInsets.all(12.w),
//                                           child: Align(
//                                             alignment:
//                                                 AlignmentDirectional.topEnd,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 const Icon(
//                                                     Icons.remove_red_eye),
//                                                 Sizer(width: 10.w),
//                                                 Label(
//                                                     text:
//                                                         '${state.star![index].totalViews}'),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.all(12.w),
//                                           child: Align(
//                                             alignment:
//                                                 AlignmentDirectional.topStart,
//                                             child: Label(
//                                                 text:
//                                                     'Rating: ${state.star![index].totalRatings}'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               : const CircularProgressIndicator(),
//                           Align(
//                             alignment: AlignmentDirectional.topStart,
//                             child: Text(
//                               state.star![index].description,
//                               style: Styles.mediumText(),
//                               textAlign: TextAlign.start,
//                               maxLines: showMore ? 100 : 2,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 showMore = !showMore;
//                               });
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(showMore
//                                     ? Icons.arrow_drop_down_rounded
//                                     : Icons.arrow_drop_up_rounded),
//                                 Label(
//                                   text: showMore
//                                       ? LocaleKeys.showLess.localize
//                                       : LocaleKeys.showMore.localize,
//                                   style: Styles.smallText(
//                                       color: Theme.of(context).primaryColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Sizer(),
//                         ],
//                       );
//                     },
//                     separatorBuilder: (context, index) => Divider(
//                       height: 40.h,
//                       color: AppColors.GREY_NORMAL_COLOR,
//                     ),
//                     itemCount: state.star?.length ?? 0,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     for (final controller in _videoControllers) {
//       controller.dispose();
//     }
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Widget buildHeaderInfo(StarEntity star) => Row(
//         children: [
//           InkWell(
//             onTap: () {
//               context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
//             },
//             child: ImageFromInternet(
//               image: star.user.image,
//               isCircle: true,
//               defaultLogo: false,
//               width: 50.w,
//               height: 50.h,
//             ),
//           ),
//           const Sizer(),
//           Expanded(
//               child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextAppButton(
//                       label: '${star.user.firstName} ${star.user.lastName}',
//                       style: Styles.mediumText(
//                           color: Theme.of(context).primaryColor),
//                       onPressed: () {
//                         context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
//                       },
//                     ),
//                     RichText(
//                       text: TextSpan(children: [
//                         TextSpan(
//                             text: star.sinceTime,
//                             style: Styles.smallText(
//                                 color: Colors.grey, fontSize: 50.sp)),
//                         WidgetSpan(
//                             child: Icon(
//                           Icons.group,
//                           size: 30.sp,
//                           color: Colors.grey,
//                         ))
//                       ]),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//         ],
//       );
// }