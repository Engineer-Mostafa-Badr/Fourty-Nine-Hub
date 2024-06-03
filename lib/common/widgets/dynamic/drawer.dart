import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/webview.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../features/authentication/presentation/widgets/log_out_widget.dart';
import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/const.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
import '../stateless/buttons/iconAppButton.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<UserCubit, BasicState<UserEntity>>(
                builder: (context, state) {
                  return context.read<UserCubit>().isLoggedIn
                      ? _buildAccountHeader(
                          context: context,
                          user: state.data,
                        )
                      : _buildLoginWidget(context: context);
                },
              ),
              competitionSubscription(context: context),
              walletCircularProgress(context: context),
              drawerListTile(
                  icon: FontAwesomeIcons.quran,
                  label: 'Quraan',
                  onTap: () => context.push(Routes.REGISTERDRIVER)),
              drawerListTile(
                  icon: FontAwesomeIcons.book,
                  label: 'Azkaar',
                  onTap: () => context.push(Routes.QURAAN)),
              drawerListTile(
                  icon: Icons.favorite,
                  label: 'Favourite',
                  onTap: () => context.push(Routes.FAVOURITE)),
              drawerListTile(
                  icon: Icons.ads_click,
                  label: 'My Ads',
                  onTap: () => context.push(Routes.MYADDS)),
              // drawerListTile(icon: Icons.list, label: 'Requests', onTap: () {}),
              drawerListTile(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () => context.push(Routes.SETTINGS)),
              drawerListTile(
                  icon: Icons.policy_outlined,
                  label: 'Policies',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WebViewScaffold(
                          url: UIConst.policyUrl, label: 'Policy')))),
              drawerListTile(
                  icon: Icons.share,
                  label: 'Share App',
                  onTap: () => context.push(Routes.SHAREAPP)),
              drawerListTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    bottomSheet(context: context, widget: const LogoutWidget());
                  }),
            ],
          ),
        ),
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
          Column(
            children: [
              IconAppButton(
                isCircle: true,
                icon: Icons.person,
                onPressed: () => context.push(Routes.LOGIN),
              ),
              Label(text: 'Login', style: Styles.mediumText()),
            ],
          ),
          Column(
            children: [
              IconAppButton(
                  isCircle: true,
                  icon: Icons.person_add,
                  onPressed: () => context.push(Routes.REGISTER)),
              Label(text: 'Register', style: Styles.mediumText()),
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
            ),
            counterItem(
              icon: Icons.person_add,
              label: 'Friends',
              value: '+110',
              onTap: () {},
            ),
            counterItem(
              icon: FontAwesomeIcons.car,
              label: 'Rides',
              value: '+5',
              onTap: () {},
            ),
            counterItem(
              icon: Icons.more_horiz,
              label: 'More',
              value: '+1K',
              onTap: () => context.go(Routes.COMPETITIONS),
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
                    text: 'Wallet',
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
      {required IconData icon,
      required String label,
      String? description,
      required Function onTap}) {
    return ListTile(
      onTap: () => onTap(),
      leading: Icon(icon),
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
                      text: 'Lucky Wheel',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  Label(
                      text: 'Do You feel lucky?',
                      style: Styles.mediumText(fontWeight: FontWeight.w400)),
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
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
            Label(
              text: value,
              style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: kToolbarHeight * 1.5,
            width: kToolbarHeight * 1.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      user?.profilePicture ?? UIConst.profilePlaceHolder,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.verified,
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
              Label(
                text: user?.fullName ?? '',
                style: Styles.mediumText(fontWeight: FontWeight.bold),
              ),
              Label(
                text: 'Driver',
                style: Styles.mediumText(),
              ),
              InkWell(
                onTap: () {
                  context.push(Routes.WALLET);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.wallet,
                      color: AppColors.PRIMARY_COLOR,
                      size: 18,
                    ),
                    const Sizer(
                      width: 4,
                      height: 4,
                    ),
                    Expanded(
                      child: Label(
                        text: '1000 L.E',
                        style: Styles.mediumText(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Register as Driver"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Register as Doctor"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Register as Restaurant"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  context.push(Routes.REGISTERDRIVER);
                } else if (value == 1) {
                  context.push(Routes.REGISTERDRIVER);
                } else if (value == 2) {
                  context.push(Routes.REGISTERDRIVER);
                }
              })
        ],
      ),
    );
  }
}
