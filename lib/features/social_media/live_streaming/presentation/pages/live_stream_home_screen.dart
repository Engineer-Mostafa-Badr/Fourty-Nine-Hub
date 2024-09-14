import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/pages/club_house_home_screen.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../routes/routes.dart';
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
          bottom:  TabBar(
            indicatorColor: AppColors.PRIMARY_COLOR,
            labelColor:  AppColors.PRIMARY_COLOR,
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

  Scaffold _videoStreamTabBar(BuildContext context) {
    return Scaffold(
      body: _buildLivePages(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.LIVEView,
              extra: ZegoArgs(
                '123',
                true,
                context.read<UserCubit>().state.data!.fullName
              ));
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLivePages() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 3,
      itemBuilder: (context, index) => const LiveCard(),
    );
  }
}
