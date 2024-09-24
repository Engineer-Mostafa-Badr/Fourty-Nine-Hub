import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import 'package:fourtyninehub/core/loading/custom_loading.dart';

import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/service_page_preview.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';

import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../res/style/styles.dart';

import '../../../../social_media/social_posts/presentation/pages/Social_home.dart';
import '../../../../social_media/stories/presentation/cubit/stories_cubit.dart';

class PagePreview extends StatelessWidget {
  const PagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Label(
            text: 'Page Preview',
            style: Styles.headerText(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Social'), // First Tab
              Tab(text: 'Service'), // Second Tab
            ],
          ),
        ),
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
                          padding:
                              const EdgeInsets.only(right: 8, left: 8, top: 8),
                          child: social.social?.face == true
                              ? SocialHomeView(
                                  userId: social.social!.userId,
                                  hideAppBar: true,
                                )
                              : const InstagramView(
                                  hideAppBar: true,
                                ),
                        );
                      } else {
                        return const CustomLoading();
                      }
                    },
                  );
                },
              ),
            ),
             const ServicePagePreview(), // Content for second tab
          ],
        ),
      ),
    );
  }
}


