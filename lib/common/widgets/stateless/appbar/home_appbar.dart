import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
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
    this.color = AppColors.PRIMARY_COLOR,  this.language=false,
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
                height: 30,
                width: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: AssetImage(Assets.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // if (showLanguage)

          if (isWithBackArrow) const SizedBox(width: 10),
          if (isWithBackArrow)
            IconAppButton(
              onPressed: () => context.pop(),
              icon: Icons.arrow_back_ios,
            ),
          Expanded(
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.AUTH_CONTAINER_COLOR),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 16,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                    const SizedBox(width: 5),
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
         if(language)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextAppButton(
                  label: LocaleKeys.lang.tr(),
                  style: Styles.mediumText(
                      color: AppColors.SECONDARY_COLOR, fontSize: 20),
                  onPressed: () {
                    if (context.locale == Locales.english) {
                      changeLang(locale: Locales.arabic);
                    } else {
                      changeLang(locale: Locales.english);
                    }
                  })),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  size: 26,
                ),
                onPressed: () => context.push(Routes.NOTIFICATIONS),
                // color: inNotifications
                //     ? AppColors.SPLASH_BLACK_COLOR
                //     : isDetailsCardService
                //         ? AppColors.PRIMARY_COLOR
                //         : color,
              ),
              Positioned(
                top: 10,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Label(
                      text: '1', style: Styles.mediumText(color: Colors.white)),
                ),
              ),
            ],
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
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight * 1);
}
