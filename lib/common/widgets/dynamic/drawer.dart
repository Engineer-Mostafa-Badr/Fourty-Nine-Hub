import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_state.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../features/authentication/presentation/widgets/log_out_widget.dart';
import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
import '../stateless/buttons/iconAppButton.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWalletCubit(serviceLocator()),
      child: BlocBuilder<UserCubit, BasicState<UserEntity>>(
        builder: (context, state) {
          var walletCubit = context.read<GetWalletCubit>();
          return Drawer(
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

                    // walletCircularProgress(context: context), gemy3617@gmail.com
                    drawerListTile(
                        icon: FontAwesomeIcons.bullhorn,
                        label: LocaleKeys.advertiseYourCompany.localize,
                        onTap: () => context.push(Routes.CREATECOMPANYAD)),

                    drawerListTile(
                        icon: FontAwesomeIcons.quran,
                        label: LocaleKeys.quraan.localize,
                        onTap: () => context.push(Routes.QURAAN)),
                    drawerListTile(
                        icon: FontAwesomeIcons.book,
                        label: LocaleKeys.azkar.localize,
                        onTap: () => context.push(Routes.AZKAAR)),

                    drawerListTile(
                        // icon: Icons.star_rounded,
                        image: Assets.favorite_main_category_icon,
                        label: LocaleKeys.favouriteCategories.localize,
                        requireLogin: true,
                        onTap: () => context.push(Routes.FAVOURITECATEGORIES)),

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
                        icon: Icons.history,
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
                        onTap: () => context.push(Routes.PRIVACY)),

                    drawerListTile(
                        icon: Icons.policy_outlined,
                        label: LocaleKeys.policies.localize,
                        onTap: () => context.push(Routes.POLICY)),
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
                              context: context, widget: const LogoutWidget());
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              children: [
                IconAppButton(
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
        Row(
          children: [
            counterItem(
                icon: Icons.ads_click,
                label: 'Special Ads',
                value: '+8',
                onTap: () {},
                context: context),
            counterItem(
                icon: Icons.person_add,
                label: 'Friends',
                value: '+110',
                onTap: () {},
                context: context),
            counterItem(
              icon: FontAwesomeIcons.car,
              label: 'Rides',
              value: '+5',
              context: context,
              onTap: () {},
            ),
            counterItem(
              icon: Icons.more_horiz,
              label: 'More',
              value: '+1K',
              onTap: () => context.go(Routes.COMPETITIONS),
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget walletCircularProgress({
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        context.push(Routes.WALLET);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.LIGHT_GRAY_COLOR),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: LocaleKeys.wallet.localize,
                    style: Styles.mediumText(fontWeight: FontWeight.bold)),
                Label(
                    text: 'Earn Money with 49Hub',
                    style: Styles.mediumText(fontWeight: FontWeight.w400)),
              ],
            )),
            SizedBox(
              height: kTextTabBarHeight,
              width: kTextTabBarHeight,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CircularProgressIndicator(
                      value: .3,
                      strokeWidth: 5,
                      color: AppColors.PRIMARY_COLOR,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned.fill(
                      child: Center(
                          child: RichText(
                              text: TextSpan(children: [
                    TextSpan(text: '300\n', style: Styles.mediumText()),
                    TextSpan(
                        text: '/1002',
                        style: Styles.mediumText(
                          fontSize: 8,
                        ))
                  ]))))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
    return ListTile(
      onTap: () => onTap(),
      leading: image != null && icon == null
          ? Image.asset(
              image,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            )
          : Icon(
              icon,
            ),
      title: Label(
          text: label, style: Styles.mediumText(fontWeight: FontWeight.w500)),
      subtitle: (description != null)
          ? Label(
              text: description,
              style: Styles.mediumText(fontWeight: FontWeight.w300))
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 12,
      ),
    );
  }

  Widget competitionSubscription({required BuildContext context}) {
    return InkWell(
      onTap: () => context.go(
        context.read<UserCubit>().isLoggedIn ? Routes.LUCKYWHEEL : Routes.LOGIN,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
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
                          color: Theme.of(context).scaffoldBackgroundColor)),
                  Label(
                      text: LocaleKeys.feelLucky.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).scaffoldBackgroundColor)),
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

  Widget counterItem(
      {required IconData icon,
      required String label,
      required String value,
      required context,
      required Function onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.GREY_BORDER_COLOR,
              radius: 25,
              child: Icon(
                icon,
                // size: ,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Label(
              text: value,
              style: Styles.mediumText(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Label(text: label, style: Styles.mediumText(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget accountWidget({
    required BuildContext context,
    required UserEntity? user,
  }) {
    var walletCubit = context.read<GetWalletCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(
            height: kToolbarHeight * 1.5,
            width: kToolbarHeight * 1.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg'
                        // user?.profilePicture ?? UIConst.profilePlaceHolder,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.PRIMARY_COLOR,
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
                    text: user?.fullName ?? '',
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (user?.isDocument ?? false)
                    const Icon(
                      Icons.verified,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                ],
              ),
              Label(
                text: getUserType(user),
                style: Styles.mediumText(),
              ),
              InkWell(
                onTap: () {
                  context.push(
                    Routes.WALLET,
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.wallet,
                      size: 18,
                    ),
                    const Sizer(
                      width: 4,
                      height: 4,
                    ),
                    BlocBuilder<GetWalletCubit, GetWalletState>(
                      builder: (context, state) {
                        return Expanded(
                          child: Label(
                            text:
                                '${state is SuccessGetWallet ? state.model.balance : 0} L.E',
                            style: Styles.mediumText(
                                decoration: TextDecoration.underline),
                          ),
                        );
                      },
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

  getUserType(
    UserEntity? user,
  ) {
    if (user?.isDoctor ?? false) {
      return "Doctor";
    } else if (user?.isLoading ?? false) {
      return "Loading";
    } else if (user?.isRestaurant ?? false) {
      return "Restaurant";
    } else if (user?.isRider ?? false) {
      return "Rider";
    } else {
      return "";
    }
  }
}
