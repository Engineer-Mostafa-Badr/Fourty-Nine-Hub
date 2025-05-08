import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/service_page_preview_copy.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../social_media/social_posts/presentation/pages/Social_home.dart';
import '../../../../social_media/stories/presentation/cubit/stories_cubit.dart';

class PagePreview extends StatefulWidget {
  const PagePreview({super.key, this.state, this.isButtonsVisible = false});

  final bool? state;
  final bool isButtonsVisible;

  @override
  State<PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    serviceLocator<MainCategoriesCubit>().loadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: WillPopScope(
        onWillPop: () async {
          if (widget.state ?? false) {
            SystemNavigator.pop();
            return false;
          }
          return true;
        },
        child: CustomScaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: HomeAppbar(
              isWithBackArrow: false,
              toolbarHeight: kTextTabBarHeight * 4.h,
              language: true,
              leading: IconButton(
                icon: const Icon(Icons.menu), // The menu icon
                onPressed: () {
                  HandleCashback.setCount('drawerCount', context);
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              bottom: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  // Light red background
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.LIGHT_GRAY_COLOR2,
                ),
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        LocaleKeys.social.tr(),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        LocaleKeys.service.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: const DrawerWidget(),
          body: Stack(
            children: [
              TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<InstagramCubit>()..loadData(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<StoryCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<CustomPageCubit>()
                          ..fetchSocialPage(),
                      ),
                      // BlocProvider(
                      //   create: (context) => ThumbnailsCubit(serviceLocator()),
                      // ),
                    ],
                    child: BlocBuilder<InstagramCubit, InstagramState>(
                      builder: (BuildContext context, state) {
                        return BlocBuilder<CustomPageCubit, CustomPageState>(
                          builder: (BuildContext context, social) {
                            if (social.status == CustomPageStates.success) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 8, top: 8),
                                child: social.social?.face == true
                                    ? SocialHomeView(
                                        payload: SocialParams(
                                          userId: social.social?.userId ?? '',
                                          hideAppBar: true,
                                        ),
                                      )
                                    : social.social?.insta == true
                                        ? const InstagramView(
                                            hideAppBar: true,
                                          )
                                        : const TwitterView(),
                              );
                            } else {
                              return const CustomLoading();
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const ServicePagePreview(),
                  // Container()
                ],
              ),
              Visibility(
                visible: widget.isButtonsVisible,
                child: Positioned(
                  right: 0,
                  left: 0,
                  bottom: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomElevatedButton(
                          child: Text(
                            LocaleKeys.saveAndActivate.localize,
                            style:
                                Styles.smallText(color: AppColors.whiteColor),
                          ),
                          onPressed: () async {
                            showAnimatedDialog(
                              context,
                              AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Label(
                                        text: LocaleKeys.restartToApply.localize,
                                        style: Styles.headerText(
                                            fontWeight: FontWeight.w400)),
                                    const Sizer(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            label: LocaleKeys.cancel.localize,
                                          ),
                                        ),
                                        const Sizer(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: AppButton(
                                            backColor: AppColors.PRIMARY_COLOR,
                                            onPressed: () {
                                              context
                                                  .read<CustomPageCubit>()
                                                  .updateActivate(true);
                                              Restart.restartApp();
                                            },
                                            label: LocaleKeys.restart.localize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        CustomElevatedButton(
                          onPressed: () async {
                            showAnimatedDialog(
                              context,
                              AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Label(
                                        text: LocaleKeys.restartToApply.localize,
                                        style: Styles.headerText(
                                            fontWeight: FontWeight.w400)),
                                    const Sizer(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            label: LocaleKeys.cancel.localize,
                                          ),
                                        ),
                                        const Sizer(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: AppButton(
                                            backColor: AppColors.PRIMARY_COLOR,
                                            onPressed: () {
                                              context
                                                  .read<CustomPageCubit>()
                                                  .updateActivate(true);
                                              Restart.restartApp();
                                            },
                                            label: LocaleKeys.restart.localize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            LocaleKeys.saveWithOutActivate.localize,
                            style:
                                Styles.smallText(color: AppColors.whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
