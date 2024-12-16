import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features/authentication/presentation/widgets/log_out_widget.dart';
import '../../../features/competition/data/repository/competition_repo_impl.dart';
import '../../../features/competition/presentation/cubit/competition_cubit/competition_cubit.dart';
import '../../../features/competition/presentation/cubit/competition_cubit/competition_state.dart';
import '../../../features/competition/presentation/view/special_ads_view.dart';
import '../../../features/custom_page/presentation/page/custom_page.dart';
import '../../../features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/const.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
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
    // TODO: implement initState
    AdInterstitialTop.loadIntersitialAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWalletCubit(serviceLocator()),
      child: BlocBuilder<UserCubit, BasicState<UserEntity>>(
        builder: (context, state) {
          context.read<GetWalletCubit>();
          return Drawer(
            width: 600.w,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    context.read<UserCubit>().isLoggedIn
                        ? _buildAccountHeader(
                            context: context,
                            user: state.data,
                          )
                        : _buildLoginWidget(context: context),

                    competitionSubscription(context: context),

                    drawerListTile(
                        image: Assets.microphone,
                        label: LocaleKeys.advertiseYourCompany.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          return context.push(Routes.CREATECOMPANYAD);
                        }),
                    drawerListTile(
                        image: Assets.quran,
                        label: LocaleKeys.quraan.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();

                          return context.push(Routes.QURAAN);
                        }),
                    drawerListTile(
                        image: Assets.azkar,
                        label: LocaleKeys.azkar.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          return context.push(Routes.AZKAAR);
                        }),
                    drawerListTile(
                        icon: Icons.maps_home_work_rounded,
                        label: LocaleKeys.customPage.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          context.push(Routes.CUSTOMPAGE);
                        }),
                    drawerListTile(
                        image: Assets.favorite_main_category_icon,
                        label: LocaleKeys.favouriteCategories.localize,
                        requireLogin: true,
                        onTap: () async {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          await context.push(Routes.FAVOURITECATEGORIES);
                          context.read<MainCategoriesCubit>().loadData();
                        }),

                    drawerListTile(
                        // icon: Icons.favorite,
                        image: Assets.favorite_sub_category_icon,
                        label: LocaleKeys.favouriteSubCategories.localize,
                        requireLogin: true,
                        onTap: () =>
                            context.push(Routes.FAVOURITESUBCATEGORIES)),
                    drawerListTile(
                        // icon: FontAwesomeIcons.adn,
                        image: Assets.favorite_ad_icon,
                        label: LocaleKeys.favouriteAds.localize,
                        requireLogin: true,
                        onTap: () => context.push(Routes.FAVOURITE)),
                    drawerListTile(
                        image: Assets.history,
                        label: LocaleKeys.requestHistory.localize,
                        requireLogin: true,
                        onTap: () => context.push(Routes.REQUESTSHISTORY)),

                    drawerListTile(
                        // icon: Icons.list,
                        image: Assets.lists_icon,
                        label: LocaleKeys.lists.localize,
                        requireLogin: true,
                        onTap: () => context.push(Routes.Lists)),
                    drawerListTile(
                        // icon: Icons.ads_click,
                        image: Assets.my_ads_icon,
                        label: LocaleKeys.myAds.localize,
                        requireLogin: true,
                        onTap: () => context.push(Routes.MYADDS)),
                    // drawerListTile(icon: Icons.list, label: 'Requests', onTap: () {}),
                    drawerListTile(
                        // icon: Icons.settings,
                        image: Assets.settings_icon,
                        label: LocaleKeys.settings.localize,
                        onTap: () => context.push(Routes.SETTINGS)),

                    drawerListTile(
                        // icon: Icons.privacy_tip,
                        image: Assets.privacy_icon,
                        label: LocaleKeys.privacy.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          return context.push(Routes.PRIVACY);
                        }),

                    drawerListTile(
                        image: Assets.policy,
                        label: LocaleKeys.policies.localize,
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          return context.push(Routes.POLICY);
                        }),
                    drawerListTile(
                        // icon: Icons.share,
                        image: Assets.share_app_icon,
                        label: LocaleKeys.shareApp.localize,
                        onTap: () => context.push(Routes.SHAREAPP)),
                    drawerListTile(
                        // icon: Icons.message,
                        image: Assets.contact_us_icon,
                        label: LocaleKeys.contactUs.localize,
                        onTap: () => context.push(Routes.CONTACTUS)),

                    drawerListTile(
                        // icon: Icons.logout,
                        image: Assets.sign_out_icon,
                        requireLogin: true,
                        label: LocaleKeys.logout.localize,
                        onTap: () {
                          bottomSheet(
                              backColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              context: context,
                              widget: const LogoutWidget());
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
                  icon: Icons.person,
                  onPressed: () => context.push(Routes.LOGIN),
                ),
                Label(
                    text: LocaleKeys.login.localize,
                    style: Styles.mediumText()),
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
                    onPressed: () => context.push(Routes.REGISTER)),
                Label(
                    text: LocaleKeys.register.localize,
                    style: Styles.mediumText()),
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
        BlocProvider(
          create: (BuildContext context) =>
              CompetitionCubit(serviceLocator.get<CompetitionRepoImpl>())
                ..fetchCompetition(context),
          child: BlocBuilder<CompetitionCubit, CompetitionState>(
            builder: (BuildContext context, state) {
              if (state is CompetitionSuccessState) {
                int calculateSumOfRequests() {
                  // Create a list of indices, excluding 0, 9, and 10
                  List<int> indicesToSum = List.generate(
                          state.competitionModel.data?.length ?? 0,
                          (index) => index)
                      .where((index) => index != 0 && index != 9 && index != 10)
                      .toList();

                  // Use fold to sum the values, handling null values with ?? 0
                  return indicesToSum.fold(0, (sum, index) {
                    return sum +
                        (state.competitionModel.data?[index].countOfRequest ??
                            0);
                  });
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // Evenly distribute space
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align items at the start
                  children: [
                    state.competitionModel.data![10].competitionId?.nameEn !=
                            null
                        ? counterItem(
                            icon: Icons.ads_click,
                            label: LocaleKeys.specialAds.localize,
                            value:
                                '${state.competitionModel.data![10].countOfRequest}',
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
                    state.competitionModel.data![0].competitionId?.nameEn !=
                            null
                        ? counterItem(
                            icon: Icons.person_add,
                            label: LocaleKeys.friends.localize,
                            value:
                                '${state.competitionModel.data![0].countOfRequest}',
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
                    state.competitionModel.data![9].competitionId?.nameEn !=
                            null
                        ? counterItem(
                            icon: FontAwesomeIcons.car,
                            label: LocaleKeys.ride.localize,
                            value:
                                '${state.competitionModel.data![9].countOfRequest}',
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
                    state.competitionModel.data != null
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
      child: ListTile(
        onTap: () => onTap(),
        leading: image != null && icon == null
            ? Image.asset(
                image,
                width: 40.h,
                height: 40.h,
                fit: BoxFit.cover,
              )
            : Icon(
                icon,
                size: 45.w,
                color: AppColors.PRIMARY_COLOR,
              ),
        title: Label(
            text: label,
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
            )),
        subtitle: (description != null)
            ? Label(
                text: description,
                style: Styles.mediumText(fontWeight: FontWeight.w300))
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 28.w,
        ),
      ),
    );
  }

  Widget competitionSubscription({required BuildContext context}) {
    return InkWell(
      onTap: () {
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        context.go(
        context.read<UserCubit>().isLoggedIn ? Routes.LUCKYWHEEL : Routes.LOGIN,
      );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.LIGHT_GRAY_COLOR),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text: LocaleKeys.luckyWheel.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.QUANTITY_COLOR)),
                  Label(
                      text: LocaleKeys.feelLucky.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.w400,
                          color: AppColors.QUANTITY_COLOR)),
                ],
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
              width: kToolbarHeight,
              child: Image.asset(
                Assets.spinWheel,
                // height: kToolbarHeight,
                // width: kToolbarHeight,
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
    context.read<GetWalletCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
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
                      return ImageFromInternet(
                        isCircle: true,
                        image:
                            user?.profilePicture ?? UIConst.profilePlaceHolder,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () async {
                                Navigator.pop(context);
                                await context
                                    .read<UserCubit>()
                                    .uploadPhoto(isGallery: true);
                                // Reload user data if needed
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () async {
                                Navigator.pop(context);
                                await context
                                    .read<UserCubit>()
                                    .uploadPhoto(isGallery: false);
                                // Reload user data if needed
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40.w,
                    color: Theme.of(context).primaryColor,
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
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
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
                    Sizer(
                      width: 8.h,
                      height: 8.h,
                    ),
                    Expanded(
                      child: Label(
                        text: '${user?.wallet ?? 0}',
                        style: Styles.mediumText(
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }

  String _getFirstTwoWords(String fullName) {
    List<String> words = fullName.split(" ");
    // if (words.length > 1) {
    //   // Capitalize the first letter of each word
    //   words = words.map((word) {
    //     return word[0].toUpperCase() + word.substring(1).toLowerCase();
    //   }).toList();
    // }
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
