import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/widgets/unread_notifications_builder.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/search_app_users.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  const HomeAppbar({
    super.key,
    this.isShowLogo = true,
    this.isWithBackArrow = false,
    this.inNotifications = false,
    this.isMenu = false,
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
                  showDialog(
                      context: context, builder: (_) => const SearchAppUsers());
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
                child: Label(text: 'Register', style: Styles.mediumText())),
          if (language)
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
                    })),
          GestureDetector(
            onTap: () {
              context.push(Routes.NOTIFICATIONS);
            },
            child: const UnreadNotificationsBuilder(),
          ),
          SizedBox(
            width: 10.h,
          ),
        ],
      ),
      elevation: 0,
      titleSpacing: 0,
      //systemOverlayStyle: SystemUiOverlayStyle.light,
      // automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight * 2.h);
}
