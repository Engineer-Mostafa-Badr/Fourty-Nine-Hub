import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../translations/translation_cubit.dart';
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
    this.color=AppColors.PRIMARY_COLOR,
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
                color: const Color(0xfff3f3f3),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Label(text: 'Search'.localize, style: Styles.mediumText()),
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
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextAppButton(
                  label: 'lang'.localize,
                  style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                  onPressed: () {
                    context.read<TranslationCubit>().changeLanguage(
                        Locale(context.isArabic ? 'en' : 'ar'), context);
                  })),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  size: 26,
                ),
                onPressed: () => context.push(Routes.NOTIFICATIONS),
                color: inNotifications
                    ? AppColors.SPLASH_BLACK_COLOR
                    : isDetailsCardService
                        ? AppColors.PRIMARY_COLOR
                        : color,
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
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      //systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: Colors.black),
      // automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight * 1);
}
