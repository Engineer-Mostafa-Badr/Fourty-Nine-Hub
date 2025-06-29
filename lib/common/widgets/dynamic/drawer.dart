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
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/custom_show_dialog.dart';
import '../../../core/widget/custom_switch_button.dart';
import '../../../core/widget/custom_text_no_login.dart';
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

  @override
  void initState() {
    AdInterstitialTop.loadIntersitialAd();
    super.initState();
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
                      ? accountWidget(context: context, user: state.data)
                      : _buildLoginWidget(context: context),
                  Divider(
                    color: context.isDarkMode
                        ? Color(0xff333333)
                        : Color(0xffD9D9D9),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              competitionSubscription(context: context),
                              drawerListTile(
                                  image: Assets.customPage,
                                  label: LocaleKeys.customPage.localize,
                                  onTap: () {
                                    if (!context.read<UserCubit>().isLoggedIn) {
                                      return pleaseLoginDialog(context);
                                    }
                                    AdInterstitialTop.loadIntersitialAd();
                                    AdInterstitialTop.showInterstitialAd();
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EditPage(),
                                      ),
                                    );
                                  }),
                              drawerListTile(
                                  image: Assets.quran,
                                  label: LocaleKeys.quraan.localize,
                                  onTap: () {
                                    AdInterstitialTop.loadIntersitialAd();
                                    AdInterstitialTop.showInterstitialAd();
                                    context.pop();
                                    return context.push(Routes.QURAAN);
                                  }),
                              drawerListTile(
                                  image: Assets.azkar,
                                  label: LocaleKeys.azkar.localize,
                                  onTap: () {
                                    AdInterstitialTop.loadIntersitialAd();
                                    AdInterstitialTop.showInterstitialAd();
                                    context.pop();

                                    return context.push(Routes.AZKAAR);
                                  }),
                              drawerListTile(
                                  // icon: Icons.settings,
                                  image: Assets.settings_icon,
                                  label: LocaleKeys.settings.localize,
                                  onTap: () {
                                    context.pop();
                                    context.push(Routes.SETTINGS);
                                  }),
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
                                  image: Assets.policy,
                                  label: LocaleKeys.policies.localize,
                                  onTap: () {
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
                                  onTap: () {
                                    showAnimatedDialog(
                                      context,
                                      AlertDialog(
                                        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        content: const LogoutWidget(),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              drawerRollWidget(
                                  label: LocaleKeys.ride.localize,
                                  image: Assets.rideIcon,
                                  onTap: () {
                                    context.pop();
                                    context.push(Routes.RIDE_HOME);
                                  }),
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
                                  context.pop();
                                  context.push(Routes.VISITA);
                                },
                              ),
                              drawerRollWidget(
                                label: LocaleKeys.meal.localize,
                                image: Assets.meal,
                                onTap: () {
                                  context.pop();
                                  context.push(Routes.FOOD);
                                },
                              ),
                              drawerRollWidget(
                                label: LocaleKeys.marriage.localize,
                                image: Assets.married,
                                onTap: () {
                                  context.pop();
                                  context.push(Routes.MARRIAGESUBCATEGORIES);
                                },
                              ),
                              drawerRollWidget(
                                label: LocaleKeys.find.localize,
                                image: Assets.find,
                                onTap: () {
                                  context.pop();
                                  context.push(Routes.Tinder);
                                },
                              ),
                              drawerRollWidget(
                                label: LocaleKeys.reel.localize,
                                image: Assets.reel,
                                onTap: () {
                                  context.pop();
                                  context.push(Routes.REELS);
                                },
                              ),
                              drawerRollWidget(
                                label: LocaleKeys.spotlight.localize,
                                image: Assets.spotlight,
                                onTap: () {
                                  if(!context.read<UserCubit>().isLoggedIn){
                                    return pleaseLoginDialog(context);
                                  }
                                  context.pop();
                                  context.push(Routes.SPOTLIGHT);
                                },
                              ),
                              // drawerRollWidget(
                              //   label: LocaleKeys.meet.localize,
                              //   image: Assets.meet,
                              //   onTap: () {
                              //     context.pop();
                              //     context.push(Routes.MEETINGROOM);
                              //   },
                              // ),
                              drawerRollWidget(
                                label: LocaleKeys.live.localize,
                                image: Assets.liveIcon,
                                onTap: () {
                                  if(!context.read<UserCubit>().isLoggedIn){
                                    return pleaseLoginDialog(context);
                                  }
                                  context.pop();
                                  context.push(Routes.LIVE);
                                },
                              ),
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
                                  if(!context.read<UserCubit>().isLoggedIn){
                                    return pleaseLoginDialog(context);
                                  }
                                  context.pop();
                                  context.push(Routes.CHAT,
                                      extra: ChatsViewParams());
                                },
                              ),
                            ],
                          ),
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
      child: Row(
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
      padding: EdgeInsets.only(top: 10.h),
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
              top: 12.0, bottom: 12.0, start: 16),
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
      required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 40.h,
            height: 40.h,
            fit: BoxFit.cover,
          ),
          Label(
            text: label,
            style: Styles.mediumText(
              fontWeight: FontWeight.w400,
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
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        if (context.read<UserCubit>().isLoggedIn) {
          Navigator.pop(context);
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
        onTap: () => onTap(),
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
    // context.read<GetWalletCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                            onTap:(){
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
                              border:Border.all(color: AppColors.GRAY_LIGHT_COLOR3),
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
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
                                    await context.read<UserCubit>().uploadPhoto(
                                        isGallery: true, context: context);
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
                                    await context.read<UserCubit>().uploadPhoto(
                                        isGallery: false, context: context);
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
                                    Navigator.pop(context);

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
                        margin: EdgeInsetsDirectional.only(end: 5,bottom: 5),
                        child: Image.asset(
                          Assets.cameraOutlined,
                          color: context.isDarkMode ? Colors.white : AppColors.SECONDARY_COLOR,
                          width: 40.w,
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
                        Label(
                          text: _getFirstTwoWords(user?.fullName ?? ''),
                          style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
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
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSwitchButton(
                value:
                    context.read<CustomPageCubit>().state.activate!.customPage,
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
                                    Navigator.pop(context);
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
              Label(text: LocaleKeys.customPage.localize),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
                builder: (context, state) {
                  var floatingNavigatorCubit =
                      context.read<FloatingNavigatorCubit>();
                  return CustomSwitchButton(
                    value: floatingNavigatorCubit.floatingNavigatorEnable,
                    onChanged: (value) async {
                      Navigator.pop(context);
                      floatingNavigatorCubit.changeFloatingNavigatorEnable();
                    },
                  );
                },
              ),
              SizedBox(
                width: 4.w,
              ),
              Label(text: LocaleKeys.floatingNavigator.localize),
            ],
          ),
          Row(
            children: [
              BlocBuilder<ChoiceRulerCubit, ChoiceRulerState>(
                builder: (context, state) {
                  var choiceRulerCubit = ChoiceRulerCubit.get(context);
                  return CustomSwitchButton(
                    value: choiceRulerCubit.choiceRulerEnabled,
                    onChanged: (value) async {
                      Navigator.pop(context);
                      choiceRulerCubit.changeChoiceRulerEnabled();
                    },
                  );
                },
              ),
              SizedBox(
                width: 4.w,
              ),
              Label(
                text: LocaleKeys.choiceRuler.localize,
              ),
            ],
          ),
          BlocBuilder<ThemeCubit, ThemeStates>(
            builder: (BuildContext context, theme) {
              var themeCubit =
              context.read<ThemeCubit>();
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
                    text: LocaleKeys.lightMode.localize,
                  )
                      : Label(
                    text: LocaleKeys.darkMode.localize,
                  ),
                ],
              );
            },
          ),
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
