import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/widgets/unread_notifications_builder.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
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
  final double? toolbarHeight;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

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
    this.showLanguage = false,
    this.color = AppColors.PRIMARY_COLOR,
    this.language = false,
  });

  @override
  Widget build(BuildContext context) {
    // context.read<UserCubit>().getUnreadedChatsCounter();
    bool isCurrentRoute(BuildContext context, String targetRoute) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      return currentRoute == targetRoute;
    }

    return AppBar(
      // toolbarHeight: 60,
      // toolbarHeight: toolbarHeight,
      bottom: bottom,
      leading: IconButton(
        icon: Image.asset(
          Assets.menu,
          width: 28,
          height: 28,
        ),
        onPressed: () {
          HandleCashback.setCount('drawerCount', context);
          // Scaffold.currentState?.openDrawer(); // Open the drawer
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Row(
        children: [
          if (isShowLogo)
            InkWell(
              onTap: () {
                if (!isCurrentRoute(context, Routes.HOME)) {
                  context.go(
                    Routes.HOME,
                  );
                } else {
                  print("object");
                }
              },
              child: SizedBox(
                height: 50.h,
                width: 50.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image(
                    image: AssetImage(Assets.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // if (showLanguage)

          if (isWithBackArrow) SizedBox(width: 20.w),
          if (isWithBackArrow)
            Expanded(
              child: IconAppButton(
                onPressed: () => context.pop(),
                icon: Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          SizedBox(
            width: 20.w,
          ),
          if (language)
            if (showLanguage)
              Expanded(
                child: TextButton(
                    onPressed: () {},
                    child: Label(text: 'Register', style: Styles.mediumText())),
              ),
          //put lang
          Container(
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextAppButton(
                  label: LocaleKeys.lang.tr(),
                  style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
                  onPressed: () {
                    HandleCashback.setCount('langCount', context);
                    if (context.locale == Locales.english) {
                      changeLang(locale: Locales.arabic, context: context);
                    } else {
                      changeLang(locale: Locales.english, context: context);
                    }
                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      // ignore: use_build_context_synchronously
                      context
                          .read<NotificationSocketIoCubit>()
                          .notificationListener(languageCode: 'en');
                      context
                          .read<NotificationSocketIoCubit>()
                          .clearAllNotificationsAndRefeatchAfterLogin(
                              languageCode: 'en');
                    });
                  })),
          SizedBox(
            width: 20.w,
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(40.r),
            onTap: () {
              context.push(Routes.SEARCH);
            },
            child: const Icon(
              Icons.search,
              size: 25,
              color: AppColors.QUANTITY_COLOR,
            ),
          ),
          const Sizer(),
          const Sizer(),
          if (showLanguage)
            Expanded(
              child: TextButton(
                  onPressed: () {},
                  child: Label(
                      text: LocaleKeys.register.localize,
                      style: Styles.mediumText())),
            ),
          // if (language)
          InkWell(
            onTap: () async {
              await context.read<UserCubit>().resetUnreadedChatsCounter();

              if (isCurrentRoute(context, Routes.CHAT) == true) {
                return;
              }

              HandleCashback.setCount('chatCount', context);
              context.push(Routes.CHAT, extra: ChatsViewParams());
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Badge.count(
                count: context.read<UserCubit>().unreadedChatsCounter,
                backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                isLabelVisible:
                    context.read<UserCubit>().unreadedChatsCounter > 0,
                child: Image.asset(
                  Assets.whatsApp,
                  color: AppColors.PRIMARY_COLOR,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          const Sizer(),
          const Sizer(),
          // SizedBox(
          //   width: 15.w,
          // ),
          InkWell(
            onTap: () {
              if (isCurrentRoute(context, Routes.NOTIFICATIONS) == true) {
                return;
              }
              HandleCashback.setCount('notificationCount', context);
              context.push(
                context.read<UserCubit>().isLoggedIn
                    ? Routes.NOTIFICATIONS
                    : Routes.LOGIN,
              );
            },
            child: UnreadNotificationsBuilder(
              inNotifications: inNotifications,
            ),
          ),
          const Sizer(),
        ],
      ),
      leadingWidth: 90.w,
      elevation: 0,
      titleSpacing: 0,

      //systemOverlayStyle: SystemUiOverlayStyle.light,
      // automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight ?? kTextTabBarHeight * 2.h);
}
