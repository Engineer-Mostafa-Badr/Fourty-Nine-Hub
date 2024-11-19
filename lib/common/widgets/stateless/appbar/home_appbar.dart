import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/widgets/unread_notifications_builder.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/search/presentation/pages/search_view.dart';
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
  final PreferredSizeWidget? bottom;

  const HomeAppbar({
    super.key,
    this.isShowLogo = true,
    this.isWithBackArrow = false,
    this.inNotifications = false,
    this.isMenu = false,
    this.bottom,
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
    return AppBar(
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      title: Row(
        children: [
          if (isShowLogo)
            InkWell(
              onTap: () {},
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
            IconAppButton(
              onPressed: () => context.pop(),
              icon: Icons.arrow_back_ios,
              size: 20,
            ),
          SizedBox(
            width: 20.w,
          ),
          if (language)
            if (showLanguage)
              TextButton(
                  onPressed: () {},
                  child: Label(text: 'Register', style: Styles.mediumText())),
          //put lang
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextAppButton(
                  label: LocaleKeys.lang.tr(),
                  style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
                  onPressed: () {
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
          Expanded(
            child: Container(
              height: 55.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: AppColors.AUTH_CONTAINER_COLOR),
              child: InkWell(
                borderRadius: BorderRadius.circular(40.r),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchView(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 30.h,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: Label(
                          text: LocaleKeys.search.localize,
                          style: Styles.mediumText(
                              color: AppColors.QUANTITY_COLOR)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showLanguage)
            TextButton(
                onPressed: () {},
                child: Label(
                    text: LocaleKeys.register.localize,
                    style: Styles.mediumText())),
          // if (language)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: InkWell(
              onTap: () {
                context.read<UserCubit>().isLoggedIn
                    ? context.push(Routes.CHAT)
                    : context.push(Routes.LOGIN);
              },
              child: SvgPicture.asset(
                Assets.message,
                height: 30.h,
              ),
            ),
          ),

          SizedBox(
            width: 40.w,
          ),
          GestureDetector(
            onTap: () {
              context.push(context.read<UserCubit>().isLoggedIn
                  ? Routes.NOTIFICATIONS
                  : Routes.LOGIN);
            },
            child: const UnreadNotificationsBuilder(),
          ),
          SizedBox(
            width: 5.w,
          ),
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
