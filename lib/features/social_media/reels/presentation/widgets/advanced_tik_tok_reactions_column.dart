import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../instagram/presentation/widgets/comment_widget_insta.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/preload_cubit/preload_bloc.dart';
import 'comments/show_comments_sheet.dart';
import 'components/unified_widget_view.dart';
import 'live_widget.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../routes/routes.dart';
import '../../../tinder/data/shared/shared.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import 'love_button.dart';
import 'share_count_bottom_sheet.dart';
import '../../../../../helpers/manage_vibration.dart';

class AdvancedTikTokReactionsColumn extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const AdvancedTikTokReactionsColumn({
    super.key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  static double iconSize = 0.1.sw;
  static const TextStyle countTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const List<Shadow> iconShadows = [
    Shadow(
      blurRadius: 10,
      color: Colors.black26,
      offset: Offset(0, 3),
    ),
  ];

  // SVG string for the comment icon
  static const String commentIconSvg = '''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" viewBox="0 0 2048 1926" width="152" height="143" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="10" dy="10" stdDeviation="10" flood-color="black"/>
    </filter>
  </defs>

  <!-- Apply the shadow to the following paths -->
  <path transform="translate(1008,507)" d="m0 0h34l32 2 37 4 33 5 29 6 36 10 35 12 37 15 28 14 28 17 16 10 19 13 11 8 13 10 15 13 7 7 6 5 6 7 8 7 8 9 13 13 11 14 9 11 14 19 14 21 11 19 11 21 11 25 8 20 9 27 7 32 6 32 3 26v48l-3 28-5 29-7 28-12 36-13 31-8 16-11 21-13 21-16 23-13 18-11 14-12 14-22 24-40 40-8 7-16 15-8 7-10 9-14 11-18 14-14 10-16 12-16 11-14 10-15 10-17 11-44 28-29 17-19 11-28 15-21 10-17 5-8-1-8-5-4-5-3-8-2-14-1-17v-74l-1-2-15-2-41-3-27-3-36-6-40-8-40-10-36-12-31-12-18-8-24-12-24-14-20-12-12-8-19-14-15-13-13-12-8-7-29-29-7-8-9-11-14-19-11-17-10-17-8-16-9-19-10-26-10-30-7-30-4-26-3-27-1-22v-13l2-24 7-42 8-34 6-20 8-22 10-23 14-29 15-25 15-22 14-19 14-18 12-13 4-5h2l2-4h2l2-4 17-16 11-10 11-9 18-14 42-28 20-12 18-10 17-9 33-14 38-13 30-8 29-7 30-5 42-5z" fill="#F5F5F5" filter="url(#shadow)"/>

  <path transform="translate(1026,922)" d="m0 0 17 1 15 4 13 7 9 7 6 5 10 13 7 14 4 13 1 5v17l-4 19-9 17-9 11-12 9-12 6-12 4-11 2h-24l-15-4-16-8-11-9-7-8-7-11-5-11-3-11v-21l4-18 6-14 10-13 7-7 15-10 11-5 12-3z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(1281,923)" d="m0 0h24l12 3 13 5 14 9 8 7 9 13 5 10 3 9 3 15v16l-5 18-7 13-11 12-10 9-14 8-13 5-9 2h-22l-15-4-12-6-9-7-8-7-10-13-7-12-5-14-1-6v-15l3-15 8-17 8-11 9-10 13-9 12-5z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(757,923)" d="m0 0h19l14 3 16 8 11 8 14 14 8 14 4 11 2 16-1 14-5 17-9 15-11 13-13 9-12 6-21 5h-23l-12-3-16-8-10-8-9-10-8-14-5-13-2-10v-20l3-14 5-12 6-9 11-12 13-10 11-5 14-4z" fill="#1E1D29" filter="url(#shadow)"/>
</svg>

  ''';

  @override
  Widget build(BuildContext context) {
    final ReelsCubit reelsCubit = context.read<ReelsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Profile Icon with Plus Button (Follow)
        // Stack(
        //   alignment: Alignment.bottomCenter,
        //   children: [

        //     // Positioned(
        //     //   bottom: 0,
        //     //   child: Container(
        //     //     decoration: BoxDecoration(
        //     //       color: Colors.red,
        //     //       borderRadius: BorderRadius.circular(15),
        //     //       border: Border.all(color: Colors.white, width: 2),
        //     //     ),
        //     //     child: const Icon(Icons.add, color: Colors.white, size: 15),
        //     //   ),
        //     // ),
        //   ],
        // ).animate().scale(duration: 200.ms),
        // _buildReactionButton(
        //   iconWidget: Image.asset(Assets.giftBoxIcon, color: Colors.white, width: 30, height: 30,),
        //   count: '',
        //   onTap: () {
        //     if (!serviceLocator<UserCubit>().isLoggedIn) {
        // context.read<PreloadBloc>().pauseTheVideo();
        //       context.push(Routes.LOGIN);
        //     } else {
        //       _showGiftBottomSheet(context);
        //     }
        //   },
        // ),
        // SizedBox(
        //   height: 15,
        // ),

        InkWell(
          onTap: () {
            ManageVibration.vibrate();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.read<PreloadBloc>().pauseCurrent();
              context.push(Routes.LOGIN);
            } else {
              context.push(Routes.OTHERSACCOUNT, extra: reel.user.id);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    reel.user.profilePictureSignedUrl ??
                        'https://i.pravatar.cc/150?img=3', // Default image if null
                  ),
                ),
              ),
              const Positioned(
                bottom: -8,
                right: -4,
                left: -4,
                child: CircleAvatar(
                  radius: 9.7,
                  backgroundColor: Color(0xffFF3308),
                  child: Icon(
                    Icons.add,
                    size: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.read<PreloadBloc>().pauseCurrent();
              context.push(Routes.LOGIN);
            } else {
              _showGiftBottomSheet(context);
            }
          },
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: FittedBox(
              child: SvgPicture.asset(
                Assets.giftReelsIcon,
                width: 25.5,
                height: 26,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // const LiveWidget(),
        // likeWidget(),
        // const SizedBox(height: 16),
        LoveButton(
          count: reel.likeCount.toString(),
          reel: reel,
          // onTap: () {
          //   if (!serviceLocator<UserCubit>().isLoggedIn) {
          // context.read<PreloadBloc>().pauseTheVideo();
          //     context.push(Routes.LOGIN);
          //   } else {
          //     _handleLikeAction(context, reelsCubit);
          //   }
          // },
        ),

        const SizedBox(height: 16),

        // Comment Icon
        _buildReactionButton(
          context: context,
          iconWidget: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: SvgPicture.asset(
              Assets.comReelIcon,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          count: reel.commentCount.toString(),
          onTap: () {
            ManageVibration.vibrate();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.read<PreloadBloc>().pauseCurrent();
              context.push(Routes.LOGIN);
            } else {
              _handleCommentAction(
                context,
              );
            }
          },
        ),
        const SizedBox(height: 16),

        // Bookmark Icon

        // Share Icon (Reversed)
        _buildReactionButton(
          context: context,
          iconWidget: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Image.asset(
              Assets.facebookShare,
              color: Colors.white,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          count: reel.shareCount.toString(),
          isReversed: true,
          onTap: () {
            ManageVibration.vibrate();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.read<PreloadBloc>().pauseCurrent();
              context.push(Routes.LOGIN);
            } else {
              showModalBottomSheet(
                context: context,
                backgroundColor:
                    context.isDarkMode ? Colors.grey[900] : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  side: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                builder: (context) {
                  return ShareCountBottomSheet();
                },
              );

              // if (!serviceLocator<UserCubit>().isLoggedIn) {
              // context.read<PreloadBloc>().pauseTheVideo();
              //   context.push(Routes.LOGIN);
              // } else {
              //   _handleShareAction(context, reel.videoMedia);
              // }
            }
          },
        ),
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: IconButton(
            icon: Icon(
              color: Colors.white,
              Icons.more_horiz,
              size: 25,
            ),
            onPressed: () {
              ManageVibration.vibrate();
              showDialog(
                context: context,
                barrierColor: Colors.transparent, // يخلي الخلفية شفافة
                builder: (context) {
                  return Align(
                    alignment: Alignment.bottomRight, // 👈 الجنب الشمال
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 50.0, bottom: 100.0), // 👈 مسافة من الشمال
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.bookmark_border,
                                  color: Colors.white),
                              onPressed: () {
                                ManageVibration.vibrate();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.flag_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                ManageVibration.vibrate();
                                Navigator.pop(context);
                                if (!serviceLocator<UserCubit>().isLoggedIn) {
                                  context.read<PreloadBloc>().pauseCurrent();
                                  context.push(Routes.LOGIN);
                                } else {
                                  _showReportBottomSheet(context);
                                }
                              },
                            ),
                            SvgPicture.asset(
                              Assets.whatsIcon,
                              color: Colors.white,
                            ),
                            const Text(
                              'Send',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              //   showModalBottomSheet(
              //     context: context,
              //     builder: (context) {
              //       return Container(
              //         width: double.infinity,
              //         padding: const EdgeInsets.symmetric(horizontal: 20),
              //         height: 80,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             _buildReactionButton(
              //               context: context,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               iconWidget: Icon(
              //                 Icons.report,
              //                 size: iconSize,
              //                 color: Colors.white,
              //                 shadows: iconShadows,
              //               ),
              //               count: LocaleKeys.report.localize,
              //               onTap: () {
              ManageVibration.vibrate();
              //                 if (!serviceLocator<UserCubit>().isLoggedIn) {
              //                   context.read<PreloadBloc>().pauseTheVideo();
              //                   context.push(Routes.LOGIN);
              //                 } else {
              //                   _showReportBottomSheet(context);
              //                 }
              //               },
              //             ),
              //             const Sizer(),
              //             _buildReactionButton(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               iconWidget: Icon(
              //                 Icons.bookmark,
              //                 size: iconSize,
              //                 color: reel.saveCount == 0
              //                     ? Colors.white
              //                     : Colors.yellowAccent,
              //                 shadows: iconShadows,
              //               ),
              //               count: LocaleKeys.save.localize,
              //               onTap: () {
              ManageVibration.vibrate();
              //                 if (!serviceLocator<UserCubit>().isLoggedIn) {
              //                   context.read<PreloadBloc>().pauseTheVideo();
              //                   context.push(Routes.LOGIN);
              //                 } else {
              //                   _handleSaveAction(context, reelsCubit);
              //                 }
              //               },
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   );
            },
          ),
        ),
        RotatingCircularButton(
          reel: reel,
          rotationController: rotationController,
        ),
        const SizedBox(height: 50),
        // SvgPicture.asset(
        //   Assets.volumeIcon,
        //   width: 24,
        //   height: 24,
        //   color: Colors.white,
        //   fit: BoxFit.cover,
        // ),
        // const SizedBox(height: 8),
      ],
    );
  }

  Widget likeWidget() {
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        return _buildReactionButton(
          context: context,
          iconWidget: SvgPicture.asset(
            Assets.loveIcon,
            width: 25,
            height: 23.75,
            color: Colors.white,
            fit: BoxFit.cover,
          ),
          count: reel.likeCount.toString(),
          onTap: () {
            ManageVibration.vibrate();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.read<PreloadBloc>().pauseCurrent();
              context.push(Routes.LOGIN);
            } else {
              _handleLikeAction(context, context.read<ReelsCubit>());
            }
          },
        );
      },
    );
  }

  // Helper widget for building reaction buttons with scaling animation
  Widget _buildReactionButton(
      {required Widget iconWidget,
      required VoidCallback onTap,
      required BuildContext context,
      required String count,
      bool isReversed = false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    final Widget animatedIcon = iconWidget.animate().scale(duration: 200.ms);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            isReversed
                ? Directionality(
                    textDirection: TextDirection.rtl,
                    child: animatedIcon,
                  )
                : animatedIcon,
            const SizedBox(height: 8),
            Text(
              count,
              style: countTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLikeAction(BuildContext context, ReelsCubit cubit) async {
    log("LSdkjflskdjflskdjflsdf l");
    try {
      await cubit.likeReel(reel.id).then((_) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          reel.likeCount++;
        } else if (response?.message == "Reel unlike successfully") {
          // if (reel.likeCount > 0) reel.likeCount--;
          reel.likeCount--;
        }
      });

      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  Future<void> _handleCommentAction(
    BuildContext context,
    //  ReelsCubit cubit,
  ) async {
    try {
      await showCommentsBottomSheet(
        context,
        reel: reel,
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Error showing comments: $e',
      );
    }
  }

  Future<void> _handleShareAction(BuildContext context, String videoUrl) async {
    await Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.saveReel(reel.id);
      final response = cubit.state.reelSaveResponse;
      if (response?.message == "saved successfully") {
        reel.saveCount++;
      } else if (response?.message == "unsaved successfully") {
        if (reel.saveCount > 0) reel.saveCount--;
      }
      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error saving reel: $e');
    }
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: reel.user.id,
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showGiftBottomSheet(BuildContext context) async {
    await showGiftBottomSheet(context, receiverId: "widget.receiverId");
  }
}
