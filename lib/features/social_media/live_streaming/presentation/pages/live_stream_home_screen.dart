import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/pages/club_house_home_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../zoom/presentation/controller/stream_state.dart';
import '../../domain/entity/live_entity.dart';
import '../widgets/liveview/live_card.dart';

class LiveStreamHomeScreen extends StatelessWidget {
  const LiveStreamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          // leading: BackButton(),
          bottom: TabBar(
            indicatorColor:
            context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            labelColor:
            context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            tabs: [
              Tab(text: LocaleKeys.live.localize),
              Tab(text: LocaleKeys.clubVoice.localize),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _videoStreamTabBar(context),
            const ClubHouseHome(),
          ],
        ),
      ),
    );
  }

  Widget _videoStreamTabBar(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<StreamCubit>().loadLives(),
      child: Scaffold(
        body: _buildLivePages(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(Routes.LIVEView,
                extra: ZegoArgs(
                    '123', true, context
                    .read<UserCubit>()
                    .state
                    .data!
                    .fullName));
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLivePages() {
    return BlocBuilder<StreamCubit, StreamState>(
      builder: (context, state) {
        var cubit = context.read<StreamCubit>();
        return PagedPageView(
          pagingController: cubit.roomsPagingController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          builderDelegate: PagedChildBuilderDelegate<LiveEntity>(
              itemBuilder: (context, item, index) {
                return LiveCard(live: item);
              },
              noItemsFoundIndicatorBuilder: (context) {
                print(cubit.roomsPagingController.itemList?.length);
                return Center(
                  child: Label(
                    text: LocaleKeys.noRooms.localize,
                    style: Styles.headerText(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) =>
                  Container(
                      margin: const EdgeInsets.only(top: 150),
                      child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
        );
      },
    );
  }
}
