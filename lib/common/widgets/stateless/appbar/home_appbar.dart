import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/utils/whatsapp_notification_utils.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/shared_pref.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../dialogs/please_login_dialog.dart';
import '../buttons/iconAppButton.dart';
import '../labels/label.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isShowLogo;
  final bool isWithBackArrow;
  final bool inNotifications;
  final bool isMenu;
  final bool isDetailsCardService;
  final bool showChat;
  final bool isIconWhite;
  final bool showLanguage;
  final Color color;
  final bool language;
  final bool isHaveLeading;
  final double? toolbarHeight;
  final Widget? leading;
  final Widget? inChat;
  final Function? onBackPressed;
  final PreferredSizeWidget? bottom;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeAppbar({
    super.key,
    this.isShowLogo = true,
    this.isWithBackArrow = false,
    this.inNotifications = false,
    this.isMenu = false,
    this.bottom,
    this.leading,
    this.toolbarHeight,
    this.isDetailsCardService = false,
    this.showChat = true,
    this.isIconWhite = false,
    this.onBackPressed,
    this.showLanguage = false,
    this.color = AppColors.PRIMARY_COLOR,
    this.language = false,
    this.isHaveLeading = false,
    this.inChat,
    this.scaffoldKey,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 30);

  @override
  Widget build(BuildContext context) {
    // context.read<UserCubit>().getUnreadedChatsCounter();
    bool isCurrentRoute(BuildContext context, String targetRoute) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      return currentRoute == targetRoute;
    }

    return AppBar(
      scrolledUnderElevation: 0,
      clipBehavior: Clip.none,
      bottom: bottom,
      leading: isHaveLeading
          ? InkWell(
              child: Image.asset(
                Assets.menu,
                width: 25,
                height: 25,
              ),
              onTap: () {
                ManageVibration.vibrate();
                HandleCashback.setCount('drawerCount', context);
                Scaffold.of(context).openDrawer();
              },
            )
          : Container(),
      title: Row(
        textDirection: TextDirection.ltr,
        children: [
          const SizedBox(
            width: 16,
          ),
          if (isShowLogo)
            InkWell(
              onTap: () async {
                ManageVibration.vibrate();
                await WhatsAppNotificationUtils.showWhatsAppMessage(
                  senderName: 'Mohamed',
                  message: 'Hello! How are you?',
                  senderAvatar:
                      'https://images.pexels.com/photos/34205159/pexels-photo-34205159.jpeg', // Optional
                  useCollapsedIcon: true,
                );
                await WhatsAppNotificationUtils.showNoInternetNotification(
                    title: 'CHAT',
                    message: 'You may have new messages',
                    isPersistent: true);
                // bool isCustomPage = await CacheManager.getActivation() ?? false;
                // if (isCustomPage) {
                //   if (!isCurrentRoute(context, Routes.HOME)) {
                //     context.go(
                //       Routes.HOME,
                //     );
                //   }
                // } else {
                //   if (!isCurrentRoute(context, Routes.HOME)) {
                //     context.go(
                //       Routes.HOME,
                //     );
                //   }
                // }
              },
              child: Image.asset(
                Assets.logoHub,
                height: 30,
              ),
            ),
          SizedBox(
            width: 20.w,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(40.r),
            onTap: () {
              ManageVibration.vibrate();
              context.push(Routes.SEARCH);
            },
            child: Icon(
              Icons.search,
              size: 25,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
          ),
          // if (showLanguage)

          // if (isWithBackArrow)
          if (isWithBackArrow) ...[
            SizedBox(width: 20.w),
            Expanded(
              child: IconAppButton(
                onPressed: () => onBackPressed != null
                    ? onBackPressed!()
                    : !isCurrentRoute(context, Routes.HOME)
                        ? context.go(
                            Routes.HOME,
                          )
                        : null,
                icon: Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ],
          SizedBox(
            width: 20.w,
          ),
          if (language)
            if (showLanguage)
              Expanded(
                child: TextButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                    },
                    child: Label(text: 'Register', style: Styles.mediumText())),
              ),
          //put lang
          const Spacer(),
          Container(
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextAppButton(
                  label: LocaleKeys.lang.localize,
                  style:
                      Styles.headerText(color: AppColors.getRedColor(context)),
                  onPressed: () {
                    ManageVibration.vibrate();
                    HandleCashback.setCount('langCount', context);
                    // if (context.locale == Locales.arabic) {
                    if (LocaleKeys.lang.localize == 'En') {
                      changeLang(locale: Locales.english, context: context);
                    } else {
                      changeLang(locale: Locales.arabic, context: context);
                    }
                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      // ignore: use_build_context_synchronously
                    });
                  })),
          SizedBox(
            width: 20.w,
          ),
          if (showLanguage)
            Expanded(
              child: TextButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                  },
                  child: Label(
                      text: LocaleKeys.register.localize,
                      style: Styles.mediumText())),
            ),
          // if (language)
          // if(inChat != null)
          // inChat ??
          //     InkWell(
          //       onTap: () async {
          //         ManageVibration.vibrate();
          //         if (!context.read<UserCubit>().isLoggedIn) {
          //           return pleaseLoginDialog(context);
          //         }
          //         await context.read<UserCubit>().resetUnreadedChatsCounter();
          //         if (isCurrentRoute(context, Routes.CHAT) == true) {
          //           return;
          //         }
          //         HandleCashback.setCount('chatCount', context);
          //         context.push(Routes.CHAT, extra: ChatsViewParams());
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.all(12),
          //         child: Badge.count(
          //           count: context.read<UserCubit>().unreadedChatsCounter,
          //           backgroundColor: AppColors.PRIMARY_COLOR_DARK,
          //           isLabelVisible:
          //               context.read<UserCubit>().unreadedChatsCounter > 0,
          //           child: Image.asset(
          //             Assets.whatsApp,
          //             color: context.isDarkMode
          //                 ? Colors.white
          //                 : AppColors.PRIMARY_COLOR,
          //             height: 20,
          //             width: 20,
          //           ),
          //         ),
          //       ),
          //     ),
          Builder(
            builder: (context) {
              final getUnreadNotificationsCountCubit =
                  context.watch<GetUnreadNotificationsCountCubit>();
              return ClickableWidget(
                onTap: () {
                  if (inNotifications) return;
                  ManageVibration.vibrate();
                  if (isCurrentRoute(context, Routes.NOTIFICATIONS) == true) {
                    return;
                  }
                  HandleCashback.setCount('notificationCount', context);
                  context.push(
                    context.read<UserCubit>().isLoggedIn
                        ? Routes.NOTIFICATIONS
                        : Routes.FirstLoginScreen,
                  );
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: CustomNotificationWidget(
                      icon: Image.asset(
                        Assets.notification,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                      ),
                      height: 20,
                      unreadCount: !context.read<UserCubit>().isLoggedIn
                          ? 0
                          : getUnreadNotificationsCountCubit
                                  .unreadNotificationsCountEntity?.total ??
                              0),
                ),
              );
            },
          ),
          if (isMenu)
            ClickableWidget(
              onTap: () {
                var currentContext =
                    AppPages.router.configuration.navigatorKey.currentContext!;
                ManageVibration.vibrate();
                HandleCashback.setCount('drawerCount', context);
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: SvgPicture.asset(
                  Assets.menuSvg,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
          // if(inChat == null)

          const Sizer(),
          // const Sizer(),
          // SizedBox(
          //   width: 15.w,
          // ),
          // InkWell(
          //   onTap: () {
          //     if (isCurrentRoute(context, Routes.NOTIFICATIONS) == true) {
          //       return;
          //     }
          //     HandleCashback.setCount('notificationCount', context);
          //     context.push(
          //       context.read<UserCubit>().isLoggedIn
          //           ? Routes.NOTIFICATIONS
          //           : Routes.LOGIN,
          //     );
          //   },
          //   child: UnreadNotificationsBuilder(
          //     inNotifications: inNotifications,
          //   ),
          // ),
          // const Sizer(),
        ],
      ),
      leadingWidth: isHaveLeading ? 90 : 0,
      elevation: 0,
      titleSpacing: 0,

      //systemOverlayStyle: SystemUiOverlayStyle.light,
      // automaticallyImplyLeading: false,
    );
  }
}
