import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/shared/tiktok_option_sheet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../social_media/reels/presentation/pages/recording/recording_shared.dart';

class AdvancedTikTokTabBar extends StatefulWidget {
  const AdvancedTikTokTabBar({super.key});

  @override
  _AdvancedTikTokTabBarState createState() => _AdvancedTikTokTabBarState();
}

class _AdvancedTikTokTabBarState extends State<AdvancedTikTokTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  int get generateRandom9DigitNumber {
    Random random = Random();
    // Generate a number between 100000000 and 999999999
    return 100000000 + random.nextInt(900000000);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Container(
          //               alignment: Alignment.centerLeft,
          //               // color: Colors.red,
          //               child: IconButton(
          //                   onPressed: () {
          //                     if (context.read<ReelsCubit>().state.controllers[
          //                             context
          //                                 .read<ReelsCubit>()
          //                                 .state
          //                                 .focusedIndex] !=
          //                         null) {
          //                       context
          //                           .read<ReelsCubit>()
          //                           .state
          //                           .controllers[context
          //                               .read<ReelsCubit>()
          //                               .state
          //                               .focusedIndex]
          //                           ?.pause();
          //                     }
          //                     context.read<ReelsCubit>().resetFocusedIndex(
          //                         context.read<ReelsCubit>().state.focusedIndex);
          //                     Navigator.pop(context);
          //                   },
          //                   icon: Icon(
          //                     Icons.arrow_back_ios,
          //                     size: 0.08.sw,
          //                     color: Colors.white,
          //                     shadows: const [
          //                       Shadow(
          //                         color: Colors.black,
          //                         offset: Offset(1, 1),
          //                         blurRadius: 5.0,
          //                       )
          //                     ],
          //                   )
          //                   )
          //                   ),
          //           Sizer(),
          //           // Icon(Icons.volume_off)
          //         ],
          //       ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildLiveIcon(onTap: () {
                AdInterstitialTop.loadIntersitialAd();
                AdInterstitialTop.showInterstitialAd();
                if (context
                    .read<ReelsCubit>()
                    .state
                    .controllers[context.read<ReelsCubit>().state.focusedIndex]!
                    .value
                    .isPlaying) {
                  context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]
                      ?.pause();
                }
                if (context.isUserLoggedIn) {
                  showTiktokOption(context, generateRandom9DigitNumber);
                } else {
                  pleaseLoginDialog(context);
                  // context.go(Routes.LOGIN);
                }
              }),
              const Sizer(
                height: 50,
              ),
              Image.asset(
                Assets.volumeOff,
                color: Colors.white,
                width: 15,
                height: 15,
              ),
              Image.asset(
                Assets.volumeOn,
                color: Colors.white,
                width: 20,
                height: 20,
              )
            ],
          ),
          Row(
            children: [
              _buildTab(LocaleKeys.Spotlight.localize, 0, onTap: () {
                if (context
                    .read<ReelsCubit>()
                    .state
                    .controllers[context.read<ReelsCubit>().state.focusedIndex]!
                    .value
                    .isPlaying) {
                  context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]
                      ?.pause();
                }
                setState(() {
                  _selectedIndex = 0;
                });
                context.push(Routes.SPOTLIGHT);
              }),
              // Following Tab
              _buildTab(LocaleKeys.snap.localize, 1, onTap: () {
                AdInterstitialTop.loadIntersitialAd();
                AdInterstitialTop.showInterstitialAd();
                if (context
                    .read<ReelsCubit>()
                    .state
                    .controllers[context.read<ReelsCubit>().state.focusedIndex]!
                    .value
                    .isPlaying) {
                  context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]
                      ?.pause();
                }
                setState(() {
                  _selectedIndex = 1;
                });
                context.push(Routes.SNAP);
              }),

              // For You Tab with rounded underline
              _buildTab("Reel", 2, onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReelsRecordingScreen(),
                  ),
                );
              }),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.push(Routes.Tinder);
            },
            child: const Icon(
              Icons.search,
              size: 40,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // LIVE Icon with Glow Effect

              const Sizer(),

              const Spacer(), // Explore Tab

              const Spacer(),
              // Search Icon with custom SVG
              _buildSearchIcon(onTap: () {
                if (context
                    .read<ReelsCubit>()
                    .state
                    .controllers[context.read<ReelsCubit>().state.focusedIndex]!
                    .value
                    .isPlaying) {
                  context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]
                      ?.pause();
                }
                context.push(Routes.Tinder);
              }),
              const Sizer(),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Live Icon with Glow Effect
  Widget _buildLiveIcon({required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 0.07.sw,
        width: 0.07.sw,
        child: Stack(
          children: [
            // Shadow layer
            Transform.translate(
              offset: const Offset(1, 1), // Adjust the offset as neede
              child: ImageFiltered(
                enabled: true,
                imageFilter: ImageFilter.blur(
                  sigmaX: 0.0,
                  sigmaY: 1.5,
                ),
                child: SvgPicture.asset(
                  'assets/images/live_icon.svg',
                  color: Colors.black87, // Shadow color
                  width: 70.w,
                  height: 70.w,
                ),
              ),
            ),
            // Actual SVG
            SvgPicture.asset(
              'assets/images/live_icon.svg',
              color: Colors.white,
              width: 70.w,
              height: 70.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index,
      {bool hasUnderline = false, required VoidCallback? onTap}) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0, left: 4.0, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 5.0,
                  )
                ],
              ),
            ),
            // Rounded Underline effect for selected tab
            if (hasUnderline || isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(top: 6.0),
                height: 3.0,
                width: 35.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 5.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(top: 6.0),
                height: 3.0,
                width: 35.0,
              ),
          ],
        ),
      ),
    );
  }

  // Custom Search Icon with Glow Effect
  Widget _buildSearchIcon({required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Icon(
          size: 0.06.sw,
          FontAwesomeIcons.magnifyingGlass,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 5.0,
            )
          ],
        ),
      ),
    );
  }
}
