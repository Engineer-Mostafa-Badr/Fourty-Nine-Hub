import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/notifications/presentation/pages/notification_view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/api_service.dart';
import '../../../../features/notifications/data/repository/notification_repo_impl.dart';
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
                height: 50.zH,
                width: 50.zW,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.zR),
                  child: Image(
                    image: AssetImage(Assets.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // if (showLanguage)

          if (isWithBackArrow) SizedBox(width: 20.zW),
          if (isWithBackArrow)
            IconAppButton(
              onPressed: () => context.pop(),
              icon: Icons.arrow_back_ios,
            ),
          Expanded(
            child: Container(
              height: 55.zH,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.zR),
                  color: AppColors.AUTH_CONTAINER_COLOR),
              child: InkWell(
                borderRadius: BorderRadius.circular(40.zR),
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 30.zH,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                    SizedBox(width: 10.zW),
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Assets.notification,
                    width: 30.zW,
                    height: 35.zH,
                    fit: BoxFit.cover,
                  ),
                ),
                BlocProvider(
                  create: (BuildContext context) =>
                  NotificationsCubit(NotificationRepoImpl(ApiService(Dio())))..fetchNotification(),
                  child: BlocBuilder<NotificationsCubit,NotificationsState>(
                    builder: (BuildContext context, state) {
                      if(state is NotificationsSuccessState) {
                        return Positioned(
                        top: 15.zH,
                        right: 10.zW,
                        child: Container(
                          padding:  EdgeInsets.symmetric(
                            vertical: 3.zH,
                            horizontal: 5.zW,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20.zR),
                          ),
                          child: Label(
                              text: '${state.notificationModel.data!.docs!.length}',
                              style: Styles.smallText(color: Colors.white)),
                        ),
                      );
                      }return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
           SizedBox(
            width: 10.zW,
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
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight * 2.zH);
}
