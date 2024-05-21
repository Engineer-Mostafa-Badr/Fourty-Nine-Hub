import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
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
            if (showLanguage)
              TextButton(
                onPressed: () {},
                child: Label(text: 'EN', style: Styles.mediumText()),
              ),
            if (isWithBackArrow) const SizedBox(width: 10),
            if (isWithBackArrow)
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDetailsCardService
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.PRIMARY_COLOR,
                  size: 22,
                ),
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
                        child:
                            Label(text: 'Search', style: Styles.mediumText()),
                      ),
                      const Icon(
                        Icons.sort,
                        size: 16,
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
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 26,
                  ),
                  onPressed: () {},
                  color: inNotifications
                      ? AppColors.SPLASH_BLACK_COLOR
                      : isDetailsCardService
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.PRIMARY_COLOR,
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
                        text: '1',
                        style: Styles.mediumText(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.black),
      // automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight * 1.5);
}
