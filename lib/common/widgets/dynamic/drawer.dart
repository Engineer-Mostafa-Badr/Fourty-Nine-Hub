import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dialogs/soon_dialog.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/service/storage.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/custom_show_dialog.dart';
import '../../../core/widget/custom_switch_button.dart';
import '../../../features/authentication/presentation/widgets/log_out_widget.dart';
import '../../../features/competition/presentation/cubit/competition_cubit/competition_cubit.dart';
import '../../../features/competition/presentation/cubit/competition_cubit/competition_state.dart';
import '../../../features/competition/presentation/view/special_ads_view.dart';
import '../../../features/custom_page/presentation/cubit/custom_page_cubit.dart';
import '../../../features/settings/presentation/cubit/choice_ruler_cubit.dart';
import '../../../features/settings/presentation/cubit/floating_navigator_cubit.dart';
import '../../../features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import '../../../features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/const.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
import '../../theme/cubit/cubit.dart';
import '../../theme/cubit/states.dart';
import '../stateless/buttons/iconAppButton.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var widgejsonData;
  bool hasVibration = false;
  @override
  void initState() {
    initVibrationValue();
    AdInterstitialTop.loadIntersitialAd();
    super.initState();
  }

  initVibrationValue() async {
    bool vibration = await Storage.getVibrationValue();
    setState(() {
      hasVibration = vibration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, BasicState<UserEntity>>(
      builder: (context, state) {
        // context.read<GetWalletCubit>();
        return Drawer(
          width: 600.w,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // context
                        //     .read<UserCubit>()
                        //     .isLoggedIn
                        //     ? _buildAccountHeader(
                        //   context: context,
                        //   user: state.data,
                        // )
                        //     : _buildLoginWidget(context: context),
                        context.read<UserCubit>().isLoggedIn
                            ? accountWidget(
                                context: context, user: UserCubit.to.state.data)
                            : _buildLoginWidget(context: context),
                        Divider(
                          color: context.isDarkMode
                              ? Color(0xff333333)
                              : Color(0xffD9D9D9),
                        ),
                        Column(
                          children: [
                            competitionSubscription(context: context),
                            drawerListTile(
                                image: Assets.customPage,
                                label: LocaleKeys.customPage.localize,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  if (!context.read<UserCubit>().isLoggedIn) {
                                    return pleaseLoginDialog(context);
                                  }
                                  AdInterstitialTop.loadIntersitialAd();
                                  AdInterstitialTop.showInterstitialAd();
                                  var currentContext = AppPages
                                      .router
                                      .configuration
                                      .navigatorKey
                                      .currentContext!;
                                  currentContext.pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditPage(),
                                    ),
                                  );
                                }),
                            if (context.read<UserCubit>().isLoggedIn)
                              drawerListTile(
                                  image: Assets.changePassword,
                                  label: LocaleKeys.changePassword.localize,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    context
                                        .pushNamed(Routes.CHANGEPASSWORDSECOND);
                                  }),

                            // drawerListTile(
                            //   // icon: Icons.settings,
                            //     image: Assets.settings_icon,
                            //     label: LocaleKeys.settings.localize,
                            //     onTap: () {
                            //       ManageVibration.vibrate();
                            //       context.pop();
                            //       context.push(Routes.SETTINGS);
                            //     }),
                            // drawerListTile(
                            //     // icon: Icons.privacy_tip,
                            //     image: Assets.privacy_icon,
                            //     label: LocaleKeys.privacy.localize,
                            //     onTap: () {

                            //       if (!context.read<UserCubit>().isLoggedIn) {
                            //         return pleaseLoginDialog(context);
                            //       } else {
                            //         AdInterstitialTop.loadIntersitialAd();
                            //         AdInterstitialTop.showInterstitialAd();
                            //
                            //         context.pop();
                            //         context.push(Routes.PRIVACY);
                            //       }
                            //     },),
                            drawerListTile(
                                image: Assets.privacy_icon,
                                label: LocaleKeys.privacy.localize,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  AdInterstitialTop.loadIntersitialAd();
                                  AdInterstitialTop.showInterstitialAd();

                                  context.pop();
                                  context.push(
                                      context.read<UserCubit>().isLoggedIn
                                          ? Routes.PRIVACY
                                          : Routes.FirstLoginScreen);
                                }),

                            drawerListTile(
                                image: Assets.policy,
                                label: LocaleKeys.policies.localize,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  AdInterstitialTop.loadIntersitialAd();
                                  AdInterstitialTop.showInterstitialAd();
                                  context.pop();
                                  return context.push(Routes.POLICY,
                                      extra: false);
                                }),
                            drawerListTile(
                                // icon: Icons.share,
                                image: Assets.share_app_icon,
                                label: LocaleKeys.shareApp.localize,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  if (!context.read<UserCubit>().isLoggedIn) {
                                    return pleaseLoginDialog(context);
                                  }
                                  context.pop();
                                  context.push(Routes.SHAREAPP);
                                }),
                            drawerListTile(
                                // icon: Icons.message,
                                image: Assets.contact_us_icon,
                                label: LocaleKeys.contactUs.localize,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  if (!context.read<UserCubit>().isLoggedIn) {
                                    return pleaseLoginDialog(context);
                                  }
                                  context.pop();
                                  context.push(Routes.CONTACTUS);
                                }),
                            drawerListTile(
                                // icon: Icons.logout,
                                image: Assets.sign_out_icon,
                                requireLogin: true,
                                label: LocaleKeys.logout.localize,
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  String? refreshToken =
                                      await Storage.getRefreshToken();
                                  print("refreshToken $refreshToken");
                                  // context.push(Routes.LOGIN);
                                  showAnimatedDialog(
                                    context,
                                    AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .drawerTheme
                                          .backgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: const LogoutWidget(),
                                    ),
                                  );
                                }),
                            drawerListTile(
                                // icon: Icons.logout,
                                image: Assets.deleteAccount,
                                requireLogin: true,
                                label: LocaleKeys.deleteAccount.localize,
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  context.read<SettingCubit>().deleteAccount();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool("ISLOGIN", false);
                                  context.go(Routes.HOME);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: 12.h,
                      start: 0,
                      top: 15.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        drawerRollWidget(
                            image: Assets.quran,
                            label: LocaleKeys.quraan.localize,
                            onTap: () {
                              ManageVibration.vibrate();
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              context.pop();
                              context.push(Routes.QURAAN);
                            }),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                            image: Assets.azkar,
                            label: LocaleKeys.azkar.localize,
                            onTap: () {
                              ManageVibration.vibrate();
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              context.pop();
                              context.push(Routes.AZKAAR);
                            }),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                            label: LocaleKeys.ride.localize,
                            image: Assets.rideIcon,
                            onTap: () {
                              ManageVibration.vibrate();
                              context.pop();
                              context.push(Routes.RIDE_HOME);
                            }),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                            label: LocaleKeys.tripJoin.localize,
                            image: Assets.newTripJoin,
                            onTap: () {
                              ManageVibration.vibrate();
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              HandleCashback.setCount('tripJoinCount', context);
                              context.push(context.read<UserCubit>().isLoggedIn
                                  ? Routes.newRideModeScreen
                                  : Routes.FirstLoginScreen);
                            }),
                        SizedBox(
                          height: 8.h,
                        ),
                        // drawerRollWidget(
                        //   label: LocaleKeys.loading.localize,
                        //   image: Assets.loading,
                        //   // onTap: () {},
                        //   onTap: () {
                        //     context.pop();
                        //     context
                        //         .push(Routes.createLoadingTripScreen);
                        //   },
                        // ),
                        drawerRollWidget(
                          label: LocaleKeys.health.localize,
                          image: Assets.healthIcon,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.VISITA);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.meal.localize,
                          image: Assets.meal,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.FOOD);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.marriage.localize,
                          image: Assets.married,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.MARRIAGESUBCATEGORIES);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.tube.localize,
                          image: Assets.tube1,
                          onTap: () {
                            ManageVibration.vibrate();
                            AdInterstitialTop.loadIntersitialAd();
                            AdInterstitialTop.showInterstitialAd();
                            HandleCashback.setCount('beAStarCount', context);
                            context.push(Routes.BE_STAR);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.find.localize,
                          image: Assets.find,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.Tinder);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.reel.localize,
                          image: Assets.reel,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.REELS);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        // drawerRollWidget(
                        //   label: LocaleKeys.spotlight.localize,
                        //   image: Assets.spotlight,
                        //   onTap: () {
                        //     ManageVibration.vibrate();
                        //     if (!context.read<UserCubit>().isLoggedIn) {
                        //       return pleaseLoginDialog(context);
                        //     }
                        //     context.pop();
                        //     context.push(Routes.SPOTLIGHT);
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // // drawerRollWidget(
                        // //   label: LocaleKeys.meet.localize,
                        // //   image: Assets.meet,
                        // //   onTap: () {

                        // //     context.pop();
                        // //     context.push(Routes.MEETINGROOM);
                        // //   },
                        // // ),
                        // drawerRollWidget(
                        //   label: LocaleKeys.live.localize,
                        //   image: Assets.liveIcon,
                        //   onTap: () {
                        //     ManageVibration.vibrate();
                        //     if (!context.read<UserCubit>().isLoggedIn) {
                        //       return pleaseLoginDialog(context);
                        //     }
                        //     context.pop();
                        //     context.push(Routes.LIVE);
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // drawerRollWidget(
                        //   label: LocaleKeys.snap.localize,
                        //   image: Assets.snap,
                        //   onTap: () {
                        //     context.pop();
                        //     context.push(Routes.SNAP);
                        //   },
                        // ),

                        drawerRollWidget(
                          label: LocaleKeys.chat.localize,
                          image: Assets.whatsApp,
                          onTap: () {
                            ManageVibration.vibrate();
                            if (!context.read<UserCubit>().isLoggedIn) {
                              return pleaseLoginDialog(context);
                            }
                            context.pop();
                            context.push(Routes.CHAT, extra: ChatsViewParams());
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: context.isArabic ? 'العاب' : "Games",
                          image: Assets.gamesIcon,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            soonDialog(context);
                            // context.push(Routes.CHAT,
                            //     extra: ChatsViewParams());
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.ads.localize,
                          image: Assets.spcialAdsIcon,
                          isSvg: true,
                          onTap: () {
                            ManageVibration.vibrate();
                            context.pop();
                            context.push(Routes.CREATECOMPANYAD);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: context.isArabic ? 'المزاد' : "Auction",
                          image: Assets.bidIcon,
                          onTap: () {
                            ManageVibration.vibrate();
                            if (!context.read<UserCubit>().isLoggedIn) {
                              return pleaseLoginDialog(context);
                            }
                            context.pop();
                            context.push(Routes.availableAuctionScreen);
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.chance.localize,
                          image: Assets.chanceIcon,
                          onTap: () {
                            ManageVibration.vibrate();
                            if (!context.read<UserCubit>().isLoggedIn) {
                              return pleaseLoginDialog(context);
                            }
                            context.pop();
                            context.push(Routes.CHANCE);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginWidget({
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    IconAppButton(
                      width: 100.h,
                      height: 100.h,
                      isCircle: true,
                      backColor: Colors.red.withValues(alpha: 0.1),
                      icon: Icons.person,
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      onPressed: () {
                        context.pop();
                        context.push(Routes.LOGIN);
                      },
                    ),
                    Label(
                      text: LocaleKeys.login.localize,
                      style: Styles.mediumText(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconAppButton(
                        width: 100.h,
                        height: 100.h,
                        isCircle: true,
                        icon: Icons.person_add,
                        backColor: Colors.red.withValues(alpha: 0.1),
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        onPressed: () {
                          context.pop();
                          context.push(Routes.REGISTER);
                        }),
                    Label(
                      text: LocaleKeys.register.localize,
                      style: Styles.mediumText(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSwitchButton(
                value: hasVibration,
                onChanged: (value) async {
                  Storage.setVibrationValue(value);
                  setState(() {
                    hasVibration = value;
                  });
                },
              ),
              SizedBox(
                width: 4.w,
              ),
              Label(text: context.isArabic ? "اهتزاز" : "Vibration"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountHeader({
    required BuildContext context,
    required UserEntity? user,
  }) {
    log(user?.id.toString() ?? "UserId", name: "UserId");
    return Column(
      children: [
        accountWidget(context: context, user: user),
        const Divider(
          color: Colors.grey,
        ),
        BlocProvider<CompetitionCubit>(
          create: (BuildContext context) =>
              serviceLocator()..fetchCompetition(),
          child: BlocBuilder<CompetitionCubit, CompetitionState>(
            builder: (BuildContext context, state) {
              if (state.status == CompetitionStates.success) {
                int calculateSumOfRequests() {
                  // Create a list of indices, excluding 0, 9, and 10
                  List<int> indicesToSum = List.generate(
                          state.competition?.length ?? 0, (index) => index)
                      .where((index) => index != 0 && index != 9 && index != 10)
                      .toList();

                  // Use fold to sum the values, ensuring all operations return an int
                  return indicesToSum.fold<int>(0, (int sum, int index) {
                    return sum +
                        (state.competition?[index].countOfRequest ?? 0).toInt();
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      child: Text(
                        LocaleKeys.competitions.localize,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // Evenly distribute space
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align items at the start
                      children: [
                        state.competition?[10].nameEn != null
                            ? counterItem(
                                icon: Icons.ads_click,
                                label: LocaleKeys.specialAds.localize,
                                value:
                                    '${state.competition?[10].countOfRequest}',
                                onTap: () {
                                  ManageVibration.vibrate();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SpecialAdsView()),
                                  );
                                },
                                context: context,
                              )
                            : const SizedBox.shrink(),
                        state.competition?[0].nameEn != null
                            ? counterItem(
                                icon: Icons.person_add,
                                label: LocaleKeys.friends.localize,
                                value:
                                    '${state.competition?[0].countOfRequest}',
                                onTap: () {
                                  ManageVibration.vibrate();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SpecialAdsView()),
                                  );
                                },
                                context: context,
                              )
                            : const SizedBox.shrink(),
                        state.competition?[9].nameEn != null
                            ? counterItem(
                                icon: FontAwesomeIcons.car,
                                label: LocaleKeys.ride.localize,
                                value:
                                    '${state.competition?[9].countOfRequest}',
                                context: context,
                                onTap: () {
                                  ManageVibration.vibrate();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SpecialAdsView()),
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                        state.competition != null
                            ? counterItem(
                                icon: Icons.more_horiz,
                                label: LocaleKeys.more.localize,
                                value: '${calculateSumOfRequests()}',
                                onTap: () {
                                  ManageVibration.vibrate();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SpecialAdsView()),
                                  );
                                },
                                context: context,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  // Widget walletCircularProgress({
  Widget drawerListTile(
      {IconData? icon,
      required String label,
      String? description,
      String? image,
      bool requireLogin = false,
      required Function onTap}) {
    if (requireLogin && !AuthHelper().isLoggedIn()) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: InkWell(
        onTap: () {
          ManageVibration.vibrate();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
              top: 10.0, bottom: 5.0, start: 16),
          child: Row(
            children: [
              image != null && icon == null
                  ? Image.asset(
                      image,
                      width: image == Assets.contact_us_icon ? 35.h : 40.h,
                      height: image == Assets.contact_us_icon ? 35.h : 40.h,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      icon,
                      size: 45.w,
                      color: AppColors.PRIMARY_COLOR,
                    ),
              const Sizer(),
              Label(
                  text: label,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  )),
              if (description != null)
                Label(
                    text: description,
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w300,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    )),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 28.w,
              ),
            ],
          ),
        ),
      ),
      // ListTile(
      //   onTap: () => onTap(),
      //   leading: image != null && icon == null
      //       ? Image.asset(
      //           image,
      //           width: image == Assets.contact_us_icon ? 35.h : 40.h,
      //           height: image == Assets.contact_us_icon ? 35.h : 40.h,
      //           fit: BoxFit.cover,
      //         )
      //       : Icon(
      //           icon,
      //           size: 45.w,
      //           color: AppColors.PRIMARY_COLOR,
      //         ),
      //   title: Label(
      //       text: label,
      //       style: Styles.mediumText(
      //         fontWeight: FontWeight.w500,
      //         color: context.isDarkMode ? Colors.white : Colors.black,
      //       )),
      //   subtitle: (description != null)
      //       ? Label(
      //           text: description,
      //           style: Styles.mediumText(
      //             fontWeight: FontWeight.w300,
      //             color: context.isDarkMode ? Colors.white : Colors.black,
      //           ))
      //       : null,
      //   trailing: Icon(
      //     Icons.arrow_forward_ios,
      //     size: 28.w,
      //   ),
      // ),
    );
  }

  Widget drawerRollWidget(
      {required String label,
      required String image,
      bool? isSvg = false,
      required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          if (isSvg != true)
            Image.asset(
              image,
              width: 35.h,
              height: 35.h,
              fit: BoxFit.cover,
            ),
          if (isSvg == true)
            SvgPicture.asset(
              image,
              width: 35.h,
              height: 35.h,
              fit: BoxFit.cover,
            ),
          const SizedBox(
            height: 4,
          ),
          Label(
            text: label,
            style: Styles.mediumText(
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget competitionSubscription({required BuildContext context}) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        if (context.read<UserCubit>().isLoggedIn) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          currentContext.pop();
          context.go(Routes.LUCKYWHEEL);
        } else {
          return pleaseLoginDialog(context);

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Dialog(
          //       insetPadding: const EdgeInsets.all(20),
          //       child: Container(
          //         width: 350,
          //         height: 400,
          //         padding: const EdgeInsets.all(16),
          //         child: Column(
          //           children: [
          //             const CustomNotLogged(),
          //             const SizedBox(
          //               height: 10,
          //             ),
          //             AppButton(
          //                 color: AppColors.LIGHT_COLOR,
          //                 backColor: AppColors.PRIMARY_COLOR_DARK,
          //                 label: "Cancel",
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 }),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: context.isDarkMode ? Color(0xff333333) : Color(0xffD9D9D9)),
        child: Row(
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: kToolbarHeight,
              child: Image.asset(
                context.isDarkMode ? Assets.spinWheelDark : Assets.spinWheel,
                // height: kToolbarHeight,
                // width: kToolbarHeight,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Label(
                      text: LocaleKeys.luckyWheel.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.QUANTITY_COLOR)),
                  Label(
                      text: LocaleKeys.feelLucky.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.w400,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.QUANTITY_COLOR)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget counterItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    required Function onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ManageVibration.vibrate();
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80.r, // Fixed width for CircleAvatar
              height: 80.r, // Fixed height for CircleAvatar
              child: CircleAvatar(
                backgroundColor: AppColors.GREY_BORDER_COLOR,
                radius: 40.r, // Radius to fit within the Container
                child: Icon(
                  icon,
                  size: 30.sp,
                  color: AppColors.QUANTITY_COLOR,
                ),
              ),
            ),
            Text(
              value,
              style: Styles.smallText(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Text(
                label,
                style: Styles.smallText(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountWidget({
    required BuildContext context,
    required UserEntity? user,
  }) {
    print("Test User ${user?.firstName}");
    // context.read<GetWalletCubit>();
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: kToolbarHeight * 2.5.h,
                width: kToolbarHeight * 2.5.w,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Positioned.fill(
                      child: BlocConsumer<UserCubit, BasicState>(
                        listener: (context, state) {
                          // if(state.isSuccess){
                          //   context.pop();
                          //   showSuccessMessage(context, 'Picture Uploaded Successfully');
                          // }
                          // if(state.isError){
                          //   showErrorMessage(context, state.failure.toString());
                          // }
                        },
                        builder: (context, state) {
                          if (state.isLoading) {
                            //create circle shimmer

                            Shimmer.fromColors(
                              baseColor: Colors.amber,
                              highlightColor: Colors.black,
                              child: CircleAvatar(
                                child: Container(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                          return ClickableWidget(
                            onTap: () {
                              ManageVibration.vibrate();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageGalleryPage(
                                    images: [
                                      user?.profilePicture ??
                                          UIConst.profilePlaceHolder
                                    ],
                                    initialIndex: 0,
                                  ),
                                ),
                              );
                            },
                            child: ImageFromInternet(
                              isCircle: true,
                              image: user?.profilePicture ??
                                  UIConst.profilePlaceHolder,
                              fit: BoxFit.fill,
                              border: Border.all(
                                  color: AppColors.GRAY_LIGHT_COLOR3),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () async {
                          ManageVibration.vibrate();
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          }
                          bottomSheet(
                            context: context,
                            asAlertDialog: true,
                            isDismissible: false,
                            backColor:
                                context.isDarkMode ? Color(0xff0D0D0D) : null,
                            widget: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: context.isDarkMode
                                        ? Color(0xff131313)
                                        : HexColor('f9f9f9'),
                                  ),
                                  child: ListTile(
                                    leading: SvgPicture.asset(
                                      context.isDarkMode
                                          ? Assets.drawerGalleryIconDark
                                          : Assets.drawerGalleryIcon,
                                    ),
                                    title: Label(
                                      text: LocaleKeys.gallery.localize,
                                    ),
                                    onTap: () async {
                                      ManageVibration.vibrate();
                                      await context
                                          .read<UserCubit>()
                                          .uploadPhoto(
                                              isGallery: true,
                                              context: context);
                                      // Reload user data if needed
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: context.isDarkMode
                                        ? Color(0xff131313)
                                        : HexColor('f9f9f9'),
                                  ),
                                  child: ListTile(
                                    // leading: const Icon(Icons.camera_alt),
                                    leading: SvgPicture.asset(
                                      context.isDarkMode
                                          ? Assets.drawerCameraIconDark
                                          : Assets.drawerCameraIcon,
                                    ),
                                    title:
                                        Label(text: LocaleKeys.camera.localize),
                                    onTap: () async {
                                      ManageVibration.vibrate();
                                      await context
                                          .read<UserCubit>()
                                          .uploadPhoto(
                                              isGallery: false,
                                              context: context);
                                      // Reload user data if needed
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: context.isDarkMode
                                          ? Color(0xff333333)
                                          : AppColors.BG_GRAY_COLOR),
                                  child: ListTile(
                                    // leading: const Icon(Icons.camera_alt),
                                    title: Center(
                                      child: Label(
                                        text: LocaleKeys.cancel.localize,
                                        style: Styles.mediumText(
                                          fontSize: 36,
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          height: 1.60,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      ManageVibration.vibrate();
                                      var currentContext = AppPages
                                          .router
                                          .configuration
                                          .navigatorKey
                                          .currentContext!;
                                      currentContext.pop();

                                      // Reload user data if needed
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return Wrap(
                          //       children: <Widget>[
                          //         ListTile(
                          //           leading: const Icon(Icons.photo_library),
                          //           title: const Text('Gallery'),
                          //           onTap: () async {
                          //             // Navigator.pop(context);
                          //             await context.read<UserCubit>().uploadPhoto(
                          //                 isGallery: true, context: context);
                          //             // Reload user data if needed
                          //           },
                          //         ),
                          //         ListTile(
                          //           leading: const Icon(Icons.camera_alt),
                          //           title: const Text('Camera'),
                          //           onTap: () async {
                          //             // Navigator.pop(context);
                          //             await context.read<UserCubit>().uploadPhoto(
                          //                 isGallery: false, context: context);
                          //             // Reload user data if needed
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Sizer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Label(
                            text: _getFirstTwoWords(user?.fullName ?? ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (user?.isDocument ?? false)
                          Icon(
                            Icons.verified,
                            color: AppColors.PRIMARY_COLOR,
                            size: 40.w,
                          ),
                      ],
                    ),
                    // Label(
                    //   text: getUserType(user),
                    //   style: Styles.mediumText(),
                    // ),
                    Sizer(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        // context.push(
                        //   Routes.WALLET,
                        // );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            size: 35.w,
                          ),
                          const Sizer(),
                          Expanded(
                            child: Label(
                              text: FormatNumbers().formatNumberByComma(
                                  user?.wallet.toString() ?? '0',
                                  isArabic: context.isArabic),
                              // text: '${user?.wallet ?? 0}',
                              style: Styles.mediumText(
                                decoration: TextDecoration.underline,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        context.push(Routes.EDITPROFILE);
                        // context.push(
                        //   Routes.WALLET,
                        // );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 25.w,
                          ),
                          const Sizer(),
                          Expanded(
                            child: Label(
                              text: LocaleKeys.edit.localize,
                              // text: '${user?.wallet ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSwitchButton(
                      value: context
                              .read<CustomPageCubit>()
                              .state
                              .activate
                              ?.customPage ??
                          false,
                      onChanged: (value) async {
                        showAnimatedDialog(
                          context,
                          AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Label(
                                    text: LocaleKeys.restartToApply.localize,
                                    style: Styles.headerText(
                                        fontWeight: FontWeight.w400)),
                                const Sizer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        onPressed: () {
                                          var currentContext = AppPages
                                              .router
                                              .configuration
                                              .navigatorKey
                                              .currentContext!;
                                          currentContext.pop();
                                        },
                                        label: LocaleKeys.cancel.localize,
                                      ),
                                    ),
                                    const Sizer(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: AppButton(
                                        backColor: AppColors.PRIMARY_COLOR,
                                        onPressed: () {
                                          context
                                              .read<CustomPageCubit>()
                                              .updateActivate(value);
                                          Restart.restartApp();
                                        },
                                        label: LocaleKeys.restart.localize,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Label(text: context.isArabic ? "مخصصه" : "Custom"),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
                      builder: (context, state) {
                        var floatingNavigatorCubit =
                            context.read<FloatingNavigatorCubit>();
                        return CustomSwitchButton(
                          value: floatingNavigatorCubit.floatingNavigatorEnable,
                          onChanged: (value) async {
                            var currentContext = AppPages.router.configuration
                                .navigatorKey.currentContext!;
                            currentContext.pop();
                            floatingNavigatorCubit
                                .changeFloatingNavigatorEnable();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Label(text: context.isArabic ? "تحكم" : "Control"),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    BlocBuilder<ChoiceRulerCubit, ChoiceRulerState>(
                      builder: (context, state) {
                        var choiceRulerCubit = ChoiceRulerCubit.get(context);
                        return CustomSwitchButton(
                          value: choiceRulerCubit.choiceRulerEnabled,
                          onChanged: (value) async {
                            var currentContext = AppPages.router.configuration
                                .navigatorKey.currentContext!;
                            currentContext.pop();
                            choiceRulerCubit.changeChoiceRulerEnabled();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Label(
                      text: context.isArabic ? "مسطره" : "Ruler",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ThemeCubit, ThemeStates>(
                  builder: (BuildContext context, theme) {
                    var themeCubit = context.read<ThemeCubit>();
                    return Row(
                      children: [
                        CustomSwitchButton(
                          value: themeCubit.isDarkTheme,
                          onChanged: (value) {
                            if (theme is LightThemeModeStates) {
                              ThemeCubit.get(context).darkThemeMode();
                            }
                            if (theme is DarkThemeModeStates) {
                              ThemeCubit.get(context).lightThemeMode();
                            }
                          },
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        themeCubit.isDarkTheme
                            ? Label(
                                text: context.isArabic ? "فاتح" : "Light",
                              )
                            : Label(
                                text: context.isArabic ? "غامق" : "Dark",
                              ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSwitchButton(
                value: hasVibration,
                onChanged: (value) async {
                  Storage.setVibrationValue(value);
                  setState(() {
                    hasVibration = value;
                  });
                },
              ),
              SizedBox(
                width: 4.w,
              ),
              Label(text: context.isArabic ? "اهتزاز" : "Vibration"),
            ],
          )
        ],
      ),
    );
  }

  String _getFirstTwoWords(String fullName) {
    List<String> words = fullName.split(" ");
    print(fullName);
    if (words.isNotEmpty) {
      // Capitalize the first letter of each word
      words = words.map((word) {
        return word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '';
      }).toList();
    }
    return words.length > 1 ? '${words[0]} ${words[1]}' : words[0];
  }

  getUserType(
    UserEntity? user,
  ) {
    if (user?.isDoctor ?? false) {
      return LocaleKeys.doctor.localize;
    } else if (user?.isLoading ?? false) {
      return LocaleKeys.loadingDriver.localize;
    } else if (user?.isRestaurant ?? false) {
      return LocaleKeys.restaurants.localize;
    } else if (user?.isRider ?? false) {
      return LocaleKeys.driver.localize;
    } else {
      return "User";
    }
  }
}
