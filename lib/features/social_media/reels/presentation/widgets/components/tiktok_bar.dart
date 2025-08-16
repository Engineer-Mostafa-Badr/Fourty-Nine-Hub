import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../ads/interstitial_ad_model.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../controllers/explore_reels_cubit/reel_cubit.dart';
import '../../controllers/preload_cubit/preload_bloc.dart';
import '../../shared/tiktok_option_sheet.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../pages/recording/recording_shared.dart';
import '../../../../../../helpers/manage_vibration.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                if (context.read<ReelsCubit>().state.controllers[
                        context.read<ReelsCubit>().state.focusedIndex] !=
                    null) {
                  context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]
                      ?.pause();
                }
                // context.read<ReelsCubit>().resetFocusedIndex(
                //     context.read<ReelsCubit>().state.focusedIndex);
                Navigator.pop(context);
              },
              child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.white,
                  )),
            ),
            Row(
              children: [
                _buildTab(LocaleKeys.Spotlight.localize, 0, onTap: () {
                  ManageVibration.vibrate();
                  if (context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]!
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
                  context.pushNamed(Routes.SPOTLIGHT);
                }),
                SizedBox(width: 16),
                // Following Tab
                _buildTab(LocaleKeys.snap.localize, 1, onTap: () {
                  ManageVibration.vibrate();
                  AdInterstitialTop.loadIntersitialAd();
                  AdInterstitialTop.showInterstitialAd();
                  if (context
                      .read<ReelsCubit>()
                      .state
                      .controllers[
                          context.read<ReelsCubit>().state.focusedIndex]!
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
                  context.pushNamed(Routes.SNAP);
                }),
                SizedBox(width: 16),
                // For You Tab with rounded underline
                _buildTab("Reel", 2, onTap: () {
                  ManageVibration.vibrate();
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
            _buildLiveIcon(onTap: () {
              ManageVibration.vibrate();
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
                    .controllers[context.read<ReelsCubit>().state.focusedIndex]
                    ?.pause();
              }
              if (context.isUserLoggedIn) {
                showTiktokOption(context, generateRandom9DigitNumber);
              } else {
                return pleaseLoginDialog(context);
                // context.pushNamed(Routes.LOGIN);
              }
            }, onBackTap: () {
              context.pop();
            }),
          ],
        ),
        SizedBox(height: 18),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Icon(
            Icons.volume_mute,
            color: AppColors.whiteColor,
            size: 30,
          ),
        )

        // Image.asset(
        //   Assets.volumeOff,
        //   color: Colors.white,
        //   width: 15,
        //   height: 15,
        // ),
        // Image.asset(
        //   Assets.volumeOn,
        //   color: Colors.white,
        //   width: 20,
        //   height: 20,
        // )
      ],
    );
  }

  // Custom Live Icon with Glow Effect
  Widget _buildLiveIcon(
      {required VoidCallback? onTap, required VoidCallback? onBackTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        Assets.liveReel,
        color: Colors.white,
        fit: BoxFit.cover,
        width: 30,
        height: 30,
      ),

      //  Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     Transform.translate(
      //       offset: const Offset(1, 1),
      //       child: ImageFiltered(
      //         imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 1.5),
      //         child: SvgPicture.asset(
      //           Assets.liveReel,
      //           color: Colors.black87,
      //           width: 50.w,
      //           height: 50.w,
      //         ),
      //       ),
      //     ),
      //     SvgPicture.asset(
      //       Assets.liveReel,
      //       color: Colors.white,
      //       width: 50.w,
      //       height: 50.w,
      //     ),
      //   ],
      // ),
      // ),
    );
  }

  Widget _buildTab(String text, int index,
      {bool hasUnderline = false, required VoidCallback? onTap}) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.white : AppColors.grey300,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                wordSpacing: 1.4),
          ),
          // Rounded Underline effect for selected tab
          if (hasUnderline || isSelected)
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(top: 4.0),
              height: 3.0,
              width: 34.0,
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: const [
                //   BoxShadow(
                //     color: Colors.black,
                //     offset: Offset(1, 1),
                //     blurRadius: 5.0,
                //   )
                // ],
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 3.0,
              width: 34.0,
            ),
        ],
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
