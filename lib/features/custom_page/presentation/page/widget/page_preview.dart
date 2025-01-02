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
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/service_page_preview%20copy.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/pages/Social_home.dart';
import '../../../../social_media/stories/presentation/cubit/stories_cubit.dart';

class PagePreview extends StatefulWidget {
  const PagePreview({super.key, required this.state});
  final bool? state;

  @override
  State<PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        child: Scaffold(
          key: _scaffoldKey,
          appBar: HomeAppbar(
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
              tabs: [
                Tab(text: LocaleKeys.social.tr()),
                Tab(text: LocaleKeys.service.tr()),
              ],
            ),
          ),
          drawer: const DrawerWidget(),
          body: TabBarView(
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
                    create: (context) =>
                        serviceLocator<CustomPageCubit>()..fetchSocialPage(),
                  ),
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
                                        hideAppBar: true),
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
            ],
          ),
        ),
      ),
    );
  }
}
